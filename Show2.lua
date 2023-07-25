-- This file:
--   http://anggtwu.net/LUA/Show2.lua.html
--   http://anggtwu.net/LUA/Show2.lua
--          (find-angg "LUA/Show2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- Based on:
--   (find-angg "LUA/Show1.lua")
--   (find-angg "LUA/Pict2e1.lua" "Show")
--   (find-angg "LUA/tikz1.lua" "Show-class")
--   (find-LATEXfile "2022pict2e-body.tex")
--   (find-LATEXfile "2022pict2e.tex")
-- Uses these files:
--   (find-angg "LUA/Show2-outer.tex")
--   (find-angg "LUA/Show2-inner.tex")
--
--      (code-show2 "SHOW2DIR" "/tmp/" "Show2")
-- (find-code-show2 "SHOW2DIR" "/tmp/" "Show2")
-- (find-code-show2 "SHOW2DIR" "~/LUA/" "Show2-outer2")

-- (defun s1 () (interactive) (find-angg "LUA/Show1.lua"))
-- (defun s2 () (interactive) (find-angg "LUA/Show2.lua"))
-- (defun so () (interactive) (find-fline "LUA/Show2-outer.tex"))
-- (defun si () (interactive) (find-fline "LUA/Show2-inner.tex"))
--
-- «.Dang»		(to "Dang")
-- «.Dang-tests»	(to "Dang-tests")
-- «.texbody»		(to "texbody")
-- «.texbody-tests»	(to "texbody-tests")
-- «.Show»		(to "Show")
-- «.Show-tests»	(to "Show-tests")
-- «.string.show»	(to "string.show")
-- «.string.show-tests»	(to "string.show-tests")




--  ____                    
-- |  _ \  __ _ _ __   __ _ 
-- | | | |/ _` | '_ \ / _` |
-- | |_| | (_| | | | | (_| |
-- |____/ \__,_|_| |_|\__, |
--                    |___/ 
--
-- An object is the class Dang "is" a string whose parts
-- between <<D>>ouble <<ANG>>le brackets "are to be expanded".
--
-- More precisely: each object of the class Dang contains a
-- field .bigstr with a string. When that object is "expanded"
-- by tostring all the parts between double angle brackets
-- in .bigstr are "expanded" by Dang.eval. The expansion
-- happens every time that the tostring is run, and so the
-- result of the expansion may change.
--
-- Note that I use these conventions:
--   a bigstr is a string that may contain newlines,
--   a str    is a string that does not contain newlines,
--   an s     is the argument for the function f when
--            we run bigstr:gsub(pat, f) or str:gsub(pat, f).
--
-- To understand the details, see the tests below, in:
--   (to "Dang-tests")
-- Based on: (find-angg "LUA/tikz1.lua" "Dang")
-- Uses:     (find-angg "LUA/lua50init.lua" "eval-and-L")
--
-- «Dang»  (to ".Dang")

Dang = Class {
  type = "Dang",
  from = function (bigstr) return Dang {bigstr=bigstr} end,
  --
  eval0 = function (s)
      if s:match("^:")             -- How show we eval s?
      then return eval(s:sub(2))   --    With ":" -> as ":<expression>"
      else return expr(s)          -- Without ":" -> as "<statements>"
      end
    end,
  eval = function (s)
      local r = Dang.eval0(s)
      if r == nil then return "" end
      return tostring(r)
    end,
  replace = function (bigstr)                      -- replace each <<s>>
      return (bigstr:gsub("<<(.-)>>", Dang.eval))  -- by Dang.eval(s)
    end,
  --
  peval0 = function (s) PP(Dang.eval0(s)) end,
  peval  = function (s) PP(Dang.eval (s)) end,
  preplace = function (bigstr) PP(Dang.replace(bigstr)) end,
  --
  __tostring = function (da) return da:tostring() end,
  __index = {
    tostring = function (da) return Dang.replace(da.bigstr) end,
    show     = function (da) return Show.new(tostring(da)) end,
    try      = function (da) return da:show():try() end,
  },
}

-- «Dang-tests»  (to ".Dang-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
= Dang. eval0 ":return 2+3,'6'"  --> 5 6
  Dang.peval0 ":return 2+3,'6'"  --> 5 "6"
= Dang. eval0         "2+3,'6'"  --> 5 6
  Dang.peval0         "2+3,'6'"  --> 5 "6"
= Dang. eval          "2+3,'6'"  --> 5
  Dang.peval          "2+3,'6'"  --> "5"

= Dang. eval    "2+3"      --> 5
  Dang.peval    "2+3"      --> "5"
= Dang.replace "a<<2+3>>b"   --> a5b
 Dang.preplace "a<<2+3>>b"   --> "a5b"

    Dang.peval    "c"        --> ""
 Dang.preplace "a<<c>>b"     --> "ab"
c = "foo"
    Dang.peval    "c"        --> "foo"
 Dang.preplace "a<<c>>b"     --> "afoob"

=    Dang.from "a<<c>>b"           --> afoob
  PP(Dang.from "a<<c>>b")          --> {"bigstr"="a<<c>>b"}
=    Dang.from("a<<c>>b").bigstr   --> a<<c>>b
  PP(Dang.from("a<<c>>b").bigstr)  --> "a<<c>>b"

 Dang.preplace "a<<:>>b"               --> "ab"
 Dang.preplace "a<<:return>>b"         --> "ab"
 Dang.preplace "a<<:return nil>>b"     --> "ab"
 Dang.preplace "a<<:return 4+5>>b"     --> "a9b"
 Dang.preplace "a<<:return 4+5,6>>b"   --> "a9b"

 Dang.preplace "a<<:return false>>b"   --> "afalseb"

--]==]





--  _            _               _       
-- | |_ _____  _| |__   ___   __| |_   _ 
-- | __/ _ \ \/ / '_ \ / _ \ / _` | | | |
-- | ||  __/>  <| |_) | (_) | (_| | |_| |
--  \__\___/_/\_\_.__/ \___/ \__,_|\__, |
--                                 |___/ 
-- «texbody»  (to ".texbody")
-- Based on: (find-angg "LUA/tikz1.lua" "texbody")

scale = "1.0"
geometry = "paperwidth=148mm, paperheight=88mm,\n            "..
           "top=1.5cm, bottom=.25cm, left=1cm, right=1cm, includefoot"
geometryhead = "paperwidth=148mm, paperheight=88mm, top=2cm"
saysuccess = "\\GenericWarning{Success:}{Success!!!}"

-- See: (find-angg "LUA/tikz1.lua" "repl2")
-- Usage: defrepl = defrepl1
defrepl1 = [[
\directlua  { dofile(os.getenv("LUA_INIT"):sub(2)) }
\def\repl    {\directlua{ print(); run_repl2_now() }}
\def\condrepl{\directlua{ if os.getenv"REPL"=="1" then print(); run_repl2_now() end }}
%\nonstopmode
]]

outertexbody = Dang.from [=[
\documentclass{book}
\usepackage{xcolor}
\usepackage{colorweb}
\usepackage{graphicx}
\usepackage[<<geometry>>]{geometry}
<<usepackages>>
<<defrepl>>
\begin{document}
\pagestyle{empty}
<<defs>>
<<hello>>
\scalebox{<<scale>>}{%
  <<texbody>>%
  }
%
<<repl>>
<<saysuccess>>
\end{document}
]=]

-- «texbody-tests»  (to ".texbody-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
= outertexbody.bigstr
= outertexbody
  texbody = "FOO"
= outertexbody

--]==]







--  ____  _
-- / ___|| |__   _____      __
-- \___ \| '_ \ / _ \ \ /\ / /
--  ___) | | | | (_) \ V  V /
-- |____/|_| |_|\___/ \_/\_/
--
-- This class treats a bigstr as LaTeX code, preprocesses it in certain
-- configurable ways, tries to run lualatex on the result, and prints
-- a status showing if the lualatex-ing was successful. It _ALMOST_
-- shows the resulting PDF, but that is delegated to an elisp function
-- called etv, that is run from a red star line like this one,
--
--    (etv)
--
-- that creates a 3-window setting whose windows are called [e]dit,
-- [t]arget, and [v]iew:
--    ___________________________
--   |           |     	       	 |
--   |           |  [t]arget	 |
--   | the file  |   buffer	 |
--   |   being   |_______________|
--   | [e]dited  |		 |
--   | (a .lua)  |  [v]iew the	 |
--   |           | resulting PDF |
--   |___________|_______________|
--
-- The function (etv) is usually defined by a call to `code-show2'.
--      See: (find-eev "eev-tlinks.el" "code-show2")
-- Based on: (find-angg "LUA/tikz1.lua" "Show-class")
--
-- «Show»  (to ".Show")
--
Show = Class {
  type = "Show",
  new  = function (bigstr) Show.bigstr = bigstr; return Show{} end,
  try  = function (bigstr) return Show.new(bigstr):write():compile() end,
  -- These variables are set at each call:
  bigstr  = "",
  log     = "",
  success = nil,
  --
  __tostring = function (s) return s:tostring() end,
  __index = {
    tostring = function (s)
        return format("Show: %s => %s", s:fnametex(), Show.success or "?")
      end,
    --
    nilify   = function (s, o) if o=="" then return nil else return o end end,
    getenv   = function (s, varname) return s:nilify(os.getenv(varname)) end,
    dir      = function (s) return s:getenv("SHOW2DIR")  or "/tmp/" end,
    stem     = function (s) return s:getenv("SHOW2STEM") or "Show2" end,
    fnametex = function (s) return s:dir()..s:stem()..".tex" end,
    fnamepdf = function (s) return s:dir()..s:stem()..".pdf" end,
    fnamelog = function (s) return s:dir()..s:stem()..".log" end,
    cmd      = function (s)
        return "cd "..s:dir().." && lualatex "..s:stem()..".tex < /dev/null"
      end,
    write = function (s)
        ee_writefile(s:fnametex(), Show.bigstr)
        return s
      end,
    compile = function (s)
        Show.log = getoutput(s:cmd())
        Show.success = Show.log:match "Success!!!"
        return s
      end,
  },
}

-- «Show-tests»  (to ".Show-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
  texbody = "FOO"
= outertexbody
= Show.try(tostring(outertexbody))
= Show.log
 (find-code-show2 "/tmp/Show2.tex")
       (code-show2 "/tmp/Show2.tex")
 (etv)

--]==]




--      _        _                   _                   
--  ___| |_ _ __(_)_ __   __ _   ___| |__   _____      __
-- / __| __| '__| | '_ \ / _` | / __| '_ \ / _ \ \ /\ / /
-- \__ \ |_| |  | | | | | (_| |_\__ \ | | | (_) \ V  V / 
-- |___/\__|_|  |_|_| |_|\__, (_)___/_| |_|\___/ \_/\_/  
--                       |___/                           
--
-- «string.show»  (to ".string.show")
string.show0 = function (bigstr, optscale)
    texbody = bigstr
    scale = optscale or 1
    return Show.try(tostring(outertexbody))
  end
string.show = function (bigstr, optscale)
    return ("$"..bigstr.."$"):show0(optscale)   -- Add "$...$"s
  end

-- «string.show-tests»  (to ".string.show-tests")
--[[
 (code-show2 "/tmp/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
= ("$a \\cdot b$"):show()
= ("$a \\cdot b$"):show(4)
 (etv)
= ("$a \\cdot b$"):show(4)
 (etv)

--]]




-- (defun e () (interactive) (find-angg "LUA/Show2.lua"))

-- Local Variables:
-- coding:  utf-8-unix
-- End:
