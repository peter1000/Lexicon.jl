import Lexicon.Utilities:

    convert,
    utf8checked!

facts("Utilities.") do

    context("Convert.") do

        @fact isa(convert(UTF8String, :sym), UTF8String)    => true
        @fact isa(convert(UTF8String, "ascii"), UTF8String) => true

        d = @compat(Dict(:A => :sym, :B => "ascii", :C => "unicode 出名字"))
        utf8checked!(d, :A)
        utf8checked!(d, :B)
        utf8checked!(d, :C)

        @fact isa(d[:A], UTF8String) => true
        @fact isa(d[:B], UTF8String) => true
        @fact isa(d[:C], UTF8String) => true

    end
end
