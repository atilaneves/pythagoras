void main() {
    import std.stdio: writeln;
    import std.range: take;
    import std.algorithm: each;

    triples()
        .take(1000)
        .each!((x, y, z) => writeln("(", x, ", ", y, ", ", z, ")"));
}


template then(alias F) {
    import std.algorithm: map, joiner;
    alias then = (range) => map!F(range).joiner;
}

auto triples() {
    import std.range: recurrence;
    import std.range: iota;
    import std.algorithm: map, filter;
    import std.typecons: tuple;

    return
        recurrence!"a[n-1]+1"(1)
        .then!(z => iota(1, z + 1).then!(x => iota(x, z + 1).map!(y => tuple(x,y,z))))
        .filter!((t)=>t[0]^^2+t[1]^^2==t[2]^^2);
}
