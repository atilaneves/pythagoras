fn main() {
    let triples = (1..).flat_map(|z| {
        (1..=z).flat_map(move |x| {
            (x..=z).filter_map(move |y| {
                if x * x + y * y == z * z {
                    Some((x, y, z))
                } else {
                    None
                }
            })
        })
    });
    for (x, y, z) in triples.take(1000) {
        println!("({}, {}, {})", x, y, z);
    }
}
