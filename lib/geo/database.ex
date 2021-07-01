defmodule GEO.Database do
  def source_path do
    Application.get_env(:geo, :database_path, "#{:code.priv_dir(:geo)}")
     |> Path.join("ip_database.tar.gz")
  end
end
