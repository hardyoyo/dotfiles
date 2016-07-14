" ---------[ INFORMATION ]---------
"
" Vim plugin for emulating Windows Notepad's logging functionality.
" Maintainer:  Sven Knurr <der_tuxman@arcor.de>
" Version:     1.6
" Last Change: 2013 Jul 14
"
" --------[ HOW TO USE IT ]--------
"
" Create a new text file. Insert .LOG. Save it. Then reopen it.
" Now you have a timestamped log file. :-)
"
" --------[ CONFIGURATION ]--------
"
" Optional values to set in your .vimrc file:
"
" let LogpadEnabled = [ 0 / 1 ]
"   >> enables/disables logpad
"   >> default value: 1
"
" let LogpadInsert = [ 0 / 1 ]
"   >> automatically enables insert mode when a new log entry is created
"   >> default value: 0
"
" let LogpadLineBreak = [ 0 / 1 ]
"   >> adds an empty line before a new log entry
"   >> default value: 0 (Windows Notepad behavior)
"
" let LogpadIgnoreNotes = [ 0 / 1 ]
"   >> allows adding notes before the first log entry
"   >> default value: 0
"
" let LogpadIgnoreReadOnly = [ 0 / 1 ]
"   >> allows logpad to ignore a file's read-only flag
"   >> default value: 0
"
" -----------[ CHANGES ]-----------
"
" v1.6: fix: logpad.vim was not detecting some timestamps correctly
" v1.5: insert mode code improvement and using function! now
" v1.4: added check and switch for read-only flag
" v1.3: added support for GetLatestVimScripts, removed initial cursor() call
" v1.2: fix: converted logpad.vim to UNIX format (was not working outside Windows)
" v1.1: fix: the LogpadLineBreak setting also affects the single empty line below ".LOG"
" v1.0: initial release.
"
" -----------[ CREDITS ]-----------
"
" This plugin was inspired by a German weblog posting, available at:
"    http://schwerdtfegr.wordpress.com/2009/08/27/eine-notepad-funkzjon-die-man-missen-lernt/
" Thanks to the guys in #vim (freenode.net) for basic help.
"
" Contributors:
"  . timestamping clues: DHulme @ freenode.net (pre-v1.6)
"  . various patches:    Talha Mansoor
"
" ---------[ HERE WE GO! ]---------

function! LogpadInit()
    " check the configuration, set it (and exit) if needed
    if !exists('g:LogpadEnabled')        | let g:LogpadEnabled        = 1 | endif
    if !exists('g:LogpadInsert')         | let g:LogpadInsert         = 0 | endif
    if !exists('g:LogpadLineBreak')      | let g:LogpadLineBreak      = 0 | endif
    if !exists('g:LogpadIgnoreNotes')    | let g:LogpadIgnoreNotes    = 0 | endif
    if !exists('g:LogpadIgnoreReadOnly') | let g:LogpadIgnoreReadOnly = 0 | endif

    if g:LogpadEnabled == 0                          | return             | endif
    if g:LogpadIgnoreReadOnly == 0 && &readonly == 1 | return             | endif

    " main part
    if getline(1) =~ '^\.LOG$'
        " 3 letters for day name - space - 3 letters for month - space - an optional space that occurs if day is single digit - one or two digit for day - space - hour:min:seconds - space - year 
        let s:timestampformat = '\(\a\{3}\s\)\{2}\s\{0,1}\d\{1,2}\s\(\d\{2}:\)\{2}\d\{2}\s\d\{4}'

        if nextnonblank(2) > 0
            if getline(nextnonblank(2)) !~ s:timestampformat && g:LogpadIgnoreNotes == 0
                " there are following lines, but these aren't timestamps,
                " obviously the user doesn't want to create a log then...
                return
            endif
        endif

        " add a new entry
        let s:failvar = 0
        while s:failvar != 1
            if g:LogpadLineBreak == 1
                " add a single empty divider line if requested
                let s:failvar = append(line('$'), "")
            endif
            let s:failvar = append(line('$'), strftime("%c"))
            let s:failvar = append(line('$'), "")

            " go to the last line
            call cursor(line('$'), 0)

            " if we're here, everything worked so far; let's exit
            let s:failvar = 1
        endwhile

        " enter insert mode if enabled
        if g:LogpadInsert == 1
            execute  ":startinsert"
        endif
    endif
endfunction

autocmd BufReadPost * call LogpadInit()

" -------[ COMPAT COMMENTS ]-------

" GetLatestVimScripts: 2775 1 :AutoInstall: logpad.vim
" vim:ft=vim:sw=4:sts=4:et
