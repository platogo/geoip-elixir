defmodule GEO.Mixfile do
  use Mix.Project

  def project do
    [app: :geo,
     version: "1.0.5",
     elixir: "~> 1.4",
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
      {:geolix, github: "elixir-geolix/geolix"},
      {:httpoison, "~> 0.11"}
    ]
  end
end
