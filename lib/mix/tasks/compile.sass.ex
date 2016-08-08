defmodule Mix.Tasks.Compile.Sass do
  use Mix.Task

  @shortdoc "Compiles sass library"
  def run(_) do
    "== Compiling Sass.ex ==" |> IO.puts
    {result, _error_code} = System.cmd("make", ["all"], stderr_to_stdout: true)
    Mix.shell.info result
    path = :filename.join(:code.priv_dir('sass'), 'sass_nif.so')
    if File.exists?(path) do
      "So was created at: #{path}" |> IO.puts
    end
  end
end
