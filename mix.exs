defmodule Acx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :acx,
      version: "0.0.2",
      elixir: "~> 1.5",
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/2pd/acx-elixir"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :poison]
    ]
  end

  defp description() do
    "A Elixir wrap for API of Acx.io exchange."
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps() do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:decimal, "~> 1.0"},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:ex_doc, "~> 0.14", only: :dev},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp package() do
    [
      name: "acx",
      files: ["lib","mix.exs", "README.md"],
      maintainers: ["Liang Shi"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/2pd/acx-elixir"}
    ]
  end


end
