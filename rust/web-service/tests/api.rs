use axum::{
    body::Body,
    http::{Request, StatusCode},
};
use rust_web_service_template::*;
use serde_json::json;
use tower::ServiceExt;

#[tokio::test]
async fn test_health_check() {
    // Build test application
    let app = app().await;

    // Create test request
    let request = Request::builder()
        .uri("/health")
        .body(Body::empty())
        .unwrap();

    // Send request and get response
    let response = app.oneshot(request).await.unwrap();

    // Assert response status
    assert_eq!(response.status(), StatusCode::OK);

    // Get response body
    let body = hyper::body::to_bytes(response.into_body()).await.unwrap();
    let json: serde_json::Value = serde_json::from_slice(&body).unwrap();

    // Assert response content
    assert_eq!(
        json,
        json!({
            "status": "ok",
            "version": env!("CARGO_PKG_VERSION")
        })
    );
}
