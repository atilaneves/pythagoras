import core.stdc.stdio: printf;
int main() {
    int t=0;

    int i = 0;
    for (int z = 1; ; ++z)
        for (int x = 1; x <= z; ++x)
            for (int y = x; y <= z; ++y)
                if (x*x + y*y == z*z) {
                    version(skip_printfs)
                        t+=(x+y+z);
                    else
                        printf("(%i, %i, %i)\n", x, y, z);
                    if (++i == 1000)
                        goto done;
                }
    done:
    version(skip_printfs)
        printf("%i\n", t);
    return 0;
}
