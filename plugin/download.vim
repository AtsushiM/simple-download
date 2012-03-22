"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/FastProject.vim
"VERSION:  0.9
"LICENSE:  MIT

let g:simple_download_PluginDir = expand('<sfile>:p:h:h').'/'
let g:simple_download_TemplateDir = g:simple_download_PluginDir.'template/'
let g:simple_download_SubDir = g:simple_download_PluginDir.'sub/'
let s:simple_download_DownloadNo = 0
let s:simple_download_DownloadOpen = 0

let s:simple_download_DownloadBeforePath = ''

if !exists("g:simple_download_DefaultConfigDir")
    let g:simple_download_DefaultConfigDir = $HOME.'/.simple-download/'
endif
if !exists("g:simple_download_DefaultDownload")
    let g:simple_download_DefaultDownload = '~Download~'
endif
if !exists("g:simple_download_DownloadWindowSize")
    let g:simple_download_DownloadWindowSize = 'topleft 50vs'
endif

" config
if !isdirectory(g:simple_download_DefaultConfigDir)
    call mkdir(g:simple_download_DefaultConfigDir)
endif
let s:simple_download_DefaultDownload = g:simple_download_DefaultConfigDir.g:simple_download_DefaultDownload
if !filereadable(s:simple_download_DefaultDownload)
    call system('cp '.g:simple_download_TemplateDir.g:simple_download_DefaultDownload.' '.s:simple_download_DefaultDownload)
endif

function! s:URICheck(uri)
  return escape(matchstr(a:uri, '[a-z]*:\/\/[^ >,;:]*'), '#')
endfunction

function! s:Wget()
    let uri = s:URICheck(getline("."))
    if uri != ""
        if s:simple_download_DownloadBeforePath != ''
            exec 'cd '.s:simple_download_DownloadBeforePath
        endif
        let cmd = 'wget '.uri
        call system(cmd)
        echo cmd
    else
        echo "No URI found in line."
    endif
endfunction

function! s:DownloadOpen()
    exec g:simple_download_DownloadWindowSize." ".g:simple_download_DefaultConfigDir.g:simple_download_DefaultDownload
    let s:simple_download_DownloadOpen = 1
    let s:simple_download_DownloadNo = bufnr('%')
endfunction
function! s:DownloadClose()
    let s:simple_download_DownloadOpen = 0
    exec 'bw '.s:simple_download_DownloadNo
    winc p
endfunction

function! s:Download()
    if s:simple_download_DownloadOpen == 0
        call s:DownloadOpen()
    else
        call s:DownloadClose()
    endif
endfunction

command! Wget call s:Wget()
command! SDownload call s:Download()

function! s:SetBufMapDownload()
    set cursorline
    nnoremap <buffer><silent> e :Wget<CR>
    nnoremap <buffer><silent> <CR> :Wget<CR>
    nnoremap <buffer><silent> q :bw %<CR>:winc p<CR>
endfunction
exec 'au BufRead '.g:simple_download_DefaultDownload.' call <SID>SetBufMapDownload()'
exec 'au BufReadPre '.g:simple_download_DefaultDownload.' let s:simple_download_DownloadBeforePath = getcwd()'
exec 'au BufWinLeave '.g:simple_download_DefaultDownload.' call <SID>DownloadClose()'
