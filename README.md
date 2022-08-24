# GeoIP Elixir


## Installation

```elixir
def deps do
  [{:geo, git: "git@github.com:platogo/geoip-elixir.git"}, tag: "1.4.5"]
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
