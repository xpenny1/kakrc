source ~/.config/kak/colors
add-highlighter global/ number-lines -relative

hook global InsertChar \t %{ exec -draft -itersel h@ }                      
set global tabstop 4                                                        
set global indentwidth 4   

#map global normal <s-t> %{:info 'Test?'<ret>}
#map global normal <s-r> %{:w; info -markup %sh{export kak_buffile=$kak_buffile; sh ~/.config/kak/compile.sh 2>&1}<ret>}


eval %sh{kak-lsp --kakoune -s $kak_session}
#eval %sh{kak-lsp}
lsp-enable

source ~/.config/kak/keys
