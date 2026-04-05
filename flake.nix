{
  description = "elixir-phoenix-metamodel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        systemInputs = with pkgs; [
          beam27Packages.elixir
          beam27Packages.elixir-ls
          nodejs
          inotify-tools
        ];
      in {
        devShell = pkgs.mkShell {
          name = "elixir-phoenix-metamodel";
          buildInputs = systemInputs;
          shellHook = ''
            export EDITOR=nano
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath [
              pkgs.beam27Packages.elixir
              pkgs.beam27Packages.elixir-ls
            ]};
          '';
        };
      });
}
