default:
	nix-shell  --run "make main.pdf"

%.pdf: %.tex
	latexmk -pdf -xelatex $<

%.tex: %.lhs
	lhs2TeX -o $@ $<

%.lhs: %.org
	emacs  --batch --eval="(load \"${MYEMACSLOAD}\")" $< -f org-beamer-export-to-latex --kill
	mv -f $*.tex $@
