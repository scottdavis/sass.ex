Code.require_file "lib/mix/tasks/compile.sass.ex"

defmodule Sass.Mixfile do
  use Mix.Project

  def project do
    [
      app:         :sass,
      version:     "1.0.3",
      elixir:      "~> 1.3.0",
      compilers:   [:sass, :elixir, :app],
      deps:        deps(),
      package:     package,
      description: description,
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
      }
    ]
  end

  defp deps do
    [
      {:libsass, github: "sass/libsass", tag: "3.3.6", only: :prod, app: false, optional: false},
      {:markdown, github: "devinus/markdown", only: :docs},
      {:ex_doc, "0.13.0", only: :docs},
      {:inch_ex, "~> 0.2", only: :docs},
    ]
  end
end
