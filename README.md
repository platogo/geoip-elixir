# GeoIP Elixir

Wrapper around Geolix that supports periodic refresh of the GeoIP database.

## Installation

```elixir
def deps do
  [{:geo, git: "git@github.com:platogo/geoip-elixir.git"}, tag: "1.4.8"]
end
```

Make sure to specify the Maxmind license key in your application:

```elixir
config :geo,
  maxmind_license_key: "your key"
```

You can also set the env variable `MAXMIND_LICENSE_KEY`.

Use Geolix lookup functions to query for IP addresses. See Geolix readme for further details.

```elixir
Geolix.lookup("8.8.8.8")
```

## Configuration

You can manually disable database refresh completely (useful for tests which don't need the GeoIP database):

```elixir
config :geo, :disable_refresh, true
```

In order to use a fake database, add something similar to the following configuration to your configuration:

```elixir
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
```

In order to use a downloaded database, use the following:

```elixir
geolix_database_path = "/absolute/path/to/ip_database.tar.gz"

config :geo,
  disable_refresh: false,
  database_path: geolix_database_path

config :geolix,
  databases: [
    %{
      id: :city,
      adapter: Geolix.Adapter.MMDB2,
      source: geolix_database_path
    }
  ]
```

## TODO

This should be changed so we no longer use `Application.get_env/2` for configuration, supervision is handled in the including
application, and `Task` is preferred over `GenServer`.
