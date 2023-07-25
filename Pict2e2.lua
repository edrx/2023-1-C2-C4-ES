-- This file:
--   http://anggtwu.net/LUA/Pict2e2.lua.html
--   http://anggtwu.net/LUA/Pict2e2.lua
--          (find-angg "LUA/Pict2e2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun p1 () (interactive) (find-angg "LUA/Pict2e1.lua"))
-- (defun p2 () (interactive) (find-angg "LUA/Pict2e2.lua"))


require "ELpeg1"  -- (find-angg "LUA/ELpeg1.lua")
                  -- (find-angg "LUA/ELpeg1.lua" "ToTeX")
                  -- (find-angg "LUA/ELpeg1.lua" "Subst")
require "Indent1" -- (find-angg "LUA/Indent1.lua")
require "Subst1"  -- (find-angg "LUA/Subst1.lua")
require "Show2"   -- (find-angg "LUA/Show2.lua")
require "MiniV1"  -- (find-angg "LUA/MiniV1.lua")

V = MiniV
v = V.fromab

-- «.Points2»			(to "Points2")
-- «.Points2-tests»		(to "Points2-tests")
-- «.Pict»			(to "Pict")
-- «.Pict-tests»		(to "Pict-tests")
-- «.PictBounds»		(to "PictBounds")
-- «.PictBounds-tests»		(to "PictBounds-tests")
-- «.PictBounds-methods»	(to "PictBounds-methods")
-- «.PictBounds-methods-tests»	(to "PictBounds-methods-tests")

-- (find-angg "LUA/Indent1.lua" "Ind")


-- (find-angg "LUA/Pict2e1.lua" "Pict2e-methods" "PradClass.__index.addline =")


table.reverse = function (A)
    local B = {}
    setmetatable(B, getmetatable(A))
    for i=1,#A do B[#A-i+1] = A[i] end
    return B
  end

table.addentries = function (A, B)
    for k,v in pairs(B) do A[k] = v end
    return A
  end


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
    add = function (pts, pt) table.insert(pts, pt); return pts end,
    adds = function (pts, pts2)
        for _,pt in ipairs(pts2) do pts:add(pt) end
        return pts
      end,
    --
    tostring = function (pts, sep) return mapconcat(tostring, pts, sep or "") end,
    pict2e   = function (pts, prefix) return prefix..tostring(pts) end,
    Line     = function (pts) return pts:pict2e("\\Line") end,
    polygon  = function (pts) return pts:pict2e("\\polygon") end,
    region0  = function (pts) return pts:pict2e("\\polygon*") end,
    polygon  = function (pts, s) return pts:pict2e("\\polygon"..(s or "")) end,
    rev      = function (pts) return table.reverse(pts) end,
    -- region = function (pts, color) return pts:region0():color(color) end,
    -- region = function (pts, color) return pts:region0() end,
  },
}

-- «Points2-tests»  (to ".Points2-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e2.lua"

a = VTable {2, 3, 4}
= a
= table.reverse(a)

pts = Points2 {v(1,2), v(3,4), v(3,1)}
= pts
= pts:Line()
= pts:Line()
= pts:rev()
= pts:add(pts:rev())
pts = Points2 {v(1,2), v(3,4), v(3,1)}

PPP(pts:Line())
-- Points2.__index.pict2e = function (pts, prefix)
--     return PictList { prefix..tostring(pts) }
--   end
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




--  ____  _      _   
-- |  _ \(_) ___| |_ 
-- | |_) | |/ __| __|
-- |  __/| | (__| |_ 
-- |_|   |_|\___|\__|
--                   
-- (find-angg "LUA/lua50init.lua" "pformat")
--
-- «Pict»  (to ".Pict")

Pict = Class {
  type    = "Pict",
  __tostring = function (p) return indent(p) end,
  __index = {
    output  = function (p) output(tostring(p)) end,
    add     = function (p, o) table.insert(p, o); return p end,
    pre     = function (p, o) return Pict {o, p} end,
    print   = function (p, o) return p:add(o) end,
    printf  = function (p, ...) return p:add(format(...)) end,
    pprintf = function (p, ...) return p:add(pformat(...)) end,
    wrap    = function (p,      a, b) return Pict              {a, p, b} end,
    wrapin  = function (p, pre, a, b) return Pict {(pre or "")..a, p, b} end,
    wrap00  = function (p, pre)  return p:wrapin(pre, "{<+1>",  "<-1>}")     end,
    wrap01  = function (p, pre)  return p:wrapin(pre, "{<+1>",  "<-1R>\n}")  end,
    wrap02  = function (p, pre)  return p:wrapin(pre, "{<+1>",  "<-1R>\n }") end,
    wrap10  = function (p, pre)  return p:wrapin(pre, "{<+1R>", "<-1>}")     end,
    wrap11  = function (p, pre)  return p:wrapin(pre, "{<+1R>", "<-1R>\n}")  end,
    wrap12  = function (p, pre)  return p:wrapin(pre, "{<+1R>", "<-1R>\n }") end,
    Wrap00  = function (p, pre)  return p:wrapin(pre, "{{<+2>",  "<-2>}}") end,
    Wrap10  = function (p, pre)  return p:wrapin(pre, "{{<+2R>", "<-2>}}") end,
    wrapbe  = function (p, b, e) return p:wrap(b.."\n <+1L>", "<-1R>\n"..e) end,
    --
    d       = function (p) return p:wrapin("",  "$<+1>", "<-1>$")  end,
    dd      = function (p) return p:wrapin("", "$$<+2>", "<-2>$$") end,
    --
    -- (find-angg "LUA/Pict2e1.lua" "Pict2e-methods")
    def      = function (p, name) return p:Wrap10("\\def\\"..name) end,
    sa       = function (p, name) return p:Wrap10("\\sa{"..name.."}") end,
    color    = function (p, color) return p:wrap00("\\color{"..color.."}") end,
    Color    = function (p, color) return p:wrap00("\\Color"..color) end,
    precolor = function (p, color) return p:pre("\\color{"..color.."}") end,
    prethickness = function (p, th) return p:pre("\\linethickness{"..th.."}") end,
    preunitlength = function (p, u) return p:pre("\\unitlength="..u) end,
    bhbox     = function (p) return p:wrapin("\\bhbox", "{$<+1>",  "<-1>$}") end,
    myvcenter = function (p) return p:wrap00("\\myvcenter") end,
    putat     = function (p, xy) return p:wrap00(pformat("\\put%s", xy)) end,
    --
    scalebox  = function (p, scale)
        if not scale then return p end
        return p:d():wrap00("\\scalebox{"..scale.."}")
      end,
    --
    addputstrat = function (p, xy, str) return p:add(pformat("\\put%s{%s}", xy, str)) end,
    addopendotat   = function (p, xy) return p:addputstrat(xy, "\\opendot")   end,
    addcloseddotat = function (p, xy) return p:addputstrat(xy, "\\closeddot") end,
    addline    = function (p, ...) return p:add(Points2.from(...):Line())    end,
    addpolygon = function (p, ...) return p:add(Points2.from(...):polygon()) end,
    addregion0 = function (p, ...) return p:add(Points2.from(...):region0()) end,
    predotdims = function (p, c, o)
        local fmt1 = "\\def\\closeddot{\\circle*{%s}}"
        local fmt2 = "\\def\\opendot  {\\circle*{%s}\\color{white}\\circle*{%s}}"
        return Pict { pformat(fmt1,c), pformat(fmt2,c,o), p }
      end,
    --
    -- 2023jun08:
    putstrat   = function (p, xy, str) return p:add(pformat("\\put%s{%s}", xy, str)) end,
    putfmtat   = function (p, xy, ...) return p:putstrat(xy, pformat(...)) end,
    putcellat  = function (p, xy, str) return p:putfmtat(xy, "\\cell{%s}", str) end,
    puttcellat = function (p, xy, str) return p:putfmtat(xy, "\\cell{\\text{%s}}", str) end,
    -- puttcellat = function (p, xy, str) return p:putcellat(xy, format("\\text{%s}", str)) end,
  }
}

-- (find-angg "LUA/Pict2e1.lua" "Pict2e-methods" "PradClass.__index.addline =")

-- «Pict-tests»  (to ".Pict-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e2.lua"

p = Pict {"a", "<!><+1>", "b", "<-1>", "c"}
= p
ab = Pict {"a", "b"}
= ab
= ab:wrapin(":", "{", "}")
= ab:wrapin(":", "{<+1><!>", "<!><-1>}")
= ab:wrapin(":", "{<+1><!>", "<-1><!>}")
= ab:wrap00()
= ab:wrap01()
= ab:wrap02()
= ab:wrap10()
= ab:wrap11()
= ab:wrap12()

= ab:def"foo"
= ab:sa "foo"
= ab:Color"Red"
= ab:precolor"red"
= ab:prethickness"1pt"
= ab:preunitlength"1pt"
= ab:bhbox()
= ab:myvcenter()
= ab:putat(v(2,3))
= ab:scalebox(2.3)

= ab:addopendotat(v(2,3))
= ab:addcloseddotat(v(2,3))
= ab:addline(v(4,5), v(6,7), v(8,9))
= ab:addpolygon(v(4,5), v(6,7), v(8,9))
= ab:addregion0(v(4,5), v(6,7), v(8,9))
= ab:predotdims(1.2, 3.4)


--]]



-- (find-angg "LUA/Pict2e1.lua" "PictBounds")


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
  --
  -- (find-angg "LUA/Pict2e1.lua" "Pict2e" "getbounds =")
  getbounds = function ()
      return PictBounds.bounds or PictBounds.new(v(0,0), v(3, 2))
    end,
  setbounds = function (...)
      PictBounds.bounds = PictBounds.new(...)
    end,
  --
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
        local p = Pict({"% Grid", "% Horizontal lines:"})
        for y=pb.y1,pb.y2 do p:addline(v(pb:x0(), y), v(pb:x3(), y)) end
        p:add("% Vertical lines:")
        for x=pb.x1,pb.x2 do p:addline(v(x, pb:y0()), v(x, pb:y3())) end
        return p
      end,
    ticks = function (pb, e)
        e = e or .2
        local p = Pict({"% Ticks", "% On the vertical axis:"})
        for y=pb.y1,pb.y2 do p:addline(v(-e, y), v(e, y)) end
        p:add("% On the horizontal axis: ")
        for x=pb.x1,pb.x2 do p:addline(v(x, -e), v(x, e)) end
        return p
      end,
    axes = function (pb)
        local p = Pict({"% Axes"})
        return p:addline(v(pb:x0(), 0), v(pb:x3(), 0))
                :addline(v(0, pb:y0()), v(0, pb:y3()))
      end,
    axesandticks = function (pb)
        return Pict { pb:axes(), pb:ticks() }
      end,
    --
    -- 2023jun08:
    hticks = function (pb, e)
        e = e or .2
        local p = Pict {"% On the horizontal axis:"}
        for x=pb.x1,pb.x2 do p:addline(v(x, -e), v(x, e)) end
        return p
      end,
    vticks = function (pb, e)
        e = e or .2
        local p = Pict {"% On the vertical axis:"}
        for y=pb.y1,pb.y2 do p:addline(v(-e, y), v(e, y)) end
        return p
      end,
    haxis = function (pb)
        return Pict({}):addline(v(pb:x0(), 0), v(pb:x3(), 0))
      end,
    vaxis = function (pb)
        return Pict({}):addline(v(0, pb:y0()), v(0, pb:y3()))
      end,
    haxisandticks = function (pb)
        return Pict { "% Horizontal axis and ticks:", pb:haxis(), pb:hticks() }
      end,
  },
}

-- «PictBounds-tests»  (to ".PictBounds-tests")
-- (find-LATEX "edrxpict.lua" "pictp0-pictp3")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e2.lua"

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
= pb:grid():prethickness("0.5pt")
= pb:grid():prethickness("0.5pt"):color("gray")

= pb
= pb:beginpicture()

= pb:p0()
= (pb:p0() + pb:p3())
= (pb:p0() + pb:p3()) * 0.5

--]]


--  ____  _      _   ____                        _                  
-- |  _ \(_) ___| |_| __ )  ___  _   _ _ __   __| |___    _ __ ___  
-- | |_) | |/ __| __|  _ \ / _ \| | | | '_ \ / _` / __|  | '_ ` _ \ 
-- |  __/| | (__| |_| |_) | (_) | |_| | | | | (_| \__ \  | | | | | |
-- |_|   |_|\___|\__|____/ \___/ \__,_|_| |_|\__,_|___/  |_| |_| |_|
--                                                                  
-- This block "adds PictBounds methods to the class Pict".
-- More precisely, it adds to Pict.__index, that is the table of methods
-- for the class Pict, a bunch of new methods that call things from the
-- class PictBounds.
-- Based on: (find-angg "LUA/Pict2e1.lua" "PictBounds-methods")
--
-- «PictBounds-methods»  (to ".PictBounds-methods")
--   
table.addentries(Pict.__index,
  { gb        = function (p) return PictBounds.getbounds() end,
    getbounds = function (p) return PictBounds.getbounds() end,
    --
    bep0      = function (p) return p:gb():beginpicture(), "\\end{picture}" end,
    bep       = function (p) return p:wrapbe(p:bep0()) end,
    --
    grid0          = function (p) return p:gb():grid() end,
    axes0          = function (p) return p:gb():axes() end,
    axesandticks0  = function (p) return p:gb():axesandticks() end,
    haxisandticks0 = function (p) return p:gb():haxisandticks() end,
    --
    gridstyle  = function (p) return p:pre("\\pictgridstyle"):wrap01() end,
    axesstyle  = function (p) return p:pre("\\pictaxesstyle"):wrap01() end,
    naxesstyle = function (p) return p:pre("\\pictnaxesstyle"):wrap01() end,
    --
    pregrid          = function (p) return p:pre(p:grid0():gridstyle()) end,
    preaxes          = function (p) return p:pre(p:axes0():axesstyle()) end,
    preaxesandticks  = function (p) return p:pre(p:axesandticks0():axesstyle()) end,
    prehaxisandticks = function (p) return p:pre(p:haxisandticks0():axesstyle()) end,
    prenaxesandticks = function (p) return p:pre(p:axesandticks0():naxesstyle()) end,
    --
    -- "PGAT" means "Picture, Grid, Axes, Ticks".
    -- This method adds begin/end picture, grid, axes, and ticks to a
    -- Pict2e object, in the right order, and with a very compact syntax
    -- to select what will be added. It can also add a bhbox and a def.
    pgat = function (p, str, def)
        if str:match("a") then p = p:preaxesandticks() end
        if str:match("A") then p = p:preaxes() end
        if str:match("N") then p = p:prenaxesandticks() end  -- for numerozinhos
        if str:match("h") then p = p:prehaxisandticks() end  -- for estatistica
        if str:match("g") then p = p:pregrid() end
        if str:match("p") then p = p:bep() end
        if str:match("c") then p = p:myvcenter() end
        if str:match("B") then p = p:bhbox() end
        if def            then p = p:def(def) end
        return p
      end,
    pgats = function (p, str, saname) return p:pgat(str):sa(saname) end,
  })

-- «PictBounds-methods-tests»  (to ".PictBounds-methods-tests")
--[[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e2.lua"
ab = Pict {"a", "b"}
= ab:bep0()
= ab:bep()

= ab:   grid0()
= ab:   gridstyle()
= ab:pregrid()

= ab:   axes0()
= ab:   axesandticks0()
= ab:   axesstyle()
= ab:  naxesstyle()
= ab: preaxes()
= ab: preaxesandticks()
= ab:prenaxesandticks()

= ab:pgat("a")
= ab:pgat("A")
= ab:pgat("N")
= ab:pgat("g")
= ab:pgat("p")
= ab:pgat("c")
= ab:pgat("B")
= ab:pgat(" ", "foo")

require "PictShow1"  -- (find-angg "LUA/PictShow1.lua")
ab = Pict {}
= ab:pgat("hg")
= ab:pgat("pgh"):show()

= show()
= Show.log
= Show.bigstr
 (etv)

--]]











-- Local Variables:
-- coding:  utf-8-unix
-- End:
