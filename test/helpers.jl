## Common Test Helpers. ##

meth(f, args) = first(methods(f, args))

fmeth(f) = first(methods(f))

macrofunc(mod, s) = getfield(mod, symbol(string("@", s)))

qs(mod, sym) = (mod, Docile.Collector.QualifiedSymbol(mod, sym))
