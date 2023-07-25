-- This file:
--   http://anggtwu.net/LUA/Indent1.lua.html
--   http://anggtwu.net/LUA/Indent1.lua
--          (find-angg "LUA/Indent1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- My first implementation of "indent" only interpreted these kinds of
-- "indentation instructions":
--
--   "<+2>"     increase the indentation by 2
--   "<-3>"     decrease the indentation by 3
--   "\n"       is converted to something like "\n ", where the number
--              of spaces is given by the current indentation
--
-- then I added support for:
--
--   "<!>"      delete all whitespace - i.e., "[ \t\n]*" on both
--              sides of the "<!>"
--
-- and then I saw that 



-- This file implements a way to convert strings with "indentation
-- instructions" into, aham, "normal strings". The indentation
-- instructions are of these kinds:
--   "<+2>"     increase the indentation by 2
--   "<-3>"     decrease the indentation by 3
--   "\n"       is converted to something like "\n ", where the number
--              of spaces is given by the current indentation
--   "<!>"      delete all whitespace - i.e., "[ \t\n]*" on both
--              sides of the "<!>"
--   "<!L>"     capture the whitespace on both sides of the "<!L>"
--              and then return the whitespace that was at the left
--   "<!R>"     same, but at the right
--   "<!LR>"    same, but returns the left and right whitespaces
--              concatenated
--
--
-- (defun e1 () (interactive) (find-angg "LUA/ELpeg1.lua"))
-- (defun i1 () (interactive) (find-angg "LUA/Indent1.lua"))
-- (defun p1 () (interactive) (find-angg "LUA/Pict2e1.lua"))

-- «.flatten»		(to "flatten")
-- «.flatten-tests»	(to "flatten-tests")
-- «.nlify»		(to "nlify")
-- «.Ind»		(to "Ind")
-- «.Ind-tests»		(to "Ind-tests")
-- «.nlify-tests»	(to "nlify-tests")
-- «.pat_indent»	(to "pat_indent")
-- «.pat_indent-tests»	(to "pat_indent-tests")
-- «.Indent»		(to "Indent")
--   «.string.indent»	(to "string.indent")
-- «.Indent-tests»	(to "Indent-tests")

require "ELpeg1"  -- (find-angg "LUA/ELpeg1.lua" "Gram")
gr,V,VA,VE,PE = Gram.new()
_ = S(" ")^0


-- «flatten»  (to ".flatten")
flatten = function (o)
    local out = VTable {}
    local add   -- recursive, defined in the next line
    add = function (x)
        if type(x) == "table"
        then map(add, x)
        else table.insert(out, x)
        end
      end
    add(o)
    return out
  end

concattables = function (A, ...)
    A = HTable(copy(A))
    for _,B in ipairs({...}) do
      for _,v in ipairs(B) do
        table.insert(A, v)
      end
    end
    return A
  end

-- «flatten-tests»  (to ".flatten-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent1.lua"
= flatten {"a", 22, {33, 44, {print}, 55}}
= concattables({10, 20}, {30, 40}, {}, {50, 60})

--]]



--        _ _  __       
--  _ __ | (_)/ _|_   _ 
-- | '_ \| | | |_| | | |
-- | | | | | |  _| |_| |
-- |_| |_|_|_|_|  \__, |
--                |___/ 
--
-- Nlify splits a string and converts each "\n" in it to a {"nl"}.
-- For example,
--   nlify("a\nbc\n\nd")
-- returns:
--   {"a", {"nl"}, "bc", {"nl"}, {"nl"}, "d"}
--
-- «nlify»  (to ".nlify")

V.nl      = P"\n" / function () return {"nl"} end
V.nonnls  = Cs((1-P"\n")^1)
V.nlify   = Ct((V.nl + V.nonnls)^0)
pat_nlify = gr:compile("nlify")
nlify     = function (str) return pat_nlify:match(str) end

-- «nlify-tests»  (to ".nlify-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent1.lua"
PP(nlify("ab\n\ncd"))
PP(nlify("abcd"))
PP(nlify(""))

gr,V,VA,VE,PE = Gram.new()
V._ = Cs(P"_"^1)
V.m = Cs(S"abcd\n"^1) / nlify
V.all = V._ * V.m * V._
gr:cmp("all", "__ab\n\ncd__")

--]]





--  ___           _ 
-- |_ _|_ __   __| |
--  | || '_ \ / _` |
--  | || | | | (_| |
-- |___|_| |_|\__,_|
--                  
-- This is used by one of the patterns in pat_indent.
-- (find-es "lpeg" "lpeg-matchtime")
--
-- «Ind»  (to ".Ind")

Ind = Class {
  type = "Ind",
  from     = function (_) return Ind{_=_, out={}} end,
  captures = function (_) return Ind.from(_):captures() end,
--captures = function (_) PP(_); return PP(Ind.from(_):captures()) end,
  mtcaptures = function (s,p,_) return p,Ind.captures(_) end,
  test     = function (_) PP(Ind.captures(_)) end,
  __tostring = function (i) return mytostring(i) end,
  __index = {
    sign   = function (i) return (i._.sign == "-") and -1 or 1 end,
    uint   = function (i) return tonumber(i._.digits) end,
    int    = function (i) return i:uint() and i:sign()*i:uint() end,
    indent = function (i) return i:int() and i:int()~=0 end,
    itable = function (i) return i:indent() and {{"indent", i:int()}} or {} end,
    --
    l      = function (i) return i._.l or "" end,
    r      = function (i) return i._.r or "" end,
    LR     = function (i) return i._.LR or "" end,
    keepl  = function (i) return i:LR()=="L" or i:LR()=="LR" end,
    keepr  = function (i) return i:LR()=="R" or i:LR()=="LR" end,
    ltable = function (i) return i:keepl() and nlify(i:l()) or {} end,
    rtable = function (i) return i:keepr() and nlify(i:r()) or {} end,
    --
    captures = function (i)
        return unpack(concattables(i:ltable(), i:itable(), i:rtable()))
      end,
  },
}

-- «Ind-tests»  (to ".Ind-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent1.lua"
Ind.test {sign="-", digits="42"}
Ind.test {sign="-", digits="42", l=" ", r=" ", LR="LR"}
Ind.test {sign="-", digits="42", l=" \n ", r=" \n\n ", LR="LR"}
Ind.test {sign="-", digits="42", l=" \n ", r=" \n\n ", LR="L"}
Ind.test {sign="-", digits="42", l=" \n ", r=" \n\n ", LR="R"}
Ind.test {                       l=" \n ", r=" \n\n ", LR="R"}
PP(Ind.captures {sign="-", digits="42"})

gr,V,VA,VE,PE = Gram.new()
V._ = Cs(P"_"^1)
V.m  = P"a" * Cc {sign="-", digits="42", l=" \n ", r=" \n\n ", LR="LR"}
V.mc = P"a" * Cc {sign="-", digits="42", l=" \n ", r=" \n\n ", LR="LR"}
V.m  = V.mc / Ind.captures
V.all = V._ * V.m * V._
gr:cmp("all", "__a__")

--]]



--              _       _           _            _   
--  _ __   __ _| |_    (_)_ __   __| | ___ _ __ | |_ 
-- | '_ \ / _` | __|   | | '_ \ / _` |/ _ \ '_ \| __|
-- | |_) | (_| | |_    | | | | | (_| |  __/ | | | |_ 
-- | .__/ \__,_|\__|___|_|_| |_|\__,_|\___|_| |_|\__|
-- |_|            |_____|                            
--
-- This block defines the lpeg pattern used by the Indent class.
-- For example, that pattern "converts"
--   "<+23>a\n<-4><!>\nb"
-- to:
--   {1="indent", 2=23} "a" {1="nl"} {1="indent", 2=-4} "" "b"
--
-- These substrings or the original string are treated specially:
--   "<+23>"   increase the indentation by 23
--   "<-4>"    decrease the indentation by 4
--   "\n"      print a newline plus the current indentation
--   "<!>\n"   <!> discards all the newlines immediately after it
-- At this moment the delimiters "<" and ">" are hardcoded.
--
-- See the classes Indent:
--   (to "Indent")
--
-- «pat_indent»  (to ".pat_indent")

V.o    = P"<"
V.c    = P">"

Cin      = function (tag, pat) return Cs(pat):Cg(tag) end
V.sign   = Cin("sign",   S"+-")
V.n      = Cin("digits", R"09"^1)
V.l      = Cin("l",      S" \t\n"^0)
V.r      = Cin("r",      S" \t\n"^0)
V.LR     = Cin("LR",     P"LR" + P"L" + P"R" + P"")
V.bang0  = (V.sign*V.n + P"!") * V.LR
V.bangt  = Ct(V.l*V.o* V.bang0 *V.c*V.r)
V.bang   = V.bangt / Ind.captures

V.spaces = Cs(S" \t"^1)
V.nl     = P"\n" / function () return {"nl"} end

V.nonnls = Cs((1-P"\n")^1)

V.special   = V.bang + V.spaces + V.nl
V.text      = Cs((-V.special * P(1))^1)
V.all       = (V.text + V.special)^0
V.tall      = Ct(V.all)
pat_indent0 = gr:compile("all")    -- returns several values
pat_indent  = gr:compile("tall")   -- returns a table

-- «pat_indent-tests»  (to ".pat_indent-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent1.lua"
    gr:cmp("bangt",  "<+23>")
o = gr:cm0("bangt",  "<+23>")
PP(o)
PP(Ind.captures(o))

    gr:cmp("bang",   "<+23>")
    gr:cmp( "all",   "<+23>a\n<-4>\nb")
    gr:cmp( "all",   "<+23>a\nb\n<-4>\nc")
    gr:cmp("tall",   "<+23>a\nb\n<-4L>\nc")
    gr:cmp("tall",   "<+23>a\nb\n<-4R>\nc")
    gr:cmp("tall",   "<+23>a\n<-4LR>\nb")
    gr:cmp("tall",   "<+23>a\n<-4><!>b")
    gr:cmp("tall",   "<+23>a\n<-4><!>\nb")
    gr:cmp("tall",   "<+23>a\n<-4> <!>  b")
    gr:cmp("tall",   "<+23>a\n<-4> <!L>  b")
    gr:cmp("tall",   "<+23>a\n<-4> <!R>  b")
    gr:cmp("tall",   "<+23>a\n<-4> <!LR>  b")
PP(pat_indent0:match "<+23>a\n<-4><!>\nb")
PP(pat_indent :match "<+23>a\n<-4><!>\nb")

--]]

--  ___           _            _   
-- |_ _|_ __   __| | ___ _ __ | |_ 
--  | || '_ \ / _` |/ _ \ '_ \| __|
--  | || | | | (_| |  __/ | | | |_ 
-- |___|_| |_|\__,_|\___|_| |_|\__|
--                                 
-- The class Indent implements the machinery to convert a string like:
--   "foo\nbar<+1>\nplic\nploc<-1>\nbof"
-- to:
--   foo
--   bar
--    plic
--    ploc
--   bof
-- and it lets us test each step of the conversion separately.
--
-- «Indent»  (to ".Indent")

Indent = Class {
  type = "Indent",
  new  = function (bigstr) return Indent {bigstr = bigstr} end,
  indent = function (bigstr, ind)
      return Indent.new(bigstr):parse():map(ind or 0):concat()
    end,
  flatten = function (o)
      return Indent.indent(table.concat(flatten(o), "\n"))
    end,
  __index = {
    parse = function (ind)
        ind.A = VTable(pat_indent:match(ind.bigstr))
        return ind
      end,
    map = function (ind, r)
        ind.B = VTable {}
        for _,o in ipairs(ind.A) do
          if type(o) == "string"  then table.insert(ind.B, o)
          elseif o[1] == "nl"     then table.insert(ind.B, "\n"..(" "):rep(r))
          elseif o[1] == "indent" then r = r + o[2]
          else error()
          end
        end
        return ind
      end,
    concat = function (ind) return table.concat(ind.B) end,
  },
}

-- «string.indent»  (to ".string.indent")
string.indent = Indent.indent   -- works only on strings
indent        = Indent.flatten  -- works on strings and tables

-- «Indent-tests»  (to ".Indent-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent1.lua"
bigstr = "foo\nbar<+1>\nplic\nploc<-1>\nbof"
o = {"foo", {"bar<+1>", "plic", "ploc<-1>"}, "bof"}
= indent(bigstr)
= indent(o)
= bigstr:indent()
= bigstr:indent(4)

i = Indent.new(bigstr)
= i:parse().A
= i:parse():map(0).B
= i:parse():map(0):concat()
=               bigstr
= Indent.indent(bigstr)
= bigstr:indent()

= indent "foo\nbar<+1>\nplic\nploc<-1>\nbof"
= indent "foo\nbar<+1LR>\nplic\nploc<-1>\nbof"
= indent "foo\nbar<+1LR>\nplic\nploc<-1LR>\nbof"

--]]


-- «Ind-tests»  (to ".Ind-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent1.lua"

a = Ind {
  "% Grid",
  "% Horizontal lines:",
  "\\Line(-1.2,0)(3.2,0)",
  "\\Line(-1.2,1)(3.2,1)",
  "% Vertical lines:",
  "\\Line(0,-2.2)(0,5.2)",
  "\\Line(1,-2.2)(1,5.2)",
  }
b = Ind { "\\linethickness{0.5pt}", a }
c = Ind { "\\color{gray}", b }
d = Ind { "{<+1><!>", c, "}<-1>" }

= d:tostring0()
= d:tostring()
= d:flatten()
= d:flatten():indent()

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent1.lua"

a = { "%hlines", "%vlines" }
b = { "thick", a }
c = { "gray", b }
d = { "{<+1><!>", c, "}<-1>" }
= d
PP(d)
= Ind.flatten(d)
= Ind.flatten(d, "\n")
= Ind.flatten(d, "\n", 0)
= Ind.tostring (d)
= Ind.tostring0(d)

e = Ind.fromcopy(d)
PP(e)
= e
= e[2]
= e[2][2]

--]]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
