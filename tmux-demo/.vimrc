syntax on
filetype plugin on
" a blue that is visible with black background
hi comment ctermfg=lightblue 

" Following are the keys mapped to run '~/runFromVim.sh' which I use in my demos using tmux

" PageDown calls the 'runFromVim' for the current line only. 
" Argument is PageDown which means no need to automatically wait on cursor as this is supposed to be controled by a human for each line. 
" Why PageDown? that's what the remote control sends.

map <PageDown> :.w !sh ~/runFromVim.sh PageDown <CR>j:call system('tmux set-option status-right ' . expand('%:t') . ':' . line('.') . shellescape(' %H:%M') )<CR>z.

" I think I mapped to F11 the same as PageDown but with automatic wait. I don't use it

map      <F11> :.w !sh ~/runFromVim.sh F11      <CR>j:call system('tmux set-option status-right ' . expand('%:t') . ':' . line('.') . shellescape(' %H:%M') )<CR>z.

" F12 is to run from line 1 to current line. 
" I use it for the initialization part.

map       <F12> :call system('tmux set-option status-right ' . expand('%:t') . ':' . line('.') . shellescape(' %H:%M') )<CR>z.:1,.w !sh ~/runFromVim.sh F12

" Shift F12 runs the selected lines

map     <S-F12> :w !sh ~/runFromVim.sh S-F12 <CR>`>:call system('tmux set-option status-right ' . expand('%:t') . ':' . line('.') . shellescape(' %H:%M') )<CR><CR>^<CR>


" I use this to add dashed underlines on SQLcl ansiconsole formatted output

map <F4> O<ESC>jyyp:s/[^ ]/-/g<CR>/SQL> select<CR>/;<CR>j^:noh<CR>z.

