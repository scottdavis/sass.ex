defmodule Libsass do
  @moduledoc """
    Compiles SASS into CSS
  """

  @doc """
    Compiles a string of SASS into a string of CSS
  """
  def compile(string, options \\ %{output_style: sass_style_nested}) do
    sass = string |> String.strip
    Libsass.Compiler.compile(sass, options)
  end

  @doc """
    Compiles a file of SASS into a string of CSS
  """
  def compile_file(path, options \\ %{output_style: sass_style_nested}) do
    filename = path |> String.strip
    Libsass.Compiler.compile_file(filename, options)
  end

  def sass_style_nested, do: 0
  def sass_style_expanded, do: 1
  def sass_style_compact, do: 2
  def sass_style_compressed, do: 3

end
