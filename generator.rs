#![feature(generators, generator_trait)]

use std::ops::{Generator, GeneratorState};

/// Wrapper around a `Generator` which yields `T` and returns `()` to
/// implement `Iterator` with item type `T`.
///
/// This wrapper type and implementation of `Iterator` should be unnecessary
/// once `Generator` is stabilized and the standard library provides an
/// equivalent implementation of `Iterator` for `Generator`.
///
/// I believe that this is unsafe without some way of ensuring that `G` is
/// pinned in place.  There is work ongoing to allow pinned generators to be
/// safely accessed, which is one of the reasons that generators are not yet
/// stable.  This particular example is safe because we don't move the
/// generator while iterating over it.
struct IterGen<G>(G);

impl<T, G> Iterator for IterGen<G>
    where G: Generator<Yield=T, Return=()>
{
    type Item = T;

    fn next(&mut self) -> Option<Self::Item> {
        match unsafe { self.0.resume() } {
            GeneratorState::Yielded(x) => Some(x),
            GeneratorState::Complete(()) => None,
        }
    }
}

fn triples() -> impl Iterator<Item=(i32, i32, i32)> {
    IterGen(||
        for z in 1.. {
            for x in 1..(z + 1) {
                for y in x..(z + 1) {
                    if x*x + y*y == z*z {
                        yield (x, y, z)
                    }
                }
            }
        }
    )
}

fn main() {
    for (x, y, z) in triples().take(1000) {
        println!("({}, {}, {})", x, y, z);
    }
}
