// simplest.cpp
#include <stdio.h>

int main() {

    int i = 0;
    for (int z = 1; ; ++z)
        for (int x = 1; x <= z; ++x)
            for (int y = x; y <= z; ++y)
                if (x*x + y*y == z*z) {
                    printf("(%i,%i,%i)\n", x, y, z);
                    if (++i == 100)
                        goto done;
                }
    done:

    return 0;
}
