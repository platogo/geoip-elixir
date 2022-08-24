defmodule GEO.Database do
  @moduledoc false

  @doc """
  Returns the path to the GeoIP database tarball.
  """
  @spec source_path(file_name :: binary) :: binary
  def source_path(file_name \\ "ip_database.tar.gz") do
    Path.join(
      Application.get_env(:geo, :database_path, "#{:code.priv_dir(:geo)}"),
      file_name
    )
  end
end
