# This file:
#   http://angg.twu.net/2023-1-C2-C4-ES/Makefile.html
#   http://angg.twu.net/2023-1-C2-C4-ES/Makefile
#           (find-angg "2023-1-C2-C4-ES/Makefile")
#      See: (find-angg "2022-2-C2-C3/Makefile")
# Author: Eduardo Ochs <eduardoochs@gmail.com>
#
# Created by hand from:
#   (find-angg "2023-1-C2-C4-ES/README.org")
#   (find-fline "/tmp/.filest0.tex")
#   (setq last-kbd-macro (kbd "C-a C-q TAB lualatex SPC C-a <down>"))

all: compile_all_texs

compile_basic_texs:
	lualatex 2023-1-C2-P1.tex
	lualatex 2023-1-C2-P2.tex
	lualatex 2023-1-C2-carro.tex
	lualatex 2023-1-C2-dicas-pra-P1.tex
	lualatex 2023-1-C2-dicas-pra-P2.tex
	lualatex 2023-1-C2-edos-lineares.tex
	lualatex 2023-1-C2-edovs.tex
	lualatex 2023-1-C2-fracoes-parciais.tex
	lualatex 2023-1-C2-intro.tex
	lualatex 2023-1-C2-macaco.tex
	lualatex 2023-1-C2-mudanca-de-variaveis.tex
	lualatex 2023-1-C2-somas-de-riemann.tex
	lualatex 2023-1-C2-volumes.tex
	lualatex 2023-1-C4-P1.tex
	lualatex 2023-1-C4-P2.tex
	lualatex 2023-1-C4-dicas-pra-P1.tex
	lualatex 2023-1-C4-dicas-pra-P2.tex
	lualatex 2023-1-C4-intro.tex
	lualatex 2023-1-ES-P1.tex
	lualatex 2023-1-ES-P2.tex
	lualatex 2023-1-ES-VR.tex

compile_all_texs:
	lualatex 2023-1-C2-P1.tex
	lualatex 2023-1-C2-P2.tex
	lualatex 2023-1-C2-carro.tex
	lualatex 2023-1-C2-dicas-pra-P1.tex
	lualatex 2023-1-C2-dicas-pra-P2.tex
	lualatex 2023-1-C2-edos-lineares.tex
	lualatex 2023-1-C2-edovs.tex
	lualatex 2023-1-C2-fracoes-parciais.tex
	lualatex 2023-1-C2-intro.tex
	lualatex 2023-1-C2-macaco.tex
	lualatex 2023-1-C2-mudanca-de-variaveis.tex
	lualatex 2023-1-C2-somas-de-riemann.tex
	lualatex 2023-1-C2-volumes.tex
	lualatex 2023-1-C4-P1.tex
	lualatex 2023-1-C4-P2.tex
	lualatex 2023-1-C4-dicas-pra-P1.tex
	lualatex 2023-1-C4-dicas-pra-P2.tex
	lualatex 2023-1-C4-intro.tex
	lualatex 2023-1-ES-P1.tex
	lualatex 2023-1-ES-P2.tex
	lualatex 2023-1-ES-VR.tex
	lualatex 2023-1-C2-tudo.tex
	lualatex 2023-1-C4-tudo.tex
	lualatex 2023-1-ES-tudo.tex
