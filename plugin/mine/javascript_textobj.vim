 "textobj-datetime - Text objects for javascript
 " Version: 0.0.1
 " Copyright (C) zhao jun an<anzizhao@gmail.com>
 " License: So-called MIT/X license  {{{
 "     Permission is hereby granted, free of charge, to any person obtaining
 "     a copy of this software and associated documentation files (the
 "     "Software"), to deal in the Software without restriction, including
 "     without limitation the rights to use, copy, modify, merge, publish,
 "     distribute, sublicense, and/or sell copies of the Software, and to
 "     permit persons to whom the Software is furnished to do so, subject to
 "     the following conditions:
 "

 if exists('g:loaded_textobj_mine')
     finish
 endif

   "选中不带括号的WORD 
   "call textobj#user#plugin('funcparameter', {
   "\   '-': {
   "\     'select-i-function': 'Funcparameter',
   "\     'select-i': 'iw ',
   "\   },
   "\ })

   "选中字母数字部分 
   call textobj#user#plugin('alpha', {
               \   '-': {
               \     'select-i-function': 'Alpha',
               \     'select-i': 'iwu',
               \   },
               \ })

   "选中驼峰 
   call textobj#user#plugin('camel', {
               \   '-': {
               \     'select-a-function': 'ACamel',
               \     'select-a': 'awc',
               \     'select-i-function': 'ICamel',
               \     'select-i': 'iwc',
               \   },
               \ })

   "选中链接单词的  .
   "call textobj#user#plugin('connectworddot', {
               "\   '-': {
               "\     'select-a-function': 'AconnectwordDot',
               "\     'select-a': 'aw.',
               "\     'select-i-function': 'IconnectwordDot',
               "\     'select-i': 'iw.',
               "\   },
               "\ })

   "选中链接单词的  .
   "call textobj#user#plugin('connectwordunderline', {
               "\   '-': {
               "\     'select-a-function': 'AconnectwordUnderline',
               "\     'select-a': 'aw-',
               "\     'select-i-function': 'IconnectwordUnderline',
               "\     'select-i': 'iw-',
               "\   },
               "\ })

   "选中当前光标到分号的
   "call textobj#user#plugin('smeicolon', {
               "\   '-': {
               "\     'select-a-function': 'Smeicolon',
               "\     'select-a': 'a;',
               "\   },
               "\ })

   "选中等于号的右手边
   "call textobj#user#plugin('equalrightside', {
               "\   '-': {
               "\     'select-a-function': 'Equalrightside',
               "\     'select-a': 'a=',
               "\   },
               "\ })

   function! AconnectwordDot()
       return s:connectword('.', 0)
   endfunction

   function! IconnectwordDot()
       return s:connectword('.', 1)
   endfunction



   function! AconnectwordUnderline()
       return s:connectword('_', 0)
   endfunction

   function! IconnectwordUnderline()
       return s:connectword('_', 1)
   endfunction



   function! Equalrightside ()
       let head_pos = getpos('.') 
       let head_pos[3] = 0

       call setpos('.', head_pos)
       "echo head_pos
       "向后搜索
       let bpos  = search('\v[=]')
       "echo bpos
       let head_pos = getpos('.')
       let head_pos[2] +=   1
       let bpos  = search('\v[;]')
       let tail_pos = getpos('.')
       let tail_pos[2] -=   1
       "echo tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction

   function! Smeicolon()
       let head_pos = getpos('.') 
       "echo head_pos
       "向后搜索
       let bpos  = search('\v[;]')
       "echo bpos
       let tail_pos = getpos('.')
       let tail_pos[2] -=   1
       "echo tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction


   function! Alpha()
       "先判断当前是否大写
       let char = s:cursor_char()
       if char !~ '\u'
           let fpos  = search('\v\A', 'b', line('.'))
       endif

      if fpos == 0
          let lineHead = search('\v^', 'b', line("."))
      endif 

      "bufName lineN colN  off 
       let head_pos = getpos('.') 

       "判断开始地方是否大写字母
       let char = s:cursor_char()
       if char !~ '\u' && fpos != 0
           let head_pos[2] +=   1
       endif

       "向后搜索
       let bpos  = search('\v\A', '', line("."))

       let lineEndPos = 0
       if bpos == 0
           let lineEndPos = search('\v$', '', line("."))
       endif 

       let tail_pos = getpos('.')
       if bpos != 0 && lineEndPos == 0 
           let tail_pos[2] -=   1
       endif
       return ['v', head_pos, tail_pos]
   endfunction

   function! ICamel()
       "先判断当前是否大写
       let char = s:cursor_char()
       if char !~ '\u'
           let fpos  = search('\v\u|\A', 'b', line("."))
       endif

      if fpos == 0
          "在这一行没有发现 移动光标到行首, line col 为0 不移动
          "echo 'fpos == 0'
          let lineHead = search('\v^', 'b', line("."))
          "echo 'lineHead' lineHead
          "cursor(0, 1)
      endif 

      let head_pos = getpos('.') 
      "可以使用echo进行调试
      "echo "head_pos" head_pos

       "判断开始地方是否大写字母
       let char = s:cursor_char()
       if char !~ '\u' && fpos != 0
           let head_pos[2] +=   1
       endif

       "向后搜索
       let bpos  = search('\v\u|\A', '', line("."))
       let lineEndPos = 0
       if bpos == 0
           "在这一行没有发现 移动光标到行首, line col 为0 不移动
           let lineEndPos = search('\v$', '', line("."))
           "echo 'bpos == 0'
       endif 

       let tail_pos = getpos('.')
       if bpos != 0 && lineEndPos == 0 
           let tail_pos[2] -=   1
       endif
       "echo  "tail_pos"  tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction


   function! Funcparameter()
       "向前搜索空白或括号前部分 添加逗号
       let curPos = getpos(".")
       let curChar = s:get_char(curPos[2]) 
        
       let fpos  = search('\v[,(]', 'b')
      "bufName lineN colN  off 
       let head_pos = getpos('.') 
       let head_pos[2] +=   1

       echo "head_pos" head_pos
       "向后搜索
       "let bpos  = search('\v\s|[],;})]')
       let fpos  = search('\v\s|[],;{}()]' )
       let tail_pos = getpos('.')
       ", : 删除 括号不删除
       let char = s:cursor_char()
       "[]一定要这样顺序  不然匹配不上
       if char =~ '[])}]'
           let tail_pos[2] -=   1
       endif

       echo  "tail_pos"  tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction


   let g:loaded_textobj_mine = 1

function! s:cursor_char()
  return getline('.')[col('.') - 1]
endfunction

function! s:get_char(col)
  return getline('.')[a:col]
endfunction

"it seem become not simple now
"search the head target, not found, search [a-zA-Z0-9] 
"search the tail target, not found, search [^a-zA-Z0-9] 
"type: 0 A  1 I
function! s:connectword(char, type)
    "if current cursor char is the search char, no need to search backward
    let curPos = getpos(".")
    let curChar = s:cursor_char()
    if curChar == a:char 
        let head_pos = getpos('.')
    else 
        let searchHead = '\v[' . a:char .']'
        let result = search(searchHead, 'b', line("."))
        if result == 0 
            "not found expect char
            call setpos(".", curPos) 
            let result = search('\v[0-9A-Za-z]', 'eb', line("."))
            let head_pos = getpos('.')
        else 
            let head_pos = getpos('.')
            if a:type == 1
                let head_pos[2] +=   1
            endif
        endif
    endif
    
    "bufName lineN colN  off 
    call setpos(".", curPos) 

    "向后搜索
    let searchTail = '\v[' . a:char .']'
    let result = search(searchTail, 'W', line("."))
    if result == 0 
        "not found expect char
        call setpos(".", curPos) 
        let searchTail = '\v\A'
        let result = search('\v[^0-9A-Za-z]', 'W', line("."))
        if result == 0 
            let result = search('\v$', 'W', line("."))
            let tail_pos = getpos('.')
            return ['v', head_pos, tail_pos]
        endif  
        "如果行尾都没有发现
        
    endif
    let tail_pos = getpos('.')
    let tail_pos[2] -=   1
    return ['v', head_pos, tail_pos]

endfunction
