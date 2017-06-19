defmodule GEO.Const do
  values = [
    ip_database_file: Path.join(:code.priv_dir(:geo), "ip_database.tar.gz")
    ]

  for {key, value} <- values do
    def encode(unquote(key)),   do: unquote(value)
    def decode(unquote(value)), do: unquote(key)
  end
end
