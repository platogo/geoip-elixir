import Config

config :geo,
  maxmind_license_key:
    System.get_env("MAXMIND_LICENSE_KEY") ||
      raise("""
      environment variable MAXMIND_LICENSE_KEY not set
      This key is needed to download the IP database

      For more information, refer to https://support.maxmind.com/hc/en-us/articles/4407116112539-Using-License-Keys
      """)

import_config "#{Mix.env()}.exs"
