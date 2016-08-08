defmodule Sass.Compiler do
  @moduledoc """
    Connection to the NIF for sass
  """

  @on_load { :init, 0 }

  defp app do
    Mix.Project.config[:app]
  end

  defp path do
    case :code.priv_dir(app) do
      {:error, :bad_name} ->
        :filename.join [:filename.dirname(:code.which(app)), '..', 'priv']
      dir ->
        dir
    end
  end

  @doc """
    Loads the sass.so library
  """
  def init do
    :ok = :erlang.load_nif(:filename.join(path, 'sass_nif'), 0)
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

end
