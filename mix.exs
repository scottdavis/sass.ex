Code.require_file "lib/mix/tasks/compile.libsass.ex"

defmodule Libsass.Mixfile do
  use Mix.Project

  def project do
    [
      app:         :libsass,
      version:     "1.0.0",
      elixir:      "~> 1.3.0",
      compilers:   [:sass, :elixir, :app],
      deps:        deps(Mix.env),
      package:     package,
      description: description,
      compilers: [:elixir_make] ++ Mix.compilers,
      make_clean: ["clean"],
    ]
  end

  def application, do: []

  defp description do
    """
    Libsass for elixir
    """
  end

  defp package do
    [
      maintainers: ["Scott Davis"],
      licenses: ["MIT"],
      contributors: ["Scott Davis"],
      license:      "MIT",
      links: %{
        GitHub: "https://github.com/scottdavis/libsass.ex",
        Issues: "https://github.com/scottdavis/libsass.ex/issues",
        Source: "https://github.com/scottdavis/libsass.ex"
      },
      files: [
        "lib",
        "src",
        "libsass_src",
        "priv",
        "Makefile",
        "mix.exs",
        "README.md",
        "LICENSE"
      ]
    ]
  end

  defp deps(:docs) do
    #[{ :ex_doc, github: "elixir-lang/ex_doc" }]
  end

  defp deps(_) do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
