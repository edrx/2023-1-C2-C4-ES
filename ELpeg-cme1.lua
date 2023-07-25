-- This file:
--   http://anggtwu.net/LUA/ELpeg-cme1.lua.html
--   http://anggtwu.net/LUA/ELpeg-cme1.lua
--          (find-angg "LUA/ELpeg-cme1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- A parser and LaTeXer for expressions like these ones:
--   http://anggtwu.net/mathologer-calculus-easy.html#17:12
--   http://www.youtube.com/watch?v=kuOxDh3egN0#t=17m12s
--   (find-calceasyvideo "17:12" " ")
--
-- (defun e1 () (interactive) (find-angg "LUA/ELpeg1.lua"))
-- (defun ec () (interactive) (find-angg "LUA/ELpeg-cme1.lua"))
-- (defun el () (interactive) (find-angg "LUA/ELpeg-lambda1.lua"))
-- (defun so () (interactive) (find-fline "~/LUA/Show2-outer.tex"))
-- (defun si () (interactive) (find-fline "~/LUA/Show2-inner.tex"))
--
-- (find-cp-LUA-links "ELpeg-cme1  ELpeg1 Globals1 PCall1 Show2 Subst1 Tree1")
--
-- «.how-it-should-look»	(to "how-it-should-look")
-- «.Vlast»			(to "Vlast")
-- «.fmts-and-funs»		(to "fmts-and-funs")
-- «.Freeze»			(to "Freeze")

require "ELpeg1"  -- (find-angg "LUA/ELpeg1.lua")
gr,V,VA,VE,PE = Gram.new()
_ = S(" ")^0

-- «Vlast»  (to ".Vlast")
-- (find-angg "LUA/ELpeg1.lua" "Gram-Vlast")
Gram.set = function (entries, name, pat)
    Vlast = pat
    entries[name] = pat
  end


AST.alttags = {
  eq="=", plus="+", minus="-", Mul="*",
  div="/", Div="//", pow="^",
  paren="()", plic="'"
}

--  ____            _        _                    
-- |  _ \ _ __ ___ | |_ ___ | |_ _   _ _ __   ___ 
-- | |_) | '__/ _ \| __/ _ \| __| | | | '_ \ / _ \
-- |  __/| | | (_) | || (_) | |_| |_| | |_) |  __/
-- |_|   |_|  \___/ \__\___/ \__|\__, | .__/ \___|
--                               |___/|_|         
--
-- «how-it-should-look»  (to ".how-it-should-look")

fun   = function (name) return mkast("fun", name) end
var   = function (name) return mkast("var", name) end
num   = function (str)  return mkast("num", str)  end
bin   = function (a, op, b) return mkast(op, a, b) end
unary = function    (op, a) return mkast(op, a)    end
paren = function (a)    return unary("()", a) end
plic  = function (a)    return unary("'", a) end
ap    = function (a, b) return bin(a, "ap", b) end

eq    = function (a, b) return bin(a, "=", b) end
plus  = function (a, b) return bin(a, "+", b) end
minus = function (a, b) return bin(a, "-", b) end
mul   = function (a, b) return bin(a, "mul", b) end
Mul   = function (a, b) return bin(a, "*",   b) end
div   = function (a, b) return bin(a, "/",   b) end
Div   = function (a, b) return bin(a, "//",  b) end
pow   = function (a, b) return bin(a, "^",   b) end

E[    "x"                ] = var"x"
E[ "ln x"                ] = ap(fun"ln", E"x")
E["(ln x)"               ] = paren(E"ln x")
E[       "3"             ] = num("3")
E["(ln x)^3"             ] = pow(E"(ln x)", E"3")
E["(ln x)^3"             ] = pow(E"(ln x)", E"3")
E[           "5"         ] = num("5")
E[                "sin x"] = ap(fun"sin", E"x")
E[            "5 + sin x"] = plus(E"5", E"sin x")
E["(ln x)^3 // 5 + sin x"] = Div(E"(ln x)^3", E"5 + sin x")

E[ "f"                                 ] = fun"f"
E[  "(x)"                              ] = paren(E"x")
E[ "f(x)"                              ] = ap(E"f", E"(x)")
E[     "g"                             ] = fun"g"
E[     "g(x)"                          ] = ap(E"g", E"(x)")
E[ "f(x)g(x)"                          ] = mul(E"f(x)", E"g(x)")
E["(f(x)g(x))"                         ] = paren(E"f(x)g(x)")
E["(f(x)g(x))'"                        ] = plic(E"(f(x)g(x))")
E[              "f'"                   ] = fun"f'"
E[              "f'(x)"                ] = ap(E"f'", E"(x)")
E[              "f'(x)g(x)"            ] = mul(E"f'(x)", E"g(x)")
E[                              "g'"   ] = fun"g'"
E[                              "g'(x)"] = ap(E"g'", E"(x)")
E[                          "f(x)g'(x)"] = mul(E"f(x)", E"g'(x)")
E[              "f'(x)g(x) + f(x)g'(x)"] = plus(E"f'(x)g(x)", E"f(x)g'(x)")
E["(f(x)g(x))' = f'(x)g(x) + f(x)g'(x)"] = eq(E"(f(x)g(x))'", E"f'(x)g(x) + f(x)g'(x)")

--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg-cme1.lua"
= E["(f(x)g(x))' = f'(x)g(x) + f(x)g'(x)"]
= E["(ln x)^3 // 5 + sin x"]

--]]

-- (find-angg "LUA/ELpeg1.lua" "assocs")
-- (find-LATEXfile "edrxgac2.tex" "\\def\\bsm")
-- (find-angg "LUA/Show2.lua" "texbody")
usepackages = [[
\usepackage{amsmath}
]]
defs = [[
\def\sm  #1{\begin{smallmatrix}#1\end{smallmatrix}}
\def\mat #1{\begin{matrix}#1\end{matrix}}
\def\psm #1{\left (\sm {#1}\right )}
\def\bsm #1{\left [\sm {#1}\right ]}
\def\pmat#1{\left (\mat{#1}\right )}
\def\bmat#1{\left [\mat{#1}\right ]}
]]

foldplic = function (A)
    local o = A[1]
    for i=2,#A do o = plic(o) end
    return o
  end
assocplic = function (pe, po) return Ct(pe*(_*po)^0) / foldplic end

VA.num   = Cs(P"-"^-1 * R"09"^1)
VA.var   = anyof "x y a b e"
VA.fun   = anyof "f'' f' f g' g ln sin sqrt"
VA.call  = P"!" * (R("AZ", "az")^1):Cs()
VA.ap    = V.fun *_* V.exprbasic

V.exprbasic = Cparen( "(", ")", V.expr)
            + Cparen(".(", ")", V.expr)
            + Cparen( "{", "}", V.expr)
            + Cparen( "[", "]", V.expr)
            + Cparen(".[", "]", V.expr)
            + V.call + V.ap + V.num + V.fun + V.var
V.exprplic  = assocplic(Vlast, Cs"'"  )
V.exprsubst = assocl(Vlast,    Cs"s"  )
V.exprpow   = assocr(Vlast,    Cs"^"  )
V.exprmul   = assocl(Vlast,    anyof("mul m"))
V.exprMul   = assocl(Vlast,    Cs"*"  )
V.exprdiv   = assocl(Vlast,    Cs"/"  )
V.exprplus  = assocl(Vlast,    anyof("+ -"))
V.exprDiv   = assocl(Vlast,    Cs"//" )
V.expreq    = assocl(Vlast,    Cs"="  )
V.exprceq   = assocl(Vlast,    Cs":=" )
V.exprnl    = assocl(Vlast,    Cs";;" )
V.expr      = _* V.exprnl


--   __           _                         _    __                 
--  / _|_ __ ___ | |_ ___    __ _ _ __   __| |  / _|_   _ _ __  ___ 
-- | |_| '_ ` _ \| __/ __|  / _` | '_ \ / _` | | |_| | | | '_ \/ __|
-- |  _| | | | | | |_\__ \ | (_| | | | | (_| | |  _| |_| | | | \__ \
-- |_| |_| |_| |_|\__|___/  \__,_|_| |_|\__,_| |_|  \__,_|_| |_|___/
--                                                                  
-- «fmts-and-funs»  (to ".fmts-and-funs")

fmts        = VTable {}
funs        = VTable {}
-- totex00     = ToTeX0 {fmts=fmts, funs=funs}
fmts[ "()"] = "(<1>)"
fmts[".()"] = "\\left(<1>\\right)"
fmts[ "[]"] = "\\bmat{<1>}"
fmts[".[]"] = "\\bsm{<1>}"
fmts[ "{}"] = "{<1>}"
fmts["'"]   = "{<1>}'"
fmts["s"]   = "<1> <2>"
fmts["+"]   = "<1> + <2>"
fmts["-"]   = "<1> - <2>"
fmts["*"]   = "<1> \\cdot <2>"
fmts["/"]   = "<1> / <2>"
fmts["//"]  = "\\frac{<1>}{<2>}"
fmts[ "="]  = "<1> = <2>"
fmts[":="]  = "<1> \\,:=\\, <2>"
fmts[";;"]  = "<1> \\\\{} <2>"
fmts["^"]   = "{<1>}^{<2>}"
fmts["ap"]  = "<1> <2>"
fmts["."]   = "<1> <2>"
fmts["m"]   = "<1> <2>"
fmts["mul"] = "<1> <2>"
fmts["num"] = "<1>"
fmts["var"] = "<1>"
fmts["call"] = "\\<1> "
fmts["fun"]  = "<funs[o[1]] or o[1]>"
funs["ln"]   = "\\ln "
funs["sin"]  = "\\sin "
funs["sqrt"] = "\\sqrt "


-- V.exprbasic = paren("{", "}", V.expr) + V.word
-- V.exprund   = assocl(Vlast,   V.opund)
-- V.expradd   = assocl(Vlast,   V.opadd)

-- «Freeze»  (to ".Freeze")
parse_cme = Parser.freeze("expr")
CME       = Parser.freeze("expr")


--[[
 (code-etv2 "SHOW2DIR" "/tmp/" "Show2")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg-cme1.lua"

= CME "g(x)"
= CME "g(x)" :totex()
= funs
= funs["g"]

= CME "g(x) := 200*x"
= CME "g(x) := 200*x" :totex()
= CME "x mul y"
= CME "!foo mul y"
= CME "!foo mul y" :totex()
= CME "x mul y"    :totex()
= CME "x . y"      :totex()
= CME "sqrt{2+3}"  :totex()
= CME "sqrt{2+3}"  :show()
 (etv)


str = ".(f(g(x))) s .[ f(y):=e^y ;; g(x):=4x]"
str = ".(f(g(x))) s .[ f(y):=e^y ;; g(x):=4x] = (e^{4 x})"
o = gr:cm0("expr", str)
= o
= o:totex()
= o:show()
= Show.log
 (etv)

  CME = Parser.freeze("expr")
= CME(".(x^2 * f(g(x))) s .[ f(x):=e^{3x} ;; f'(x):=3e^{3x}]")
= CME(".(x^2 *   f(g(x))) s .[ f(x):=e^{3x} ;; f'(x):=3e^{3x}]"):totex()
= CME(".(x^2 mul f(g(x))) s .[ f(x):=e^{3x} ;; f'(x):=3e^{3x}]"):totex()

= CME("[f(x):=x^2 ;; a:=4]")
= CME(" [f(x):=x^2 ;; a:=4]"):totex()
= CME(" [f(x):=x^2 ;; a:=4]"):show()
 (etv)
  CME(".[f(x):=x^2 ;; a:=4]"):show()
 (etv)

  RC = CME("(f(g(x)))' = f'(g(x))g'(x)")
= RC
= RC:show(2)
 (etv)


str = ".[ f(x):=x^2 ;; a:=3]"
str = "2 s 4"
str = "2 s .[ 4 ]"
str = ".[ f(y):=e^y ;; g(x):=4x]"
str = "2 ;; .[ 4 ]"

= paren("(", ")", V.expr)

=   E["(ln x)^3 // 5 + sin x"]
= CME "(ln x)^3 // 5 + sin x"
=   E["(f(x)g(x))' = f'(x)g(x) + f(x)g'(x)"]
= CME "(f(x)g(x))' = f'(x)g(x) + f(x)g'(x)"

= CME    "f(x):=x^2 ;; a:=3"
= CME  "[ f(x):=x^2 ;; a:=3]"
= CME ".[ f(x):=x^2 ;; a:=3]"

= Show.log
= Show.bigstr


--]]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
