use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
};
use color_eyre::eyre::Report;
use serde_json::json;
use std::fmt;
use tracing::error;

#[derive(Debug)]
pub enum AppError {
    Database(String),
    NotFound(String),
    Validation(String),
    Unauthorized(String),
    Internal(String),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            AppError::Database(msg) => write!(f, "Database error: {}", msg),
            AppError::NotFound(msg) => write!(f, "Not found: {}", msg),
            AppError::Validation(msg) => write!(f, "Validation error: {}", msg),
            AppError::Unauthorized(msg) => write!(f, "Unauthorized: {}", msg),
            AppError::Internal(msg) => write!(f, "Internal error: {}", msg),
        }
    }
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, error_message) = match self {
            AppError::Database(ref msg) => {
                error!("Database error: {}", msg);
                (StatusCode::INTERNAL_SERVER_ERROR, "Database error occurred")
            }
            AppError::NotFound(ref msg) => (StatusCode::NOT_FOUND, msg),
            AppError::Validation(ref msg) => (StatusCode::BAD_REQUEST, msg),
            AppError::Unauthorized(ref msg) => (StatusCode::UNAUTHORIZED, msg),
            AppError::Internal(ref msg) => {
                error!("Internal error: {}", msg);
                (
                    StatusCode::INTERNAL_SERVER_ERROR,
                    "An internal error occurred",
                )
            }
        };

        let body = json!({
            "error": {
                "message": error_message,
                "status": status.as_u16()
            }
        });

        (status, axum::Json(body)).into_response()
    }
}

impl From<Report> for AppError {
    fn from(err: Report) -> Self {
        error!("Converting Report to AppError: {:?}", err);
        AppError::Internal(err.to_string())
    }
}

impl From<sea_orm::DbErr> for AppError {
    fn from(err: sea_orm::DbErr) -> Self {
        error!("Database error: {:?}", err);
        AppError::Database(err.to_string())
    }
}

impl std::error::Error for AppError {}
