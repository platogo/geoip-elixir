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
      with {:ok, file} <- download_database(),
           :ok <- File.write(GEO.Database.source_path(), file) do
        if(reload, do: Geolix.reload_databases(), else: :ok)
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

      database_expired?() ->
        true

      true ->
        false
    end
  end

  defp database_time_diff do
    :calendar.datetime_to_gregorian_seconds(:calendar.universal_time()) -
      :calendar.datetime_to_gregorian_seconds(database_last_modified())
  end

  defp database_expired? do
    database_time_diff() >= @refresh_interval / 1000 - 60
  end

  defp database_last_modified do
    GEO.Database.source_path()
    |> File.stat!()
    |> Map.fetch!(:mtime)
  end

  defp download_database() do
    url = "https://download.maxmind.com/geoip/databases/GeoIP2-City/download?suffix=tar.gz"
    Logger.info("Downloading IP database")

    with {:ok, authorization_header} <- authoriziation_header(),
         {:ok, %HTTPoison.Response{headers: headers, status_code: 302}} <-
           HTTPoison.get(url, [authorization_header]),
         {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           HTTPoison.get(Map.new(headers)["Location"], [], timeout: 200_000, recv_timeout: 200_000) do
      {:ok, body}
    else
      {:error, :maxmind_license_key} ->
        Logger.error("MAXMIND License key not set")
        :ignore

      _ ->
        :error
    end
  end

  defp authoriziation_header do
    case Application.get_env(:geo, :maxmind_license_key) do
      nil -> {:error, :maxmind_license_key_not_set}
      license_key -> {:ok, {"Authorization", "Basic #{Base.encode64("83191:#{license_key}")}"}}
    end
  end
end
