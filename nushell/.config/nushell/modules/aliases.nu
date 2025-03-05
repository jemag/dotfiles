export alias ll = ls -ls
export alias la = ls -las
export alias tf = terraform
export alias tg = terragrunt
export alias g = git
export alias n = nvim

#NOTE: this would be how to define a function that we can now use wihtin the nushell
export def hello [] {
  print "hello"
}
