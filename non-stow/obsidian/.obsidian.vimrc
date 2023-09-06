inoremap jk <Esc>
nmap j gj
nmap k gk
vnoremap j gj
vnoremap k gk
nnoremap I g0i
nnoremap A g$a
exmap 0 goLineLeftSmart
exmap $ goLineRight
nnoremap Y y$

noremap [ (
noremap ] )


exmap nextHeading obcommand obsidian-editor-shortcuts:goToNextHeading
exmap prevHeading obcommand obsidian-editor-shortcuts:goToPrevHeading
nnoremap <C-j> :nextHeading
nnoremap <C-k> :prevHeading
