unmap <Space>
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

exmap nextHeading obcommand obsidian-editor-shortcuts:goToNextHeading
exmap prevHeading obcommand obsidian-editor-shortcuts:goToPrevHeading
nnoremap <Space>j :nextHeading
nnoremap <Space>k :prevHeading

" Close obsidian
exmap closeWindow obcommand workspace:close-window
nnoremap ZZ :closeWindow

" Splits
exmap splitVertical obcommand workspace:split-vertical
exmap splitHorizontal obcommand workspace:split-horizontal
exmap only obcommand workspace:close-others
exmap closeTab obcommand workspace:close
nnoremap <C-w>v :splitVertical
nnoremap <C-w>s :splitHorizontal
nnoremap <C-w>o :only
nnoremap <C-w>c :closeTab

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

exmap switcherOpen obcommand switcher:open
nmap <Space>sf :switcherOpen
exmap searchGlobal obcommand global-search:open
nmap <Space>st :searchGlobal
exmap replaceCurrentFile obcommand editor:open-search-replace
nmap <Space>rs :replaceCurrentFile

" Smarter o and O (inserting prefix for markdown lists)
exmap blankBelow obcommand obsidian-editor-shortcuts:insertLineBelow
exmap blankAbove obcommand obsidian-editor-shortcuts:insertLineAbove
nmap &a& :blankAbove
nmap &b& :blankBelow
nmap o &b&i
nmap O &a&i
