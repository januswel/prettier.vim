" vim ftplugin file
" Filename:     typescript.vim
" Maintainer:   janus_wel <janus.wel.3@gmail.com>
" License:      MIT License

" preparations {{{1
" check if this ftplugin is already loaded or not
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" reset the value of 'cpoptions' for portability
let s:save_cpoptions = &cpoptions
set cpoptions&vim

" main {{{1
" options {{{2
" for ftplugin files
setlocal formatoptions-=t
setlocal formatoptions+=rol

" autocmds {{{2
augroup PrettierTypescript
    autocmd!
    autocmd BufWritePre *.ts,*.tsx call prettier#Modify()
augroup END

" post-processings {{{1
" restore the value of 'cpoptions'
let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

" }}}1
" vim: ts=4 sw=4 sts=0 et fdm=marker fdc=3
