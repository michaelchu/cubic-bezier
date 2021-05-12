defmodule CubicBezier.MixProject do
  use Mix.Project

  @github_url "https://github.com/bjunc/cubic-bezier"

  def project do
    [
      app: :cubic_bezier,
      description: "Elixir implementation of the CSS cubic-bezier function.",
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: %{
        maintainers: ["Robert Juncosa"],
        licenses: ["MIT"],
        links: %{"GitHub" => @github_url}
      },

      # Docs
      name: "Cubic Bezier",
      homepage_url: @github_url,
      docs: [
        main: "getting-started",
        extras: [
          "docs/getting-started.md"
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
