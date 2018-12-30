#include <stdio.h>
#include <range/v3/all.hpp>

using namespace ranges;

int main() {

    auto triples = view::for_each(view::ints(1), [](int z) {
        return view::for_each(view::ints(1, z + 1), [=](int x) {
            return view::for_each(view::ints(x, z + 1), [=](int y) {
                return yield_if(x * x + y * y == z * z,
                    std::make_tuple(x, y, z));
            });
        });
    });

    RANGES_FOR(auto triple, triples | view::take(1000)) {
        printf("(%i, %i, %i)\n", std::get<0>(triple), std::get<1>(triple), std::get<2>(triple));
    }
}
