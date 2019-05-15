function fish_user_key_bindings
    bind -k \cF forward-char
    bind -M insert \cF forward-char 
    bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"
end

fzf_key_bindings
