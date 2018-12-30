import std.stdio;
import std.typecons;
import std.concurrency;

auto triples(int n) {
    return new Generator!(Tuple!(int, int, int))({
        int i = 0;
        for (int z = 1; ; ++z)
            for (int x = 1; x <= z; ++x)
                for (int y = x; y <= z; ++y)
                    if (x*x + y*y == z*z) {
                        yield(tuple(x, y, z));
                        if (++i == n)
                            return;
                    }
    });
}

void main() {
    foreach(tup; triples(1000)) {
        writeln("(", tup[0], ", ", tup[1], ", ", tup[2], ")");
    }
}
