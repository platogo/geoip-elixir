defmodule GEO.Database do
  def source_path do
    Path.join("#{:code.priv_dir(:geo)}", "ip_database.tar.gz")
  end
end
