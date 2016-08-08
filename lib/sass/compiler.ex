defmodule Sass.Compiler do
  @moduledoc """
    Connection to the NIF for sass
  """

  @on_load { :init, 0 }

  defp app do
    Mix.Project.config[:app]
  end

  @doc """
    Loads the sass.so library
  """
  def init do
    :ok = :erlang.load_nif(nif_path, 0)
  end

  @doc """
    A noop that gets overwritten by the NIF compile
  """
  def compile(_,_) do
    exit(:nif_library_not_loaded)
  end

 @doc """
    A noop that gets overwritten by the NIF compile_file
  """
  def compile_file(_,_) do
    exit(:nif_library_not_loaded)
  end

  @doc false
  defp nif_path,
    do: :filename.join(priv_dir(), 'sass_nif')

  @doc false
  defp priv_dir do
    app
    |> :code.priv_dir
    |> maybe_priv_dir
  end

  @doc false
  defp maybe_priv_dir({:error, _}) do
    app
    |> :code.which
    |> :filename.dirname
    |> :filename.dirname
    |> :filename.join('priv')
  end
  defp maybe_priv_dir(path),
    do: path

end
