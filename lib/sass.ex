defmodule Sass do
  @moduledoc """
    Compiles SASS into CSS
  """

  @doc """
    Compiles a string of SASS into a string of CSS
  """
  def compile(string) when is_binary(string) do
    string
    |> to_charlist
    |> Sass.Compiler.compile
  end

  #@doc """
    #Compiles a file of SASS into a string of CSS
  #"""
  #def compile_file(path) do
    #path
    #|> String.strip
    #|> Sass.Compiler.compile_file
  #end

end
