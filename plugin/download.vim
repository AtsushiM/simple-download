"AUTHOR:   Atsushi Mizoue <asionfb@gmail.com>
"WEBSITE:  https://github.com/AtsushiM/simple-download.vim
"VERSION:  0.9
"LICENSE:  MIT

let g:simple_download_PluginDir = expand('<sfile>:p:h:h').'/'
let g:simple_download_TemplateDir = g:simple_download_PluginDir.'template/'
let g:simple_download_DownloadBeforePath = ''

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

command! SDownload call sdownload#Download()
exec 'au BufRead '.g:simple_download_DefaultDownload.' call sdownload#SetBufMapDownload()'
exec 'au BufReadPre '.g:simple_download_DefaultDownload.' let g:simple_download_DownloadBeforePath = getcwd()'
exec 'au BufWinLeave '.g:simple_download_DefaultDownload.' call sdownload#DownloadClose()'
