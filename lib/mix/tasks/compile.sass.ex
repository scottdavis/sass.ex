defmodule Mix.Tasks.Compile.Sass do
  use Mix.Task

  @shortdoc "Compiles sass library"
  def run(_) do
    if Mix.shell.cmd("make") != 0 do
      raise Mix.Error, message: "could not run `make priv/sass.so`. Do you have make and gcc installed?"
    end
  end
end
