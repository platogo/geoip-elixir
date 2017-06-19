defmodule GEO do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    configure_ip_database()

    children = [
      worker(GEO.Database.Refresh, [])
    ]

    options = [strategy: :one_for_one, name: GEO.Supervisor]
    Supervisor.start_link(children, options)
  end

  defp configure_ip_database() do
     Geolix.load_database(%{
       id: :city,
       adapter: Geolix.Adapter.MMDB2,
       source: GEO.Const.encode(:ip_database_file)
     })
  end

  # Refresh database file during compilation
  {:ok, _started} = Application.ensure_all_started(:httpoison)
  case GEO.Database.Refresh.refresh(true) do
    :ok -> :ok
    :error -> raise "Could not refresh IP database"
  end
end
