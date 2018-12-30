#include <stdio.h>
#include <tuple>

using namespace std;

template<typename F>
void triples(int N, F&& func) {
    int i = 0;
    for (int z = 1; ; ++z) {
        for (int x = 1; x <= z; ++x) {
            for (int y = x; y <= z; ++y) {
                if (x*x + y*y == z*z) {
                    func(make_tuple(x, y, z));
                    if (++i == N)
                        return;
                }
            }
        }
    }
}


int main() {
    triples(
        1000,
        [](auto t) { printf("(%i, %i, %i)\n", get<0>(t), get<1>(t), get<2>(t)); }
    );
}
