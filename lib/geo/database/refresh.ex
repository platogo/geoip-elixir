defmodule GEO.Database.Refresh do
  @moduledoc """
  GeoIP database refresh GenServer behaviour implementation.

  The worker will download the GeoIP database if it is missing, and will redownload it if it becomes expired.
  """
  require Logger

  use GenServer

  @name __MODULE__
  @refresh_interval :timer.hours(24)

  # Client API

  @spec start_link([]) :: :ignore | {:error, any} | {:ok, pid}
  def start_link([]) do
    GenServer.start_link(@name, :ok, name: @name)
  end

  @spec refresh(boolean()) :: :error | :ok
  def refresh(reload \\ true) do
    if refresh?() do
      with {:ok, file} <- do_download_database(),
           :ok <- File.write(GEO.Database.source_path(), file) do
        if(reload, do: Geolix.reload_databases())
      else
        :ignore ->
          :ok

        {:error, error} ->
          Logger.error("Failed to refresh database, reason: #{error}")
          :error

        _ ->
          :error
      end
    else
      :ok
    end
  end

  # Callbacks

  @impl true
  @spec init(:ok) :: {:ok, nil}
  def init(:ok) do
    Process.send(self(), :refresh, [])
    {:ok, nil}
  end

  @impl true
  def handle_info(:refresh, state) do
    case refresh() do
      :ok -> Process.send_after(self(), :refresh, @refresh_interval)
      :error -> Process.send_after(self(), :refresh, :timer.minutes(2))
    end

    {:noreply, state}
  end

  # Decides whether to refresh the GeoIP DB. It will be refreshed if the file does not exist yet or it is
  # older than the refresh interval
  defp refresh? do
    cond do
      Application.get_env(:geo, :disable_refresh) ->
        false

      !File.exists?(GEO.Database.source_path()) ->
        true

      database_time_diff() >= @refresh_interval / 1000 - 60 ->
        true

      true ->
        false
    end
  end

  defp database_time_diff do
    :calendar.datetime_to_gregorian_seconds(:calendar.universal_time()) -
      :calendar.datetime_to_gregorian_seconds(database_last_modified())
  end

  defp database_last_modified do
    GEO.Database.source_path()
    |> File.stat!()
    |> Map.fetch!(:mtime)
  end

  defp do_download_database(license_key \\ Application.get_env(:geo, :maxmind_license_key)) do
    url = "https://download.maxmind.com/app/geoip_download?edition_id=GeoIP2-City&suffix=tar.gz"
    Logger.info("Downloading IP database")

    case HTTPoison.get("#{url}&license_key=#{license_key}") do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> {:ok, body}
      _ -> :error
    end
  end
end
