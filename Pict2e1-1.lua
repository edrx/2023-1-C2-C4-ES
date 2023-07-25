-- This file:
--     http://angg.twu.net/LUA/Pict2e1-1.lua.html
--     http://angg.twu.net/LUA/Pict2e1-1.lua
--             (find-angg "LUA/Pict2e1-1.lua")
--    See: http://angg.twu.net/pict2e-lua.html
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2022apr21
--
-- Tests for Pict2e1.lua that use functions that don't need to be in
-- the core.
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

-- «.Plot2D»			(to "Plot2D")
-- «.Plot2D-test1»		(to "Plot2D-test1")
-- «.Plot2D-test2»		(to "Plot2D-test2")
-- «.Node»			(to "Node")
-- «.Nodes»			(to "Nodes")
-- «.Nodes-test1»		(to "Nodes-test1")
-- «.Nodes-test2»		(to "Nodes-test2")
-- «.Nodes-test3»		(to "Nodes-test3")
-- «.Nodes-test4»		(to "Nodes-test4")
-- «.Nodes-test5»		(to "Nodes-test5")
-- «.Nodes-test6»		(to "Nodes-test6")
-- «.Nodes-test6-pdf»		(to "Nodes-test6-pdf")
-- «.Numerozinhos»		(to "Numerozinhos")
-- «.Numerozinhos-test1»	(to "Numerozinhos-test1")
-- «.Numerozinhos-test2»	(to "Numerozinhos-test2")
-- «.Numerozinhos-test3»	(to "Numerozinhos-test3")
-- «.Numerozinhos-test4»	(to "Numerozinhos-test4")
-- «.Numerozinhos-test5»	(to "Numerozinhos-test5")
-- «.Numerozinhos-test6»	(to "Numerozinhos-test6")
-- «.Tracinhos»			(to "Tracinhos")
-- «.Tracinhos-test»		(to "Tracinhos-test")
-- «.FromYs»			(to "FromYs")
-- «.FromYs-tests»		(to "FromYs-tests")

require "Pict2e1"      -- (find-angg "LUA/Pict2e1.lua")

pi, sin, cos = math.pi, math.sin, math.cos

-- seqn = function (a, b, n)
--     local f = function (k) return a + (b-a)*(k/n) end
--     return map(f, seq(0, n))
--   end




--  ____  _       _   ____  ____  
-- |  _ \| | ___ | |_|___ \|  _ \ 
-- | |_) | |/ _ \| __| __) | | | |
-- |  __/| | (_) | |_ / __/| |_| |
-- |_|   |_|\___/ \__|_____|____/ 
--                                
-- «Plot2D»  (to ".Plot2D")

Plot2D = Class {
  type  = "Plot2D",
  new   = function (tbl)
      if type(tbl.P)  == "string" then tbl.P  = Code.ve(tbl.P)  end
      if type(tbl.Pt) == "string" then tbl.Pt = Code.ve(tbl.Pt) end
      if tbl.ts then tbl.ts = HTable(tbl.ts) end
      return Plot2D(tbl)
    end,
  from  = function (P, ts)
      return Plot2D.new({P=P, ts=ts})
    end,
  __tostring = function (p) return p:tostring() end,
  __index = {
    tostring = function (p)
        return pformat("P:  %s\nPt: %s\nts: %s", p.P, p.Pt, p:tstostring())
      end,
    tstostring = function (p)
        if not p.ts then return "nil" end
        local f = function (t) return pformat("%s", t) end
        local pts = "{"..mapconcat(f, p.ts, ", ").."}"
        return pts
      end,
    topts = function (p)
        return myunpack(map(p.P, p.ts))
      end,
    toline = function (p)
        return Pict2e.line(p:topts())
      end,
    tovector = function (p, t)
        return Pict2eVector.fromwalk(p.P(t), p.Pt(t))
      end,
    tovectors = function (p, ts)
        local f = function (t) return p:tovector(t) end
        return PictList(map(f, ts))
      end,
  },
}

-- «Plot2D-test1»  (to ".Plot2D-test1")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
= Plot2D.from("x =>     sin(x) ")
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4))
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4)).ts
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4)):tstostring()
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4))
= Plot2D.from("x =>     sin(x) ", seq(0, pi, pi/4)):topts()
= Plot2D.from("x => v(x,sin(x))", seq(0, pi, pi/4)):topts()
= Plot2D.from("x => v(x,sin(x))", seq(0, pi, pi/4)):toline()
= Plot2D.from("x => v(x,sin(x))", seqn(0, pi,   4)):toline():Color("Red")

xs = seqn(0, 2*pi, 128)
fx = function (expr) return "x => v(x,"..expr..")" end
plotf = function (expr) return Plot2D.from(fx(expr), xs):toline() end
= plotf("sin(x)")

Pict2e.bounds = PictBounds.new(v(0,-1), v(7,1))
Show.preamble = [[ \unitlength=35pt ]]
PradClass.__index.bshow0 = function (p)
    return p:pgat("pgat"):d():tostringp()
  end

r = PictList {
    plotf("sin(x)")  :Color("Red"),
    plotf("sin(2*x)"):Color("Orange"),
    plotf("sin(3*x)"):Color("Green"),
    plotf("sin(4*x)"):Color("Violet"),
  }:prethickness("2pt")
= r
= r:bshow()
 (etv)

--]==]



-- «Plot2D-test2»  (to ".Plot2D-test2")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
PradClass.__index.bshow0 = function (p)
    return p:pgat("pgat"):d():tostringp()
  end
Pict2e.bounds = PictBounds.new(v(-3,-3), v(3,3))
Show.preamble = [[
  \unitlength=25pt
]]

_P  = function (t) return v(   cos(t),       sin(t)) end
_Pt = function (t) return v(  -sin(t),       cos(t)) end
_Q  = function (t) return v(   cos(4*t)/2,   sin(4*t)/2) end
_Qt = function (t) return v(-2*sin(4*t),   2*cos(4*t)  ) end
_R  = function (t) return _P(t)+_Q(t) end
_Rt = function (t) return _Pt(t)+_Qt(t) end

ts   = seqn(0, 2*pi, 64)
r = Plot2D.new {
      P  = "t => _R (t)",
      Pt = "t => _Rt(t)",
      ts = ts
  }

ts_v = seqn(0, 2*pi, 6)
= r:tovectors(ts_v)

p = PictList {
      r:toline():Color("Orange"),
      r:tovectors(ts_v):Color("Red")
    }:prethickness("2pt")
= p
= p:bshow()
 (etv)

--]==]





-- «Node»  (to ".Node")
--
Node = Class {
  type  = "Node",
  from  = function (x, y, tag, linkto, tex)
      return Node {x=x, y=y, tag=tag, linkto=linkto, tex=tex}
    end,
  __tostring = function (nd) return mytostringpv(nd) end,
  __index = {
    xy = function (nd) return v(nd.x, nd.y) end,
    totex = function (nd)
        return pformat("\\putnode%s{%s}", nd:xy(), nd.tex or nd.tag)
      end,
  },
}

-- «Nodes»  (to ".Nodes")
--
Nodes = Class {
  type  = "Nodes",
  new   = function () return Nodes {_={}} end,
  snode = function (xy)
      return pformat("\\put%s{\\snode}", xy)
    end,
  __tostring = function (nds)
      return mapconcat(mytostringp, nds._, "\n")
    end,
  __index = {
    add0 = function (nds, x, y, tag, tex, linkto)
        local n = #(nds._)+1
        local node = Node {x=x, y=y, n=n, tag=tag, tex=tex, linkto=linkto}
        nds._[n]   = node
        nds._[tag] = node
        return nds
      end,
    --
    addnode = function(nds, y, xtaglinkto)
        local x,tag,linkto = xtaglinkto:match("^(.-):(.-):(.-)$")
        x = x+0
        if linkto == "" then linkto = nil end
        nds:add0(x, y, tag, nil, linkto)
      end,
    addnodes = function(nds, y, line)
        for _,xtaglinkto in ipairs(split(line)) do
          nds:addnode(y, xtaglinkto)
        end
      end,
    addtex = function(nds, tag, tex)
        local node = nds._[tag]
        if node then node.tex = tex end
      end,
    addtexs = function (nds, bigstr)
        local A = split(bigstr)
        for i=1,#A,2 do nds:addtex(A[i], A[i+1]) end
      end,
    --
    nodestotex = function (nds)
        local f = function (nd) return nd:totex() end
        return PictList(map(f, nds._))
      end,
    linkstotex = function (nds)
        local p = PictList {}
        for i,nd1 in ipairs(nds._) do
          if nd1.linkto then
            local nd2 = nds._[nd1.linkto]
            if not nd2 then error(format("Bad linkto: %s -> %s", nd1.tag, nd1.linkto)) end
            p:addline(nd1:xy(), nd2:xy())
          end
        end
        return p
      end,
    totex = function (nds)
        return PictList {nds:linkstotex(), nds:nodestotex(), nds:snodestotex()}
      end,
    --
    midpoint = function (nds, tag1, tag2)
        return (nds._[tag1]:xy() + nds._[tag2]:xy()) * 0.5
      end,
    midabove = function (nds, tag1)
        local tag2 = nds._[tag1].linkto
        return nds:midpoint(tag1, tag2)
      end,
    snodes = function (nds, tags)
        tags = split(tags)
        local f = function (tag) return Nodes.snode(nds:midabove(tag)) end    
        return PictList(map(f, tags))
      end,
    withsnodetags = function (nds, snodetags)
        local nds2 = copy(nds)
        nds2.snodetags = snodetags
        return nds2
      end,
    snodestotex = function (nds)
        return nds:snodes(nds.snodetags or "")
      end,
    totexwithsnodes = function (nds, tags)
        return PictList { nds:totex(), nds:snodes(tags) }
      end,
    --
    show0 = function (nds, pgat, scale)
        return nds:totex():pgat(pgat):scalebox(scale):d()
      end,
    show = function (nds, ...)
        return Show.try(nds:show0(...):tostringp())
      end,
  },
}






-- «Nodes-test1»  (to ".Nodes-test1")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
nds = Nodes.new()
nds:add0(0, 0, "a", nil, "+")
nds:add0(1, 1, "+", nil, nil)
nds:add0(2, 0, "b", nil, "+")
= nds
PPP(nds)
= nds:nodestotex()
= nds:linkstotex()

= nds._[1]
= nds._[1]:totex()
= nds:totex()

--]]


-- «Nodes-test2»  (to ".Nodes-test2")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"

Show.preamble = [[
  \unitlength=25pt
  \def\Sone{[\mathrm{S1}]}
  \def\Stwo{[\mathrm{S2}]}
]]

Pict2e.bounds = PictBounds.new(v(-1,-1), v(4,4))

p = PictList {
  [[ \Line(0,0)(3,3) ]],
  [[ \Line(2,2)(3,1) ]],
  [[ \putnode(0,0){a} ]],
  [[ \putnode(1,1){\Stwo} ]],
  [[ \putnode(2,2){+} ]],
  [[ \putnode(3,3){\Stwo} ]],
  [[ \putnode(3,1){b} ]],
}
= p:bshow()
 (etv)
= p:bshow("p")
 (etv)

nds = Nodes.new()
nds:add0(0, 0, "a", nil, "+")
nds:add0(1, 1, "+", nil, nil)
nds:add0(2, 0, "b", nil, "+")
= nds
= nds:totex()
= nds:totex():bshow()
 (etv)

Pict2e.bounds = PictBounds.new(v(0,0), v(2,1), 0.5)

Show.preamble = [[
  \unitlength=35pt
  \def\nodesize{0.7}
]]
= nds:totex():bshow()
 (etv)

--]==]



-- «Nodes-test3»  (to ".Nodes-test3")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
Pict2e.bounds = PictBounds.new(v(-1,0), v(10,4), 0.5)

Show.preamble = [[
  \unitlength=35pt
  \def\nodesize{0.9}
]]

PradClass.__index.bshow0 = function (p, str, scale)
    return p:pgat(str or "pgat"):d():scalebox(scale):tostringp()
  end

nds = Nodes.new()
nds:add0(-1,2, "x0", "x",               "dd")
nds:add0(0, 3, "dd", [[\frac{d}{d\_}]], "=")
nds:add0(1, 2, "f",  [[f(\_)]],         "dd")
nds:add0(2, 1, "g1", [[g(\_)]],         "f")
nds:add0(3, 0, "x1", "x",               "g1")
nds:add0(4, 4, "=",  nil,               nil)
nds:add0(8, 3, "*",  "·",               "=")
nds:add0(5, 2, "f'", [[f'(\_)]],        "*")
nds:add0(6, 1, "g2", [[g(\_)]],         "f'")
nds:add0(7, 0, "x2", "x",               "g2")
nds:add0(9, 2, "g'", [[g'(\_)]],        "*")
nds:add0(10,1, "x3", "x",               "g'")
= nds
= nds:totex()
= nds:totex():bshow(nil, "0.7")
 (etv)
= nds:totex():bshow("p", "0.7")
 (etv)

= nds:midpoint("dd", "=")
= nds:midabove("dd")

= nds:snodes("x1 x2")
= nds:totexwithsnodes("x1 x2")
= nds:totexwithsnodes("x1 x2"):bshow("p", "0.7")
 (etv)

--]==]


-- «Nodes-test4»  (to ".Nodes-test4")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
Pict2e.bounds = PictBounds.new(v(-1,0), v(10,4), 0.5)
Show.preamble = [[
  \unitlength=35pt
  \def\nodesize{0.9}
]]
PradClass.__index.bshow0 = function (p, str, scale)
    return p:pgat(str or "pgat"):d():scalebox(scale):tostringp()
  end

mknds_43 = function ()
    nds = Nodes.new()
    nds:add0( 0, 3, "dd", [[\frac{d}{d\_}]], "=")
    nds:add0(11, 3, "*",  [[·]],             "=")
    nds:add0( 6, 4, "=",  nil,               nil)
  end
mknds_210_a = function ()
    nds:add0(-1, 2, "x0", [[x]],             "dd")
    nds:add0( 1, 2, "f",  [[f(\_)]],         "dd")
    nds:add0( 7, 2, "f'", [[f'(\_)]],        "*")
    nds:add0(12, 2, "g'", [[g'(\_)]],        "*")
    nds:add0( 3, 1, "g1", [[g(\_)]],         "f")
    nds:add0( 4, 0, "x1", [[x]],             "g1")
    nds:add0( 9, 1, "g2", [[g(\_)]],         "f'")
    nds:add0(10, 0, "x2", [[x]],             "g2")
    nds:add0(13, 1, "x3", [[x]],             "g'")
  end

mknds_43()
mknds_210_a()
= nds
= nds:totexwithsnodes("x1 x2")
= nds:totexwithsnodes("x1 x2"):bshow("p", "0.7")
= nds:totexwithsnodes("x1 x2"):bshow("pgat", "0.7")
 (etv)

--]==]



-- «Nodes-test5»  (to ".Nodes-test5")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
Pict2e.bounds = PictBounds.new(v(0,0), v(13,4), 0.5)
Show.preamble = [[
  \unitlength=35pt
  \def\nodesize{0.9}
]]

nds_addtexs = function ()
    nds:addtexs [[ * ·  dd \frac{d}{d\_}  x1 x  x2 x  x3 x  x4 x  g1 g  g2 g  ]]
    nds:addtexs [[ t1 t   t2 t   t3 t  sin \sin   cos \cos                    ]]
    nds:addtexs [[ *1 ·   *2 ·     42a 42   42b 42  42c 42                    ]]
  end

nds = Nodes.new()
nds:addnodes(4, "                          6:=:                           ")
nds:addnodes(3, "       1:dd:=                           11:*:=           ")
nds:addnodes(2, " 0:x1:dd    2:f:dd             7:f':*         12:g':*    ")
nds:addnodes(1, "                 4:g1:f          9:g2:f'        13:x4:g' ")
nds:addnodes(0, "                    5:x2:g1         10:x3:g2             ")
nds_addtexs()
nds_initial = nds
= nds
= nds:totex()
= nds:totexwithsnodes(""):bshow("pgat", "0.7")
 (etv)

nds = Nodes.new()
nds:addnodes(4, "                          6:=:                                  ")
nds:addnodes(3, "       1:dd:=                                       11:*:=      ")
nds:addnodes(2, " 0:t1:dd   2:sin:dd             7:cos:*                12:42c:* ")
nds:addnodes(1, "                 4:*1:sin              9:*2:cos                 ")
nds:addnodes(0, "             3:42a:*1   5:t2:*1    8:42b:*2  10:t3:*2           ")
nds_addtexs()
nds_final = nds
= nds
= nds:totex()
= nds:totexwithsnodes(""):bshow("pgat", "0.7")
 (etv)

= nds:totexwithsnodes("x1 x2")
= nds:totexwithsnodes("x1 x2"):bshow("p", "0.7")
 (etv)

= nds_initial:totex()
= nds_initial:totex():pgat("pgat")
= nds_initial:totex():pgat("pgat"):scalebox("0.7")
= nds_initial:totex():pgat("pgat"):scalebox("0.7"):d()

Nodes.__index.topage0 = function (nds)
    return nds:totex():pgat("pgat"):scalebox("0.7"):d()
  end

all = PictList {
  nds_initial:topage0(),
  "\\newpage",
  nds_final:topage0(),
}
= all
= all:tostring()
= all:tostringp()

= Show.try(all:tostringp())
 (etv)

--]==]


-- «Nodes-test6»  (to ".Nodes-test6")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
Pict2e.bounds = PictBounds.new(v(0,0), v(13,4), 0.5)
Show.preamble = [[
  \unitlength=35pt
  \def\nodesize{0.9}
]]
nds_addtexs = function ()
    nds:addtexs [[ dd \frac{d}{d\_}  sin \sin   cos \cos ]]
    nds:addtexs [[ *   ·   *1 ·    *2 ·                  ]]
    nds:addtexs [[ x1  x   x2 x    x3 x  x4 x            ]]
    nds:addtexs [[ t1  t   t2 t    t3 t                  ]]
    nds:addtexs [[ g1  g   g2 g                          ]]
    nds:addtexs [[ 42a 42  42b 42  42c 42                ]]
  end

nds = Nodes.new()
nds:addnodes(4, "                          6:=:                           ")
nds:addnodes(3, "       1:dd:=                           11:*:=           ")
nds:addnodes(2, " 0:x1:dd    2:f:dd             7:f':*         12:g':*    ")
nds:addnodes(1, "                 4:g1:f          9:g2:f'        13:x4:g' ")
nds:addnodes(0, "                    5:x2:g1         10:x3:g2             ")
nds_addtexs()
nds_0 = nds
= nds
= nds:totex()
= nds:withsnodetags("dd"):show0("pgat", "0.7")
= nds:withsnodetags("dd"):show("pgat", "0.7")
 (etv)

nds = Nodes.new()
nds:addnodes(4, "                          6:=:                           ")
nds:addnodes(3, "       1:dd:=                           11:*:=           ")
nds:addnodes(2, " 0:t1:dd   2:sin:dd           7:cos:*         12:42c:*   ")
nds:addnodes(1, "               4:g1:sin          9:g2:cos                ")
nds:addnodes(0, "                    5:x2:g1         10:x3:g2             ")
nds_addtexs()
nds_1 = nds

nds = Nodes.new()
nds:addnodes(4, "                          6:=:                           ")
nds:addnodes(3, "       1:dd:=                           11:*:=           ")
nds:addnodes(2, " 0:t1:dd   2:sin:dd           7:cos:*         12:42c:*   ")
nds:addnodes(1, "               4:*1:sin            9:*2:cos              ")
nds:addnodes(0, "          3:42a:*1  5:x2:*1     8:42b:*2  10:x3:*2       ")
nds_addtexs()
nds_2 = nds

nds = Nodes.new()
nds:addnodes(4, "                          6:=:                                  ")
nds:addnodes(3, "       1:dd:=                                       11:*:=      ")
nds:addnodes(2, " 0:t1:dd   2:sin:dd             7:cos:*                12:42c:* ")
nds:addnodes(1, "                 4:*1:sin              9:*2:cos                 ")
nds:addnodes(0, "             3:42a:*1   5:t2:*1    8:42b:*2  10:t3:*2           ")
nds_addtexs()
nds_3 = nds

pgat = "pgat"
pgat = ""
all = PictList {
  nds_0:withsnodetags("dd *      "):show0(pgat, "0.7"),
  "\\newpage",
  nds_0:withsnodetags("x1 f f' g'"):show0(pgat, "0.7"),
  "\\newpage",
  nds_1:withsnodetags("g1 g2     "):show0(pgat, "0.7"),
  "\\newpage",
  nds_2:withsnodetags("x2 x3     "):show0(pgat, "0.7"),
  "\\newpage",
  nds_3:withsnodetags("          "):show0(pgat, "0.7"),
}
= Show.try(all:tostringp())
 (etv)


= nds:show0("pgat", "0.7")
= nds:show("pgat", "0.7")
= nds:show("p", "0.7")

-- «Nodes-test6-pdf»  (to ".Nodes-test6-pdf")
-- (find-pdf-page "~/LATEX/2022pict2e-nodes-test6.pdf")
-- (find-fline "cd ~/LATEX/; xpdf  2022pict2e.pdf")
-- (find-fline "cd ~/LATEX/; cp -v 2022pict2e.pdf 2022pict2e-nodes-test6.pdf")
-- (find-cp-angg-links "2022pict2e-nodes-test6.pdf" "~/LATEX/" "LATEX/")
-- http://angg.twu.net/LATEX/2022pict2e-nodes-test6.pdf


--]==]




--  _   _                                   _       _               
-- | \ | |_   _ _ __ ___   ___ _ __ ___ ___(_)_ __ | |__   ___  ___ 
-- |  \| | | | | '_ ` _ \ / _ \ '__/ _ \_  / | '_ \| '_ \ / _ \/ __|
-- | |\  | |_| | | | | | |  __/ | | (_) / /| | | | | | | | (_) \__ \
-- |_| \_|\__,_|_| |_| |_|\___|_|  \___/___|_|_| |_|_| |_|\___/|___/
--                                                                  
-- «Numerozinhos»  (to ".Numerozinhos")
Numerozinhos = Class {
  type    = "Numerozinhos",
  xyn     = function (x, y, n)
      return pformat("\\put(%s,%s){\\cell{\\text{%s}}}", x, y, n)
    end,
  xyns    = function (x, y, str)
      local p = PictList {}
      for i,n in ipairs(split(str)) do
        table.insert(p, Numerozinhos.xyn(x+i-1, y, n))
      end
      return p
    end,
  xynss   = function (x, y, bigstr)
      local p = PictList {}
      local lines = splitlines((bigstr:gsub("|", "\n")))
      local topy = y + #lines - 1
      for nline,line in ipairs(lines) do
        table.insert(p, Numerozinhos.xyns(x, topy-nline+1, line))
      end
      return p
    end,
  fromf  = function (xy_sw, xy_ne, f)
      local xmin,xmax,ymin,ymax = xy_sw[1], xy_ne[1], xy_sw[2], xy_ne[2]
      -- print("xmin,xmax,ymin,ymax", xmin,xmax,ymin,ymax)
      local p = PictList {}
      for y=ymax,ymin,-1 do
        for x=xmin,xmax do
          local n = f(x,y)
          table.insert(p, Numerozinhos.xyn(x, y, n))
        end
      end
      return p
    end,
  --
  from = function (x, y, bigstr)
      return Numerozinhos {x=x, y=y, bigstr=bigstr}
    end,
  spectolines = function (spec)
      return PwSpec.from(spec):topict():prethickness("2pt"):Color("Orange")
    end,
  --
  __index = {
    toputs = function (ns)
        return Numerozinhos.xynss(ns.x, ns.y, ns.bigstr)
      end,
    topictbody = function (ns, spec, etc)
        local lines = spec and Numerozinhos.spectolines(spec)
        local puts  = ns:toputs()
        local body  = PictList {}
        table.insert(body, lines)   -- lines first, below
        table.insert(body, puts)    -- numbers over the lines
        table.insert(body, etc)
        return body
      end,
    topict = function (ns, ...)
        return ns:topictbody(...):pgat("Npc"):preunitlength("11pt")
      end,
    topictu = function (ns, u, ...)
        return ns:topictbody(...):pgat("Npc"):preunitlength(u)
      end,
  },
}

-- A quick hack to add dots and (gradient) vectors
PradClass.__index.adddv = function (p, ...)
    local tio = function (o) table.insert(p, o) end
    local dot = function (x,y) tio(pformat("\\put(%s,%s){\\closeddot}", x, y)) end
    local vec = function (x,y,Dx,Dy) tio(Pict2eVector.fromwalk(v(x,y),v(Dx,Dy))) end
    for i,item in ipairs({...}) do
      if type(item) == "string" then table.insert(p, item)
      elseif type(item) == "table" then
        if #item >= 2 then dot(item[1],item[2]) end
        if #item == 4 then vec(unpack(item)) end
      end
    end
    return p
  end

-- «Numerozinhos-test1»  (to ".Numerozinhos-test1")
-- (c2m221isp 7 "exercicio-2-dica")
-- (c2m221isa   "exercicio-2-dica")
-- (find-LATEX "2022pict2e.tex" "grid-axes-ticks")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"

= Numerozinhos.xyns (2, 4, "24 34 44")
= Numerozinhos.xynss(2, 4, "24 34 44")
= Numerozinhos.xynss(2, 4, "25 35 45 | 24 34")
= Numerozinhos.xynss(2, 4, "25 35 45 | 24 34"):pgat("pN")

Pict2e.bounds = PictBounds.new(v(0,0), v(4,3))
= Numerozinhos.xynss(2, 1, 
    [[ a b c 
       d e f
       g h i ]]):bshow("pN")
 (etv)

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
require "Piecewise1"
p = Numerozinhos.from(2, 1,
    [[ a b c 
       d e f
       g h i ]])
= p:topict()
= p:topict("(2,1)--(2,2)")
= p:topict(              ):bshow("")
 (etv)
= p:topict("(2,1)--(2,2)"):bshow("")
 (etv)

--]==]



-- «Numerozinhos-test2»  (to ".Numerozinhos-test2")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"

-- (find-angg "LUA/lua50init.lua" "minus-0")
truncn = function (n) return trunc0(string.format("%.3f", fix0(n))) end

Pict2e.bounds = PictBounds.new(v(0,0), v(6,5))
x0,y0 = 4,3
p = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), function (x1,y1)
        local Dx,Dy = x1-x0,y1-y0
        print(Dx, Dy, Dx*Dy)
        return Dx*Dy
      end)

= p:bshow("pN")
= p:pgat("pN"):bshow("")
= p:pgat("pN"):preunitlength("12pt"):bshow("")
 (etv)

--]==]


-- «Numerozinhos-test3»  (to ".Numerozinhos-test3")
-- (c3m221nfp 19 "piramide")
-- (c3m221nfa    "piramide")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"

Pict2e.bounds = PictBounds.new(v(-1,-1), v(9,9))
p = Numerozinhos.xynss(0, 0, 
    [[ 0 0 0 0 0 0 0 0 0
       0 0 0 0 0 0 0 0 0
       0 0 1 1 1 1 1 0 0
       0 0 1 2 2 2 1 0 0
       0 0 1 2 3 2 1 0 0
       0 0 1 2 2 2 1 0 0
       0 0 1 1 1 1 1 0 0
       0 0 0 0 0 0 0 0 0
       0 0 0 0 0 0 0 0 0]])
= p:pgat("pN"):preunitlength("11pt"):bshow("")
 (etv)

--]==]


-- «Numerozinhos-test4»  (to ".Numerozinhos-test4")
-- (c3m221fhp 5 "exercicio-2-fig")
-- (c3m221fha   "exercicio-2-fig")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"

Numerozinhos.xyn = function (x, y, n)
    if n == "." then return nil end
    if n == "?" then n = "\\ColorRed{?}" end
    return pformat("\\put(%s,%s){\\cell{\\text{%s}}}", x, y, n)
  end

Pict2e.bounds = PictBounds.new(v(-5,-5), v(5,5))
p = Numerozinhos.xynss(-4, -4, 
    [[ . . ? . . . . . .
       . . . . ? . . ? .
       . . . ? ? . ? . ?
       . . . . 3 2 5 . .
       . . ? ? ? 8 ? ? .
       . . ? ? ? . . . .
       ? . ? . ? 4 . . .
       . . . . . . . . .
       . . . . . . ? . .]])
= p:pgat("pN"):preunitlength("11pt"):bshow("")
 (etv)

--]==]


-- «Numerozinhos-test5»  (to ".Numerozinhos-test5")
-- (c3m221fhp 7 "exercicio-5")
-- (c3m221fha   "exercicio-5")
-- (c3m221fha   "exercicio-5" "nff \"Dx*Dy\"")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"

Pict2e.bounds = PictBounds.new(v(0,0), v(6,5))
x0,y0 = 4,3
nff = function (str)
    return Code.vc("x,y => local Dx,Dy = x-x0,y-y0; return "..str)
  end
p = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), nff "Dx*Dy")
= p:pgat("pN"):preunitlength("11pt"):bshow("")
 (etv)

-- (find-pdftoolsr-page "~/LATEX/2022-1-C3-VR.pdf" 2)
F = nff "Dy               "
G = nff "     Dx * (Dx+Dy)"
H = nff "Dy + Dx * (Dx+Dy)"
pF = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), F):pgat("pN")
pG = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), G):pgat("pN")
pH = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), H):pgat("pN")
= pH
sp = "\\quad"
p3 = PictList({ pF, sp, pG, sp, pH }):preunitlength("11pt")
= p3:bshow("")
 (etv)

= pH:preunitlength("25pt"):bshow("")
 (etv)

 (eepitch-maxima)
 (eepitch-kill)
 (eepitch-maxima)
[x0,y0] : [4,3];
[Dx,Dy] : [x-x0,y-y0];
G : Dy + Dx * (Dx+Dy);
subst([x=4,y=1], G);

--]]

-- «Numerozinhos-test6»  (to ".Numerozinhos-test6")
-- (find-angg "LUA/Pict2e1.lua" "Pict2eVector-tests")
-- (find-angg "LUA/lua50init.lua" "minus-0")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
truncn = function (n) return trunc0(string.format("%.3f", fix0(n))) end
nff = function (str)
    return Code.vc("x,y => local Dx,Dy = x-x0,y-y0; return "..str)
  end

Pict2e.bounds = PictBounds.new(v(0,0), v(6,5))
x0,y0 = 4,3
p = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), nff "Dx*Dy")
p:adddv("\\color{Red2}", "\\linethickness{1.0pt}")
p:adddv({4,1}, {4,2,2,1})
PPPV(p)
= p
= p:pgat("pN"):preunitlength("12.5pt"):bshow("")
 (etv)

--]]





--  _____               _       _               
-- |_   _| __ __ _  ___(_)_ __ | |__   ___  ___ 
--   | || '__/ _` |/ __| | '_ \| '_ \ / _ \/ __|
--   | || | | (_| | (__| | | | | | | | (_) \__ \
--   |_||_|  \__,_|\___|_|_| |_|_| |_|\___/|___/
--                                              
-- «Tracinhos»  (to ".Tracinhos")
Tracinhos = Class {
  type = "Tracinhos",
  new = function (r)
      r = r or 0.2
      return Tracinhos { r=r, p=PictList({}) }
    end,
  __index = {
    v = function (tr, Dy, Dx)
        Dx = Dx or 1
        if Dx == 0 then
          if Dy == 0 then return nil end
          return v(0, tr.r)
        end
        local v0 = v(Dx, Dy)
        local v1 = v0 * (1 / v0:norm())
        local v2 = v1 * tr.r
        return v2
      end,
    tracinho = function (tr, xy, Dy, Dx)
        local vv = tr:v(Dy, Dx)
        if not vv then return tr end
        tr.p:addline(xy-vv, xy+vv)

      end,
  },
}

-- «Tracinhos-test»  (to ".Tracinhos-test")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
tr = Tracinhos {r=0.2, p=PictList{}}
V.__index.norm = function (v) return (v[1]^2 + v[2]^2)^0.5 end

Pict2e.bounds = PictBounds.new(v(-2,-2), v(2,2))
tr = Tracinhos.new()
for y=2,-2,-1 do
  for x=-2,2 do
    tr:tracinho(v(x,y), -y, x)
  end
end
= tr.p:pgat("pN"):bshow("")
 (etv)

Pict2e.bounds = PictBounds.new(v(-2,-2), v(2,2))
tr = Tracinhos.new()
for y=2,-2,-1 do
  for x=-2,2 do
    tr:tracinho(v(x,y), 1, x)
  end
end
= tr.p:pgat("pN"):bshow("")
 (etv)

Pict2e.bounds = PictBounds.new(v(-2,-2), v(2,2))
tr = Tracinhos.new()
for y=2,-2,-1 do
  for x=-2,2 do
    tr:tracinho(v(x,y), x+y, 2)
  end
end
= tr.p:pgat("pN"):bshow("")
 (etv)




--]]


--  _____                 __   __   
-- |  ___| __ ___  _ __ __\ \ / /__ 
-- | |_ | '__/ _ \| '_ ` _ \ V / __|
-- |  _|| | | (_) | | | | | | |\__ \
-- |_|  |_|  \___/|_| |_| |_|_||___/
--                                  
-- «FromYs»  (to ".FromYs")
-- Based on: (c2m221p1p 7 "escadas-defs")
--           (c2m221p1a   "escadas-defs")
--           (c2m221p1p 8 "escadas-gab")
--           (c2m221p1a   "escadas-gab")
--
FromYs = Class {
  type   = "FromYs",
  fromys = function (ys) return FromYs {ys=ys} end,
  __tostring = function (fry) return mytostringv(fry) end,
  __index = {
    getYs = function (fry, Y0)
        fry.Ys = {Y0}
        for i,y in ipairs(fry.ys) do
          local lastY = fry.Ys[#fry.Ys]
          table.insert(fry.Ys, lastY+y)
        end
        fry.ymax = foldl1(max, fry.ys)
        fry.ymin = foldl1(min, fry.ys)
        fry.Ymax = foldl1(max, fry.Ys)
        fry.Ymin = foldl1(min, fry.Ys)
        local hx = function (x, y)
            return format(" (%s,%s)c--(%s,%s)o", x-1,y, x,y)
          end
        fry.yspec = ""
        for x,y in ipairs(fry.ys) do fry.yspec = fry.yspec .. hx(x, y) end
        local xY = function (x) return format("(%s,%s)", x, fry.Ys[x+1]) end
        PP(fry.ys)
        PP(fry.Ys)
        PP(xY(0), xY(1), xY(2))
        fry.Yspec = mapconcat(xY, seq(0, #fry.Ys-1), "--")
        return fry
      end,
    getypict = function (fry, ymin, ymax)
        ymin = ymin or fry.ymin
        ymax = ymax or fry.ymax
        local pws  = PwSpec.from(fry.yspec)
        local pict = pws:topict():setbounds(v(0, ymin), v(#fry.ys, ymax))
        return pict
      end,
    getYpict = function (fry, Ymin, Ymax)
        Ymin = Ymin or fry.Ymin
        Ymax = Ymax or fry.Ymax
        local pws  = PwSpec.from(fry.Yspec)
        local pict = pws:topict():setbounds(v(0, Ymin), v(#fry.Ys-1, Ymax))
        return pict
      end,
    getYgrid = function (fry, Ymin, Ymax)
        Ymin = Ymin or fry.Ymin
        Ymax = Ymax or fry.Ymax
        local pws  = PwSpec.from("")
        local pict = pws:topict():setbounds(v(0, Ymin), v(#fry.Ys-1, Ymax))
        return pict
      end,
  },
}

-- «FromYs-tests»  (to ".FromYs-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict2e1-1.lua"
require "Piecewise1"
fryy = FromYs.fromys {0,1,2,3}
fryy:getYs(10)
= fryy
= fryy:getypict()
= fryy:getYpict()
= fryy:getYpict():pgat("pgatc")
= fryy:getYpict():pgat("pgatc"):sa("fig Foo")

--]]








-- Local Variables:
-- coding:  utf-8-unix
-- End:
