#include <iostream>

int main() {

    int i = 0;
    for (int z = 1; ; ++z)
        for (int x = 1; x <= z; ++x)
            for (int y = x; y <= z; ++y)
                if (x*x + y*y == z*z) {
                    std::cout << "(" << x << "," << y << "," << z << ")" << std::endl;
                    if (++i == 1000)
                        goto done;
                }
    done:

    return 0;
}
