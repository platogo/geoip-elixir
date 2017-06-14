defmodule GEO do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(GEO.RefreshDatabase, [])
    ]

    options = [strategy: :one_for_one, name: GEO.Supervisor]
    Supervisor.start_link(children, options)
  end

  # Refresh database file during compilation
  if GEO.RefreshDatabase.refresh? do
    case Mix.Tasks.Geo.RefreshIpDatabaseTask.run(nil) do
      :ok -> :ok
      :error -> raise "Could not refresh IP database"
    end
  end
end
