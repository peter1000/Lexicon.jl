import Lexicon.Utilities:

    convert,
    utf8checked!

facts("Utilities.") do

    context("Convert.") do

        @fact isa(convert(UTF8String, :sym), UTF8String)    => true
        @fact isa(convert(UTF8String, "ascii"), UTF8String) => true

        d = @compat(Dict{Symbol, Any}(:A => :sym, :B => "ascii", :C => "unicode 出名字"))

        @fact utf8checked!(d, :A) => "sym"
        @fact utf8checked!(d, :B) => "ascii"
        @fact utf8checked!(d, :C) => "unicode 出名字"

        @fact isa(d[:A], UTF8String) => true
        @fact isa(d[:B], UTF8String) => true
        @fact isa(d[:C], UTF8String) => true

    end
end
