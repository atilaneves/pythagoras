include system/ansi_c

proc main() =
  var t = 0

  block done:
    var i = 0

    var z = 1
    while true:
      for x in 1..z:
        for y in x..z:
          if x*x + y*y == z*z:
            when defined(skip_printfs):
              t += x+y+z
            else:
              c_printf("(%i, %i, %i)\n", x, y, z)
            i.inc
            if i == 1000:
              break done
      z.inc

  when defined(skip_printfs):
    c_printf("%i\n", t)

main()
