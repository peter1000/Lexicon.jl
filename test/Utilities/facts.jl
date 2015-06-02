require(joinpath(dirname(@__FILE__), "ExampleAside.jl"))
require(joinpath(dirname(@__FILE__), "NameOf.jl"))

import ExampleAside

import NameOf

import Lexicon.Utilities: nameof, convert, utf8checked!

import Docile: Cache

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

    context("Nameof ExampleAside") do
        obj = Cache.objects(ExampleAside)[1]
        @fact nameof(ExampleAside, obj) => :aside_ExampleAside_L3
    end


    context("NameOf Modules.") do

        @fact nameof(NameOf, NameOf.NameOf) => :NameOf

    end

    context("NameOf Globals.") do

        @fact nameof(NameOf, :G_M_1) => symbol("G_M_1")
        @fact nameof(NameOf, :G_C_1) => symbol("G_C_1")

    end

    context("NameOf Types.") do

        @fact nameof(NameOf, NameOf.T_A_1)  => symbol("T_A_1")
        @fact nameof(NameOf, :T_TA_1)       => symbol("T_TA_1")
        @fact nameof(NameOf, NameOf.T_M_1)  => symbol("T_M_1")
        @fact nameof(NameOf, NameOf.T_I_1)  => symbol("T_I_1")

    end

    context("NameOf Macros.") do

        @fact nameof(NameOf, macrofunc(NameOf, "m_1")) => symbol("@m_1")

    end

    context("NameOf Functions.") do

        @fact nameof(NameOf, NameOf.f_1)  => symbol("f_1")
        @fact nameof(NameOf, fmeth(NameOf.f_10)) => symbol("f_10")

    end

end
