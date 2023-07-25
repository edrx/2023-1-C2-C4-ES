-- This file:
--   http://anggtwu.net/LUA/PCall1.lua.html
--   http://anggtwu.net/LUA/PCall1.lua
--          (find-angg "LUA/PCall1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun pc1 () (interactive) (find-angg "LUA/PCall1.lua"))
-- (defun xp2 () (interactive) (find-angg "LUA/XPCall2.lua"))
--
-- Used by: (find-angg "LUA/Globals1.lua" "Globals")
--
-- (find-angg "edrxrepl/edrxpcall.lua")
-- (find-angg "LUA/lua50init.lua" "MyXpcall")
-- https://en.wikipedia.org/wiki/Exception_handling
-- Rationale behind unwind-protect and double errors:
--   https://groups.google.com/g/comp.lang.lisp/c/OWg7boIvyM8?pli=1
-- (find-elnode "Catch and Throw")
-- (find-elnode "Cleanups")
-- (find-clnode "Blocks and Exits")
-- http://lua-users.org/wiki/FinalizedExceptions
--
-- Used by: (find-angg "LUA/Globals1.lua" "Globals")
--          (find-angg "LUA/Globals1.lua" "Globals" "run =")
--
-- «.PCall»		(to "PCall")
-- «.PCall-tests»	(to "PCall-tests")


--  ____   ____      _ _ 
-- |  _ \ / ___|__ _| | |
-- | |_) | |   / _` | | |
-- |  __/| |__| (_| | | |
-- |_|    \____\__,_|_|_|
--                       
-- «PCall»  (to ".PCall")

PCall = Class {
  type    = "PCall",
  __index = {
    --
    -- :mayrun(o) is a utility function that runs o if o is non-nil.
    mayrun = function (pc, o)
        if type(o) == "function" then o(pc);     return pc end
        if type(o) == "string"   then pc[o](pc); return pc end
        return pc
      end,
    --
    -- :a() runs some preparations (in pc.before),
    -- :b() runs the body of the protected call (in pc.f),
    -- :c() runs some cleanups (in pc.after).
    a = function (pc) return pc:mayrun(pc.before) end,
    b = function (pc, ...)
        local args = pack(...)
        pc.results = pack(pcall(function () return pc.f(unpack(args)) end))
        return pc
      end,
    c = function (pc) return pc:mayrun(pc.after) end,
    --
    -- :run(...) is the highest-level method.
    run = function (pc, ...) return pc:a():b(...):c():rrye() end,
    rrye = function (pc)
        if pc:gotok()
        then return pc:returnresults()
        else pc:yielderror()
        end
      end,
    gotok         = function (pc) return pc.results[1] end,
    yielderror    = function (pc) error(pc.results[2]) end,
    returnresults = function (pc) return unpack(pc.results, 2, pc.results.n) end,
  },
}

-- «PCall-tests»  (to ".PCall-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Globals1.lua"
p = PCall {
  before = function () print "(before)" end,
  f      = function (a,b) print(a,b); return a+b,a*b end,
  after  = function () print "(after)" end,
}
= p:run(3,4)
= p:run(3,nil)

--]]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
