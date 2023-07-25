-- This file:
--     http://angg.twu.net/LUA/Pict2e1.lua.html
--     http://angg.twu.net/LUA/Pict2e1.lua
--             (find-angg "LUA/Pict2e1.lua")
--    See: http://angg.twu.net/pict2e-lua.html
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- First version: 2022apr11
-- This version:  2022apr21
--
-- Pict2e1: generate code for Pict2e using
-- Prads (printable algebraic datatypes).
--
-- Based on: (find-angg "LUA/Prad1.lua")
--           (find-LATEX "2022pict2e.lua")
--
-- (defun a  () (interactive) (find-angg "LUA/Pict2e1.lua"))
-- (defun b  () (interactive) (find-angg "LUA/Pict2e1-1.lua"))
-- (defun ab () (interactive) (find-2b '(a) '(b)))
-- (defun et () (interactive) (find-angg "LATEX/2022pict2e.tex"))
-- (defun eb () (interactive) (find-angg "LATEX/2022pict2e-body.tex"))
-- (defun ao () (interactive) (find-angg "LATEX/2022pict2e.lua"))
-- (defun v  () (interactive) (find-pdftools-page "~/LATEX/2022pict2e.pdf"))
-- (defun tb () (interactive) (find-ebuffer (eepitch-target-buffer)))
-- (defun etv () (interactive) (find-wset "13o2_o_o" '(tb) '(v)))
-- (setenv "PICT2ELUADIR" "~/LATEX/")
--
-- (code-c-d "pict2elua" "/tmp/pict2e-lua/" :anchor)
-- (defun a  () (interactive) (find-pict2elua "Pict2e1.lua"))
-- (defun b  () (interactive) (find-pict2elua "Pict2e1-1.lua"))
-- (defun ab () (interactive) (find-2b '(a) '(b)))
-- (defun et () (interactive) (find-pict2elua "2022pict2e.tex"))
-- (defun eb () (interactive) (find-pict2elua "2022pict2e-body.tex"))
-- (defun v  () (interactive) (find-pdftools-page "/tmp/pict2e-lua/2022pict2e.pdf"))
-- (defun tb () (interactive) (find-ebuffer (eepitch-target-buffer)))
-- (defun etv () (interactive) (find-wset "13o2_o_o" '(tb) '(v)))
-- (setenv "PICT2ELUADIR" "/tmp/pict2e-lua/")

-- «.Prads»			(to "Prads")
-- «.PradOutput»		(to "PradOutput")
-- «.PradOutput-tests»		(to "PradOutput-tests")
-- «.PradContext»		(to "PradContext")
-- «.PradContext-tests»		(to "PradContext-tests")
-- «.PradStruct»		(to "PradStruct")
-- «.PradStruct-tests»		(to "PradStruct-tests")
-- «.PradClass»			(to "PradClass")
--   «.PradList»		(to "PradList")
--   «.PradSub»			(to "PradSub")
-- «.PradClass-tests»		(to "PradClass-tests")
--
-- «.nonPrads»			(to "nonPrads")
-- «.Show»			(to "Show")
-- «.Show-tests»		(to "Show-tests")
-- «.MiniV»			(to "MiniV")
-- «.MiniV-tests»		(to "MiniV-tests")
-- «.Points2»			(to "Points2")
-- «.Points2-tests»		(to "Points2-tests")
-- «.Pict2eVector»		(to "Pict2eVector")
-- «.Pict2eVector-tests»	(to "Pict2eVector-tests")
--
-- «.Pict2e»			(to "Pict2e")
--   «.PictList»		(to "PictList")
--   «.PictSub»			(to "PictSub")
-- «.Pict2e-tests»		(to "Pict2e-tests")
-- «.Pict2e-methods»		(to "Pict2e-methods")
-- «.Pict2e-methods-tests»	(to "Pict2e-methods-tests")
--
-- «.PictBounds»		(to "PictBounds")
-- «.PictBounds-tests»		(to "PictBounds-tests")
-- «.PictBounds-methods»	(to "PictBounds-methods")
-- «.PictBounds-methods-tests»	(to "PictBounds-methods-tests")
--
-- «.fake_ln_mod_x»		(to "fake_ln_mod_x")



require "edrxlib"


--  ____                _     
-- |  _ \ _ __ __ _  __| |___ 
-- | |_) | '__/ _` |/ _` / __|
-- |  __/| | | (_| | (_| \__ \
-- |_|   |_|  \__,_|\__,_|___/
--                            
-- «Prads»  (to ".Prads")
-- Printable algebraic datatypes.
-- See: (find-angg "LUA/Prad1.lua")

spaces = function (n)
    return string.rep(" ", n)
  end
delnewline = function (str)
    return (str:gsub("\n$", ""))
  end



--  ____                _  ___        _               _   
-- |  _ \ _ __ __ _  __| |/ _ \ _   _| |_ _ __  _   _| |_ 
-- | |_) | '__/ _` |/ _` | | | | | | | __| '_ \| | | | __|
-- |  __/| | | (_| | (_| | |_| | |_| | |_| |_) | |_| | |_ 
-- |_|   |_|  \__,_|\__,_|\___/ \__,_|\__| .__/ \__,_|\__|
--                                       |_|              
-- «PradOutput»  (to ".PradOutput")
-- The "print"s that are run by a Prad object are "redirected" to a
-- PradOutput object.
--
PradOutput = Class {
  new  = function () return PradOutput({}) end,
  type = "PradOutput",
  __tostring = function (po) return po:tostring("contract") end,
  __index = {
    add0 = function (po, line)
        table.insert(po, line)
        return po
      end,
    add1 = function (po, ctx, line, suffix)
        return po:add0(ctx.indent .. line .. (suffix or ctx.suffix) .. "\n")
      end,
    --
    contractible0 = function (po, i)       -- if it ends with a "{\n"
        return po[i]:match("^(.*{)%%?\n$") -- then return its left part
      end,
    contractible1 = function (po, j, n)
        if po[j]:sub(1, n) == spaces(n)    -- if its starts with n spaces
        then return po[j]:sub(n+1)         -- then return its right part
        end
      end,
    contractifpossible = function (po, i)
        local a =       po:contractible0(i)
        local b = a and po:contractible1(i + 1, #a)
        if b then
          po[i]   = a
          po[i+1] = b
        end
      end,
    contract = function (po)
        local po = copy(po)
        for i=#po-1,1,-1 do
	  po:contractifpossible(i)
        end
        return po
      end,
    --
    tostring = function (po, contract)
        if contract then po = po:contract() end
        return delnewline(table.concat(po))
      end,
  },
}

-- «PradOutput-tests»  (to ".PradOutput-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"

po = PradOutput({
  "abcd{%\n",
  "     foo\n"
})
PPP(po)
= po:tostring()
= po:tostring("contract")
= po

--]]


--  ____                _  ____            _            _   
-- |  _ \ _ __ __ _  __| |/ ___|___  _ __ | |_ _____  _| |_ 
-- | |_) | '__/ _` |/ _` | |   / _ \| '_ \| __/ _ \ \/ / __|
-- |  __/| | | (_| | (_| | |__| (_) | | | | ||  __/>  <| |_ 
-- |_|   |_|  \__,_|\__,_|\____\___/|_| |_|\__\___/_/\_\\__|
--                                                          
-- «PradContext»  (to ".PradContext")
--
PradContext = Class {
  type = "PradContext",
  new  = function (indent, suffix)
      return PradContext {indent=(indent or ""), suffix=(suffix or "")}
    end,
  __tostring = mytostringp,
  __index = {
    copy    = function (pc) return copy(pc) end,
    set     = function (pc, key, val) pc[key] = val; return pc end,
    copyset = function (pc, key, val) return pc:copy():set(key, val) end, 
    copyindent = function (pc, extraindent)
        return pc:copyset("indent", pc.indent .. (extraindent or " "))
      end,
  },
}

-- «PradContext-tests»  (to ".PradContext-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"

= PradContext.new()
= PradContext.new():copyindent()
= PradContext.new():copyindent("  ")
= PradContext.new():copy()
= PradContext.new():copy():set("foo", "bar")
= PradContext.new():copyset("foo", "bar")

--]]



--  ____                _ ____  _                   _   
-- |  _ \ _ __ __ _  __| / ___|| |_ _ __ _   _  ___| |_ 
-- | |_) | '__/ _` |/ _` \___ \| __| '__| | | |/ __| __|
-- |  __/| | | (_| | (_| |___) | |_| |  | |_| | (__| |_ 
-- |_|   |_|  \__,_|\__,_|____/ \__|_|   \__,_|\___|\__|
--                                                      
-- «PradStruct»  (to ".PradStruct")
-- The class PradStruct implements a way to print
-- the low-level structure of a Prad object... like this:
--
--   > a = PradList {"aa", PradSub {b="BEGIN", e="END", 20, 24}, "aaa"}
--   > = a:tostruct()
--   PradList {(
--     1 = "aa",
--     2 = PradSub {(
--       b = "BEGIN",
--       e = "END",
--       1 = 20,
--       2 = 24
--     )},
--     3 = "aaa"
--   )}

PradStruct = Class {
  type     = "PradStruct",
  tostring = function (o, ctx)
      return PradStruct.print(o, nil, ctx):tostring()
    end,
  --
  comparekeys = function (key1, key2)
      local type1, type2 = type(key1), type(key2)
      if type1 ~= type2
      then return type1 > type2
      else return key1 < key2
      end
    end,
  sortedkeys = function (A)
      local lt = PradStruct.comparekeys
      return sorted(keys(A), lt)
    end,
  keyprefix = function (key)
      if key == nil then return "" end
      return format("%s = ", key)
    end,
  genkvpcs = function (A)
      return cow(function ()
          local keys = PradStruct.sortedkeys(A)
          for i,key in ipairs(keys) do
            local val = A[key]
            local keyprefix = PradStruct.keyprefix(key)
            local comma = (i < #keys) and "," or ""
            coy(key, val, keyprefix, comma)
          end
        end)
    end,
  be = function (o, keyprefix, comma)
      keyprefix = keyprefix or ""
      comma = comma or ""
      if type(o) ~= "table" then error() end
      if getmetatable(o) == nil then return keyprefix.."{", "}"..comma end
      local b = format("%s%s {(", keyprefix, otype(o))
      local e = format(")}%s", comma)
      return b,e
    end,
  --
  printitem = function (o, out, ctx, key, comma)
      if type(o) == "table" then
        local keyprefix = PradStruct.keyprefix(key)
        local b,e       = PradStruct.be(o, keyprefix, comma)
        local newctx    = ctx:copyindent("  ")
        out:add1(ctx, b)
        for key,val,keyprefix,comma in PradStruct.genkvpcs(o) do
          PradStruct.printitem(val, out, newctx, key, comma)
        end
        out:add1(ctx, e)
      else
        local keyprefix = PradStruct.keyprefix(key)
        out:add1(ctx, keyprefix..mytostring(o)..(comma or ""))
      end
    end,
  print = function (o, out, ctx, key, comma)
      if type(ctx) == "string" then
        ctx = PradContext.new(ctx)
      end
      out = out or PradOutput.new()
      ctx = ctx or PradContext.new()
      PradStruct.printitem(o, out, ctx, key, comma)
      return out
    end,
  --
  __index = {
  },
}

-- «PradStruct-tests»  (to ".PradStruct-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
a =          {b="BB", e="EE", "a", "aa", 42}
b = PradSub  {b="BB", e="EE", "a", "aa", 42}
c = PradList {b, 333, {"foo", 200}}

PP(PradStruct.sortedkeys(a))
for key,val,keyprefix,comma in PradStruct.genkvpcs(a) do
  print(key,val,keyprefix,comma)
end
PP(PradStruct.be(a))
PP(PradStruct.be(a, "foo = ", ","))
PP(PradStruct.be(b))
PP(PradStruct.be(b, "foo = ", ","))

out = PradOutput.new()
ctx = PradContext.new()
PradStruct.print(c, out, ctx)
PradStruct.print("foo", out, ctx)
PradStruct.print("foo", out, ctx, "k", ",")
= out

= PradStruct.print(c)
= PradStruct.print(c):tostring()
= PradStruct.print(c, nil, ":: "):tostring()
= PradStruct.tostring(c)
= PradStruct.tostring(c, ":: ")

--]]



--  ____                _  ____ _               
-- |  _ \ _ __ __ _  __| |/ ___| | __ _ ___ ___ 
-- | |_) | '__/ _` |/ _` | |   | |/ _` / __/ __|
-- |  __/| | | (_| | (_| | |___| | (_| \__ \__ \
-- |_|   |_|  \__,_|\__,_|\____|_|\__,_|___/___/
--                                              
-- «PradClass»  (to ".PradClass")
-- Our printable algebraic datatypes are objects of classes that
-- inherit from PradClass. An example:
--
--   > = PradList {"aa", PradSub {b="BEGIN", e="END", "20", "42"}, "aaa"}
--   aa
--   BEGIN
--    20
--    42
--   END
--   aaa
--
PradClass = Class {
  type = "PradClass",
  from = function (classtable)
      Class(classtable)
      setmetatable(classtable.__index, { __index = PradClass.__index })
      return classtable
    end,
  __index = {
    add0 = function (prad, out, ctx, line)
        return out:add0(line)
      end,
    add1 = function (prad, out, ctx, line, suffix)
        return out:add0(ctx.indent .. line .. (suffix or ctx.suffix) .. "\n")
      end,
    --
    printitem = function (prad, out, ctx, item)
        if type(item) == "string"
        then prad:add1(out, ctx, item)
        else item:print(out, ctx)
        end
      end,
    printitems = function (prad, out, ctx)
        for i,item in ipairs(prad) do
          prad:printitem(out, ctx, item)
        end
      end,
    --
    tostring = function (prad, out, ctx)
        return prad:tooutput(out, ctx):tostring("contract")
      end,
    tooutput = function (prad, out, ctx)
        if type(ctx) == "string" then
          ctx = PradContext.new(ctx)
        end
        out = out or PradOutput.new()
        ctx = ctx or PradContext.new()
        prad:print(out, ctx)
        return out
      end,
    tostruct = function (prad)
        return PradStruct.tostring(prad)
      end,
  },
}

-- «PradList»  (to ".PradList")
-- PradList and PradSub are the two basic classes "derived" from
-- PradClass. They are mostly used for 1) tests, 2) as inspirations
-- for the classes PictList and PictSub.

PradList = PradClass.from {
  type = "PradList",
  __tostring = function (pl) return pl:tostring() end,
  __index = {
    print = function (pl, out, ctx)
        pl:printitems(out, ctx)
      end,
  },
}

-- «PradSub»  (to ".PradSub")
--
PradSub = PradClass.from {
  type = "PradSub",
  __tostring = function (ps) return ps:tostring() end,
  __index = {
    print = function (ps, out, ctx)
        local newctx = ctx:copyindent()
        ps:add1(out, ctx, (ps.b or "{"))
        ps:printitems(out, newctx)
        ps:add1(out, ctx, (ps.e or "}"))
      end,
  },
}

-- «PradClass-tests»  (to ".PradClass-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
a = PradList {"aa", "aaa"}
b = PradList {"bb", a, "bbb"}
c = PradSub  {"cc", "ccc"}
d = PradList {"dd", b, c, "ddd"}
e = PradSub  {b="BEGIN", e="END", "ee", d, "eee"}
= a
= b
= c
= d
= d:tostring(nil, ":: ")
= e
= PradStruct.tostring(e)

= PradList {"aa", PradSub {b="BEGIN", e="END", "20", "42"}, "aaa"}

--]]











--                    ____                _     
--  _ __   ___  _ __ |  _ \ _ __ __ _  __| |___ 
-- | '_ \ / _ \| '_ \| |_) | '__/ _` |/ _` / __|
-- | | | | (_) | | | |  __/| | | (_| | (_| \__ \
-- |_| |_|\___/|_| |_|_|   |_|  \__,_|\__,_|___/
--                                              
-- «nonPrads»  (to ".nonPrads")
-- Some classes that don't depend on PradClass,
-- or that have just a few methods that mention it.



--  ____  _                   
-- / ___|| |__   _____      __
-- \___ \| '_ \ / _ \ \ /\ / /
--  ___) | | | | (_) \ V  V / 
-- |____/|_| |_|\___/ \_/\_/  
--                            
-- «Show»  (to ".Show")
-- Show a chunk of tex code by saving it to 2022pict2e-body.tex,
-- latexing 2022pict2e.tex, and displaying the resulting PDF.
-- See: (find-LATEX "2022pict2e.tex")
--      (find-LATEX "2022pict2e.tex" "load-body")

show_dir = os.getenv("PICT2ELUADIR") or "~/LATEX/"

Show = Class {
  type = "Show",
  new  = function (o) return Show {bigstr = tostring(o)} end,
  try0 = function (bigstr) return Show.new(bigstr):write():compile() end,
  try  = function (bigstr) return Show.try0(Show.preamble..(bigstr or "nil")) end,
  preamble = "",
  --
  __tostring = function (test)
      return format("Show: %s => %s", test.fname_body, test.success or "?")
    end,
  __index = {
    fname_body  = show_dir.."2022pict2e-body.tex",
    fname_tex   = show_dir.."2022pict2e.tex",
    --          (find-LATEX "2022pict2e.tex" "load-body")
    --
    write = function (test)
        ee_writefile(test.fname_body, test.bigstr)
        return test
      end,
    cmd = function (test)
        local cmd = "cd "..show_dir..
                " && lualatex "..test.fname_tex.." < /dev/null"
        return cmd
      end,
    compile = function (test)
        local log = getoutput(test:cmd())
        local success = log:match "Success!!!"
        Show.log = log
        test.success = success 
        return test
      end,
    print = function (test) print(test); return test end,
  },
}


-- «Show-tests»  (to ".Show-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
= Show.try "Hello"
 (etv)
= Show.try [[$$ \ln x $$]]
 (etv)
= Show.try()
 (etv)

--]==]




--  __  __ _       ___     __
-- |  \/  (_)_ __ (_) \   / /
-- | |\/| | | '_ \| |\ \ / / 
-- | |  | | | | | | | \ V /  
-- |_|  |_|_|_| |_|_|  \_/   
--                           
-- «MiniV»  (to ".MiniV")
-- Based on: (find-dn6 "picture.lua" "V")
-- but with the code for ZHAs deleted.
--
MiniV = Class {
  type    = "MiniV",
  __tostring = function (v) return pformat("(%s,%s)",    v[1], v[2]) end,
  __add      = function (v, w) return V{v[1]+w[1], v[2]+w[2]} end,
  __sub      = function (v, w) return V{v[1]-w[1], v[2]-w[2]} end,
  __unm      = function (v) return v*-1 end,
  __mul      = function (v, w)
      local ktimesv   = function (k, v) return V{k*v[1], k*v[2]} end
      local innerprod = function (v, w) return v[1]*w[1] + v[2]*w[2] end
      if     type(v) == "number" and type(w) == "table" then return ktimesv(v, w)
      elseif type(v) == "table" and type(w) == "number" then return ktimesv(w, v)
      elseif type(v) == "table" and type(w) == "table"  then return innerprod(v, w)
      else error("Can't multiply "..tostring(v).."*"..tostring(w))
      end
    end,
  --
  fromab = function (a, b)
      if     type(a) == "table"  then return a
      elseif type(a) == "number" then return V{a,b}
      elseif type(a) == "string" then
        local x, y = a:match("^%((.-),(.-)%)$")
        if x then return V{x+0, y+0} end
	-- support for lr coordinates deleted
        error("V() got bad string: "..a)
      end
    end,
  __index = {
    todd = function (v) return v[1]..v[2] end,
    to12 = function (v) return v[1], v[2] end,
    to_x_y = function (v) return v:to12() end,
    xy = function (v) return "("..v[1]..","..v[2]..")" end,
    --
    norm = function (v) return (v[1]^2 + v[2]^2)^0.5 end,
  },
}

V = V or MiniV
v = V.fromab

-- «MiniV-tests»  (to ".MiniV-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
V = MiniV
v = V.fromab
= v(1,2) + 0.1*v(3,4)

--]]





--  ____       _       _       
-- |  _ \ ___ (_)_ __ | |_ ___ 
-- | |_) / _ \| | '_ \| __/ __|
-- |  __/ (_) | | | | | |_\__ \
-- |_|   \___/|_|_| |_|\__|___/
--                             
-- «Points2»  (to ".Points2")
--
Points2 = Class {
  type = "Points2",
  new  = function () return Points2 {} end,
  from = function (...) return Points2 {...} end,
  __tostring = function (pts) return pts:tostring() end,
  __index = {
    tostring = function (pts, sep)
        return mapconcat(tostring, pts, sep or "")
      end,
    add = function (pts, pt)
        table.insert(pts, pt)
        return pts
      end,
    adds = function (pts, pts2)
        for _,pt in ipairs(pts2) do table.insert(pts, pt) end
        return pts
      end,
    rev = function (pts)
        local pr = Points2.new()
        for i=#pts,1,-1 do
          table.insert(pr, pts[i])
        end
        return pr
      end,
    --
    pict2e = function (pts, prefix)
        return prefix..tostring(pts)
      end,
    Line    = function (pts) return pts:pict2e("\\Line") end,
    polygon = function (pts) return pts:pict2e("\\polygon") end,
    region0 = function (pts) return pts:pict2e("\\polygon*") end,
    polygon = function (pts, s) return pts:pict2e("\\polygon"..(s or "")) end,
    -- region  = function (pts, color) return pts:region0():color(color) end,
    -- region  = function (pts, color) return pts:region0() end,
    --
  },
}

-- «Points2-tests»  (to ".Points2-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
pts = Points2 {v(1,2), v(3,4), v(3,1)}
= pts
= pts:Line()
= pts:rev()
= pts:add(pts:rev())
pts = Points2 {v(1,2), v(3,4), v(3,1)}

PPP(pts:Line())
Points2.__index.pict2e = function (pts, prefix)
    return PictList { prefix..tostring(pts) }
  end
PPP(pts:Line())
= pts:Line()
= pts:Line():bshow()
 (etv)
= pts:polygon()
= pts:polygon():bshow()
 (etv)
= pts:region0():bshow()
 (etv)

--]]





--  ____  _      _   ____    __     __        _             
-- |  _ \(_) ___| |_|___ \ __\ \   / /__  ___| |_ ___  _ __ 
-- | |_) | |/ __| __| __) / _ \ \ / / _ \/ __| __/ _ \| '__|
-- |  __/| | (__| |_ / __/  __/\ V /  __/ (__| || (_) | |   
-- |_|   |_|\___|\__|_____\___| \_/ \___|\___|\__\___/|_|   
--                                                          
-- «Pict2eVector»  (to ".Pict2eVector")
-- Based on: (find-dn6 "picture.lua" "pict2e-vector")

Pict2eVector = Class {
  type     = "Pict2eVector",
  lowlevel = function (x0, y0, x1, y1)
      local dx, dy = x1-x0, y1-y0
      local absdx, absdy = math.abs(dx), math.abs(dy)
      local veryvertical = absdy > 100*absdx
      local f = function (Dx,Dy,len)
          return Dx,Dy, len
        end
      if veryvertical then
        if dy > 0 then return f( 0,1,  dy) else return f( 0,-1, -dy) end 
      else
        if dx > 0 then return f(dx,dy, dx) else return f(dx,dy, -dx) end
      end 
    end,
  --
  eps = 1/4,
  latex = function (x0, y0, x1, y1)
      local norm = math.sqrt((x1-x0)^2 + (y1-y0)^2)
      if norm < Pict2eVector.eps then
        return pformat("\\put%s{}", v(x0,y0)) -- if very short draw nothing
      end
      local Dx,Dy, len = Pict2eVector.lowlevel(x0, y0, x1, y1)
      return pformat("\\put%s{\\vector%s{%s}}", v(x0,y0), v(Dx,Dy), len)
    end,
  fromto = function (x0y0, x1y1)
      local x0,y0, x1,y1 = x0y0[1],x0y0[2], x1y1[1],x1y1[2]
      return Pict2eVector.latex(x0,y0, x1,y1)
    end,
  fromwalk = function (x0y0, dxdy)
      return Pict2eVector.fromto(x0y0, x0y0+dxdy)
    end,
  __index = {
  },
}

-- «Pict2eVector-tests»  (to ".Pict2eVector-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
x0y0 = v(3,2)
= x0y0
f = function (ang, len)
    return Pict2eVector.fromwalk(x0y0, v(math.cos(ang),math.sin(ang))*len)
  end
= f(0, 2)
PPP(f(0, 2))

p = PictList{}
for i=0,1.5,1/8 do p:addobj(f(i*math.pi, i*2)) end
= p
= p:bshow()
 (etv)

r = Pict2e.region0(v(0,0), v(2,0), v(0,2))
q = PictList {
    r:color("red")  :putat(v(1, 1)),
    r:color("orange"):putat(v(1, 2)),
    p
  }
= q 
= q:bshow()
 (etv)

--]==]






--  ____  _      _   ____      
-- |  _ \(_) ___| |_|___ \ ___ 
-- | |_) | |/ __| __| __) / _ \
-- |  __/| | (__| |_ / __/  __/
-- |_|   |_|\___|\__|_____\___|
--                             
-- «Pict2e»  (to ".Pict2e")
-- Pict2e objects are implemented using the PradClass defined in the
-- first part of this file, and they have lots of methods that use and
-- call the "nonPrad" classes defined in the second part of this file.
--
-- THIS IS A FAKE CLASS.
--
-- The "objects of the class Pict2e" are in reality objects of the
-- classes PictList and PictSub, defined below, that are derived from
-- PradClass.
--
-- See: (find-LATEX "2022pict2e.lua" "Pict2e")

Pict2e = Class {
  type = "Pict2e",
  line    = function (...) return PictList({}):addline(...) end, 
  polygon = function (...) return PictList({}):addpolygon(...) end, 
  region0 = function (...) return PictList({}):addregion0(...) end, 
  --
  bounds    = nil,
  getbounds = function ()
      return Pict2e.bounds or PictBounds.new(v(0,0), v(3, 2))
    end,
  --
  __index = {
  },
}

-- «PictList»  (to ".PictList")
-- «PictSub»   (to ".PictSub")

PictList = PradClass.from {
  type = "PictList",
  __tostring = function (pl) return pl:tostring() end,
  __index = {
    print = function (pl, out, ctx)
        pl:printitems(out, ctx)
      end,
  },
}

PictSub = PradClass.from {
  type = "PictSub",
  __tostring = function (ps) return ps:tostring() end,
  __index = {
    print = function (ps, out, ctx)
        local newctx = ctx:copyindent()
        ps:add1(out, ctx, (ps.b or "{"))
        ps:printitems(out, newctx)
        ps:add1(out, ctx, (ps.e or "}"))
      end,
  },
}

-- «Pict2e-tests»  (to ".Pict2e-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
p = PictList {}
= p:addobj("% foo")
= p:addline(v(1,2), v(3,4))
= p:addline(v(1,2), v(3,4), v(5,6))
= Pict2e.line(v(1,2), v(3,4), v(5,6))
= Pict2e.line(v(1,2), v(3,4), v(5,6)):precolor("red")
= Pict2e.line(v(1,2), v(3,4), v(5,6)):color("red")
= Pict2e.region0(v(1,2), v(3,4), v(3,1)):color("red")

--]]


-- «Pict2e-methods»  (to ".Pict2e-methods")
-- These methods transform Pict2e objects.
-- As Pict2e objects are objects of the classes PradList and PradSub,
-- that are derived from PradClass, these methods are added to
-- PradClass.

PradClass.__index.def = function (pis, name)
    local b = "\\def\\"..name.."{{"
    local e = "}}"
    return PradSub({b=b, pis, e=e})
  end
PradClass.__index.sa = function (pis, name)
    local b = "\\sa{"..name.."}{{"
    local e = "}}"
    return PradSub({b=b, pis, e=e})
  end
PradClass.__index.Color = function (pis, color)
    local b = "\\Color"..color.."{"
    local e = "}"
    return PradSub({b=b, e=e, pis})
  end
PradClass.__index.precolor = function (pis, color)
    local c = "\\color{"..color.."}"
    return PradList({c, pis})
  end
PradClass.__index.prethickness = function (pis, thickness)
    local c = "\\linethickness{"..thickness.."}"
    return PradList({c, pis})
  end
PradClass.__index.preunitlength = function (pis, unitlength)
    local c = "\\unitlength="..unitlength
    return PradList({c, pis})
  end
PradClass.__index.bhbox = function (pis)
    local b = "\\bhbox{$"
    local e = "$}"
    return PradSub({b=b, pis, e=e})
  end
PradClass.__index.myvcenter = function (pis)
    local b = "\\myvcenter{"
    local e = "}"
    return PradSub({b=b, pis, e=e})
  end
PradClass.__index.putat = function (pis, xy)
    local b = pformat("\\put%s{", xy)
    local e = "}"
    return PradSub({b=b, pis, e=e})
  end

PradClass.__index.color = function (pis, color)
    return PictSub({pis:precolor(color)})
  end

PradClass.__index.addobj = function (pis, o)
    table.insert(pis, o)
    return pis
  end

PradClass.__index.addputstrat = function (pis, xy, str)
    return pis:addobj(pformat("\\put%s{%s}", xy, str))
  end
PradClass.__index.addopendotat = function (pis, xy)
    return pis:addputstrat(xy, "\\opendot")
  end
PradClass.__index.addcloseddotat = function (pis, xy)
    return pis:addputstrat(xy, "\\closeddot")
  end

PradClass.__index.addline = function (pis, ...)
    local pts = Points2.from(...)
    return pis:addobj(pts:Line())
  end
PradClass.__index.addpolygon = function (pis, ...)
    local pts = Points2.from(...)
    return pis:addobj(pts:polygon())
  end
PradClass.__index.addregion0 = function (pis, ...)
    local pts = Points2.from(...)
    return pis:addobj(pts:region0())
  end

PradClass.__index.bshow0 = function (p, str)
    return p:pgat(str or "pgat"):dd():tostringp()
  end
PradClass.__index.bshow = function (p, ...)
    return Show.try(p:bshow0(...))
  end

PradClass.__index.output = function (p)  -- for dednat6
    return output(p:tostringp())
  end

PradClass.__index.setbounds = function (p, ...)
    Pict2e.bounds = PictBounds.new(...)
    return p
  end

-- «Pict2e-methods-tests»  (to ".Pict2e-methods-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
p = PictList {}
= p:addobj("% foo")
= p:addline(v(1,2), v(3,4))
= p:addline(v(1,2), v(3,4), v(5,6))
= Pict2e.line(v(1,2), v(3,4), v(5,6))
= Pict2e.line(v(1,2), v(3,4), v(5,6)):precolor("red")
= Pict2e.line(v(1,2), v(3,4), v(5,6)):color("red")
= Pict2e.line(v(1,2), v(3,4), v(5,6)):Color("Red")
= Pict2e.polygon(v(1,2), v(3,4), v(3,1)):color("red")
= Pict2e.polygon(v(1,2), v(3,4), v(3,1)):color("red"):bshow0()
= Pict2e.polygon(v(1,2), v(3,4), v(3,1)):color("red"):bshow()
 (etv)
= Pict2e.region0(v(1,2), v(3,4), v(3,1)):color("red"):bshow()
 (etv)
Pict2e.bounds = PictBounds.new(v(0,0), v(4,4))
= Pict2e.region0(v(1,2), v(3,4), v(3,1)):color("red"):bshow()
 (etv)

-- (find-LATEX "2021-2-C3-bezier.tex" "exercicio-3-figs")

tof = function (str) return Code.ve(format("t => v(t,%s)", str)) end
= tof "t*t"
= tof "t*t" (4)
pi, sin, cos = math.pi, math.sin, math.cos
ts  = seq(0, 2*pi, pi/16)
xys = map(tof "sin(t)", ts) 
toplot = function (ts, strexpr, color)
    return Pict2e.line(myunpack(map(tof(strexpr), ts))):color(color)
  end
= Pict2e.line(myunpack(xys)):color("red")
= toplot(ts, "t*t", "yellow")
body = PictList {
    toplot(ts, "sin(t)",     "red"),
    toplot(ts, "cos(t)",     "orange"),
    toplot(ts, "2*sin(2*t)", "DarkGreen")
  }
= body
Pict2e.bounds = PictBounds.new(v(0,-2), v(7,2))
= body:bshow()
 (etv)

--]]






--  ____  _      _   ____                        _     
-- |  _ \(_) ___| |_| __ )  ___  _   _ _ __   __| |___ 
-- | |_) | |/ __| __|  _ \ / _ \| | | | '_ \ / _` / __|
-- |  __/| | (__| |_| |_) | (_) | |_| | | | | (_| \__ \
-- |_|   |_|\___|\__|____/ \___/ \__,_|_| |_|\__,_|___/
--                                                     
-- «PictBounds»  (to ".PictBounds")
-- (find-LATEX "edrxpict.lua" "pictp0-pictp3")
-- (find-es "pict2e" "picture-mode")
-- (find-kopkadaly4page (+ 12 288) "\\begin{picture}(x dimen,y dimen)")
-- (find-kopkadaly4text (+ 12 288) "\\begin{picture}(x dimen,y dimen)")
-- (find-kopkadaly4page (+ 12 301) "13.1.6 Shifting a picture environment")
-- (find-kopkadaly4text (+ 12 301) "13.1.6 Shifting a picture environment")
-- (find-kopkadaly4page (+ 12 302) "\\begin{picture}(x dimen,y dimen)(x offset,y offset)")
-- (find-kopkadaly4text (+ 12 302) "\\begin{picture}(x dimen,y dimen)(x offset,y offset)")

PictBounds = Class {
  type = "PictBounds",
  new  = function (ab, cd, e)
      local a,b = ab[1], ab[2]
      local c,d = cd[1], cd[2]
      local x1,x2 = min(a,c), max(a,c)
      local y1,y2 = min(b,d), max(b,d)
      return PictBounds {x1=x1, y1=y1, x2=x2, y2=y2, e=e or .2}
    end,
  __tostring = function (pb) return pb:tostring() end,
  __index = {
    x0 = function (pb) return pb.x1 - pb.e end,
    x3 = function (pb) return pb.x2 + pb.e end,
    y0 = function (pb) return pb.y1 - pb.e end,
    y3 = function (pb) return pb.y2 + pb.e end,
    p0 = function (pb) return v(pb.x1 - pb.e, pb.y1 - pb.e) end,
    p1 = function (pb) return v(pb.x1,        pb.y1       ) end,
    p2 = function (pb) return v(pb.x2,        pb.y2       ) end,
    p3 = function (pb) return v(pb.x2 + pb.e, pb.y2 + pb.e) end,
    tostring = function (pb)
        return pformat("LL=(%s,%s) UR=(%s,%s) e=%s",
          pb.x1, pb.y1, pb.x2, pb.y2, pb.e)
      end,
    --
    beginpicture = function (pb)
        local dimen  =  pb:p3() - pb:p0()
        local center = (pb:p3() + pb:p0()) * 0.5
        local offset =  pb:p0()
        return pformat("\\begin{picture}%s%s", dimen, offset)
      end,
    --
    grid = function (pb)
        local p = PictList({"% Grid", "% Horizontal lines:"})
        for y=pb.y1,pb.y2 do p:addline(v(pb:x0(), y), v(pb:x3(), y)) end
        p:addobj("% Vertical lines:")
        for x=pb.x1,pb.x2 do p:addline(v(x, pb:y0()), v(x, pb:y3())) end
        return p
      end,
    ticks = function (pb, e)
        e = e or .2
        local p = PictList({"% Ticks", "% On the vertical axis:"})
        for y=pb.y1,pb.y2 do p:addline(v(-e, y), v(e, y)) end
        p:addobj("% On the horizontal axis: ")
        for x=pb.x1,pb.x2 do p:addline(v(x, -e), v(x, e)) end
        return p
      end,
    axes = function (pb)
        local p = PictList({"% Axes"})
        return p:addline(v(pb:x0(), 0), v(pb:x3(), 0))
                :addline(v(0, pb:y0()), v(0, pb:y3()))
      end,
    axesandticks = function (pb)
        return PictList { pb:axes(), pb:ticks() }
      end,
  },
}

-- «PictBounds-tests»  (to ".PictBounds-tests")
-- (find-LATEX "edrxpict.lua" "pictp0-pictp3")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"

= PictBounds.new(v(-1,-2), v( 3, 5))
= PictBounds.new(v( 3, 5), v(-1,-2))
= PictBounds.new(v( 3, 5), v(-1,-2), 0.5)
pb = PictBounds.new(v(-1,-2), v( 3, 5))
= pb:p0()
= pb:p1()
= pb:p2()
= pb:p3()

= pb:grid()
= pb:ticks()
= pb:axes()
= pb:axesandticks()
= pb:grid():prethickness("0.5pt"):color("gray")

= pb
= pb:beginpicture()

= pb:p0()
= (pb:p0() + pb:p3())
= (pb:p0() + pb:p3()) * 0.5

--]]


--  ____  _      _   ____                        _           
-- |  _ \(_) ___| |_| __ )  ___  _   _ _ __   __| |___   _   
-- | |_) | |/ __| __|  _ \ / _ \| | | | '_ \ / _` / __|_| |_ 
-- |  __/| | (__| |_| |_) | (_) | |_| | | | | (_| \__ \_   _|
-- |_|   |_|\___|\__|____/ \___/ \__,_|_| |_|\__,_|___/ |_|  
--                                                           
-- «PictBounds-methods»  (to ".PictBounds-methods")
-- (find-LATEX "2022pict2e.tex" "grid-axes-ticks")
-- Methods that use PictBounds and that transform Pict2e objects.
-- They are installed in PradClass, and are used mainly by :pgat().

PradClass.__index.bep = function (p)
    local b = Pict2e.getbounds():beginpicture()
    local e = "\\end{picture}"
    return PradSub({b=b, e=e, p})
  end
PradClass.__index.pregrid = function (p)
    local grid0 = Pict2e.getbounds():grid()
    local grid  = PradSub { "\\pictgridstyle", grid0 }
    return PradList({grid, p})
  end
PradClass.__index.preaxesandticks = function (p)
    local axesandticks0 = Pict2e.getbounds():axesandticks()
    local axesandticks  = PradSub { "\\pictaxesstyle", axesandticks0 }
    return PradList({axesandticks, p})
  end
PradClass.__index.prenaxesandticks = function (p)
    local axesandticks0 = Pict2e.getbounds():axesandticks()
    local axesandticks  = PradSub { "\\pictnaxesstyle", axesandticks0 }
    return PradList({axesandticks, p})
  end
PradClass.__index.preaxes = function (p)
    local axesandticks0 = Pict2e.getbounds():axes()
    local axesandticks  = PradSub { "\\pictaxesstyle", axesandticks0 }
    return PradList({axesandticks, p})
  end

-- "PGAT" means "Picture, Grid, Axes, Ticks".
-- This method adds begin/end picture, grid, axes, and ticks to a
-- Pict2e object, in the right order, and with a very compact syntax
-- to select what will be added. It can also add a bhbox and a def.
--
PradClass.__index.pgat = function (p, str, def)
    if str:match("a") then p = p:preaxesandticks() end
    if str:match("A") then p = p:preaxes() end
    if str:match("N") then p = p:prenaxesandticks() end  -- for numerozinhos
    if str:match("g") then p = p:pregrid() end
    if str:match("p") then p = p:bep() end
    if str:match("c") then p = p:myvcenter() end
    if str:match("B") then p = p:bhbox() end
    if def            then p = p:def(def) end
    return p
  end

-- Surround with dollars and double dollars.
PradClass.__index.d  = function (p) return PradSub({b="$",  e="$",  p}) end
PradClass.__index.dd = function (p) return PradSub({b="$$", e="$$", p}) end

PradClass.__index.scalebox = function (p, scale)
    if not scale then return p end
    local b = "\\scalebox{"..scale.."}{$"
    local e = "$}"
    return PradSub({b=b, p, e=e})
  end

-- Like :tostring(), but adds a percent to the end of each line.
PradClass.__index.tostringp = function (p, ...)
    return p:tostring(nil, PradContext.new(nil, "%"))
  end

-- «PictBounds-methods-tests»  (to ".PictBounds-methods-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"
= Pict2e.line(v(1,2), v(3,4)):pregrid()
= Pict2e.line(v(1,2), v(3,4)):pregrid():preaxesandticks()
= Pict2e.line(v(1,2), v(3,4)):pregrid():preaxes()
= Pict2e.line(v(1,2), v(3,4)):bep()
= Pict2e.line(v(1,2), v(3,4)):pgat("pgat")
= Pict2e.line(v(1,2), v(3,4)):pgat("pAt")
= Pict2e.line(v(1,2), v(3,4)):pgat("pB", "foo")
= Pict2e.line(v(1,2), v(3,4)):pgat("pB"):d()
= Pict2e.line(v(1,2), v(3,4)):pgat("pB"):dd()
o = Pict2e.line(v(1,2), v(3,4)):pgat("pgatB"):dd()
= o:tostring()
= o:tostring(nil, ":: ")
= o:tostring(nil, PradContext.new(":: ", "%"))
= o:tostring(nil, PradContext.new(nil, "%"))
= o:tostringp()
= Show.try(o:tostringp())
 (etv)

Pict2e.bounds = PictBounds.new(v(0,0), v(3, 2), 0.7)
o = Pict2e.line(v(1,2), v(3,4)):pgat("pgat"):dd()
= o
= o:tostringp()
= Show.try(o:tostringp())
 (etv)


--]]




-- «fake_ln_mod_x»  (to ".fake_ln_mod_x")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1.lua"

Pict2e.bounds = PictBounds.new(v(-5,-5), v(5,5))
fake_ln_mod_x = function (C1, C2)
    return PictList({})
      :addline(v(-4, 3+C1),
               v(-3, 3+C1),
               v(-2, 2+C1),
               v(-1, 0+C1),
               v(-0,-3+C1))
      :addline(v( 4, 3+C2),
               v( 3, 3+C2),
               v( 2, 2+C2),
               v( 1, 0+C2),
               v( 0,-3+C2))
      :addopendotat(v(-0,-3+C1))
      :addopendotat(v( 0,-3+C2))
  end
= fake_ln_mod_x(0, 0)
= fake_ln_mod_x(1, 2)
= fake_ln_mod_x(0, 0):bshow()
 (etv)
Pict2e.bounds = PictBounds.new(v(-5,-5), v(5,5))
Pict2e.bounds = PictBounds.new(v(-4,-4), v(4,4))
= fake_ln_mod_x(1, -1):bshow()
 (etv)

--]]






-- Local Variables:
-- coding:  utf-8-unix
-- End:
