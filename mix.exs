defmodule Sass.Mixfile do
  use Mix.Project

  def project do
    [
      app:         :sass,
      version:     "1.0.19",
      compilers:   [:elixir_make] ++ Mix.compilers,
      deps:        deps(),
      package:     package(),
      description: description(),
      make_clean: ["clean"],
      docs: [logo: "assets/sass.png",
          extras: ["README.md"]],
      name: "Sass.ex",
      source_url: "https://github.com/scottdavis/sass.ex",
      homepage_url: "https://github.com/scottdavis/sass.ex"
    ]
  end

  def application, do: []

  defp description do
    """
    Sass for elixir
    """
  end

  defp package do
    [
      maintainers: ["Scott Davis"],
      licenses: ["MIT"],
      contributors: ["Scott Davis"],
      license:      "MIT",
      links: %{
        GitHub: "https://github.com/scottdavis/sass.ex",
        Issues: "https://github.com/scottdavis/sass.ex/issues",
        Source: "https://github.com/scottdavis/sass.ex"
      },
      files: files()
    ]
  end

  defp files do
    [
      'libsass',
      'lib/**/*',
      'src/*.c',
      'mix.exs',
      'LICENSE',
      'README.*',
      'Makefile'

    ]
  end

  defp deps do
    [
      {:elixir_make, "~> 0.3.0"},
      {:markdown, github: "devinus/markdown", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, "~> 0.2", only: :dev}
    ]
  end
end
