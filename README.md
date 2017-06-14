# GeoIP Elixir


## Installation


```elixir
def deps do
  [{:geo, git: "git@github.com:platogo/geoip-elixir.git"}]
end
```

Make sure to specify the Maxmind license key in your application:

```
config :geo,
  maxmind_license_key: "your key"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/geo](https://hexdocs.pm/geo).

