-- This file:
--   http://anggtwu.net/LUA/Caepro4.lua.html
--   http://anggtwu.net/LUA/Caepro4.lua
--          (find-angg "LUA/Caepro4.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/Caepro4.lua"))
--
-- (defun c1 () (interactive) (find-angg "LUA/Caepro1.lua"))
-- (defun c2 () (interactive) (find-angg "LUA/Caepro2.lua"))
-- (defun c3 () (interactive) (find-angg "LUA/Caepro3.lua"))
-- (defun c4 () (interactive) (find-angg "LUA/Caepro4.lua"))
--
-- (defun g2 () (interactive) (find-angg "LUA/Gram2.lua"))
-- (defun g3 () (interactive) (find-angg "LUA/Gram3.lua"))
--
-- (find-Deps1-links "Caepro4")
-- (find-Deps1-cps   "Caepro4")
-- (find-Deps1-anggs "Caepro4")

-- «.MkTable»		(to "MkTable")
-- «.MkTable-tests»	(to "MkTable-tests")
-- «.AnyOf»		(to "AnyOf")
-- «.AnyOf-tests»	(to "AnyOf-tests")
-- «.anyofs»		(to "anyofs")
-- «.anyofs-tests»	(to "anyofs-tests")
-- «.gram»		(to "gram")
-- «.gram-tests»	(to "gram-tests")
-- «.Abbrev»		(to "Abbrev")
-- «.Abbrev-tests»	(to "Abbrev-tests")
-- «.LaTeX»		(to "LaTeX")
-- «.LaTeX-tests»	(to "LaTeX-tests")
-- «.run_options»	(to "run_options")
-- «.run_options-tests»	(to "run_options-tests")

-- require "Gram2"   -- (find-angg "LUA/Gram2.lua")
require "ELpeg1"     -- (find-angg "LUA/ELpeg1.lua")

lpeg.ptmatch = function (pat, str) PP(pat:Ct():match(str)) end
lpeg.Copyto  = function (pat, tag) return pat:Cg(tag) * Cb(tag) end



--  __  __ _    _____     _     _      
-- |  \/  | | _|_   _|_ _| |__ | | ___ 
-- | |\/| | |/ / | |/ _` | '_ \| |/ _ \
-- | |  | |   <  | | (_| | |_) | |  __/
-- |_|  |_|_|\_\ |_|\__,_|_.__/|_|\___|
--                                     
-- «MkTable»  (to ".MkTable")
-- Superseded by: (find-angg "LUA/AnyOf1.lua" "MkTable")

MkTable = Class {
  type = "MkTable",
  from = function (bigstr, tag)
      local mkt = MkTable {bigstr=bigstr, tag=tag, _=VTable{}}
      for k,v in mkt:kvs() do mkt._[k] = v end
      return mkt
    end,
  __tostring = function (mkt) return mkt.bigstr end,
  __index = {
    pat = "(%S+) +%-> +(%S+)",
    kvs = function (mkt)   return mkt.bigstr:gmatch(mkt.pat) end,
    v   = function (mkt,k) return mkt._[k] end,
  },
}

mktable = function (bigstr) return MkTable.from(bigstr)._ end

-- «MkTable-tests»  (to ".MkTable-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro4.lua"
bigstr = [[
  foobar  -> OOBAR    (Comment)
  foo     -> OO
  foob    -> OOB
]]
mkt = MkTable.from(bigstr)
= mkt
= mkt:v("foo")
= mkt._
  for k,v in mkt:kvs() do print(k,v) end

--]==]


--     _                 ___   __ 
--    / \   _ __  _   _ / _ \ / _|
--   / _ \ | '_ \| | | | | | | |_ 
--  / ___ \| | | | |_| | |_| |  _|
-- /_/   \_\_| |_|\__, |\___/|_|  
--                |___/           
--
-- «AnyOf»  (to ".AnyOf")
-- See: (find-angg "LUA/Gram2.lua" "anyof")

AnyOf = Class {
  type = "AnyOf",
  from = function (bigstr, tag, tag2, default)
      local mt = MkTable.from(bigstr)
      return AnyOf {mt=mt, tag=tag, tag2=tag2, default=default}
    end,
  __tostring = function (mtp) return mtp.mt.bigstr end,
  __index = {
    kvs = function (mtp)    return mtp.mt:kvs() end,
    v   = function (mtp, k) return mtp.mt:v(k)  end,
    pat = function (mtp)
        local p = P(false)
        for k,v in mtp:kvs() do p = p + Cs(k) end
        if mtp.default then p = p + Cc(mtp.default) end
     -- if mtp.tag     then p = p:Cg(mtp.tag) * Cb(mtp.tag) end
        if mtp.tag     then p = p:Copyto(mtp.tag) end
        if mtp.tag2    then p = p * (Cb(mtp.tag) / mtp.mt._):Cg(mtp.tag2) end
        return p
      end,
  },
}

-- «AnyOf-tests»  (to ".AnyOf-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro4.lua"
bigstr = [[
  a -> AA
  b -> BB
  c -> CC
]]
  mtp = AnyOf.from(bigstr, "x", "xx", "b")
= mtp
  PPPV(mtp)
s = Cs"_"
p = mtp:pat()
(s * p * s):ptmatch("_a_")
(s * p * s):ptmatch("__")
(s * p * s):ptmatch("_d_")

--]==]



--                           __     
--   __ _ _ __  _   _  ___  / _|___ 
--  / _` | '_ \| | | |/ _ \| |_/ __|
-- | (_| | | | | |_| | (_) |  _\__ \
--  \__,_|_| |_|\__, |\___/|_| |___/
--              |___/               
--
-- «anyofs»  (to ".anyofs")

sems = AnyOf.from([[
    x -> 2019.1   y -> 2019.2
    a -> 2020.1   b -> 2020.2
    c -> 2021.1   d -> 2021.2
    e -> 2022.1   f -> 2022.2
    g -> 2023.1
  ]], "sem", "yyyy.s")

Ms = AnyOf.from([[
    2 -> C2   3 -> C3   4 -> C4
    5 -> ES   6 -> GA   7 -> LA
  ]], "M", "MM")

quadros = mktable [[
    2x -> 2019.1-C2/2019.1-C2.pdf   3x -> 2019.1-C3/2019.1-C3.pdf
    2y -> 2019.2-C2/2019.2-C2.pdf   3y -> 2019.2-C3/2019.2-C3.pdf
    2e -> 2022.1-C2/C2-quadros.pdf  3e -> 2022.1-C3/C3-quadros.pdf
    2f -> 2022.2-C2/C2-quadros.pdf  3f -> 2022.2-C3/C3-quadros.pdf
    2g -> 2023.1-C2/C2-quadros.pdf
    4g -> 2023.1-C4/C4-quadros.pdf
    5g -> 2023.1-ES/ES-quadros.pdf
    6g -> 2023.1-GA/GA-quadros.pdf
    7g -> 2023.1-LA/LA-quadros.pdf
  ]]

otherHtmls = AnyOf.from([[
                (find-TH "2023-caepro")

    Issomuda  -> 2023-caepro0
    SobreaVR  -> 2023-caepro-VR
    Oquesobra -> 2023-caepro-o-que-sobra
    Visaud    -> 2023-visual-vs-auditivo
    Slogans   -> 2023-precisamos-de-mais-slogans

    Sapt      -> 2021aulas-por-telegram
    Somas     -> 2021-1-C2-somas-1-dicas
    Cabos     -> 2021-2-c3-cabos-na-diagonal
    AprC2     -> 2022-apresentacao-sobre-C2
    CalcEasy  -> mathologer-calculus-easy

    Omnisys   -> omnisys

  ]], "short", "htmlstem")

anggPdfs = AnyOf.from([[
    Mpg     -> LATEX/material-para-GA
    ZHAs    -> LATEX/2017planar-has-1
    La2018  -> LATEX/2018-1-LA-material
    La2018Q -> 2018.1-LA/2018.1-LA
    Rosiak  -> tmp/rosiak__sheaf_theory_through_examples
    Missing -> LATEX/2022on-the-missing

    Bort3   -> 2019.2-C3/Bortolossi/bortolossi-cap-3
    Bort4   -> 2019.2-C3/Bortolossi/bortolossi-cap-4
    Bort5   -> 2019.2-C3/Bortolossi/bortolossi-cap-5
    Bort6   -> 2019.2-C3/Bortolossi/bortolossi-cap-6
    Bort7   -> 2019.2-C3/Bortolossi/bortolossi-cap-7
    Bort8   -> 2019.2-C3/Bortolossi/bortolossi-cap-8
    Bort10  -> 2019.2-C3/Bortolossi/bortolossi-cap-10
    Bort11  -> 2019.2-C3/Bortolossi/bortolossi-cap-11
    Bort12  -> 2019.2-C3/Bortolossi/bortolossi-cap-12
    Es1     -> BE/2012.1-BE
    Es2     -> 2012.2-ES/2012.2-ES
    Es3     -> 2013.1-ES/2013.1-ES
    Es4     -> 2013.2-ES/2013.2-ES
    Leit1   -> tmp/leithold-pt-cap1
    Leit2   -> tmp/leithold-pt-cap2
    Leit3   -> tmp/leithold-pt-cap3
    Leit4   -> tmp/leithold-pt-cap4
    Leit5   -> tmp/leithold-pt-cap5
    Leit6   -> tmp/leithold-pt-cap6
    Leit7   -> tmp/leithold-pt-cap7
    Leit8   -> tmp/leithold-pt-cap8
    Leit9   -> tmp/leithold-pt-cap9
    LeitA   -> tmp/leithold-pt-apA
    LeitF   -> tmp/leithold-pt-apF
    Stew17  -> tmp/stewart7-cap17
    Stew16  -> tmp/stewart7-cap16
    Stew15  -> tmp/stewart7-cap15
    Stew14  -> tmp/stewart7-cap14
    Stew13  -> tmp/stewart7-cap13
    Stew12  -> tmp/stewart7-cap12
    Stew11  -> tmp/stewart7-cap11
    Stew10  -> tmp/stewart7-cap10
    Stew9   -> tmp/stewart7-cap9
    Stew8   -> tmp/stewart7-cap8
    Stew7   -> tmp/stewart7-cap7
    Stew6   -> tmp/stewart7-cap6
    Stew5   -> tmp/stewart7-cap5
    Stew4   -> tmp/stewart7-cap4
    Stew3   -> tmp/stewart7-cap3
    Stew2   -> tmp/stewart7-cap2
    Stew1   -> tmp/stewart7-cap1
    Stew0   -> tmp/stewart7-cap0
    Thomas55 -> 2020.2-C2/thomas_secoes_5.5_e_5.6
    Thomas56 -> 2020.2-C2/thomas_secoes_5.5_e_5.6
    Apexcap4  -> 2022.2-C3/APEX_Calculus_Version_4_cap_4
    Apexcap7  -> 2022.2-C3/APEX_Calculus_Version_4_cap_7
    Apexcap12 -> 2022.2-C3/APEX_Calculus_Version_4_cap_12
    RossA     -> 2022.1-C2/ross__elementary_analysis_secs_10_32_33_34

    DFcap7 -> 2023.1-GA/Apostila_GACV_caps_07-09
    DFES1  -> 2023.1-GA/delgado_frensel_nedir__GA_I
    DFES2  -> 2023.1-GA/delgado_frensel_nedir__GA_II
    VenturiGA -> 2023.1-GA/venturi__algebra_vetorial_e_geometria_analitica
    MB6    -> tmp/morettin_bussab__estatistica_basica_6a_ed
    Rrj    -> LATEX/2021rrj

    MMM       -> tmp/carnielli_pizzi__modalities_and_multimodalities
    Chellas   -> tmp/chellas__modal_logic_an_introduction
    Hesseling -> tmp/hesseling__gnomes_in_the_fog_the_reception_of_brouwer_s_intuitionism_in_the_1920s
    ZillCullenInicio -> tmp/zill_cullen__equacoes_diferenciais__inicio
    NG -> tmp/nederpelt_geuvers__type_theory_and_formal_proof_an_introduction

    CaepDiff     -> LATEX/2023-caepro-hist
    CaepIssoMuda -> LATEX/2023-caepro
    CaepPlano    -> LATEX/2023-caepro-plano
    CaepVR       -> LATEX/2023-caepro-VR
    CaepColor    -> LATEX/2023-caepro-reclamacoes

  ]], "short", "pdfstem")

externalPdfs = AnyOf.from([[
    Miranda  -> http://hostel.ufabc.edu.br/~daniel.miranda/calculo/calculo.pdf
    Selinger -> https://www.mathstat.dal.ca/~selinger/papers/lambdanotes.pdf
    DiffyQs  -> https://www.jirka.org/diffyqs/diffyqs.pdf

  ]], "short", "pdfurl")

-- «anyofs-tests»  (to ".anyofs-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro4.lua"
sems        :pat():ptmatch("x")
Ms          :pat():ptmatch("5")
otherHtmls  :pat():ptmatch("Slogans01:23")
anggPdfs    :pat():ptmatch("Leit2")
externalPdfs:pat():ptmatch("Miranda")

--]]



--                            
--   __ _ _ __ __ _ _ __ ___  
--  / _` | '__/ _` | '_ ` _ \ 
-- | (_| | | | (_| | | | | | |
--  \__, |_|  \__,_|_| |_| |_|
--  |___/                     
--
-- «gram»  (to ".gram")

gr,V,VA,VE,PE  = Gram.new()

dottodash = function (s) return (s:gsub("%.", "-")) end
getquadro = function (M, sem) return quadros[M..sem] end
getquadro_pat = (Cb"M" * Cb"sem" / getquadro):Copyto"quadro"

V.N            = Cs(R"09"^1)
V.optN         = Cs(R"09"^1) + Cc("1")
V.optpN        = S"pP"^-1 * V.optN

V.M            = Ms:pat()
V.sem          = sems:pat() * (Cb"yyyy.s" / dottodash):Cg"yyyy-s"
V.optsem       = sems:pat() * (Cb"yyyy.s" / dottodash):Cg"yyyy-s"
V.turma        = Cs(S"cem"):Copyto"turma"
V.numpdf       = V.optN :Copyto"numpdf"
V.optpage      = V.optN :Copyto"page"
V.optppage     = V.optpN:Copyto"page"
V.anchor       = (P"#"^-1 * Cs(P(1)^1)) / function (str) return "#"..str end
V.optanchor    = (V.anchor + Cc""):Copyto"hanchor"


VA.Tudo        = V.M * V.optsem  * Cs("T") * V.optpage
VA.semPage     = V.M * V.optsem  * Cs("P") * V.optanchor
VA.quadros     = V.M * V.optsem  * Cs("Q") * V.optpage * getquadro_pat
VA.quadrosJpgs = V.M * V.optsem  * Cs("J") * V.optpage
VA.logPdfizado = V.M * V.optsem  * Cs("L") * V.numpdf * V.turma * V.optpage
VA.otherHtml   = otherHtmls:pat()   * V.optanchor
VA.anggPdf     = anggPdfs:pat()     * V.optppage
VA.externalPdf = externalPdfs:pat() * V.optppage

V.any          = V.Tudo        + V.semPage
               + V.quadros     + V.quadrosJpgs
               + V.logPdfizado + V.otherHtml
               + V.anggPdf     + V.externalPdf 

-- «gram-tests»  (to ".gram-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro4.lua"

= gr:cm ("Tudo", "2cT1")
  gr:cmp("Tudo", "2cT1")
  gr:cmp("Tudo", "2cT")
  gr:cmp("any",  "2eT4")
  gr:cmp("any",  "2xQ4")

= getquadro("2", "x")
(Cc"2":Cg"M" * Cc"x":Cg"Sem"):ptmatch("")
(Cc"2":Cg"M" * Cc"x":Cg"sem" * getquadro_pat):ptmatch("")
(Cc"2":Cg"M" * Cc"x":Cg"sem" * Cb"sem"):ptmatch("")

lpeg.pamatch = function (pat, str) PP(pat:Ct():match(str)) end

--]]


--     _    _     _                        
--    / \  | |__ | |__  _ __ _____   __
--   / _ \ | '_ \| '_ \| '__/ _ \ \ / /
--  / ___ \| |_) | |_) | | |  __/\ V /
-- /_/   \_\_.__/|_.__/|_|  \___| \_/
--                                         
-- «Abbrev»  (to ".Abbrev")

Abbrev = Class {
  type = "Abbrev",
  from = function (str)
      return Abbrev {str=str}
    end,
  sexp     = function (str) return Abbrev.from(str):psexp()    end,
  anggurl  = function (str) return Abbrev.from(str):panggurl() end,
  __index = {
    pat    = function (ab) return Abbrev.patc end,
    -- pat = function (ab) return gr:compile("any") end,
    print  = function (ab) print(ab.ast); print(); PPV(ab.ast); return ab end,
    subst  = function (ab, str)
        local f = function (s) return ab.ast[s] end
        return (str:gsub("<(.-)>", f))
      end,
    expand = function (ab)
        ab.ast    = ab:pat():match(ab.str)
        local ast = ab.ast
        ast.what  = ab.whats[ast[0]]
        ast.long  = ab:subst(ab.fmts[ast[0]])
        ast.hpage = ast.page and (ast.page == "" and "" or "#page="..ast.page)
        ast.sexp  = ab:subst(ab.sexps[ast.what])
        ast.anggurl = ab:subst(ab.anggurls[ast.what])
        return ab
      end,
    --
    -- Protected calls:
    pexpand  = function (ab) pcall(function () ab:expand() end); return ab end,
    past     = function (ab) return ab:pexpand().ast or {} end,
    psexp    = function (ab) return (ab:past() or {}).sexp    end,
    panggurl = function (ab) return (ab:past() or {}).anggurl end,
    --
    whats = mktable [[
        Tudo        -> pdf
        semPage     -> html
        logPdfizado -> pdf
        otherHtml   -> html
        anggPdf     -> pdf
        externalPdf -> externalpdf
        quadros     -> pdf
      ]],
    fmts = mktable [[
        Tudo        -> LATEX/<yyyy-s>-<MM>-tudo.pdf
        semPage     -> <yyyy.s>-<MM>.html
        logPdfizado -> logs-pdfizados/<M><sem>L<numpdf><turma>.pdf
        otherHtml   -> <htmlstem>.html<hanchor>
        anggPdf     -> <pdfstem>.pdf
        externalPdf -> <pdfurl>
        quadros     -> <quadro>
      ]],
    sexps = {
        html        = '(brg "file:///home/edrx/TH/L/<long>")',
        pdf         = '(find-pdf-page "~/<long>" <page>)',
        externalpdf = '(find-pdf-page (ee-url-to-fname "<long>") <page>)',
      },
    anggurls = {
        html        = 'http://anggtwu.net/<long>',
        pdf         = 'http://anggtwu.net/<long><hpage>',
        externalpdf = '<long><hpage>',
      },
  },
}

Abbrev.patc = gr:compile("any")

-- «Abbrev-tests»  (to ".Abbrev-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro4.lua"
test = function (str) print(Abbrev.sexp(str)); print(Abbrev.anggurl(str)) end
test = function (str) ab = Abbrev.from(str):pexpand():print() end
test "2eT"
test "2eT4"
test "Foo"
test "2eP"
test "2eP#foo"
test "2eQ4"
test "2aL1m4"
test "Slogans"
test "Slogans#01:23"
test "Bort7"
test "Bort7p22"
test "Miranda"
test "MirandaP22"
= Abbrev.sexp "MirandaP22"
= Abbrev.anggurl "MirandaP22"
run_options("-sexp", "MirandaP22")

-- falta quadrosjpgs

--]]




--  _         _____   __  __
-- | |    __ |_   _|__\ \/ /
-- | |   / _` || |/ _ \\  / 
-- | |__| (_| || |  __//  \ 
-- |_____\__,_||_|\___/_/\_\
--                          
-- «LaTeX»  (to ".LaTeX")
-- (find-LATEX "2023-1-C2-carro.tex" "defs-caepro")
--
Caurl = function (str)
    return (Abbrev.anggurl(str):gsub("#", "\\#"))
  end

-- «LaTeX-tests»  (to ".LaTeX-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro4.lua"
= Caurl "2eT3"

--]]




-- «run_options»  (to ".run_options")
-- (find-angg ".emacs" "caepro3")
--
run_options = function (a, b)
    if     a == nil        then return
    elseif a == "Caepro4"  then return
    elseif a == "-sexp"    then print(Abbrev.sexp(b))
    elseif a == "-anggurl" then print(Abbrev.anggurl(b))
    else PP("Bad options:", a, b)
    end
  end

run_options(...)

-- «run_options-tests»  (to ".run_options-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro4.lua"
run_options("-sexp", "2eT66")
run_options("-sexp", "Foo")
run_options("-sexp", "_2eT66")
run_options("-sexp", "Leit4")
run_options("-sexp", "Leit4p10")
run_options("-sexp", "7gQ")
run_options("-anggurl", "7gQ")

--]]














-- Local Variables:
-- coding:  utf-8-unix
-- End:
