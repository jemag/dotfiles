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

" Close obsidian
exmap closeWindow obcommand workspace:close-window
nnoremap ZZ :closeWindow

" Splits
exmap splitVertical obcommand workspace:split-vertical
exmap splitHorizontal obcommand workspace:split-horizontal
exmap only obcommand workspace:close-others
nnoremap <C-w>v :splitVertical
nnoremap <C-w>s :splitHorizontal
nnoremap <C-w>o :only

exmap focusRight obcommand editor:focus-right
nnoremap <C-l> :focusRight

exmap focusLeft obcommand editor:focus-left
nnoremap <C-h> :focusLeft

exmap focusTop obcommand editor:focus-top
nnoremap <C-k> :focusTop
exmap focusBottom obcommand editor:focus-bottom
nnoremap <C-j> :focusBottom

" Go back and forward with Ctrl+O and Ctrl+I
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <C-o> :back
exmap forward obcommand app:go-forward
nmap <C-i> :forward

unmap <Space>
exmap switcherOpen obcommand switcher:open
nmap <Space>sf :switcherOpen
exmap searchGlobal obcommand global-search:open
nmap <Space>st :searchGlobal
exmap replaceCurrentFile obcommand editor:open-search-replace
nmap <Space>rs :replaceCurrentFile
