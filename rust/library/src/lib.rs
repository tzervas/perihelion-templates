#![cfg_attr(not(feature = "std"), no_std)]
#![cfg_attr(docsrs, feature(doc_cfg))]
#![deny(missing_docs)]
#![forbid(unsafe_code)]
#![warn(
    clippy::all,
    clippy::pedantic,
    clippy::cargo,
    clippy::nursery,
    rust_2018_idioms
)]

//! A template for creating secure Rust libraries.
//!
//! This template provides a foundation for building robust and secure Rust libraries
//! with features like:
//! - No-std support
//! - Comprehensive error handling
//! - Serialization support
//! - Memory security
//! - Thorough testing infrastructure

#[cfg(feature = "alloc")]
extern crate alloc;

use serde::{Deserialize, Serialize};
use thiserror::Error;
use tracing::{debug, error, info};
use zeroize::Zeroize;

/// Custom error types for the library
#[derive(Debug, Error)]
pub enum Error {
    /// Invalid input provided
    #[error("invalid input: {0}")]
    InvalidInput(String),

    /// Operation failed
    #[error("operation failed: {0}")]
    OperationFailed(String),
}

/// Result type for library operations
pub type Result<T> = std::result::Result<T, Error>;

/// Example structure with secure handling of sensitive data
#[derive(Debug, Serialize, Deserialize, Zeroize)]
#[zeroize(drop)]
pub struct SecureData {
    /// Public identifier
    pub id: String,
    /// Sensitive data that will be zeroed on drop
    #[serde(skip)]
    sensitive: String,
}

impl SecureData {
    /// Creates a new instance of SecureData
    ///
    /// # Arguments
    ///
    /// * `id` - Public identifier
    /// * `sensitive` - Sensitive data that will be securely handled
    ///
    /// # Returns
    ///
    /// A new instance of SecureData
    ///
    /// # Examples
    ///
    /// ```
    /// use rust_library_template::SecureData;
    ///
    /// let data = SecureData::new("public-id", "secret-data");
    /// assert_eq!(data.id(), "public-id");
    /// ```
    pub fn new(id: impl Into<String>, sensitive: impl Into<String>) -> Self {
        let instance = Self {
            id: id.into(),
            sensitive: sensitive.into(),
        };
        debug!("Created new SecureData instance with id: {}", instance.id);
        instance
    }

    /// Returns a reference to the public identifier
    pub fn id(&self) -> &str {
        &self.id
    }

    /// Performs a secure operation with the sensitive data
    ///
    /// # Returns
    ///
    /// Result of the operation
    pub fn secure_operation(&self) -> Result<bool> {
        info!("Performing secure operation for id: {}", self.id);
        if self.sensitive.is_empty() {
            error!("Invalid sensitive data for id: {}", self.id);
            return Err(Error::InvalidInput("sensitive data is empty".into()));
        }
        Ok(true)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_secure_data_new() {
        let data = SecureData::new("test-id", "secret");
        assert_eq!(data.id(), "test-id");
    }

    #[test]
    fn test_secure_operation_success() {
        let data = SecureData::new("test-id", "secret");
        assert!(data.secure_operation().is_ok());
    }

    #[test]
    fn test_secure_operation_failure() {
        let data = SecureData::new("test-id", "");
        assert!(data.secure_operation().is_err());
    }
}
