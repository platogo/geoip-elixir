defmodule GEO.Mixfile do
  use Mix.Project

  def project do
    [
      app: :geo,
      version: "1.5.0",
      elixir: "~> 1.16",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
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
      {:geolix_adapter_mmdb2, "~> 0.6.0"},
      {:httpoison, "~> 2.2"}
    ]
  end
end
