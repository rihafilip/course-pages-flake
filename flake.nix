{

  description = "Course Pages Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        node = pkgs.nodejs_24;
      in
      {
        packages = rec {
          course-pages =
            let
              version = "v0.11.0";
            in
            pkgs.stdenv.mkDerivation {
              name = "course-pages";
              src = ./src/course-pages-${version}.tar.gz;

              buildInputs = [ node ];

              installPhase = ''
                runHook preInstall

                mkdir -p $out/bin
                cp -r ./* $out/bin

                ln -s $out/bin/course-pages.js $out/bin/course-pages

                runHook postInstall
              '';
            };

          default = course-pages;
        };

        apps = {
          default = {
            type = "app";
            program = "${self.packages.${system}.course-pages}/bin/course-pages";
          };
        };
      }
    );
}
