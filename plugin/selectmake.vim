" try to figure out which make program to use based on files in the current
" directory. will automatically switch to the waf build system whenever the
" wscript_build file is present. otherwise, just use make.

if exists("make_selected")
    finish
endif
let make_selected = 1

" save compatibility flags and then set them to the default 
" to ensure our script runs in a known environment
let s:cpo_bak = &cpo
set cpo&vim

let s:patterns = [ { 'glob': ['bb'], 'makeprg' : '../bb -j4' },
                 \ { 'glob': ['CMakeLists.txt'], 'makeprg' : '../bb -j4' },
                 \ { 'glob': ['waf'], 'makeprg' : './waf -p -j3' },
                 \ { 'glob': ['wscript_build'], 'makeprg' : '../waf -p -j3' },
                 \ { 'glob': ['makefile', 'Makefile', 'GNUmakefile'], 'makeprg': 'make' },
                 \ { 'glob': ['SConstruct', 'sconstruct'], 'makeprg': 'scons' },
                 \ { 'glob': ['SConscript', 'sconscript'], 'makeprg': 'scons -u' } ]

let s:found = 0
for s:item in s:patterns 
    let s:glob_list = s:item['glob']
    for s:g in s:glob_list
        let s:fileList = glob(s:g)
        if len(s:fileList) != 0
            let &makeprg = s:item['makeprg']
            let s:found = 1
            break
        endif
    endfor
    if s:found != 0
        break
    endif
endfor

" restore the compatability flags
let &cpo = s:cpo_bak

