" vim ftplugin file
" Filename:     javascript.vim
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
" functions {{{2

" search prettier path
if !exists('*s:SearchPrettier')
    function s:SearchPrettier()
        let dir_in_file = expand('%:p:h')
        let dirs = split(dir_in_file, '/')
        while !empty(dirs)
            let path = '/' . join(dirs, '/') . '/node_modules/.bin/prettier'
            if executable(path)
                return path
            endif
            call remove(dirs, -1)
        endwhile
        if executable('prettier')
            return 'prettier'
        endif
        return ''
    endfunction
endif

" save cursor and screen positions
" pair up this function with s:RestorePositions
if !exists('*s:SavePositions')
    function s:SavePositions()
        " cursor pos
        let cursor = getpos('.')

        " screen pos
        normal! H
        let screen = getpos('.')

        return [screen, cursor]
    endfunction
endif

" restore cursor and screen positions
" pair up this function with s:SavePositions
if !exists('*s:RestorePositions')
    function s:RestorePositions(pos)
        " screen
        call setpos('.', a:pos[0])

        " cursor
        normal! zt
        call setpos('.', a:pos[1])
    endfunction
endif

if !exists('*s:ModifyByPrettier')
    function s:ModifyByPrettier()
        let pos = s:SavePositions()
        try
            let s:saved = @z

            let prettier_path = s:SearchPrettier()
            if prettier_path == ''
                return
            endif

            let config_path = system(prettier_path . ' --find-config-path ' . expand('%:p'))
            silent execute '1,$!' . prettier_path . ' --config ' . config_path
            silent execute '1,$yank z'
            if v:shell_error != 0
                normal! u
                echoerr @z
            endif
        catch
            echoerr v:exception
        finally
            let @z = s:saved
            call s:RestorePositions(pos)
        endtry
    endfunction
endif

" options {{{2
" for ftplugin files
setlocal formatoptions-=t
setlocal formatoptions+=rol

augroup javascript
    autocmd!
    autocmd BufWritePre *.js,*.jsx call <SID>ModifyByPrettier()
augroup END

" post-processings {{{1
" restore the value of 'cpoptions'
let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

" }}}1
" vim: ts=4 sw=4 sts=0 et fdm=marker fdc=3
