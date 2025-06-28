use criterion::{black_box, criterion_group, criterion_main, Criterion};

fn criterion_benchmark(c: &mut Criterion) {
    // Add your benchmarks here
    c.bench_function("example_benchmark", |b| {
        b.iter(|| {
            let result = black_box("World");
            format!("Hello, {}!", result)
        })
    });
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
