{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            unstable = import nixpkgs-unstable {
              system = prev.system;
            };
          })
        ];
      };
    in
    with pkgs; {
      devShells.default = mkShell {
        buildInputs = [
          shellcheck
          shfmt
        ];
      };

      formatter = nixpkgs-fmt;
    }
    );
}
