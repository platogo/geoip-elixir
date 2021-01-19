defmodule GEO.Mixfile do
  use Mix.Project

  def project do
    [app: :geo,
     version: "1.2.1",
     elixir: "~> 1.11",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {GEO, []}
    ]
  end

  defp deps do
    [
      {:geolix, "~> 2.0"},
      {:httpoison, "~> 1.8"}
    ]
  end
end
