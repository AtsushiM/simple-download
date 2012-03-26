"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/simple-download.vim
"VERSION:  0.9
"LICENSE:  MIT

let s:simple_download_DownloadNo = 0
let s:simple_download_DownloadOpen = 0

function! sdownload#URICheck(uri)
  return escape(matchstr(a:uri, '[a-z]*:\/\/[^ >,;:]*'), '#')
endfunction

function! sdownload#Wget()
    let uri = sdownload#URICheck(getline("."))
    if uri != ""
        if g:simple_download_DownloadBeforePath != ''
            exec 'cd '.g:simple_download_DownloadBeforePath
        endif
        let cmd = 'wget '.uri
        call system(cmd)
        echo cmd
    else
        echo "No URI found in line."
    endif
endfunction

function! sdownload#DownloadOpen()
    exec g:simple_download_DownloadWindowSize." ".g:simple_download_DefaultConfigDir.g:simple_download_DefaultDownload
    let s:simple_download_DownloadOpen = 1
    let s:simple_download_DownloadNo = bufnr('%')
endfunction
function! sdownload#DownloadClose()
    let s:simple_download_DownloadOpen = 0
    exec 'bw '.s:simple_download_DownloadNo
    winc p
endfunction

function! sdownload#Download()
    if s:simple_download_DownloadOpen == 0
        call sdownload#DownloadOpen()
    else
        call sdownload#DownloadClose()
    endif
endfunction

function! sdownload#SetBufMapDownload()
    set cursorline
    nnoremap <buffer><silent> e :call sdownload#Wget()<CR>
    nnoremap <buffer><silent> <CR> :call sdownload#Wget()<CR>
    nnoremap <buffer><silent> q :call sdownload#DownloadClose()<CR>
endfunction
