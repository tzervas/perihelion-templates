use assert_cmd::Command;
use predicates::prelude::*;

#[test]
fn cli_no_args() {
    Command::cargo_bin("rust-cli-template")
        .unwrap()
        .assert()
        .failure()
        .stderr(predicate::str::contains("Usage"));
}

#[test]
fn cli_with_name() {
    Command::cargo_bin("rust-cli-template")
        .unwrap()
        .args(&["-n", "World"])
        .assert()
        .success()
        .stdout(predicate::str::contains("Hello, World!"));
}

#[test]
fn cli_with_high_count() {
    Command::cargo_bin("rust-cli-template")
        .unwrap()
        .args(&["-n", "Test", "-c", "11"])
        .assert()
        .success()
        .stdout(predicate::str::contains("Hello, Test!"));
}
