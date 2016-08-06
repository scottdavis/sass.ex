# Libsass.ex
Libsass 3.3.6 bindings for elixir
## Use

```shell
mix compile
iex -S mix
```

```elixir
Sass.compile "#navbar {width: 80%;height: 23px;ul { list-style-type: none; } li {float: left; a { font-weight: bold; } } }"
#=> {:ok, "#navbar {\n  width: 80%;\n  height: 23px; }\n  #navbar ul {\n    list-style-type: none; }\n  #navbar li {\n    float: left; }\n    #navbar li a {\n      font-weight: bold; }\n"}

Sass.compile_file "test/sample_scss.scss"
#=> {:ok, "/* sample_scss.scss */\n#navbar {\n  width: 80%;\n  height: 23px; }\n  #navbar ul {\n    list-style-type: none; }\n  #navbar li {\n    float: left; }\n    #navbar li a {\n      font-weight: bold; }\n"}
```

## License

[MIT/X11](./LICENSE)

Copyright (c) 2014 Daniel Farrell

## Credit

Based on sass.ex by [Daniel Farrell](https://github.com/danielfarrell/sass.ex)
