pub fn main() {
    triples(|x, y, z| {
        println!("({}, {}, {})", x, y, z);
    });
}


fn triples<F>(func: F) where F: Fn(i32, i32, i32) {
    let mut i = 0 as i32;
    for z in 1.. {
        for x in 1..=z {
            for y in x..=z {
                if x*x + y*y == z*z {
                    func(x, y, z);
                    i = i + 1;
                    if i == 1000 {
                        return;
                    }
                }
            }
        }
    }
}
