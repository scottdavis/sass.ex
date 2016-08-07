defmodule Mix.Tasks.Compile.Sass do
  use Mix.Task

  @shortdoc "Compiles sass library"
  def run(_) do
    dir = "#{__DIR__}/../../../deps/libsass"
    if !File.dir?(dir) do
      Mix.shell.cmd("git clone --branch 3.3.6 git@github.com:sass/libsass.git #{dir}")
    end
    if Mix.shell.cmd("make") != 0 do
      raise Mix.Error, message: "could not run `make priv/sass.so`. Do you have make and gcc installed?"
    end
  end
end
