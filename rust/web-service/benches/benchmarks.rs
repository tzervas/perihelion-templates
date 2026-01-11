use criterion::{black_box, criterion_group, criterion_main, Criterion};
use rust_web_service_template::*;

fn criterion_benchmark(c: &mut Criterion) {
    let runtime = tokio::runtime::Runtime::new().unwrap();

    c.bench_function("health_check", |b| {
        b.iter(|| {
            runtime.block_on(async {
                let app = app().await;
                let response = app
                    .oneshot(
                        axum::http::Request::builder()
                            .uri("/health")
                            .body(axum::body::Body::empty())
                            .unwrap(),
                    )
                    .await
                    .unwrap();
                black_box(response);
            });
        })
    });
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
