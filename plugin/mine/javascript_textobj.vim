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
   call textobj#user#plugin('withoutbracketword', {
   \   '-': {
   \     'select-i-function': 'WithoutBracketWORD',
   \     'select-i': 'iwe',
   \   },
   \ })

   "选中字母数字部分 
   call textobj#user#plugin('alpha', {
               \   '-': {
               \     'select-i-function': 'Alpha',
               \     'select-i': 'iwu',
               \   },
               \ })

   "选中驼峰 链接单词的一部分
   call textobj#user#plugin('camel', {
               \   '-': {
               \     'select-a-function': 'ACamel',
               \     'select-a': 'awc',
               \     'select-i-function': 'ICamel',
               \     'select-i': 'iwc',
               \   },
               \ })

   "选中链接单词的一部分
   call textobj#user#plugin('connectword', {
               \   '-': {
               \     'select-a-function': 'Aconnectword',
               \     'select-a': 'aw.',
               \     'select-i-function': 'Iconnectword',
               \     'select-i': 'iw.',
               \   },
               \ })

   "选中当前光标到分号的
   call textobj#user#plugin('smeicolon', {
               \   '-': {
               \     'select-a-function': 'Smeicolon',
               \     'select-a': 'a;',
               \   },
               \ })

   "选中等于号的右手边
   call textobj#user#plugin('equalrightside', {
               \   '-': {
               \     'select-a-function': 'Equalrightside',
               \     'select-a': 'a=',
               \   },
               \ })

   function! Aconnectword()
       let fpos  = search('\v[-/[:blank:]-_.]', 'b')
      "bufName lineN colN  off 
       let head_pos = getpos('.') 
       let head_pos[2] +=   1
       "echo head_pos
       "向后搜索
       let bpos  = search('\v[-/[:blank:]-_.]')

       let tail_pos = getpos('.')
       "let tail_pos[2] -=   1
       "echo tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction

   function! Iconnectword()
       let fpos  = search('\v[-/[:blank:]-_.]', 'b')
      "bufName lineN colN  off 
       let head_pos = getpos('.') 
       let head_pos[2] +=   1
       echo head_pos
       "向后搜索
       let bpos  = search('\v[-/[:blank:]-_.]')

       let tail_pos = getpos('.')
       let tail_pos[2] -=   1
       "echo tail_pos 
       return ['v', head_pos, tail_pos]
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

   function! ACamel()
       let fpos  = search('\v\u|\A', 'b')
      "bufName lineN colN  off 
       let head_pos = getpos('.') 
       "echo head_pos
       "向后搜索
       let bpos  = search('\v\u|\A')

       let tail_pos = getpos('.')
       let tail_pos[2] -=   1
       "echo tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction

   function! ICamel()
       let fpos  = search('\v\u|\A', 'b')
      "bufName lineN colN  off 
       let head_pos = getpos('.') 
       let head_pos[2] +=   1
       "echo head_pos
       "向后搜索
       let bpos  = search('\v\u|\A')

       let tail_pos = getpos('.')
       let tail_pos[2] -=   1
       "echo tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction

   function! Alpha()
       let fpos  = search('\v\A|\n', 'b')
      "bufName lineN colN  off 
       let head_pos = getpos('.') 
       let head_pos[2] +=   1
       "echo head_pos
       "向后搜索
       let bpos  = search('\v\A|\n')

       let tail_pos = getpos('.')
       let tail_pos[2] -=   1
       "echo tail_pos 
       return ['v', head_pos, tail_pos]
   endfunction

   function! WithoutBracketWORD()
       "向前搜索空白或括号前部分 添加逗号
       let fpos  = search('\v\s|,|;|[|\(|\{', 'b')
      "bufName lineN colN  off 
       let head_pos = getpos('.') 
       let head_pos[2] +=   1
       "echo head_pos
       "向后搜索
       let bpos  = search('\v\s|,|;|\)|]|\}')
       let tail_pos = getpos('.')
       ", : 删除 括号不删除
       let char = s:cursor_char()
       "[]一定要这样顺序  不然匹配不上
       if char =~ '[])}]'
           let tail_pos[2] -=   1
       endif

       return ['v', head_pos, tail_pos]
   endfunction

   function! ChunkBlock()
       normal! $va{}}}
       let tail_pos = getpos('.')
       normal! F}%g0
       let head_pos = getpos('.')
       return ['v', head_pos, tail_pos]
   endfunction

   let g:loaded_textobj_mine = 1

function! s:cursor_char()
  return getline('.')[col('.') - 1]
endfunction
