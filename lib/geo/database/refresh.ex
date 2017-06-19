defmodule GEO.Database.Refresh do
  require Logger

  use GenServer

  @name __MODULE__
  @minutes_2 2 * 60 * 1000
  @hours_24 24 * 60 * 60 * 1000
  @refresh_interval @hours_24

  def start_link do
    GenServer.start_link(@name, :ok, name: @name)
  end

  def init(:ok) do
    Process.send(self(), :refresh, [])
    {:ok, nil}
  end

  def handle_info(:refresh, state) do
    case refresh() do
      :ok -> Process.send_after(self(), :refresh, @refresh_interval)
      :error -> Process.send_after(self(), :refresh, @minutes_2)
    end
    {:noreply, state}
  end

  def refresh(reload \\ true) do
    if refresh?() do
      with {:ok, file} <- download_database(),
           :ok <- write_database(file)
      do
        case reload do
          true -> Geolix.reload_databases
          false -> :ok
        end
      else
        _ -> :error
      end
    else
      :ok
    end
  end

  defp refresh? do
    case File.exists?(GEO.Const.encode(:ip_database_file)) do
      false -> true
      true -> database_time_diff() >= (@refresh_interval / 1000) - 60
    end
  end

  defp database_time_diff do
    (:calendar.universal_time()
    |> :calendar.datetime_to_gregorian_seconds) -
    (database_last_modified()
    |> :calendar.datetime_to_gregorian_seconds)
  end

  defp database_last_modified do
    GEO.Const.encode(:ip_database_file)
    |> File.stat!
    |> Map.fetch!(:mtime)
  end

  defp download_database do
    url = "https://download.maxmind.com/app/geoip_download?edition_id=GeoIP2-City&suffix=tar.gz"
    license_key = Application.get_env(:geo, :maxmind_license_key)
    Logger.info "Downloading IP database"
    case HTTPoison.get("#{url}&license_key=#{license_key}") do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> {:ok, body}
      _ -> :error
    end
  end

  defp write_database(file) do
    case File.write(GEO.Const.encode(:ip_database_file), file) do
      :ok -> :ok
      {:error, _} -> :error
    end
  end
end
