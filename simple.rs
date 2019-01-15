pub fn main() {
    print_triples();
}


fn print_triples() {
    let mut i = 0 as i32;
    for z in 1.. {
        for x in 1.. (z+1) {
            for y in x.. (z+1) {
                if x*x + y*y == z*z {
                    println!("({}, {}, {})", x, y, z);
                    i = i + 1;
                    if i == 1000 {
                        return;
                    }
                }
            }
        }
    }
}
