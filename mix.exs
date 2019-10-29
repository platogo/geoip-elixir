defmodule GEO.Mixfile do
  use Mix.Project

  def project do
    [app: :geo,
     version: "1.1.1",
     elixir: "~> 1.9",
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
      {:geolix, "~> 0.18"},
      {:httpoison, "~> 1.6"}
    ]
  end
end
