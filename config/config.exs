use Mix.Config

config :geo,
  maxmind_license_key: System.get_env("MAXMIND_LICENCE_KEY")

import_config "#{Mix.env}.exs"
