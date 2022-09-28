import Config

config :geo,
  disable_refresh: true

config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.Fake,
      data: %{
        {1, 1, 1, 1} => %{country: %{iso_code: "AT"}, location: %{time_zone: "Europe/Vienna"}},
        {2, 2, 2, 2} => %{country: %{iso_code: "HU"}, location: %{time_zone: "Europe/Budapest"}},
      }
    }
  ]
  # databases: [
  #   %{
  #     id: :city,
  #     adapter: Geolix.Adapter.MMDB2,
  #     source:
  #       System.get_env(
  #         "GEOLIX_DATABASE_PATH",
  #         Path.expand("#{__DIR__}/../priv/geo/ip_database.tar.gz")
  #       )
  #   }
  # ]
