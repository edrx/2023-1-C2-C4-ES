-- This file:
--   http://anggtwu.net/LUA/PictShow1.lua.html
--   http://anggtwu.net/LUA/PictShow1.lua
--          (find-angg "LUA/PictShow1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun p2  () (interactive) (find-angg "LUA/Pict2e2.lua"))
-- (defun s2  () (interactive) (find-angg "LUA/Show2.lua"))
-- (defun ps1 () (interactive) (find-angg "LUA/PictShow1.lua"))
--
--   (find-angg "LUA/Show2.lua" "texbody")
--
-- «.usepict2e»			(to "usepict2e")


require "Pict2e2"    -- (find-angg "LUA/Pict2e2.lua")
require "Show2"      -- (find-angg "LUA/Show2.lua")
                     -- (find-angg "LUA/Show2.lua" "texbody")



-- «usepict2e»  (to ".usepict2e")
-- (find-angg "LUA/Show2.lua" "texbody")

usepict2e = [[
  \usepackage{edrx21}
  \usepackage{pict2e}
  \def\pictgridstyle{\color{GrayPale}\linethickness{0.3pt}}
  \def\pictaxesstyle{\linethickness{0.5pt}}
  \def\closeddot{{\circle*{0.4}}}
  \def\opendot  {{\circle*{0.4}\color{white}\circle*{0.25}}}
  \unitlength=20pt
]]
usepackages = Dang.from "<<usepict2e>>"

Pict.__index.show = function (p, pgatargs)
    texbody = p:pgat(pgatargs or "")
    return Show.try(tostring(outertexbody))
  end






--[==[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "PictShow1.lua"
p = Pict{}:addline(v(1,1), v(2,2), v(3,1)):prethickness"2pt"
= p
= p:pgat("")
= p:show("pga")
 (etv)

q = p:pgat("pga"):d()
q = p:pgat("pga")
= q
= outertexbody    
texbody = q
= outertexbody

= Show.try(tostring(outertexbody))
= Show.log
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (etv)

--]==]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
