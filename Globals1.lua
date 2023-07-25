-- This file:
--   http://anggtwu.net/LUA/Globals1.lua.html
--   http://anggtwu.net/LUA/Globals1.lua
--          (find-angg "LUA/Globals1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun g1 () (interactive) (find-angg "LUA/Globals1.lua"))
--
-- «.Globals»		(to "Globals")
-- «.Globals-tests»	(to "Globals-tests")

require "PCall1"   -- (find-angg "LUA/PCall1.lua")



--   ____ _       _           _     
--  / ___| | ___ | |__   __ _| |___ 
-- | |  _| |/ _ \| '_ \ / _` | / __|
-- | |_| | | (_) | |_) | (_| | \__ \
--  \____|_|\___/|_.__/ \__,_|_|___/
--                                  
-- I wrote this class for ELpeg1.lua. In ELpeg1 the current grammar
-- and the current way to convert an AST to text are stored in some
-- global variables... (TODO: write more!)
--
-- «Globals»  (to ".Globals")

Globals = Class {
  type = "Globals",
  save = function (names) return Globals({names = names}):save() end,
  __tostring = function (gl) return gl.names end,
  __index = {
    save = function (gl)
        gl._ = {}
        for _,name in ipairs(split(gl.names)) do gl._[name] = _G[name] end
        return gl
      end,
    restore = function (gl)
        for _,name in ipairs(split(gl.names)) do _G[name] = gl._[name] end
        return gl
      end,
    --
    -- :run(f,...) uses this: (find-angg "LUA/PCall1.lua" "PCall")
    run = function (gla,f,...)
        local glb = Globals.save(gla.names)
        return PCall({
          before = function () gla:restore() end,
          f      = function (...) return f(...) end,
          after  = function () glb:restore() end,
        }):run(...)
      end,
    fun = function (gla,f)
        return function (...) return gla:run(f, ...) end
      end,
  },
}

-- «Globals-tests»  (to ".Globals-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Globals1.lua"
a,b = 1,2
gl = Globals.save "a b c"
= gl
a,b,c = 3,4,5
= a,b,c
gl:restore()
= a,b,c

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Globals1.lua"
a,b = 1,2,nil
  f12_globals = Globals.save "a b c"
a,b,c = 3,4,5
  f12_globals:run(PP, 10, 20)
= f12_globals:run(function (d,e,...)
    print(a,b,c,d,e,...)
    return d,e,d+e
  end, 20, 30)
= f12_globals:fun(function (d,e,...)
    print(a,b,c,d,e,...)
    return d,e,d+e
  end)(20, 30)
= a,b,c

= f12_globals:run(function (d,e,...)
    print(a,b,c,d,e,...)
    return d,e,d+e
  end, 20, nil)   -- err
= a,b,c

--]]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
