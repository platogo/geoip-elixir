defmodule GEO.Database do
  @moduledoc false

  @doc """
  Returns the path to the GeoIP database tarball.
  """
  @spec source_path() :: binary
  def source_path() do
    Application.fetch_env!(:geo, :database_path)
  end
end
