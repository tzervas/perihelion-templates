package com.example.cli;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import picocli.CommandLine;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.nio.file.Path;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for the CLI application.
 */
class AppTest {
    @Test
    void testHelpCommand() {
        int exitCode = new CommandLine(new App()).execute("--help");
        assertThat(exitCode).isEqualTo(0);
    }

    @Test
    void testSuccessfulExecution() {
        // Capture stdout
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PrintStream originalOut = System.out;
        System.setOut(new PrintStream(outputStream));

        try {
            int exitCode = new CommandLine(new App()).execute("--name", "World");
            assertThat(exitCode).isEqualTo(0);
            assertThat(outputStream.toString()).contains("Hello, World!");
        } finally {
            System.setOut(originalOut);
        }
    }

    @Test
    void testMissingRequiredOption() {
        int exitCode = new CommandLine(new App()).execute();
        assertThat(exitCode).isEqualTo(2);
    }

    @Test
    void testHighCount(@TempDir Path tempDir) {
        int exitCode = new CommandLine(new App()).execute("--name", "Test", "--count", "11");
        assertThat(exitCode).isEqualTo(0);
    }
}
