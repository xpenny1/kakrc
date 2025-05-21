source ~/.config/kak/colors
add-highlighter global/ number-lines -relative

hook global InsertChar \t %{ exec -draft -itersel h@ }                      
set global tabstop 4                                                        
set global indentwidth 4   

#map global normal <s-t> %{:info 'Test?'<ret>}
#map global normal <s-r> %{:w; info -markup %sh{export kak_buffile=$kak_buffile; sh ~/.config/kak/compile.sh 2>&1}<ret>}


#hook global BufCreate .*\.typ %{ set buffer filetype typst }
#hook global WinCreate .*\.typ %{ add-highlighter number-lines }

# .typ files are not registert as their mime type because of libmagic
source ~/.config/kak/typst.kak
hook global BufSetOption filetype=typst %{
    hook buffer InsertChar \n %{write}
    hook buffer ModeChange pop:insert:normal %{write}
    hook buffer NormalKey d %{write}
    hook buffer NormalKey p %{write}
}


eval %sh{kak-lsp --kakoune -s $kak_session}
#eval %sh{kak-lsp}
hook -group lsp-filetype-nu global BufSetOption filetype=nu %{
    set-option buffer lsp_servers %{
        [nu-language-server]
        root_globs = [".nu"]
        command = "nu"
        args = ["lsp"]
    }
}

lsp-enable

#source "%val{config}/plugins/shellcheck.kak/shellcheck.kak"
#hook -group lsp-filetype-sh global BufSetOption filetype=sh %{
#    shellcheck-enable
#}

source ~/.config/kak/keys
