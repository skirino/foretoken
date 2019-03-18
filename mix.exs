defmodule Foretoken.MixProject do
  use Mix.Project

  @github_url "https://github.com/skirino/foretoken"

  def project() do
    [
      app:               :foretoken,
      version:           "0.3.0",
      elixir:            "~> 1.6",
      build_embedded:    Mix.env() == :prod,
      start_permanent:   Mix.env() == :prod,
      deps:              deps(),
      description:       "An ETS-based implementation of the token bucket algorithm",
      package:           package(),
      source_url:        @github_url,
      homepage_url:      @github_url,
      test_coverage:     [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
    ]
  end

  def application() do
    [
      mod: {Foretoken.Application, []},
    ]
  end

  defp deps() do
    [
      {:croma      , "~> 0.9"},
      {:dialyxir   , "~> 0.5"   , [only: :dev ]},
      {:ex_doc     , "~> 0.18.0", [only: :dev ]},
      {:excoveralls, "~> 0.10"  , [only: :test]},
    ]
  end

  defp package() do
    [
      files:       ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Shunsuke Kirino"],
      licenses:    ["MIT"],
      links:       %{"GitHub repository" => @github_url},
    ]
  end
end
