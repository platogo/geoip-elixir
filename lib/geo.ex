defmodule GEO do
  use Application

  def start(_type, _args) do
    children = [
      GEO.Database.Refresh
    ]

    options = [strategy: :one_for_one, name: GEO.Supervisor]
    Supervisor.start_link(children, options)
  end

  # Refresh database file during compilation
  {:ok, _started} = Application.ensure_all_started(:httpoison)

  case GEO.Database.Refresh.refresh() do
    :ok -> :ok
    :error -> raise "Could not refresh IP database"
  end
end
