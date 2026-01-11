use color_eyre::eyre::Result;
use serde::Deserialize;
use std::env;

#[derive(Debug, Deserialize)]
pub struct Config {
    pub database_url: String,
    pub redis_url: String,
    pub jwt_secret: String,
    pub environment: Environment,
}

#[derive(Debug, Deserialize, Clone, Copy)]
#[serde(rename_all = "lowercase")]
pub enum Environment {
    Development,
    Production,
}

impl Config {
    pub fn is_production(&self) -> bool {
        matches!(self.environment, Environment::Production)
    }
}

pub fn load() -> Result<Config> {
    // Load .env file if it exists
    dotenv::dotenv().ok();

    let database_url = env::var("DATABASE_URL")?;
    let redis_url = env::var("REDIS_URL")?;
    let jwt_secret = env::var("JWT_SECRET")?;
    let environment = match env::var("ENVIRONMENT").unwrap_or_else(|_| "development".into()).as_str() {
        "production" => Environment::Production,
        _ => Environment::Development,
    };

    Ok(Config {
        database_url,
        redis_url,
        jwt_secret,
        environment,
    })
}
