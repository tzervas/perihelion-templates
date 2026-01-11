package com.example.cli;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.util.concurrent.Callable;

/**
 * Main application class for the CLI.
 */
@Command(
    name = "java-cli-template",
    mixinStandardHelpOptions = true,
    version = "0.1.0",
    description = "A template for creating secure Java CLI applications"
)
public class App implements Callable<Integer> {
    private static final Logger logger = LoggerFactory.getLogger(App.class);

    @Option(names = {"-n", "--name"}, description = "Name to operate on", required = true)
    private String name;

    @Option(names = {"-c", "--count"}, description = "Count of operations", defaultValue = "1")
    private int count;

    /**
     * Main entry point for the application.
     *
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        int exitCode = new CommandLine(new App())
            .setExecutionStrategy(new CommandLine.RunLast())
            .execute(args);
        System.exit(exitCode);
    }

    @Override
    public Integer call() throws Exception {
        logger.info("Starting application with name: {} and count: {}", name, count);

        if (count > 10) {
            logger.warn("Count is quite high: {}", count);
        }

        // Your application logic here
        System.out.printf("Hello, %s!%n", name);

        return 0;
    }
}
