import core.stdc.stdio: printf;
import std.typecons: tuple;


void printTriples(alias func)(int N) {
    int i = 0;
    for (int z = 1; ; ++z) {
        for (int x = 1; x <= z; ++x) {
            for (int y = x; y <= z; ++y) {
                if (x*x + y*y == z*z) {
                    func(tuple(x, y, z));
                    if (++i == N)
                        return;
                }
            }
        }
    }
}


void main() {
    printTriples!((t) { printf("(%i, %i, %i)\n", t[0], t[1], t[2]); })
                 (1000);
}
