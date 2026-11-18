# .latexmkrc
$pdf_mode = 1;  # 4 means use lualatex
$pdflatex  = 'lualatex %O -synctex=1 -interaction=nonstopmode -file-line-error %S';
$out_dir = 'out_files';
