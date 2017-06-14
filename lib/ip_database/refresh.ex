defmodule GEO.RefreshDatabase do
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

  def refresh? do
    case File.read(Const.encode(:ip_database_file)) do
      {:error, _} -> true
      {:ok, _} -> database_time_diff() >= (@refresh_interval / 1000) - 60
    end
  end

  defp database_time_diff do
    (:calendar.universal_time()
    |> :calendar.datetime_to_gregorian_seconds) -
    (database_last_modified()
    |> :calendar.datetime_to_gregorian_seconds)
  end

  defp database_last_modified do
    Const.encode(:ip_database_file)
    |> File.stat!
    |> Map.fetch!(:mtime)
  end

  defp refresh do
    if refresh?() do
      case Mix.Tasks.Geo.RefreshIpDatabaseTask.run(nil) do
        :ok -> Geolix.reload_databases
        :error -> :error
      end
    else
      :ok
    end
  end
end
