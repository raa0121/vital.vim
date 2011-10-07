Dir.glob('autoload/vital/__latest__/**/*.vim') do |f|
  modname = f[/autoload\/vital\/__latest__\/(.*?)\.vim/, 1].
    gsub(/(\w)(\w+)/) { $1.upcase + $2 }.gsub('/', '.')
  str_deps = File.read(f)[/function! s:dependencies\(\)\n\s*return (.*?)\s+endfunction\n/m, 1]
  deps = str_deps ? eval(str_deps) : [] # this can be dangerous
  p [modname, deps]
end
