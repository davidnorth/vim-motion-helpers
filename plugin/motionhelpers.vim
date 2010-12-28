" http://vim.wikia.com/wiki/Move_to_next/previous_line_with_same_indentation
" Jump to the next or previous line that has the same level or a lower
" level of indentation than the current line.
"
" exclusive (bool): true: Motion is exclusive
" false: Motion is inclusive
" fwd (bool): true: Go to next line
" false: Go to previous line
" lowerlevel (bool): true: Go to line with lower indentation level
" false: Go to line with the same indentation level
" skipblanks (bool): true: Skip blank lines
" false: Don't skip blank lines
function! NextIndent(exclusive, fwd, lowerlevel, skipblanks)
  let line = line('.')
  let column = col('.')
  let lastline = line('$')
  let indent = indent(line)
  let stepvalue = a:fwd ? 1 : -1
  while (line > 0 && line <= lastline)
    let line = line + stepvalue
    if ( ! a:lowerlevel && indent(line) == indent ||
          \ a:lowerlevel && indent(line) < indent)
      if (! a:skipblanks || strlen(getline(line)) > 0)
        if (a:exclusive)
          let line = line - stepvalue
        endif
        exe line
        exe "normal " column . "|"
        return
      endif
    endif
  endwhile
endfunction


nnoremap <silent> <C-k> :call NextIndent(0, 0, 0, 1)<CR>
nnoremap <silent> <C-j> :call NextIndent(0, 1, 0, 1)<CR>
nnoremap <silent> <C-p> :call NextIndent(0, 0, 1, 1)<CR>
nnoremap <silent> <C-o> :call NextIndent(0, 1, 1, 1)<CR>
vnoremap <silent> <C-k> <Esc>:call NextIndent(0, 0, 0, 1)<CR>m'gv''
vnoremap <silent> <C-j> <Esc>:call NextIndent(0, 1, 0, 1)<CR>m'gv''
vnoremap <silent> <C-p> <Esc>:call NextIndent(0, 0, 1, 1)<CR>m'gv''
vnoremap <silent> <C-o> <Esc>:call NextIndent(0, 1, 1, 1)<CR>m'gv''


" onoremap <silent> [l :call NextIndent(0, 0, 0, 1)<CR>
" onoremap <silent> ]l :call NextIndent(0, 1, 0, 1)<CR>
" onoremap <silent> [L :call NextIndent(1, 0, 1, 1)<CR>
" onoremap <silent> ]L :call NextIndent(1, 1, 1, 1)<CR>
"






fun! s:SpeedyVerticalMotion(splits, split) "{{{

  " Find line number for top of Window
  normal H
  let topLine = line('.')
  " Fine number for last non-empty line in window (is there an easier way to
  " find this out?
  normal L
  let bottomLine = line('.')

  " Not height of window but height of the part that has something in it
  let winHeight = bottomLine - topLine

  let linesInSegment = winHeight / a:splits
  let newOffset = ( linesInSegment * (a:split-1) )
  "+ (linesInSegment / 2)
  let newLine = float2nr(topLine+newOffset)
  " call setpos('.', [0, newLine, 1])
  execute ":"+newLine
endfunction "}}}

" Move to middle of top or bottom half of screen as well as the middle
nnoremap <silent> ,t :call <SID>SpeedyVerticalMotion(4.0, 2)<Cr>
" nnoremap <silent> ,w :call <SID>SpeedyVerticalMotion(4.0, 3)<Cr>
nnoremap <silent> ,b :call <SID>SpeedyVerticalMotion(4.0, 4)<Cr>
vnoremap <silent> ,t <Esc>:call <SID>SpeedyVerticalMotion(4.0, 2)<CR>m'gv''
" vnoremap <silent> ,w <Esc>:call <SID>SpeedyVerticalMotion(4.0, 3)<CR>m'gv''
vnoremap <silent> ,b <Esc>:call <SID>SpeedyVerticalMotion(4.0, 4)<CR>m'gv''


fun! s:GoToMiddleCharacterInLine() "{{{
  " Get the line contents and indent level
  let text = getline('.')
  let indent = indent('.')
  " Find number of characters exlcuding initial whitespace
  let numChars = len(text) - indent
  let newCol = (numChars / 2) + indent
  exe "normal " . newCol . "|"
endfunction "}}}

" Override default 'gm' behaviour, go to middle column of the line rather than window
nnoremap <silent> gm :call <SID>GoToMiddleCharacterInLine()<Cr>

" Move to Start, End and miDdle of line
nnoremap <silent> ,s ^
nnoremap <silent> ,d :call <SID>GoToMiddleCharacterInLine()<Cr>
nnoremap <silent> ,e $
vnoremap <silent> ,s ^
vnoremap <silent> ,d <Esc>:call <SID>GoToMiddleCharacterInLine()<CR>m`gv``
vnoremap <silent> ,e $

