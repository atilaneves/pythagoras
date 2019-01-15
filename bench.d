@safe:


enum numTries = 20;


int main(string[] args) {
    try {
        run(Options(args));
        return 0;
    } catch(Exception e) {
        import std.stdio: stderr;
        () @trusted { stderr.writeln("Error: ", e.msg); }();
        return 1;
    }
}


struct Options {

    Compiler compiler;
    Implementation implementation;
    Mode mode;

    this(string[] args) {
        import std.getopt: getopt, defaultGetoptPrinter;
        import std.stdio;

        auto helpInfo =
        getopt(
            args,
            "i|implementation", "Implementation (simple|...)", &implementation,
            "c|compiler", "compiler (dmd|ldc|clang|rust)", &compiler,
            "m|mode", "mode (debug|release)", &mode,
        );

        if(helpInfo.helpWanted) {
            () @trusted { defaultGetoptPrinter("bench <options>", helpInfo.options); }();
        }

        writeln("Benchmarking ", compiler, " for ", implementation, " in ", mode, " mode");
    }
}

void run(in Options options) {
    import std.stdio: writeln;

    {
        const ct = benchCT(options.compiler, options.implementation, options.mode);
        writeln("CT: ", ct);
    }

    {
        const rt = benchRT(options.compiler, options.implementation, options.mode);
        writeln("RT: ", rt);
    }
}


enum Compiler {
    dmd,
    ldc,
    clang,
    rust,
}


enum Implementation {
    simple,
    lambda,
    range,
    generator,
}

enum Mode {
    debug_,
    release,
}


auto benchCT(in Compiler compiler, in Implementation implementation, in Mode mode) {
    return time(compileCommand(compiler, implementation, mode));
}

auto benchRT(in Compiler compiler, in Implementation implementation, in Mode mode) {
    execute(linkCommand(compiler, implementation, mode));
    const binFileName = binFileName(implementation);
    return time(["./" ~ binFileName]);
}


auto time(in string[] args) {
    import std.process: execute;
    import std.exception: enforce;
    import std.conv: text;
    import std.array: join;
    import std.datetime.stopwatch: StopWatch, AutoStart;
    import std.datetime: hours, Duration;
    import std.algorithm: min;
    import std.stdio: write, writeln, stdout;

    auto duration = 99.hours;

    foreach(i; 0 .. numTries) {
        write(i, " ");
        () @trusted { stdout.flush; }();
        auto sw = StopWatch(AutoStart.yes);
        execute(args);
        duration = min(duration, cast(Duration) sw.peek);
    }
    writeln;

    return duration;
}

void execute(in string[] args) {
    import std.process: execute_ = execute;
    import std.exception: enforce;
    import std.conv: text;
    import std.array: join;

    const ret = execute_(args);
    enforce(ret.status == 0, text("Could not execute '", args.join(" "), "':\n", ret.output));
}

string[] compileCommand(in Compiler compiler, in Implementation implementation, in Mode mode) {

    const fileName = srcFileName(compiler, implementation);

    final switch(compiler) with(Compiler) {
        case dmd:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["dmd", "-c", fileName];
                case release:
                    return ["dmd", "-c", "-O", "-inline", fileName];
            }

        case ldc:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["ldc", "-c", fileName];
                case release:
                    return ["ldc2", "-c", "-O2", fileName];
            }

        case clang:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["clang++", "-c", fileName];
                case release:
                    return ["clang++", "-c", "-O2", fileName];
            }

        case rust:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["rustc", "--emit=obj", fileName];
                case release:
                    return ["rustc", "--emit=obj", "-C", "opt-level=2", fileName];
            }
    }
}


string[] linkCommand(in Compiler compiler, in Implementation implementation, in Mode mode) {

    const srcFileName = srcFileName(compiler, implementation);
    const binFileName = binFileName(implementation);

    final switch(compiler) with(Compiler) {
        case dmd:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["dmd", srcFileName];
                case release:
                    return ["dmd", "-O", "-inline", srcFileName];
            }

        case ldc:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["ldc2", "-of", binFileName, srcFileName];
                case release:
                    return ["ldc2", "-of", binFileName, "-O2", srcFileName];
            }

        case clang:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["clang++", "-o", binFileName, srcFileName];
                case release:
                    return ["clang++", "-o", binFileName, "-O2", srcFileName];
            }

        case rust:
            final switch(mode) with(Mode) {
                case debug_:
                    return ["rustc", srcFileName];
                case release:
                    return ["rustc", "-C", "opt-level=2", srcFileName];
            }
    }
}



string srcFileName(in Compiler compiler, in Implementation implementation) {
    return binFileName(implementation) ~ extension(compiler);
}


string binFileName(in Implementation implementation) {
    import std.conv: text;
    return text(implementation);
}

string extension(in Compiler compiler) {
    final switch(compiler) with(Compiler) {
        case dmd:
        case ldc:
            return ".d";
        case clang:
            return ".cpp";
        case rust:
            return ".rs";
    }
}
