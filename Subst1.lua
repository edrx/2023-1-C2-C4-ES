-- This file:
--   http://anggtwu.net/LUA/Subst1.lua.html
--   http://anggtwu.net/LUA/Subst1.lua
--          (find-angg "LUA/Subst1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun s1 () (interactive) (find-angg "LUA/Subst1.lua"))
-- (defun e1 () (interactive) (find-angg "LUA/ELpeg1.lua"))
-- (defun i1 () (interactive) (find-angg "LUA/Indent1.lua"))

-- «.Subst»			(to "Subst")
-- «.Subst-tests»		(to "Subst-tests")
-- «.totex»			(to "totex")
--   «.ToTeX-fakeclass»		(to "ToTeX-fakeclass")
-- «.totex-tests»		(to "totex-tests")


-- (find-angg "LUA/Indent1.lua" "string.indent")
indent        = indent        or function (s) return s end
string.indent = string.indent or function (s) return s end


--  ____        _         _   
-- / ___| _   _| |__  ___| |_ 
-- \___ \| | | | '_ \/ __| __|
--  ___) | |_| | |_) \__ \ |_ 
-- |____/ \__,_|_.__/|___/\__|
--                            
-- This is like the Dang class of tikz1.lua,
--   (find-angg "LUA/tikz1.lua" "Dang")
-- but with lots of configurable options.
-- Subst has four kinds of expansions: in
--     Subst({}):gsub "_<1>_<2+3>_<:return 4+5>_<aa>_<+6><-7><!>_"
--   the "1"           in <1>           is expanded with expn,
--   the "2+3"         in <2+3>         is expanded with expexpr,
--   the ":return 2+3" in <:return 2+3> is expanded with expeval, and
--   the "aa"          in <aa>          is expanded with expfield.
-- The substrings "<+6>", "<-7>", "<!>" at the end above all fall in
-- the "do not expand" category; they are left unchanged. This is for:
--   (find-angg "LUA/Indent1.lua")
-- Note that the original Dang class only supports exprs and evals.
-- Also, the "tostring" method below has several configurable subcases.
-- Usually when we define objects of the class Subst we override at least
-- table_tos and expn. The overrides are done with addoverrides.
--   See: (find-angg "LUA/lua50init.lua" "addoverrides")
--        (to "totex")
--
-- «Subst»  (to ".Subst")

Subst = Class {
  type = "Subst",
  __tostring = function (su) return su:tostring() end,
  __index = {
    --
    fields   = {aa="AAA", bb="BBB"},
    hasfield = function (su, s)    return su.fields[s] end,
    expfield = function (su, s)    return su.fields[s] end,
    expn     = function (su, n)    return format("(expn %d)", n) end,
    expexpr  = function (su, code) return format("(expexpr %s)", code) end,
    expeval  = function (su, code) return format("(expeval %s)", code) end,
    --
    nil_tos    = function (su)      return "(nil)" end,
    number_tos = function (su, n)   return myntos(n) end,
    table_tos  = function (su, tbl) return mytostring(tbl) end,
    tostring   = function (su)      return su:tostring1(su.o) end,
    tostring1  = function (su, o)
        if type(o) == "string" then return o                end
        if type(o) == "nil"    then return su:nil_tos()     end
        if type(o) == "number" then return su:number_tos(o) end
        if type(o) == "table"  then return su:table_tos(o)  end
        return tostring(o)
      end,
    --
    donotexpand = function (su, s)
        return s:match("^[-+!][0-9]*$")
      end,
    --
    pat = "<(.-)>",
    --
    gsub1 = function (su, s)
        if su:donotexpand(s)   then return nil                  end
        if s:match("^[0-9]+$") then return su:expn(s+0)         end
        if su:hasfield(s)      then return su:expfield(s)       end
        if s:match("^:")       then return su:expeval(s:sub(2)) end
        if true                then return su:expexpr(s)        end
      end,
    gsub = function (su, fmt)
        local f = function (s) return su:tostring1(su:gsub1(s)) end
        return (fmt:gsub(su.pat, f))
      end,
    --
    with         = function (su, o) su.o = o; return su end,
    addoverrides = function (su, O) return addoverrides(su, O) end,
  },
}

-- «Subst-tests»  (to ".Subst-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Subst1.lua"
  su = Subst {o={20,30}}
= su
  su = Subst {}
fmt = "field: <aa>\n" ..
      "expr:  <2+3>\n" ..
      "eval:  <:return 4+5>\n" ..
      "n:     <1>"
= su:gsub(fmt)

=       expr "2+3"
=       eval "return 2+3"
  su.expexpr = function (su, code) return expr(code) end
  su.expeval = function (su, code) return eval(code) end
= su:expexpr "2+3"
= su:expeval "return 2+3"
= su:gsub(fmt)

  su = Subst {o={20,30}}
= su:gsub(fmt)
O = {
  expn = function (su, n) return "["..su.o[n].."]" end,
}
su:addoverrides(O)
= su:gsub(fmt)

--]]



--  _        _            
-- | |_ ___ | |_ _____  __
-- | __/ _ \| __/ _ \ \/ /
-- | || (_) | ||  __/>  < 
--  \__\___/ \__\___/_/\_\
--                        
-- Based on: (find-angg "LUA/ELpeg1.lua" "ToTeX")
-- This is the basic way to convert ASTs to TeX code.
-- Every time that totex00 is run it creates a new Subst object with:
--   1. overrides for three methods: table_tos, expn, expexpr
--   2. a few other methods: tag, fmt, getn,
--   3. a copy of the argument o.
-- This new Subst object is recursive. In a case like this,
--   o = mkast("*", 2, 3)
--   fmts["*"] = "<1> \\cdot <2>"
-- something like this will happen:
--       totex(o)
--   --> totex0(o)
--   --> totex00(o):tostring()
--   --> totex00(o):tostring1(o)
--   --> totex00(o):table_tos(o)
--   --> totex00(o):gsub("<1> \\cdot <2>")
--   --> totex00(o):expn(1)
--   --> totex00(o):getn(1)
--   --> totex00(o[1])
--
-- Note that this recursion scheme uses several globals: totex,
-- totex0, totex00, fmts, and sometimes funs. I've tried to write
-- alternatives to this with no globals, but in all cases their code
-- ended up very intrincate... in this version with globals at least
-- the code is quite simple.
--
-- To use indent, override the definition of totex below with:
--   totex = function (o) return totex0 (o):indent() end
-- See: (find-angg "LUA/Indent1.lua" "Indent")
--
-- «totex»  (to ".totex")

--totex = function (o) return totex0(o) end
totex   = function (o) return tostring(totex0(o)):indent() end
totex0  = function (o) return totex00(o) end
totex00 = function (o) return ToTeX.fromo(o) end


-- «ToTeX-fakeclass»  (to ".ToTeX-fakeclass")
-- This is a fake class in the sense that its creators,
-- ToTeX.from(A) and ToTeX.fromo(o), return objects of the class
-- Subst, but with some methods overridden. Also, ToTeX.__index
-- is not a list of methods but a list of overrides.

ToTeX = Class {
  type  = "ToTeX",
  from  = function (A) return Subst(copy(A)):addoverrides(ToTeX.__index) end,
  fromo = function (o) return ToTeX.from({o=o}) end,
  __index = {
    --
    -- Override table_tos
    tag  = function (su) return su.o[0] end,
    fmt  = function (su) return fmts[su:tag()] end,
    table_tos = function (su)
        if not su:tag() then return "[No tag]" end
        if not su:fmt() then return "[No fmt: "..su:tag().."]" end
        return su:gsub(su:fmt())
      end,
    --
    -- Override expn
    getn = function (su, n) return totex00(su.o[n]) end,
    expn = function (su, n) return su:getn(n):tostring() end,
    --
    -- For debugging:
    expexpr = function (su, code)
        return L("su,o => "..code)(su, su.o)
      end,
  },
}

-- «totex-tests»  (to ".totex-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Subst1.lua"
dofile "ELpeg1.lua"  -- for mkast

  s = Subst    {o={20,30}}
= s
  t = ToTeX.fromo({20,30})
= t
= otype(s)   --> Subst
= otype(t)   --> Subst
= s
= t

fmts        = VTable {}
fmts["+"]   = "<1> + <2>"
fmts["*"]   = "<1> \\cdot <2>"

funs        = VTable {}
funs["sin"] = VTable {}

o = mkast("+", "a", mkast("*", 2, 3.4567))
= o
= totex  (o)
= totex0 (o)
= totex00(o)
= totex00(o).o
= totex00(o):tag()
= totex00(o):fmt()
= totex00(o):getn(1)
= totex00(o):getn(1).o
= totex00(o):getn(2)
= totex00(o):getn(2).o
= totex00(o):getn(2):fmt()
= totex00(o):getn(2):getn(2)
= totex00(o):getn(2):getn(2).o
= totex00()
= totex00():gsub("a<2+3>b")

--]==]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
