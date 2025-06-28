use criterion::{black_box, criterion_group, criterion_main, Criterion};
use rust_library_template::SecureData;

fn criterion_benchmark(c: &mut Criterion) {
    c.bench_function("secure_data_new", |b| {
        b.iter(|| {
            let data = SecureData::new(
                black_box("test-id"),
                black_box("sensitive-data"),
            );
            black_box(data)
        })
    });

    c.bench_function("secure_operation", |b| {
        let data = SecureData::new("test-id", "sensitive-data");
        b.iter(|| {
            black_box(data.secure_operation()).unwrap();
        })
    });
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
