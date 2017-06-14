defmodule Mix.Tasks.Geo.RefreshIpDatabaseTask do
  require Logger

  use Mix.Task

  @shortdoc "Refresh IP database"


  def run(_args) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)

    url = "https://download.maxmind.com/app/geoip_download?edition_id=GeoIP2-City&suffix=tar.gz"
    license_key = Application.get_env(:geo, :maxmind_license_key)
    Logger.info "Downloading IP database"
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get("#{url}&license_key=#{license_key}"),
         :ok <- File.write(Const.encode(:ip_database_file), body) do
      :ok
    else
      _ -> :error
    end
  end
end
