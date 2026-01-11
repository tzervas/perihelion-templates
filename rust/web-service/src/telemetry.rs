use color_eyre::eyre::Result;
use opentelemetry::sdk::trace::{self, Sampler};
use opentelemetry::sdk::Resource;
use opentelemetry::KeyValue;
use opentelemetry_otlp::WithExportConfig;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt, EnvFilter};

pub fn init() -> Result<()> {
    // Configure OpenTelemetry tracer
    let tracer = opentelemetry_otlp::new_pipeline()
        .tracing()
        .with_exporter(
            opentelemetry_otlp::new_exporter()
                .tonic()
                .with_endpoint("http://localhost:4317"),
        )
        .with_trace_config(
            trace::config()
                .with_sampler(Sampler::AlwaysOn)
                .with_resource(Resource::new(vec![KeyValue::new(
                    "service.name",
                    env!("CARGO_PKG_NAME"),
                )])),
        )
        .install_batch(opentelemetry::runtime::Tokio)?;

    // Create tracing layer with OpenTelemetry
    let telemetry = tracing_opentelemetry::layer().with_tracer(tracer);

    // Configure log filtering from environment
    let env_filter = EnvFilter::try_from_default_env().unwrap_or_else(|_| {
        EnvFilter::new(format!(
            "{}=info,tower_http=debug,axum::rejection=trace",
            env!("CARGO_PKG_NAME")
        ))
    });

    // Initialize tracing subscriber with console and OpenTelemetry layers
    tracing_subscriber::registry()
        .with(env_filter)
        .with(tracing_subscriber::fmt::layer())
        .with(telemetry)
        .try_init()?;

    Ok(())
}
