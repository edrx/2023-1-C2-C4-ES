-- This file:
--   http://anggtwu.net/LUA/Caepro5.lua.html
--   http://anggtwu.net/LUA/Caepro5.lua
--          (find-angg "LUA/Caepro5.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/Caepro5.lua"))
--
-- (find-Deps1-links "Caepro5")
-- (find-Deps1-cps   "Caepro5")
-- (find-Deps1-anggs "Caepro5")

-- «.anyofs»			(to "anyofs")
-- «.anyofs-tests»		(to "anyofs-tests")
-- «.TocLinesToAnyOf»		(to "TocLinesToAnyOf")
-- «.TocLinesToAnyOf-tests»	(to "TocLinesToAnyOf-tests")
-- «.gram»			(to "gram")
-- «.gram-tests»		(to "gram-tests")
-- «.Enrichen»			(to "Enrichen")
--   «.Enrichen-pdfs»		(to "Enrichen-pdfs")
--   «.Enrichen-htmls»		(to "Enrichen-htmls")
--   «.Enrichen-jpgs»		(to "Enrichen-jpgs")
--   «.Enrichen-tex»		(to "Enrichen-tex")
--   «.Enrichen-sexps»		(to "Enrichen-sexps")
--   «.Enrichen-urls»		(to "Enrichen-urls")
-- «.Enrichen-tests»		(to "Enrichen-tests")
-- «.lsquadros_cache»		(to "lsquadros_cache")
-- «.lsquadros_cache-tests»	(to "lsquadros_cache-tests")
-- «.LaTeX»			(to "LaTeX")
-- «.LaTeX-tests»		(to "LaTeX-tests")
-- «.preprocess»		(to "preprocess")
-- «.run_options»		(to "run_options")
-- «.run_options-tests»		(to "run_options-tests")

require "ELpeg1"             -- (find-angg "LUA/ELpeg1.lua")
require "LsQuadros1"         -- (find-angg "LUA/LsQuadros1.lua")
require "LsQuadros1-cache"   -- (find-angg "LUA/LsQuadros1-cache.lua")
require "TocLines1"          -- (find-angg "LUA/TocLines1.lua")
require "AnyOf1"             -- (find-angg "LUA/AnyOf1.lua")

-- For debugging:
Gram.__index.cm2 = function (gr, ...)
    print(gr:cm(...))  -- See: (find-angg "LUA/Gram2.lua" "Gram" "cm  =")
    gr:cmp(...)        -- See: (find-angg "LUA/Gram2.lua" "Gram" "cmp =")
  end



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

    StewPtCap15     -> tmp/stewart72pt-cap15
    StewPtCap16     -> tmp/stewart72pt-cap16
    StewPtCap17     -> tmp/stewart72pt-cap17
    StewPtApendiceH -> tmp/stewart72pt-apH

    Thomas55 -> 2020.2-C2/thomas_secoes_5.5_e_5.6
    Thomas56 -> 2020.2-C2/thomas_secoes_5.5_e_5.6
    Apexcap4  -> 2022.2-C3/APEX_Calculus_Version_4_cap_4
    Apexcap7  -> 2022.2-C3/APEX_Calculus_Version_4_cap_7
    Apexcap12 -> 2022.2-C3/APEX_Calculus_Version_4_cap_12
    RossA     -> 2022.1-C2/ross__elementary_analysis_secs_10_32_33_34

    DFcap7    -> 2023.1-GA/Apostila_GACV_caps_07-09
    DFES1     -> 2023.1-GA/delgado_frensel_nedir__GA_I
    DFES2     -> 2023.1-GA/delgado_frensel_nedir__GA_II
    VenturiGA -> 2023.1-GA/venturi__algebra_vetorial_e_geometria_analitica
    AckerGA1  -> acker/acker__ga_livro1_2019
    AckerGA2  -> acker/acker__ga_livro2_2020
    AckerGA3  -> acker/acker__ga_livro3_2021
    AckerGA4  -> acker/acker__ga_livro4_2019

    MB6    -> tmp/morettin_bussab__estatistica_basica_6a_ed
    Rrj    -> LATEX/2021rrj

    MMM       -> tmp/carnielli_pizzi__modalities_and_multimodalities
    Chellas   -> tmp/chellas__modal_logic_an_introduction
    Hesseling -> tmp/hesseling__gnomes_in_the_fog_the_reception_of_brouwer_s_intuitionism_in_the_1920s
    ZillCullenInicio -> tmp/zill_cullen__equacoes_diferenciais__inicio
    NG           -> tmp/nederpelt_geuvers__type_theory_and_formal_proof_an_introduction
    BoyceDip3    -> tmp/boyce-diprima_pt__cap3
    BoyceDipEng3 -> tmp/boyce-diprima__cap3
    FPLean4      -> 2023.1-LA/fplean4-inicio

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
    ProofsAndTypes -> http://www.paultaylor.eu/stable/prot.pdf
    TPinLean  -> https://leanprover.github.io/theorem_proving_in_lean/theorem_proving_in_lean.pdf
    Pelletier -> https://www.sfu.ca/~jeffpell/papers/pelletierNDtexts.pdf

    MBE01 -> https://home.csulb.edu/~woollett/mbe1intro.pdf
    MBE02 -> https://home.csulb.edu/~woollett/mbe2plotfit.pdf
    MBE03 -> https://home.csulb.edu/~woollett/mbe3ode1.pdf
    MBE04 -> https://home.csulb.edu/~woollett/mbe4solve.pdf
    MBE05 -> https://home.csulb.edu/~woollett/mbe5matrix.pdf
    MBE06 -> https://home.csulb.edu/~woollett/mbe6calc1.pdf
    MBE07 -> https://home.csulb.edu/~woollett/mbe7sint.pdf
    MBE08 -> https://home.csulb.edu/~woollett/mbe8nint.pdf
    MBE09 -> https://home.csulb.edu/~woollett/mbe9bfloat.pdf
    MBE10 -> https://home.csulb.edu/~woollett/mbe10fltrans.pdf
    MBE11 -> https://home.csulb.edu/~woollett/mbe11fft.pdf
    MBE12 -> https://home.csulb.edu/~woollett/mbe12dirac3.pdf
    MBE13 -> https://home.csulb.edu/~woollett/mbe13qdraw.pdf
    MBE14 -> https://home.csulb.edu/~woollett/mbe14fit.pdf

  ]], "short", "pdfurl")

-- «anyofs-tests»  (to ".anyofs-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro5.lua"
sems        :pat():ptmatch("x")
Ms          :pat():ptmatch("5")
otherHtmls  :pat():ptmatch("Slogans01:23")
otherHtmls  :pat():ptmatch("Slogans#01:23")
anggPdfs    :pat():ptmatch("Leit2")
anggPdfs    :pat():ptmatch("Bort7")
externalPdfs:pat():ptmatch("Miranda")
externalPdfs:pat():ptmatch("ProofsAndTypes")

--]]



--  _____          _     _                _____       _                 ___   __ 
-- |_   _|__   ___| |   (_)_ __   ___  __|_   _|__   / \   _ __  _   _ / _ \ / _|
--   | |/ _ \ / __| |   | | '_ \ / _ \/ __|| |/ _ \ / _ \ | '_ \| | | | | | | |_ 
--   | | (_) | (__| |___| | | | |  __/\__ \| | (_) / ___ \| | | | |_| | |_| |  _|
--   |_|\___/ \___|_____|_|_| |_|\___||___/|_|\___/_/   \_\_| |_|\__, |\___/|_|  
--                                                               |___/           
-- «TocLinesToAnyOf»  (to ".TocLinesToAnyOf")

TocLinesToAnyOf = Class {
  type = "TocLinesToAnyOf",
  fromstem = function (stem)
      local fname = "~/LATEX/"..stem..".mytoc"
      local tl = TocLines.readmytoc(fname)
      local bigstr = tl:revnamesandpages()
      return TocLinesToAnyOf {stem=stem, fname=fname, tl=tl, bigstr=bigstr}
    end,
  fromstemandtags = function (stem, ...)
      return TocLinesToAnyOf.fromstem(stem):addanyof(...)
    end,
  from = function (stem)
      return TocLinesToAnyOf.fromstemandtags(stem, "partname", "initpage")
    end,
  __tostring = function (tltao) return tltao.bigstr end,
  __index = {
    addanyof = function (tltao, ...)
        tltao.anyo = AnyOf.from(tltao.bigstr, ...)
        return tltao
      end,
    pat1 = function (tltao)
        return tltao.anyo:pat() * Cc(tltao.stem):Cg"stem"
      end,
    pat2 = function (tltao)
        return tltao:pat1() * (P"_" * (R"09"^1):Copyto"subpage")^-1
      end,
  },
}

-- «TocLinesToAnyOf-tests»  (to ".TocLinesToAnyOf-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro5.lua"
-- (find-LATEX "2022-2-C2-tudo.mytoc")
stem  =        "2022-2-C2-tudo"
tltao = TocLinesToAnyOf.from(stem)
= tltao
= tltao.stem
= tltao.fname
= tltao.bigstr
= tltao.anyo
p = tltao:pat1()
p = tltao:pat2()
p:ptmatch "2022-2-C2-P1"
p:ptmatch "2022-2-C2-P1_4"

p = TocLinesToAnyOf.from("2022-2-C2-C3-ajuda"):pat2()
p:ptmatch "2022-500-linhas-etel_4"

--]]



--                            
--   __ _ _ __ __ _ _ __ ___  
--  / _` | '__/ _` | '_ ` _ \ 
-- | (_| | | | (_| | | | | | |
--  \__, |_|  \__,_|_| |_| |_|
--  |___/                     
--
-- «gram»  (to ".gram")
-- (find-angg "LUA/Gram2.lua" "Gram-tests")

gr,V,VA,VE,PE  = Gram.new()

dottodash = function (s) return (s:gsub("%.", "-")) end
-- getquadro = function (M, sem) return quadros[M..sem] end
-- getquadro_pat = (Cb"M" * Cb"sem" / getquadro):Copyto"quadro"

V.N            = Cs(R"09"^1)
V.optN         = Cs(R"09"^1) + Cc("1")
V.optpN        = S"pP"^-1 * V.optN

V.M            = Ms:pat()
V.sem          = sems:pat() * (Cb"yyyy.s" / dottodash):Cg"yyyy-s"
V.turma        = Cs(S"cem"):Copyto"turma"   -- para logs pdfizados
V.numpdf       = V.optN :Copyto"numpdf"     -- para logs pdfizados
V.numjpg       = V.optN :Copyto"numjpg"
V.optpage      = V.optN :Copyto"page"
V.optppage     = V.optpN:Copyto"page"
V.optsubpage   = (P"_" * V.N:Copyto"subpage")^-1
V.anchor       = (P"#"^-1 * Cs(P(1)^1)) / function (str) return "#"..str end
V.optanchor    = (V.anchor + Cc""):Copyto"hanchor"

VA.T = V.M * V.sem * Cs("T") * V.optpage      -- pdfzão com tudo
VA.P = V.M * V.sem * Cs("P") * V.optanchor    -- página do curso (html)
VA.Q = V.M * V.sem * Cs("Q") * V.optpage      -- quadros (em PDF)
VA.J = V.M * V.sem * Cs("J") * V.numjpg       -- um quadro em JPG 
VA.L = V.M * V.sem * Cs("L") * V.numpdf * V.turma * V.optpage   -- um log pdfizado

VA.otherHtml   = otherHtmls:pat()   * V.optanchor
VA.anggPdf     = anggPdfs:pat()     * V.optppage
VA.externalPdf = externalPdfs:pat() * V.optppage

VA.AP          = anggPdfs:pat()     * V.optppage          -- anggpdf (like tmp/stewartcap1)
VA.EP          = externalPdfs:pat() * V.optppage          -- external PDF (like miranda)
VA.OH          = otherHtmls:pat()   * V.optanchor         -- otherhtml (like slogans)
VA.TL          = TocLinesToAnyOf.from("2022-2-C2-C3-ajuda"):pat2()  -- a tocline'd PDF

V.any          = V.T + V.P + V.Q + V.J + V.L
               + V.AP + V.EP + V.OH + V.TL    -- + V.externalPdf 

caepropat      = gr:compile("any")

-- «gram-tests»  (to ".gram-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro5.lua"
  gr:cm2("T", "2cT")
  gr:cm2("T", "2cT42")
  gr:cm2("P", "2cP")
  gr:cm2("P", "2cP#foo")
  gr:cm2("Q", "2cQ")
  gr:cm2("Q", "2cQ20")
  gr:cm2("J", "2cJ")
  gr:cm2("J", "2cJ20")
  gr:cm2("TL", "2022-500-linhas-etel")
  gr:cm2("TL", "2022-500-linhas-etel_4")
  gr:cm2("any",  "2eT4")
  gr:cm2("any",  "2xQ4")
  gr:cm2("any",  "Bort7")
  gr:cm2("any",  "Slogans")
  gr:cm2("any",  "Slogans#01:23")

= caepropat:match("2xQ4")
= caepropat:match("Slogans#01:23")

--]]


--  _____            _      _                
-- | ____|_ __  _ __(_) ___| |__   ___ _ __  
-- |  _| | '_ \| '__| |/ __| '_ \ / _ \ '_ \ 
-- | |___| | | | |  | | (__| | | |  __/ | | |
-- |_____|_| |_|_|  |_|\___|_| |_|\___|_| |_|
--                                           
-- «Enrichen»  (to ".Enrichen")

Enrichen = Class {
  type = "Enrichen",
  from0     = function (o)   return Enrichen {o=o} end,
  fromstr0  = function (str) return Enrichen.from0(caepropat:match(str)) end,
  fromstr   = function (str) return Enrichen.fromstr0(str):adds0() end,
  --
  getsexp   = function (str) return Enrichen.getfield ("sexp", str) end,
  pgetsexp  = function (str) return Enrichen.pgetfield("sexp", str) end,
  geturl    = function (str) return Enrichen.getfield ("urlp", str) end,
  pgeturl   = function (str) return Enrichen.pgetfield("urlp", str) end,
  getfield  = function (field, str) return Enrichen.fromstr(str).o[field] end,
  pgetfield = function (field, str)
      local result
      pcall(function () result = Enrichen.getfield(field, str) end)
      return result
    end,
  --
  test = function (str)
      e = Enrichen.fromstr(str)
      print(e.o)
      print()
      print(e)
      print(e.o.sexp)
      print(e.o.asexp)
    end,
  --
  __tostring = function (e) return mytostringv(e.o) end,
  __index = {
    bads = function (e, s) PP("Bad s:", s); error() end,
    subst = function (e, fmt)
        local f = function (s) return e.o[s] or e:bads(s) end
        return (fmt:gsub("<(.-)>", f))
      end,
    --
    -- «Enrichen-pdfs»  (to ".Enrichen-pdfs")
 -- T_pdf    = function (e) return e:subst"LATEX/<yyyy-s>-<MM>-tudo.pdf" end,
    T_pdf    = function (e) return e:subst"LATEX/<yyyy-s>-<MM>-Tudo.pdf" end,
    Q_pdf    = function (e) return quadros[e.o.M .. e.o.sem] end,
    L_pdf    = function (e) return e:subst"logs-pdfizados/<M><sem>L<numpdf><turma>.pdf" end,
    TL_pdf   = function (e) return e:subst"LATEX/<stem>.pdf" end,
    AP_pdf   = function (e) return e:subst"<pdfstem>.pdf" end,
    EP_pdf   = function (e) return (e.o.pdfurl:gsub("(https?)://", "snarf/%1/")) end,
    pdf      = function (e) return e.o.T_pdf  or e.o.L_pdf  or e.o.Q_pdf or
                                   e.o.TL_pdf or e.o.AP_pdf or e.o.EP_pdf end,
    tlp0     = function (e) return e.o.initpage+(e.o.subpage or 1)-1 end,
    tlp      = function (e) return e.o.initpage and e:tlp0() end,
    p        = function (e) return e:tlp() or e.o.page end,
    hp       = function (e) return e:subst"#page=<p>" end,
    pdfp     = function (e) return e:subst"<pdf><hp>" end,
    pdfsexp  = function (e) return e:subst'(find-pdf-page "~/<pdf>" <p>)' end,
    pdftsexp = function (e) return e:subst'(find-pdf-text8 "~/<pdf>" <p>)' end,
    --
    -- «Enrichen-htmls»  (to ".Enrichen-htmls")
    P_html   = function (e) return e:subst"<yyyy.s>-<MM>.html" end,
    OH_html  = function (e) return e:subst"<htmlstem>.html" end,
    html     = function (e) return e.o.P_html or e.o.OH_html end,
    htmla    = function (e) return e:subst"<html><hanchor>" end,
    htmlsexp = function (e) return e:subst'(brg "file:///home/edrx/TH/L/<htmla>")' end,
    --
    -- «Enrichen-jpgs»  (to ".Enrichen-jpgs")
    dir      = function (e) return e.o["yyyy.s"].."-"..e.o.MM end,
    dirstems = function (e) return lsquadros_cache[e:dir()] end,
    numjpg   = function (e) return e.o.numjpg + 0 end,
    jpgstem  = function (e) return e:dirstems().stems[e:numjpg()] end,
    J_jpg    = function (e) return e:dir().."/"..e:jpgstem()..".jpg" end,
    jpg      = function (e) return e.o.J_jpg end,
    jpgsexp  = function (e) return e:subst'(xz "~/<jpg>")' end,
    --
    -- «Enrichen-tex»  (to ".Enrichen-tex")
    TL_tex   = function (e) return e:subst"LATEX/<stem>.tex" end,
    asexp    = function (e) return e:subst'(find-anchor "~/<TL_tex>" "<partname>")' end,
    --
    -- «Enrichen-sexps»  (to ".Enrichen-sexps")
    sexp     = function (e) return e.o.pdfsexp or e.o.jpgsexp or e.o.htmlsexp end,
    tsexp    = function (e) return e.o.pdftsexp end,
    --
    -- «Enrichen-urls»  (to ".Enrichen-urls")
    url = function (e)
        local angg = function (s)
            if not s then return end
            if s:match"://" then return s end
            return "http://anggtwu.net/"..s
          end
        return angg(e.o.pdfurl or e.o.pdf or e.o.html or e.o.jpg)
      end,
    urlp = function (e) return e.o.url..(e.o.hp or e.o.hanchor or "") end,
    --
    call1 = function (e, name) return e[name](e) end,
    add1  = function (e, name) e.o[name] = e:call1(name) end,
    adds  = function (e, names) for _,name in ipairs(split(names)) do e:add1(name) end end,
    adds0 = function (e) e:adds(e.adds_[e.o[0]]); return e end,
    adds_ = {
      T  = "   T_pdf basicpdf ",  -- 2eT100
      L  = "   L_pdf basicpdf ",  -- 2aL1c4
      Q  = "   Q_pdf basicpdf ",  -- 2eQ2
      AP = "  AP_pdf basicpdf ",  -- Bort7
      EP = "  EP_pdf basicpdf ",  -- MirandaP20
      TL = "  TL_pdf basicpdf TL_tex asexp ",  -- 2021-sapt-slides_2
      P  = "  P_html html htmla   htmlsexp sexp url urlp ",  -- 2aP
      OH = " OH_html html htmla   htmlsexp sexp url urlp ",  -- Slogans#01:23
      J  = " dir jpgstem J_jpg jpg jpgsexp sexp url urlp ",  -- 2eJ1
    },
    --
    basicpdf = function (e)
        e:adds" p hp pdf pdfp pdfsexp sexp url urlp pdftsexp tsexp "
      end,
  },
}

-- «Enrichen-tests»  (to ".Enrichen-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro5.lua"
= Enrichen. getsexp "2aT1"
= Enrichen.pgetsexp "2aT1"
= Enrichen. getsexp "BLA"
= Enrichen.pgetsexp "BLA"    -- err
  Enrichen.test "2aT1"
  Enrichen.test "BLA"        -- err

test = Enrichen.test
test "2xT4"
test "2xT4"
test "2xQ4"
test "2aL1c4"
test "2022-500-linhas-etel"
test "2022-500-linhas-etel_1"
test "2022-500-linhas-etel_2"
test "2aP"
test "2aP#foo"
test "Slogans"
test "Slogans#01:23"
test "2xJ4"
test "2xQ4"

=   Enrichen.fromstr  "2xT4"
=   Enrichen.fromstr  "2xQ4"
=   Enrichen.fromstr  "2aL1m4"
=   Enrichen.fromstr  "2022-500-linhas-etel"
=   Enrichen.fromstr  "2022-500-linhas-etel_1"
=   Enrichen.fromstr  "2022-500-linhas-etel_2"
=   Enrichen.fromstr  "2aP"
=   Enrichen.fromstr  "2aP#foo"
=   Enrichen.fromstr  "Slogans"
=   Enrichen.fromstr  "Slogans#01:23"
=   Enrichen.fromstr  "2xJ4"

  gr:cm2("TL", "2022-500-linhas-etel")
  gr:cm2("TL", "2022-500-linhas-etel_4")

e = Enrichen.fromstr0 "2xP"
e = Enrichen.fromstr0 "2xQ"
e = Enrichen.fromstr0 "2xJ"
e = Enrichen.fromstr0 "2aL"
e = Enrichen.fromstr0 "2xT4"
e = Enrichen.fromstr0 "2xJ"
e = Enrichen.fromstr  "2xJ"
= e
=         e.o[0]
= e.adds_[e.o[0]]
= e:adds0()

= lsquadros_cache["2019.2-C2"]

= e:Jfile()
= e
= e:subst("_<page>_")
= e:subst("_<foo>_")


--]==]



--  _                           _                                 _          
-- | |___  __ _ _   _  __ _  __| |_ __ ___  ___     ___ __ _  ___| |__   ___ 
-- | / __|/ _` | | | |/ _` |/ _` | '__/ _ \/ __|   / __/ _` |/ __| '_ \ / _ \
-- | \__ \ (_| | |_| | (_| | (_| | | | (_) \__ \  | (_| (_| | (__| | | |  __/
-- |_|___/\__, |\__,_|\__,_|\__,_|_|  \___/|___/___\___\__,_|\___|_| |_|\___|
--           |_|                              |_____|                        
--
-- «lsquadros_cache»  (to ".lsquadros_cache")
lsquadros_cache = copy(require "LsQuadros1-cache")
lsquadros_cache_prepare = function ()
    for i=1,#lsquadros_cache do
      local dir = lsquadros_cache[i].dir
      lsquadros_cache[dir] = lsquadros_cache[i]
    end
  end
lsquadros_cache_prepare()

-- «lsquadros_cache-tests»  (to ".lsquadros_cache-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro5.lua"
lsquadros_cache = copy(require "LsQuadros1-cache")
for i=1,#lsquadros_cache do print(lsquadros_cache[i].dir) end
= lsquadros_cache["2022.2-C2"]
lsquadros_cache_prepare()
= lsquadros_cache["2022.2-C2"]

= lsquadros_cache
= lsquadros_cache[1]
= lsquadros_cache[1].dir
= lsquadros_cache[1].stems
= lsquadros_cache[1].stems[1]

lsquadros_cache = copy(require "LsQuadros1-cache")
= lsquadros_cache["2022.2-C2"]
= lsquadros_cache

--]]




-- (find-angg "LUA/Subst1.lua" "Subst")
-- (find-angg "LUA/Caepro4.lua" "Abbrev" "fmts =")

--                                                   
--  _ __  _ __ ___ _ __  _ __ ___   ___ ___  ___ ___ 
-- | '_ \| '__/ _ \ '_ \| '__/ _ \ / __/ _ \/ __/ __|
-- | |_) | | |  __/ |_) | | | (_) | (_|  __/\__ \__ \
-- | .__/|_|  \___| .__/|_|  \___/ \___\___||___/___/
-- |_|            |_|                                
--
-- «preprocess»  (to ".preprocess")
-- pad9_1  -> 2023-pad-09-74_1   <- pp1
-- pad9_66 -> 2023-pad-09-74_66  <- pp66
-- pad5_63 -> 2023-pad-05-08_1   <- pp63
-- pad5_66 -> 2023-pad-05-08_4   <- pp66

preprocess = function (str)
    local p = str:lower():match"^pp(%d+)"
    if p and (p+0 <= 66)
    then str = "2023-pad-09-74_"..p 
    end
    local a,p = str:lower():match"^pad(%d)_(%d+)"
    if a == "5" then return "2023-pad-05-08_"..(p-62) end
    if a == "9" then return "2023-pad-09-74_"..p end
    return str
  end



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
    local url = Enrichen.pgetfield("urlp", preprocess(str))
    return url and (url:gsub("#", "\\#"))
  end

-- «LaTeX-tests»  (to ".LaTeX-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro5.lua"
= Caurl "2eT3"
= Caurl "BLA"

--]]




-- «run_options»  (to ".run_options")
-- (find-es "lua5" "run_options")
--
run_options = function (a, b)
    local pr = preprocess
    if     a == nil        then return
    elseif a == "Caepro5"  then return
    elseif a == "-sexp"    then print(Enrichen.pgetsexp(pr(b)))
    elseif a == "-tsexp"   then print(Enrichen.pgetfield("tsexp", pr(b)))
    elseif a == "-asexp"   then print(Enrichen.pgetfield("asexp", pr(b)))
    elseif a == "-test"    then Enrichen.test(pr(b))
    elseif a == "-anggurl" then print(Enrichen.pgetfield("urlp", pr(b)))
    else PP("Bad options:", a, b)
    end
  end

run_options(...)

-- «run_options-tests»  (to ".run_options-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Caepro5.lua"
run_options("-sexp", "2aT1")
run_options("-tsexp", "2aT1")
run_options("-sexp", "BLA")
run_options("-test", "2aT1")
run_options("-test", "BLA")
run_options("-anggurl", "2aT1")
= Caurl "2aT1"
= Caurl "BLA"

--]]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
