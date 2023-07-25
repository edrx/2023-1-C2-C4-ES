-- This file:
--   http://anggtwu.net/LUA/Estatistica1.lua.html
--   http://anggtwu.net/LUA/Estatistica1.lua
--          (find-angg "LUA/Estatistica1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e   () (interactive) (find-angg "LUA/Estatistica1.lua"))
-- (defun es1 () (interactive) (find-angg "LUA/Estatistica1.lua"))
-- (find-Deps1-links "Caepro4 Estatistica1")
-- (find-Deps1-cps   "Caepro4 Estatistica1")
-- (find-Deps1-anggs "Caepro4 Estatistica1")
-- 5gQ1

-- «.PictDots»			(to "PictDots")
-- «.PictDots-tests»		(to "PictDots-tests")
-- «.defcells»			(to "defcells")
-- «.haxisandticks»		(to "haxisandticks")
-- «.haxisandticks-tests»	(to "haxisandticks-tests")
-- «.SqP»			(to "SqP")
-- «.SqP-tests»			(to "SqP-tests")
--   «.pacocas-test»		(to "pacocas-test")

require "Pict2e2"    -- (find-angg "LUA/Pict2e2.lua")
require "PictShow1"  -- (find-angg "LUA/PictShow1.lua")



-- (find-angg "LUA/Pict2e2.lua" "PictBounds-methods-tests")

--  ____  _      _   ____        _       
-- |  _ \(_) ___| |_|  _ \  ___ | |_ ___ 
-- | |_) | |/ __| __| | | |/ _ \| __/ __|
-- |  __/| | (__| |_| |_| | (_) | |_\__ \
-- |_|   |_|\___|\__|____/ \___/ \__|___/
--                                       
-- «PictDots»  (to ".PictDots")

PictDots = Class {
  type = "PictDots",
  from = function (str)
      local pat = "([-0-9.]+),([-0-9.]+)"
      local xys = VTable {}
      for x,y in str:gmatch(pat) do table.insert(xys, {x+0,y+0}) end
      return PictDots {str=str, xys=xys}
    end,
  __index = {
    topict = function (pds)
        local p = Pict {}
        for _,xy in ipairs(pds.xys) do
          p:addcloseddotat(v(xy[1], xy[2]))
        end
        return p
      end,
  },
}

pdots = function (str) return PictDots.from(str):topict() end


-- «PictDots-tests»  (to ".PictDots-tests")
--[[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Estatistica1.lua"
p = PictDots.from "2,3 4,-6 1.5,-2.34"
= p.xys
= p:topict()

output = print

PictBounds.setbounds(v(0,0), v(2,2))
p = pdots "(1,1) (2,1) (2,2)"
= p
= p:pgat("pat")
p:pgat("pat", "foo"):output()
= p:pgat("pat"):show()
= Show.log
= Show.bigstr
 (etv)

p:pgat("pat", "foo"):output()

-- (find-angg "LUA/Pict2e2.lua" "PictBounds-tests")

--]]



-- «defcells»  (to ".defcells")
-- (find-es "tex" "picture-cells")

defcells = [[
\def\cellhr#1{\hbox to 0pt    {\cellfont${#1}$\hss}}
\def\cellhc#1{\hbox to 0pt{\hss\cellfont${#1}$\hss}}
\def\cellhl#1{\hbox to 0pt{\hss\cellfont${#1}$}}
\def\cellva#1{\setbox0#1\raise \dp0       \box0}
\def\cellvm#1{\setbox0#1\lower \celllower \box0}
\def\cellvb#1{\setbox0#1\lower \ht0       \box0}

\def\cellnw  #1{\cellva{\cellhl{#1}}}
 \def\celln  #1{\cellva{\cellhc{#1}}}
  \def\cellne#1{\cellva{\cellhr{#1}}}
\def\cellw   #1{\cellvm{\cellhl{#1}}}
 \def\celle  #1{\cellvm{\cellhr{#1}}}
\def\cellsw  #1{\cellvb{\cellhl{#1}}}
 \def\cells  #1{\cellvb{\cellhc{#1}}}
  \def\cellse#1{\cellvb{\cellhr{#1}}}
]]

defs = Dang.from [[
\catcode`\^^J=10
\directlua{dofile "dednat6load.lua"}
<<defcells>>
\celllower=4pt
]]



--  _                _                     _ _   _      _        
-- | |__   __ ___  _(_)___  __ _ _ __   __| | |_(_) ___| | _____ 
-- | '_ \ / _` \ \/ / / __|/ _` | '_ \ / _` | __| |/ __| |/ / __|
-- | | | | (_| |>  <| \__ \ (_| | | | | (_| | |_| | (__|   <\__ \
-- |_| |_|\__,_/_/\_\_|___/\__,_|_| |_|\__,_|\__|_|\___|_|\_\___/
--                                                               
-- «haxisandticks»  (to ".haxisandticks")
-- (find-angg "LUA/Pict2e2.lua" "PictBounds-methods")
-- (find-angg "LUA/Pict2e2.lua" "PictBounds")
-- (find-angg "LUA/Pict2e2.lua" "PictBounds" "axesandticks =")

-- table.addentries(PictBounds.__index,
--   { haxis = function (pb)
--         local p = Pict({"% Axes"})
--         return p:addline(v(pb:x0(), 0), v(pb:x3(), 0))
--       end,
--   })

table.addentries(Pict.__index,
  { enslower = -0.25,
    ens = function (p, enslower)  -- for estatistica: numeros below the h axis
         for x=0,p:gb().x2-1 do
           p = p:putcellat(v(x+0.5, enslower or p.enslower), x)
         end
         return p
      end,
    addsqptext = function (p, xy, str)
        if not str then return p end
        local x,y = xy[1],xy[2]
        return p:puttcellat(v(x+0.5, y+0.5), str)
      end,
    addsqp = function (p, xy, str)
        local x,y = xy[1],xy[2]
        local x0,x1,y0,y1 = x,x+1,y,y+1
        local pts = Points2 {v(x0,y0), v(x1,y0), v(x1,y1), v(x0,y1)}
        p:add(pts:polygon())
        return p:addsqptext(xy, str)
      end,
  })

-- «haxisandticks-tests»  (to ".haxisandticks-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Estatistica1.lua"
= defs

p = Pict {}
p:addsqp(v(2,2), "foo")
= p      :pgat("hng"):show()
= p:ens():pgat("hng"):show()
= Show.log
= Show.bigstr
 (etv)

--]==]




--  ____        ____  
-- / ___|  __ _|  _ \ 
-- \___ \ / _` | |_) |
--  ___) | (_| |  __/ 
-- |____/ \__, |_|    
--           |_|      
--
-- Diagrams in which each square represents a person.
--
-- «SqP»  (to ".SqP")

SqP = Class {
  type  = "SqP",
  from0 = function (max)
      local sqp = SqP {max=max, heights={}, p=Pict{}}
      if max then
        for x=0,max do sqp.heights[x] = 0 end
      end
      return sqp
    end,
  from = function (spec)
      return SqP.from0():drop(spec)
    end,
  __tostring = VTable.__tostring,
  __index = {
    height = function (sqp, x) return sqp.heights[x] or 0 end,
    incrheight = function (sqp, x)
        sqp.heights[x] = sqp:height(x) + 1
        return sqp:height(x)
      end,
    drop0 = function (sqp, x, str)
        local y = sqp:height(x)
        PP("drop0", x, y)
        sqp.p:addsqp(v(x,y), str)
        sqp:incrheight(x)
      end,
    drop = function (sqp, spec)
        for _,str in ipairs(split(spec)) do
          local x,s = unpack(split(str, "([^:]+)"))
          PP(x, s)
          sqp:drop0(x+0, s)
        end
        return sqp
      end,
    topict = function (sqp, options)
        return sqp.p:ens():pgat(options or "ph")
      end,
  },
}

-- «SqP-tests»  (to ".SqP-tests")
--[==[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Estatistica1.lua"
PictBounds.setbounds(v(0,0), v(6,2))
s = SqP.from0(5)
s = SqP.from0()
= s
= s:drop "1:A 1:B 4:C 5:D"
= s:topict()
= s:topict():show()
= Show.log
= Show.bigstr
 (etv)

--]==]


-- «pacocas-test»  (to ".pacocas-test")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Estatistica1.lua"
PictBounds.setbounds(v(0,0), v(6,2))
spec1 = "1:A 1:B 4:C 5:D"
spec2 = "1:A 2:B 3:C 5:D"
p1    = SqP.from(spec1):topict():sa("pacocas 1")
p2    = SqP.from(spec2):topict():sa("pacocas 2")
p3    = Pict { p1, p2, "\\ga{pacocas 1}, \\ga{pacocas 2}" }
p     = p3:preunitlength("13pt")
= p
= p:show()
= Show.log
= Show.bigstr
 (etv)



p = s.p:prethickness("0.5pt")
p = s.p:prethickness("1pt")
=     s.p      :pgat("pgh")
=     s.p:ens():pgat("pgh")
=     s.p:ens():pgat("pgat")

p2 =  s.p      :pgat("pgh")
= p2
= s.p:ens():pgat("ph") :show()
=   p:ens():pgat("ph") :show()
= Show.log
= Show.bigstr
 (etv)

= outertexbody.bigstr
= defs

  p = Pict {}
= p:pgat("pat")
= p:pgat("pat"):show()
= Show.log
= Show.bigstr
 (etv)

= p:pgat("pgt"):show()
= Show.log
= Show.bigstr
 (etv)

--]==]











-- Local Variables:
-- coding:  utf-8-unix
-- End:
