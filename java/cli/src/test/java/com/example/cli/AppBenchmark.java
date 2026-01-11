package com.example.cli;

import org.openjdk.jmh.annotations.*;
import picocli.CommandLine;

import java.util.concurrent.TimeUnit;

/**
 * Benchmarks for the CLI application.
 */
@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@State(Scope.Thread)
@Fork(1)
@Warmup(iterations = 2)
@Measurement(iterations = 3)
public class AppBenchmark {

    private CommandLine cli;

    @Setup
    public void setup() {
        cli = new CommandLine(new App());
    }

    @Benchmark
    public void benchmarkBasicCommand() {
        cli.execute("--name", "World");
    }

    @Benchmark
    public void benchmarkHighCount() {
        cli.execute("--name", "Test", "--count", "11");
    }
}
