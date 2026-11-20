{ pkgs, ... }:

{
  languages.elixir = {
    enable = true;
    package = pkgs.beam.packages.erlang_29.elixir_1_20;
  };
}
