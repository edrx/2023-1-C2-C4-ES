-- This file:
--   http://anggtwu.net/LUA/ELpeg1.lua.html
--   http://anggtwu.net/LUA/ELpeg1.lua
--          (find-angg "LUA/ELpeg1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- See: http://anggtwu.net/2023-hacking-lpegrex.html
--
-- (defun e1 () (interactive) (find-angg "LUA/ELpeg1.lua"))
-- (defun e2 () (interactive) (find-angg "LUA/ELpeg2.lua"))
-- (defun g2 () (interactive) (find-angg "LUA/Gram2.lua"))
--
-- (find-sh0 "cp -v {ELpeg1,ELpeg-cme1,Tree1,Show2,Subst1,Globals1,PCall1}.lua ~/LATEX/")

-- «.AST»		(to "AST")
-- «.AST-tests»		(to "AST-tests")
-- «.E»			(to "E")
-- «.E-tests»		(to "E-tests")

-- «.Cast»		(to "Cast")
-- «.Cast-tests»	(to "Cast-tests")
-- «.Expected»		(to "Expected")
-- «.Expected-tests»	(to "Expected-tests")
-- «.Gram»		(to "Gram")
-- «.Gram-Vlast»	(to "Gram-Vlast")
-- «.Gram-tests»	(to "Gram-tests")
-- «.Keywords»		(to "Keywords")
-- «.Keywords-tests»	(to "Keywords-tests")
--
-- «.LpegDebug»		(to "LpegDebug")
-- «.LpegDebug-tests»	(to "LpegDebug-tests")
-- «.GramDebug»		(to "GramDebug")
-- «.GramDebug-tests»	(to "GramDebug-tests")
--
-- «.folds»		(to "folds")
-- «.folds-tests»	(to "folds-tests")
-- «.anyof»		(to "anyof")
-- «.anyof-tests»	(to "anyof-tests")
-- «.assocs»		(to "assocs")
-- «.assocs-test»	(to "assocs-test")
-- «.endingwith»	(to "endingwith")
-- «.endingwith-tests»	(to "endingwith-tests")
--
-- «.totex»			(to "totex")
-- «.totex-tests»		(to "totex-tests")
-- «.Globals»			(to "Globals")
-- «.Globals-tests»		(to "Globals-tests")
-- «.Parser.freeze»		(to "Parser.freeze")
-- «.Parser.freeze-tests»	(to "Parser.freeze-tests")
--
-- «.Parser»		(to "Parser")
-- «.Parser-tests»	(to "Parser-tests")

require "Tree1"    -- (find-angg "LUA/Tree1.lua")
require "Show2"    -- (find-angg "LUA/Show2.lua")
require "Subst1"   -- (find-angg "LUA/Subst1.lua")
require "Globals1" -- (find-angg "LUA/Globals1.lua")
require "lpeg"     -- (find-es "lpeg" "lpeg-quickref")
                   -- (find-es "lpeg" "globals")
lpeg = lpeg or require "lpeg" 

B,C,P,R,S,V = lpeg.B,lpeg.C,lpeg.P,lpeg.R,lpeg.S,lpeg.V
Cb,Cc,Cf,Cg = lpeg.Cb,lpeg.Cc,lpeg.Cf,lpeg.Cg
Cp,Cs,Ct    = lpeg.Cp,lpeg.Cs,lpeg.Ct
Carg,Cmt    = lpeg.Carg,lpeg.Cmt
lpeg.ptmatch = function (pat, str) PP(pat:Ct():match(str)) end
L = Code.L


--     _    ____ _____ 
--    / \  / ___|_   _|
--   / _ \ \___ \ | |  
--  / ___ \ ___) || |  
-- /_/   \_\____/ |_|  
--                     
-- «AST»  (to ".AST")
--
AST = Class {
  type = "AST",
  alttags = {},			     -- Override this!
  ify = function (o)                 -- "o" needs to be a (scratch) table.
      if o[0] and AST.alttags[o[0]]  -- In some cases
      then o[0] = AST.alttags[o[0]]  --  we change o[0],
      end                            -- and in all cases
      return AST(o)                  --  we change the metatable of o.
    end,
  __tostring = function (o) return tostring(SynTree.from(o)) end,
  __index = {
    -- See: (find-angg "LUA/Subst1.lua" "totex")
    --      (find-angg "LUA/Show2.lua"  "string.show")
    totex00 = function (o,...) return totex00(o,...) end, -- returns a tt
    totex0  = function (o,...) return totex0 (o,...) end, -- returns a tt
    totex   = function (o,...) return totex  (o,...) end, -- returns linear text
    show    = function (o,...) return totex(o):show(...) end  -- needs Show
  },
}

-- «AST-tests»  (to ".AST-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
= AST     {2, 3, 4}
= AST     {[0]="mul", 2, 3, 4}
= AST     {[0]="mul", 2, 3, AST {4,5,6}}
= AST.ify {[0]="mul", 2, 3, AST {4,5,6}}

  AST.alttags = {mul="*"}   -- changes "mul" to "*" in AST.ify

= AST     {[0]="mul", 2, 3, AST     {[0]="mul",4,5,6}}
= AST     {[0]="mul", 2, 3, AST.ify {[0]="mul",4,5,6}}
= AST.ify {[0]="mul", 2, 3, AST     {[0]="mul",4,5,6}}   
= AST.ify {[0]="mul", 2, 3, AST.ify {[0]="mul",4,5,6}}   

--]]



--  _____ 
-- | ____|
-- |  _|  
-- | |___ 
-- |_____|
--        
-- "E" lets us create a dictionary whose entries are strings,
-- and whose values are ASTs that show how those strings are
-- expected to be parsed - usually by a grammar that we haven't
-- written yet.
-- «E»  (to ".E")

entries = {}
E = setmetatable({}, {
    __call     = function (_,name) return entries[name] end,
    __index    = function (_,name) return entries[name] end,
    __newindex = function (_,name,o) entries[name] = o end,
  })

mkast = function (op, ...) return AST.ify {[0]=op, ...} end

-- «E-tests»  (to ".E-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
  E[      "4*5"] = mkast("*", 4, 5)
  E["2*3"      ] = mkast("*", 2, 3)
  E["2*3 + 4*5"] = mkast("+", E"2*3", E"4*5")
= E["2*3 + 4*5"]

--]]




-- «Cast»  (to ".Cast")
-- These two are similar:
--      Cast(tag, pat)
--   lpeg.Ct     (pat)
-- but the version with "Cast" converts the table to an AST.

Ckv   = function (key, val) return Cg(Cc(val), key) end
C0    = function (tag)      return Cg(Cc(tag), 0)   end
Cast  = function (tag, pat) return Ct(C0(tag)*pat) / AST.ify end

-- «Cast-tests»  (to ".Cast-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
N    = Cs(R"09")
op   = Cs(R"*/")
expr = Cast("muls", N*(op*N)^0)
= expr:match("2*3/4*5") 

--]]



--  _____                      _           _ 
-- | ____|_  ___ __   ___  ___| |_ ___  __| |
-- |  _| \ \/ / '_ \ / _ \/ __| __/ _ \/ _` |
-- | |___ >  <| |_) |  __/ (__| ||  __/ (_| |
-- |_____/_/\_\ .__/ \___|\___|\__\___|\__,_|
--            |_|                            
-- Usage:
--   Expected.C("patfoo", patfoo)
--   Cexpect   ("patfoo", patfoo)
-- creates an lpeg pattern that tries to match patfoo,
-- and when that fails it aborts with an error that
-- mentions the name "patfoo".
-- This is used by the class Gram.
--
-- «Expected»  (to ".Expected")
Expected = Class {
  type = "Expected",
  -- prat = prat1,
  prat0 = function (subj, pos, patname)
      print("At: "..pos)                  -- very primitive
    end,
  prat1 = function (subj, pos, patname)
      print("At:  "..(" "):rep(pos).."^") -- slightly better
    end,
  err = function (subj, pos, patname)
      print("Subj: "..subj)
      Expected.prat(subj, pos, patname)
      print("Expected: "..patname)
      error()
    end,
  --
  C = function (patname, pat)
      local f = function(subj, pos) Expected.err(subj, pos, patname) end
      return pat + (P""):Cmt(f)
    end,
  P = function (str)
      return Expected.C(str, P(str))
    end,
  __index = {
  },
}
-- Choose one:
-- Expected.prat = Expected.prat0
   Expected.prat = Expected.prat1

Cexpected = Expected.C

-- «Expected-tests»  (to ".Expected-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
Expected.prat = Expected.prat0
pa = P"a"
pb = P"b"
pat = pa*pb
= pat:match("abc")
pat = pa*Cexpected("pb", pb)
= pat:match("abc")
= pat:match("ac")
Expected.prat = Expected.prat1
= pat:match("abc")
= pat:match("ac")

--]]




--   ____                     
--  / ___|_ __ __ _ _ __ ___  
-- | |  _| '__/ _` | '_ ` _ \ 
-- | |_| | | | (_| | | | | | |
--  \____|_|  \__,_|_| |_| |_|
--                            
-- In the terminology of
--   http://www.inf.puc-rio.br/~roberto/lpeg/lpeg.html#grammar
-- an object of the class Gram is a grammar that:
--   1) hasn't been "fixed" yet,
--   2) doesn't have an initial rule yet,
--   3) has a nicer interface.
--
-- The typical usage is:
--   gr,V,VAST,VEXPECT,PEXPECT = Gram.new()
-- Notes: this V overrides the "V = lpeg.V";
-- and I need to document VAST...
--
-- «Gram»  (to ".Gram")
Gram = Class {
  type = "Gram",
  new = function ()
     return Gram.fromentries(VTable {})
   end,
  --
  -- To save the last definition, use: (to "Gram-Vlast")
  set = function (entries, name, pat)
      entries[name] = pat
    end,
  fromentries = function (entries)
      local gr = Gram {entries=entries}
      local V = setmetatable({}, {
        __call     = function (_,name) return lpeg.V(name) end,
        __index    = function (_,name) return lpeg.V(name) end,
        __newindex = function (_,name,pat)
            Gram.set(entries, name, pat)
          end,
      })
      local VAST = setmetatable({}, {
        __newindex = function (v,name,pat)
            Gram.set(entries, name, Cast(name,pat))
          end,
      })
      local VEXPECT = setmetatable({}, {
        __call  = function (_,name) return Expected.C(name, lpeg.V(name)) end,
        __index = function (_,name) return Expected.C(name, lpeg.V(name)) end,
      })
      local PEXPECT = setmetatable({}, {
        __call  = function (_,str) return Expected.P(str) end,
        __index = function (_,str) return Expected.P(str) end,
      })
      return gr,V,VAST,VEXPECT,PEXPECT
    end,
  --
  from = function (oldgram)  -- untested
      return Gram.fromentries(VTable(copy(oldgram.entries)))
    end,
  --
  __tostring = function (gr) return gr:tostring() end,
  __index = {
    grammar0 = function (gr, top)
        local entries = copy(gr.entries)
        entries[1] = top
        return entries
      end,
    grammar = function (gr, top) return gr:grammar0(top) end,
    compile = function (gr, top) return lpeg.P(gr:grammar(top)) end,
    cm0 = function (gr, top, subj, pos)
        if type(pos) == "string" then pos = subj:match(pos) end
        return gr:compile(top):match(subj, pos)
      end,
    cm  = function (gr, ...) return trees(gr:cm0(...)) end,
    cmp = function (gr, ...) PP(gr:cm0(...)) end,
    tostring = function (gr, sep)
        local ks = sorted(keys(gr.entries))
        return mapconcat(mytostring, ks, sep or "\n")
      end,
    --
    debug = function (gr, ...) return GramDebug.from(gr, ...) end,
  },
}

grcm = function (...) print(gr:cm(...)) end

-- «Gram-Vlast»  (to ".Gram-Vlast")
-- This is useful, but uses a global with a hardcoded name:
--   Gram.set = function (entries, name, pat)
--       Vlast = pat
--       entries[name] = pat
--     end


-- «Gram-tests»  (to ".Gram-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
gr,V,VA,VE,PE = Gram.new()
_ = S(" ")^0

V.N    = Cs(R"09")
V.pow  =        V.N   *  C"^" * V.N         grcm("pow", "1^2^3")
V.pow  =        V.N   * (C"^" * V.N)^0      grcm("pow", "1^2^3")

V.pow  = Ct(    V.N   * (C"^" * V.N  )^0)   grcm("pow", "1^2^3")
V.div  = Ct(    V.pow * (C"/" * V.pow)^0)   grcm("div", "4/5/6")
V.sub  = Ct(    V.div * (C"-" * V.div)^0)   grcm("sub", "1^2^3-4/5/6")

VA.pow =        V.N   * (C"^" * V.N  )^0    grcm("pow", "1^2^3")
VA.div =        V.pow * (C"/" * V.pow)^0    grcm("div", "4/5/6")
VA.sub =        V.div * (C"-" * V.div)^0    grcm("sub", "1^2^3-4/5/6")

V.pow  = assocr(V.N,     C"^")              grcm("pow", "1^2^3")
V.div  = assocl(V.pow,   C"/")              grcm("div", "4/5/6")
V.sub  = assocl(V.div,   C"-")              grcm("sub", "1^2^3 - 4/5/6 - 7")
                                            grcm("sub", "1^2^3 - 4/5/(6-7)")

V.basic = "("*_* V.expr *_*")" + V.N
V.pow   = assocr(V.basic, C"^")
V.div   = assocl(V.pow,   C"/")
V.sub   = assocl(V.div,   C"-")
V.expr  = V.sub                               grcm("expr", "1^2^3 - 4/5/(6-7)")

V.basic  = V.paren + V.N                    
V .paren =               "("*_*V.expr*_*")"   grcm("expr", "1^2^3 - 4/5/(6-7)")
VA.paren =               "("*_*V.expr*_*")"   grcm("expr", "1^2^3 - 4/5/(6-7)")
V .paren = Cast("Paren", "("*_*V.expr*_*")")  grcm("expr", "1^2^3 - 4/5/(6-7)")
V .paren = Cast("()",    "("*_*V.expr*_*")")  grcm("expr", "1^2^3 - 4/5/(6-7)")
V .paren = Cast(nil,     "("*_*V.expr*_*")")  grcm("expr", "1^2^3 - 4/5/(6-7)")

V .paren =               "("*_*V.expr*_*")"   grcm("expr", "1^2^3 - 4/5/(6-7")
V .paren =               "("*_*V.expr*_*PE")" grcm("expr", "1^2^3 - 4/5/(6-7")
V .paren =               "("*_*V.expr*_*PE")" grcm("expr", "1^2^3 - 4/5/(6-7)")

--]]

-- Old?
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
gr,V,VA,VE = Gram.new()
grcm = function (...) print(gr:cm(...)) end
_ = S(" ")^0

VA.pow = V.N   * (C"^" * V.N)^0
=        gr:cm("pow", "1^2^3")

VA.sub = V.N * C"-" * V.N
=        gr:cm("sub", "2-3-4")
VA.sub = V.N * (C"-" * V.N)^0
=        gr:cm("sub", "2-3-4")

VA.N  = Cs((R"09")^1)
V .op = Cs(P"-")
VA.A  = V.N * (V.op * V .N)^0
VA.B  = V.N * (V.op * VE.N)^0

= gr
= gr:grammar()
= gr:grammar("A")
= gr:cm("A", "2-3-4,  foo")
= gr:cm("A", "2-3-4-, foo")
= gr:cm("B", "2-3-4-, foo")

--]]



--  _  __                                _     
-- | |/ /___ _   ___      _____  _ __ __| |___ 
-- | ' // _ \ | | \ \ /\ / / _ \| '__/ _` / __|
-- | . \  __/ |_| |\ V  V / (_) | | | (_| \__ \
-- |_|\_\___|\__, | \_/\_/ \___/|_|  \__,_|___/
--           |___/                             
--
-- «Keywords»  (to ".Keywords")
-- This class implements the idea that some "words"
-- are "keywords" and the other ones are "non-keywords".
-- A linguistic trick: an "anonkeyword"
--                     is "a non-key word".
-- Typical usage:
--   word = Cs(R"az"^1)
--   keywords,K,KE,KW,NKW = Keywords.from(word)
--
Keywords = Class {
  type = "Keywords",
  from = function (wordpat)
      local keywords = Set.new()
      local addkeyword = function (kw) keywords:add(kw); return kw end
      local isakeyword = function (subj,pos,captk)
          if keywords:has(captk) then return pos,captk end
        end
      local isanonkeyword = function (subj,pos,captk)
          if not keywords:has(captk) then return pos,captk end
        end
      local isthis = function (kw)
          return function (subj,pos,captk)
              if captk == kw then return pos,captk end
            end
        end
      local AKEYWORD    = wordpat:Cmt(isakeyword)
      local ANONKEYWORD = wordpat:Cmt(isanonkeyword)
      local THISKEYWORD = function (kw)
          addkeyword(kw)
          return wordpat:Cmt(isthis(kw))
        end
      local EXPECTTHISKEYWORD = function (kw)
          return Cexpected(kw, THISKEYWORD(kw))
        end
      local K = setmetatable({}, {
          __call = function (_,kw) return THISKEYWORD(kw) end,
        })
      local KE = setmetatable({}, {
          __call = function (_,kw) return EXPECTTHISKEYWORD(kw) end,
        })
      local KW  = AKEYWORD
      local NKW = ANONKEYWORD
      return Keywords {
          wordpat = wordpat,
          keywords = keywords,
          addkeyword = addkeyword,
          isakeyword = isakeyword,
          isanonkeyword = isanonkeyword,
          isthis = isthis,
          AKEYWORD = AKEYWORD,
          ANONKEYWORD = ANONKEYWORD,
          THISKEYWORD = THISKEYWORD,
          EXPECTTHISKEYWORD = EXPECTTHISKEYWORD,
          K = K,
        }, K,KE,KW,NKW
    end,
  __tostring = function (ks) return ks.keywords:ksc(" ") end,
  __index = {
  },
}

-- «Keywords-tests»  (to ".Keywords-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
word = Cs(R"az"^1)
keywords,K,KE,KW,NKW = Keywords.from(word)
pdo  = K"do"
pend = K"end"
edo  = KE"do"
PPPV(keywords)
=    keywords          --> do end
= word:match("doo_0")  --> doo
= word:match("do_0")   --> do
= KW  :match("doo_0")  --> nil
= KW  :match("do_0")   --> do
= NKW :match("doo_0")  --> doo
= NKW :match("do_0")   --> nil
= pdo :match("doo_0")  --> nil
= pdo :match("do_0")   --> do
= edo :match("do_0")   --> do
= edo :match("doo_0")  --> do

--]]



--  _                      ____       _                 
-- | |    _ __   ___  __ _|  _ \  ___| |__  _   _  __ _ 
-- | |   | '_ \ / _ \/ _` | | | |/ _ \ '_ \| | | |/ _` |
-- | |___| |_) |  __/ (_| | |_| |  __/ |_) | |_| | (_| |
-- |_____| .__/ \___|\__, |____/ \___|_.__/ \__,_|\__, |
--       |_|         |___/                        |___/ 
--
-- An object of the class LpegDebug contains a way of adding debug
-- information to an lpeg pattern. Normally this is used by the class
-- GramDebug, defined below, that implements ways to add debug
-- information to several entries of a grammar.
--
-- This "debug information" consists of several "pieces", and this
-- class contains methods for adding some, all, or the default "pieces
-- of debug information" to an lpeg pattern. The default is to add
-- only "match-time debugging" (style = "cmt"); use style = "slash" to
-- add only "slash debugging", and use style = "cmt slash" to add both.
--
-- See: (find-es "lpeg" "pegdebug0")
--      (find-es "lpeg" "pegdebug")
-- «LpegDebug»  (to ".LpegDebug")
--
LpegDebug = Class {
  type = "LpegDebug",
  from = function (name)
      return LpegDebug {name=name}
    end,
  __tostring = function (lpd) return mytostringp(lpd) end,
  __index = {
    subst = function (lpd, fmt, pos)
        local name = lpd.name
        local A = {name=name, pos=pos}
        return (fmt:gsub("<(.-)>", A))
      end,
    --
    -- Methods for matchtime debugging
    cmtfmt = function (lpd, fmt)
        return function (subj,pos,...)
            printf(lpd:subst(fmt, pos))
            return pos
          end
      end,
    cmt0   = function (lpd, fmt, pat) return pat:Cmt(lpd:cmtfmt(fmt)) end,
    cmtt   = function (lpd, fmt) return lpd:cmt0(fmt, lpeg.P(true)) end,
    pcbeg  = function (lpd) return lpd:cmtt("(<name>:<pos>\n") end,
    pcmid  = function (lpd) return lpd:cmtt(" <name>:<pos>\n") end,
    pcend  = function (lpd) return lpd:cmtt(" <name>:<pos>)\n") end,
    pcfail = function (lpd) return lpd:cmtt(" <name>:fail)\n") end,
    cmtdbg = function (lpd, pat)
        return lpd:pcbeg()*pat*lpd:pcend()
             + lpd:pcfail()*P(false)
      end,
    --
    -- Mathods for slash debugging
    slfmt   = function (lpd, fmt)
        return function (pos)
            printf(lpd:subst(fmt, pos))
          end
      end,
    psl0   = function (lpd, fmt) return Cp() / lpd:slfmt(fmt) end,
    pslbeg = function (lpd) return lpd:psl0("[<name>:<pos>\n") end,
    pslmid = function (lpd) return lpd:psl0(" <name>:<pos>\n") end,
    pslend = function (lpd) return lpd:psl0(" <name>:<pos>]\n") end,
    psldbg = function (lpd, pat) return lpd:pslbeg()*pat*lpd:pslend() end,
    --
    -- Choose a style
    style = "cmt",
    dbg = function (lpd, pat)
        if lpd.style:match("cmt")   then pat = lpd:cmtdbg(pat) end
        if lpd.style:match("slash") then pat = lpd:psldbg(pat) end
        return pat
      end,
  },
}

-- «LpegDebug-tests»  (to ".LpegDebug-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
LpegDebug.__index.style = "slash"
LpegDebug.__index.style = "cmt"
lpd = LpegDebug.from("A")
= lpd
= lpd:subst("foo")
= lpd:subst("foo:<name>")
= lpd:subst("foo:<name>:<pos>.", 42)

pa = P"aa":Cs()
pb = P"bb":Cs()
pc = P"cc":Cs()

-- Test matchtime debugging
pbeg  = lpd:cmtt("(<name>:<pos>\n")
pmid  = lpd:cmtt(" <name>:<pos>\n")
pend  = lpd:cmtt(" <name>:<pos>)\n")
pfail = lpd:cmtt(" <name>:fail)\n")
pbeg  = lpd:pcbeg()
pmid  = lpd:pcmid()
pend  = lpd:pcend()
pfail = lpd:pcfail()

= (pa*pb) : match("aabbcc")
= (pbeg*pa*pmid*pb*pend)    : match("aabbcc")
= (pbeg*pa*pb*pend)         : match("aabbcc")
= (pbeg*pa*pb*pend + pfail) : match("aabbcc")
= (pbeg*pa*pb*pend + pfail) : match("aacc")

--]]

--[[
-- Test changing styles

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
LpegDebug.__index.style = "cmt"   -- Start with matchtime
dbg = function (name, pat) return LpegDebug.from(name):dbg(pat) end

pa  = P"aa":Cs()
pb  = P"bb":Cs()
pc  = P"cc":Cs()
pab = pa * (pb+pc)

pda = dbg("a", pa)
= pda:match("aa")
= pda:match("cc")

LpegDebug.__index.style = "slash"  -- Switch to slash
pda = dbg("a", pa)
= pda:match("aa")
= pda:match("cc")

-- Bigger examples. Choose one style
LpegDebug.__index.style = "cmt"
LpegDebug.__index.style = "slash"
LpegDebug.__index.style = "cmt slash"
pda  = dbg("a", pa)
pdb  = dbg("b", pb)
pdc  = dbg("c", pc)
pdab = dbg("ab", pda * (pdb+pdc))
= pab :match("aacc")
= pdab:match("aacc")

--]]



--   ____                     ____       _                 
--  / ___|_ __ __ _ _ __ ___ |  _ \  ___| |__  _   _  __ _ 
-- | |  _| '__/ _` | '_ ` _ \| | | |/ _ \ '_ \| | | |/ _` |
-- | |_| | | | (_| | | | | | | |_| |  __/ |_) | |_| | (_| |
--  \____|_|  \__,_|_| |_| |_|____/ \___|_.__/ \__,_|\__, |
--                                                   |___/ 
--
-- An object of the class GramDebug contains an object of the class
-- Gram and a set of "dbgnames". A dbgname is the name of an entry of
-- the grammar that has to be modified by the method "modifyentry"
-- when the grammar is compiled; the modification is performed by the
-- class LpegDebug, that puts some debugging code around the original
-- pattern associated to that name.
--
-- «GramDebug»  (to ".GramDebug")
--
GramDebug = Class {
  type = "GramDebug",
  from = function (gr, style)
      local dbgnames = Set.new()
      if style then LpegDebug.__index.style = style end
      return GramDebug {gr=gr, dbgnames=dbgnames}
    end,
  __tostring = function (lds)
      return "dbgnames: "..lds.dbgnames:ksc(" ")
    end,
  __index = {
    dbg = function (grd, names)
        for _,name in ipairs(split(names)) do grd.dbgnames:add(name) end
      end,
    --
    -- See: (to "Gram")
    modifyentry = function (grd, entries, name)
        entries[name] = LpegDebug.from(name):dbg(grd.gr.entries[name])
      end,
    compile = function (grd, top)
        local entries = copy(grd.gr.entries)
        for name in grd.dbgnames:gen() do grd:modifyentry(entries, name) end
        entries[1] = top
        return lpeg.P(entries)
      end,
    cm0 = function (gr, top, subj, pos)
        if type(pos) == "string" then pos = subj:match(pos) end
        return grd:compile(top):match(subj, pos)
      end,
    cm = function (grd, ...) return trees(grd:cm0(...)) end,
  },
}

-- «GramDebug-tests»  (to ".GramDebug-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
gr,V = Gram.new()
V.aa = Cs"aa"
V.bb = Cs"bb"
V.cc = Cs"cc"
V.ab = V.aa * (V.bb + V.cc)

grd  = GramDebug.from(gr)
grd:dbg "aa"
= grd:cm("ab", "aabbcc")
grd:dbg "bb"
= grd:cm("ab", "aabbcc")

grd  = GramDebug.from(gr)
grd:dbg "bb"
= grd:cm("ab", "aabbcc")

--]]





--  _____     _     _     
-- |  ___|__ | | __| |___ 
-- | |_ / _ \| |/ _` / __|
-- |  _| (_) | | (_| \__ \
-- |_|  \___/|_|\__,_|___/
--                        
-- «folds»  (to ".folds")
-- Based on: (find-angg "LUA/lua50init.lua" "fold")
--
foldl2 = function (A)  -- starts from the left
    local B = A[1]
    for i=3,#A,2 do
      local op,c = A[i-1],A[i]
      B = AST {[0]=op, B, c}
    end
    return B
  end
foldr2 = function (A)  -- starts from the right
    local B = A[#A]
    for i=#A-2,1,-2 do
      local c,op = A[i],A[i+1]
      B = AST {[0]=op, c, B}
    end
    return B
  end
foldh2 = function (A)
    if type(A) ~= "table" then return A end
    if #A == 1 then return A end
    local B = AST {[0]=A[2], A[1]}
    for i=3,#A,2 do table.insert(B, A[i]) end
    return B
  end
foldh  = function (A)   -- an horizontal pseudo-fold, for debugging
    if type(A) ~= "table" then return A end
    if #A == 1 then return A[1] end
    return AST(A)
  end
foldpost = function (A)
    local f = function (e, op) return AST {[0]="Post", e, op} end
    return foldl1(f, A)
  end
foldpre = function (A)
    local f = function (op, e) return AST {[0]="Pre", op, e} end
    return foldr1(f, A)
  end

-- «folds-tests»  (to ".folds-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
= foldl2 {2, "-", 4, "-", 6, "-", 8}   --> ((2-4)-6)-8
= foldr2 {2, "^", 4, "^", 6, "^", 8}   --> 2^(4^(6^8))
= foldl2 {2, "+", 4, "*", 6, "/", 8}
= foldr2 {2, "+", 4, "*", 6, "/", 8}
= foldh2 {2, "+", 4, "*", 6, "/", 8}
= foldh  {2, "+", 4, "*", 6, "/", 8}
= foldl2 {2}
= foldr2 {2}
= foldh2 {2}
= foldh  {2}
= foldh  (2)
= foldpost {"a", "()", "{}", "[]"}
= foldpre  {"!", "~", "#", "a"}

--]]


--     _                       __ 
--    / \   _ __  _   _  ___  / _|
--   / _ \ | '_ \| | | |/ _ \| |_ 
--  / ___ \| | | | |_| | (_) |  _|
-- /_/   \_\_| |_|\__, |\___/|_|  
--                |___/           
--
-- «anyof»  (to ".anyof")
-- Uses: (find-angg "LUA/lua50init.lua" "fold" "foldl1")
-- Based on: (find-angg "LUA/Caepro4.lua" "AnyOf")
-- Usage:
--   anyof("+ - *")
-- returns this pattern:
--   Cs("+") + Cs("-") + Cs("*")
--
anyof = function (str)
    local plus = function (a, b) return a+b end
    return foldl1(plus, map(Cs, split(str)))
  end
Cparen0 = function (o,c,pat) return            P(o)*_* pat *_*P(c)  end
Cparen  = function (o,c,pat) return Cast(o..c, P(o)*_* pat *_*P(c)) end

-- «anyof-tests»  (to ".anyof-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
gr,V,VA = Gram.new()
V.op    = anyof "+ - * /"
V.N     = Cs(R"09"^1)
V.foo   = V.N * (V.op * V.N)^0
VA.Foo  = V.N * (V.op * V.N)^0
 gr:cmp("foo", "1*2+3-4/5")
= gr:cm("foo", "1*2+3-4/5")
= gr:cm("Foo", "1*2+3-4/5")

_       = S" "^0
V.p     = Cparen(".(", ").", V.Foo)
= gr:cm("p", ".(1*2+3-4/5).")

--]]



--     _                           
--    / \   ___ ___  ___   ___ ___ 
--   / _ \ / __/ __|/ _ \ / __/ __|
--  / ___ \\__ \__ \ (_) | (__\__ \
-- /_/   \_\___/___/\___/ \___|___/
--                                 
-- «assocs»  (to ".assocs")
-- "pe" is the "expression pattern".
-- "po" is the "operator pattern".
assoct     = function (pe, po) return Ct(pe * (_* po *_* pe)^0) end
assocl     = function (pe, po) return assoct(pe, po) / foldl2 end
assocr     = function (pe, po) return assoct(pe, po) / foldr2 end
assoch     = function (pe, po) return assoct(pe, po) / foldh  end
assocpost  = function (pe, po) return Ct(pe*(_*po)^0) / foldpost end
assocpostp = function (pe, po) return Ct(pe*(_*po)^1) / foldpost end
assocpre   = function (po, pe) return Ct((po*_)^0*pe) / foldpre  end

-- «assocs-test»  (to ".assocs-test")
-- TODO: tests for assocpost and assocpre
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"

gr,V   = Gram.new()

V.Num    = (R"09")^1
V.S      = (S" \t\n")^0
V.sNum   = Cs(V"Num")
  _      = V.S

V.expr2  = assocl(V.expr1, Cs"^")
V.expr3  = assocr(V.expr2, Cs"/")
V.expr4  = assocr(V.expr3, Cs"-")
V.pexpr4 = "(" * _ * V.expr4 * _ * ")"
V.expr1  = V.sNum + V.pexpr4
V.expr1  = V.pexpr4 + V.sNum

subj = "1^2^3 - 4/5/6 / 7^8^9^(10-11)"

= subj
= gr:cm("expr4", subj)

= Ct(Cg(Cc("name"),"tag"))
= Ct(Cg(Cc("name"),0))

--]]


--                 _ _                      _ _   _     
--   ___ _ __   __| (_)_ __   __ ___      _(_) |_| |__  
--  / _ \ '_ \ / _` | | '_ \ / _` \ \ /\ / / | __| '_ \ 
-- |  __/ | | | (_| | | | | | (_| |\ V  V /| | |_| | | |
--  \___|_| |_|\__,_|_|_| |_|\__, | \_/\_/ |_|\__|_| |_|
--                           |___/                      
--
-- «endingwith»  (to ".endingwith")
-- Some simple parser combinators.
-- See: (find-es "haskell" "ReadS")
-- "endingwith" is used to define statements and lvalues in Lua.
--
-- oneormorec  (expr, comma): one or more exprs, separated by commas
-- oneormorecc (expr, comma): one or more exprs, separated by commas,
--                            allowing an optional extra comma at the end
-- zeroormorec (expr, comma): zero or more exprs, separated by commas
-- zeroormorecc(expr, comma): zero or more exprs, separated by commas,
--                            allowing an optional extra comma at the end
-- endingwith  (pa, pb):      a sequence of pas and pbs ending with a pb

oneormorec   = function (pe, pc) return pe * (_*pc*_*pe)^0 end
oneormorecc  = function (pe, pc) return oneormorec (pe, pc) * (_*pc)^-1 end
zeroormorec  = function (pe, pc) return oneormorec (pe, pc)^-1 end

zeroormorecc = function (pe, pc) return oneormorecc(pe, pc)^-1 end
endingwith   = function (pa, pb) return (_* (pa*_)^0 * pb)^1 end

-- «endingwith-tests»  (to ".endingwith-tests")
-- TODO: write better tests.
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
_  = (P" ")^0
pe = Cs "4"
pa = Cs".a"
pb = Cs"(b)"
pc = Cs ","
= oneormorec  (pe, pc):match("4, 4,")
= oneormorecc (pe, pc):match("4, 4,")
= zeroormorec (pe, pc):match("4, 4,")
= zeroormorecc(pe, pc):match("4, 4,")
= endingwith  (pa, pb):match(" .a (b) .a .a (b) .a")

--]]







--  _        _            
-- | |_ ___ | |_ _____  __
-- | __/ _ \| __/ _ \ \/ /
-- | || (_) | ||  __/>  < 
--  \__\___/ \__\___/_/\_\
--                        
-- This is the basic way to convert ASTs to TeX code.
-- I moved its code to Subst1.lua, that is "require"d. See:
--   (find-angg "LUA/Subst1.lua" "Subst")
--   (find-angg "LUA/Subst1.lua" "totex")
-- «totex»        (to ".totex")

-- «totex-tests»  (to ".totex-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
fmts      = VTable {}
fmts["+"] = "<1> + <2>"
fmts["*"] = "<1> \\cdot <2>"

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


 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"

fmts = VTable {}
funs = VTable {}
-- totex00 = ToTeX0 {fmts=fmts, funs=funs}
fmts.ap  = "<1> <2>"
fmts.fun = "<1>"
fmts.var = "<1>"
funs.sin = "\\sin "

  E["sin"]   = mkast("fun", "sin")
  E[    "x"] = mkast("var", "x")
  E["sin x"] = mkast("ap", E"sin", E"x")
= E["sin x"]
= E["sin x"][1]
= E["sin x"]:totex()

= E["sin x"]:totex()
fmts.fun = "<funs[o[1]] or o[1]>"
= E["sin x"]:totex()

       (code-etv2 "SHOW2DIR" "/tmp/" "Show2")
 (find-code-etv2 "SHOW2DIR" "/tmp/" "Show2")
= E["sin x"]:totex():show()
= E["sin x"]:totex():show(4)
= E["sin x"]:show(2.5)
 (etv)

--]==]



--   ____ _       _           _     
--  / ___| | ___ | |__   __ _| |___ 
-- | |  _| |/ _ \| '_ \ / _` | / __|
-- | |_| | | (_) | |_) | (_| | \__ \
--  \____|_|\___/|_.__/ \__,_|_|___/
--                                  
-- I moved this code to Globals1.lua, that is "require"d.
-- See: (find-angg "LUA/Globals1.lua")
--
-- «Globals»  (to ".Globals")
-- «Globals-tests»  (to ".Globals-tests")


--  ____                             __                       
-- |  _ \ __ _ _ __ ___  ___ _ __   / _|_ __ ___  ___ _______ 
-- | |_) / _` | '__/ __|/ _ \ '__| | |_| '__/ _ \/ _ \_  / _ \
-- |  __/ (_| | |  \__ \  __/ | _  |  _| | |  __/  __// /  __/
-- |_|   \__,_|_|  |___/\___|_|(_) |_| |_|  \___|\___/___\___|
--                                                            
-- Work in progress!
-- See: (find-angg "LUA/ELpeg-cme1.lua" "Freeze")
-- «Parser.freeze»  (to ".Parser.freeze")

Parser = Class {
  type   = "Parser",
  freeze = function (top)
      local p = Parser({top=top}):compile():save()
      return p:matcher(),p
    end,
  __index = {
    compile = function (p) grc = gr:compile(p.top); return p end,
    save    = function (p) p.globals = p:save0(); return p end,
    save0   = function (p) return Globals.save "gr grc fmts funs" end,
    restore = function (p) p.globals:restore(); return p end,
    match   = function (p, subj, pos) p:restore(); return p:match0(subj, pos) end,
    match0  = function (p, subj, pos)
        if type(pos) == "string" then pos = subj:match(pos) end
        return grc:match(subj, pos)
      end,
    matcher = function (p) return function (...) return p:match(...) end end,
  },
}

-- «Parser.freeze-tests»  (to ".Parser.freeze-tests")
--[[
-- (find-angg "LUA/Globals1.lua" "Globals-tests")
-- These tests are broken

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ELpeg1.lua"
dofile "Globals1.lua"

lambda_globals = Globals.save "fmts funs gr"
lambda_totex   = lambda_globals:fun(function (...) totex  (...) end)
lambda_totex0  = lambda_globals:fun(function (...) totex0 (...) end)
lambda_totex00 = lambda_globals:fun(function (...) totex00(...) end)

lambda_totex   = lambda_globals:fun(totex)
lambda_totex0  = lambda_globals:fun(totex0)
lambda_totex00 = lambda_globals:fun(totex00)


--]]






-- Local Variables:
-- coding:  utf-8-unix
-- End:
