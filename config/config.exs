import Config

config :geo,
  maxmind_license_key: System.get_env("MAXMIND_LICENSE_KEY")

import_config "#{Mix.env()}.exs"
