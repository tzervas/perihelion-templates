use clap::Parser;
use color_eyre::eyre::Result;
use tracing::{info, warn};

/// CLI Template Application
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Name to operate on
    #[arg(short, long)]
    name: String,

    /// Optional count parameter
    #[arg(short, long, default_value_t = 1)]
    count: u8,
}

#[tokio::main]
async fn main() -> Result<()> {
    // Initialize error handling
    color_eyre::install()?;

    // Initialize logging
    tracing_subscriber::fmt::init();

    // Parse command line arguments
    let args = Args::parse();

    info!("Starting application with name: {}", args.name);

    if args.count > 10 {
        warn!("Count is quite high: {}", args.count);
    }

    // Your application logic here
    println!("Hello, {}!", args.name);

    Ok(())
}
