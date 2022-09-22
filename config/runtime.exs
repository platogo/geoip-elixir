import Config

geolix_database_path =
  System.get_env(
    "GEOLIX_DATABASE_PATH",
    Path.expand("#{__DIR__}/../priv/geo/ip_database.tar.gz")
  )

config :geo,
  disable_refresh: true,
  database_path: geolix_database_path

config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: geolix_database_path
    }
  ]
