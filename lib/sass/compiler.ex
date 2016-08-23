defmodule Sass.Compiler do
  @moduledoc """
    Connection to the NIF for sass
  """

  @on_load { :init, 0 }
  @nifname 'sass_nif'

  defp app do
    :sass
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

 @doc """
    A noop that gets overwritten by the NIF compile_file
  """
  def version() do
    exit(:nif_library_not_loaded)
  end

  @doc false
  defp nif_path do
    case :code.priv_dir(app) do
      {:error, :bad_name} ->
        case :filelib.is_dir(:filename.join(['..', '..', 'priv'])) do
          true ->
            :filename.join(['..', '..', 'priv', @nifname])
          _ ->
            :filename.join(['priv', @nifname])
        end
      dir ->
        :filename.join(dir, @nifname)
    end
  end
end
