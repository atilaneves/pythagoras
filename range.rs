fn triples() -> impl Iterator<Item=(i32, i32, i32)> {
    (1..).flat_map(|z| {
        (1..(z + 1)).flat_map(move |x| {
            (x..(z + 1)).filter_map(move |y| {
                if x * x + y * y == z * z {
                    Some((x, y, z))
                } else {
                    None
                }
            })
        })
    })
}

fn main() {
    for (x, y, z) in triples().take(1000) {
        println!("({}, {}, {})", x, y, z);
    }
}
