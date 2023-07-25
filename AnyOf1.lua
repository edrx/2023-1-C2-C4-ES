-- This file:
--   http://anggtwu.net/LUA/AnyOf1.lua.html
--   http://anggtwu.net/LUA/AnyOf1.lua
--          (find-angg "LUA/AnyOf1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/AnyOf1.lua"))
--
-- Based on:
-- (find-angg "LUA/Caepro4.lua" "MkTable")
-- (find-angg "LUA/Caepro4.lua" "AnyOf")

-- «.MkTable»		(to "MkTable")
-- «.MkTable-tests»	(to "MkTable-tests")
-- «.AnyOf»		(to "AnyOf")
-- «.AnyOf-tests»	(to "AnyOf-tests")


require "lpeg"       -- (find-es "lpeg" "lpeg-quickref")
                     -- (find-es "lpeg" "globals")
lpeg         = lpeg or require "lpeg" 
B,C,P,R,S,V  = lpeg.B,lpeg.C,lpeg.P,lpeg.R,lpeg.S,lpeg.V
Cb,Cc,Cf,Cg  = lpeg.Cb,lpeg.Cc,lpeg.Cf,lpeg.Cg
Cp,Cs,Ct     = lpeg.Cp,lpeg.Cs,lpeg.Ct
Carg,Cmt     = lpeg.Carg,lpeg.Cmt
lpeg.ptmatch = function (pat, str) PP(pat:Ct():match(str)) end
lpeg.Copyto  = function (pat, tag) return pat:Cg(tag) * Cb(tag) end




--  __  __ _    _____     _     _      
-- |  \/  | | _|_   _|_ _| |__ | | ___ 
-- | |\/| | |/ / | |/ _` | '_ \| |/ _ \
-- | |  | |   <  | | (_| | |_) | |  __/
-- |_|  |_|_|\_\ |_|\__,_|_.__/|_|\___|
--                                     
-- «MkTable»  (to ".MkTable")
-- Supersedes: (find-angg "LUA/Caepro4.lua" "MkTable")

MkTable = Class {
  type  = "MkTable",
  from  = function (bigstr) return MkTable.from0(bigstr):read() end,
  from0 = function (bigstr) return MkTable {bigstr=bigstr, _=VTable{}} end,
  __tostring = function (mkt) return "a MkTable whose bigstr is:\n"..mkt.bigstr end,
  __index = {
    pat  = "(%S+) +%-> +(%S+)",
    kvs  = function (mkt) return mkt.bigstr:gmatch(mkt.pat) end,
    read = function (mkt) for k,v in mkt:kvs() do mkt._[k] = v end; return mkt end,
    v    = function (mkt,k) return mkt._[k] end,
  },
}

mktable = function (bigstr) return MkTable.from(bigstr)._ end

-- «MkTable-tests»  (to ".MkTable-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "AnyOf1.lua"
bigstr = [[
  foobar  -> OOBAR    (This is a comment)
  foo     -> OO
  foob    -> OOB
]]
  mkt = MkTable.from0(bigstr); PPPV(mkt)
  mkt = MkTable.from (bigstr); PPPV(mkt)
= mkt._
= mktable(bigstr)

= mkt
= mkt:v("foo")
  for k,v in mkt:kvs() do print(k,v) end   -- parses bigstr again

--]==]


--     _                 ___   __ 
--    / \   _ __  _   _ / _ \ / _|
--   / _ \ | '_ \| | | | | | | |_ 
--  / ___ \| | | | |_| | |_| |  _|
-- /_/   \_\_| |_|\__, |\___/|_|  
--                |___/           
--
-- «AnyOf»  (to ".AnyOf")
-- Supersedes:
--   (find-angg "LUA/Caepro4.lua" "AnyOf")
-- This class implements a version of this basic "anyof",
--   (find-angg "LUA/Gram2.lua" "anyof")
-- that uses a MkTable to translate the matched string.
-- Idea:
--   ms     is the matched string,
--   tms    is the translated version of the matched string,
--   mtag   says where to store the matched string,
--   tmtag  says where to store the translated matched string


AnyOf = Class {
  type = "AnyOf",
  from = function (bigstr, mtag, tmtag, default)
      local mkt = MkTable.from(bigstr)
      return AnyOf {mkt=mkt, mtag=mtag, tmtag=tmtag, default=default}
    end,
  __tostring = function (anyo)
      return "An AnyOf with this bigstr:\n"..anyo.mkt.bigstr
    end,
  __index = {
    kvs = function (anyo)    return anyo.mkt:kvs() end,
    v   = function (anyo, k) return anyo.mkt:v(k)  end,
    pat = function (anyo)
        local p = P(false)
        for k,v in anyo:kvs() do p = p + Cs(k) end
        if anyo.default then p = p + Cc(anyo.default) end
     -- if anyo.tag     then p = p:Cg(anyo.tag) * Cb(anyo.tag) end
        if anyo.mtag    then p = p:Copyto(anyo.mtag) end
        if anyo.tmtag   then p = p * (Cb(anyo.mtag) / anyo.mkt._):Cg(anyo.tmtag) end
        return p
      end,
  },
}

-- «AnyOf-tests»  (to ".AnyOf-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "AnyOf1.lua"
bigstr = [[
  aa  -> AA
  a   -> A
  aaa -> AAA
]]
  ao = AnyOf.from(bigstr, "MTAG", "TMTAG")
= ao
  PPPV(ao)
s = Cs"_"
p = ao:pat()
(s * p * s):ptmatch("_a_")
(s * p * s):ptmatch("_aa_")
(s * p * s):ptmatch("_aaa_")

(s * p * s):ptmatch("__")
(s * p * s):ptmatch("_d_")

--]==]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
