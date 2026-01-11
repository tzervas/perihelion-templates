use axum::{
    extract::State,
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::get,
    Json, Router,
};
use color_eyre::eyre::Result;
use serde::{Deserialize, Serialize};
use std::net::SocketAddr;
use tower_http::{
    compression::CompressionLayer,
    cors::CorsLayer,
    trace::{self, TraceLayer},
};
use tracing::{info, Level};

mod config;
mod db;
mod error;
mod telemetry;

#[derive(Debug, Serialize)]
struct HealthCheck {
    status: String,
    version: String,
}

#[derive(Debug, Deserialize)]
struct AppState {
    db: db::Pool,
}

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize error handling
    color_eyre::install()?;

    // Initialize telemetry
    telemetry::init()?;

    // Load configuration
    let config = config::load()?;

    // Initialize database connection
    let db = db::connect(&config.database_url).await?;

    // Create application state
    let state = AppState { db };

    // Build the router
    let app = Router::new()
        .route("/health", get(health_check))
        .with_state(state)
        .layer(
            TraceLayer::new_for_http()
                .make_span_with(trace::DefaultMakeSpan::new().level(Level::INFO))
                .on_response(trace::DefaultOnResponse::new().level(Level::INFO)),
        )
        .layer(CompressionLayer::new())
        .layer(CorsLayer::permissive());

    // Start the server
    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    info!("listening on {}", addr);

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await?;

    Ok(())
}

async fn health_check() -> Response {
    let health = HealthCheck {
        status: "ok".to_string(),
        version: env!("CARGO_PKG_VERSION").to_string(),
    };

    (StatusCode::OK, Json(health)).into_response()
}
