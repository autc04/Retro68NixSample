{
  description = "A sample application for Retro68";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    Retro68.url = "github:autc04/Retro68";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      systems =
        [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }:
        let
          application = retroPkgs: retroPkgs.stdenvUniversal.mkDerivation {
            name = "Sample";
            src = ./.;

            nativeBuildInputs = [
              pkgs.cmake
              pkgs.ninja
              pkgs.nixfmt
              inputs'.Retro68.packages.tools
            ];

              # set an environment variable to the full path of the compiler,
              # for use by c_cpp_properties.json for VSCode Intellisense
            FULL_COMPILER_PATH = "${retroPkgs.stdenvUniversal.cc}/bin/${retroPkgs.targetPlatform.config}-g++";
          };
        in {

          packages.m68k =
            application inputs'.Retro68.legacyPackages.pkgsCross.m68k;
          packages.powerpc =
            application inputs'.Retro68.legacyPackages.pkgsCross.powerpc;

          packages.fat = pkgs.runCommand "fat" { } ''
            mkdir -p $out
            ${inputs'.Retro68.packages.tools}/bin/Rez -o $out/Sample.bin \
              --copy ${self'.packages.m68k}/Sample.bin \
              --copy ${self'.packages.powerpc}/Sample.bin \
              --data ${self'.packages.powerpc}/Sample.bin \
              --type 'APPL' --creator '????'
          '';

          packages.default = self'.packages.fat;
          devShells.default = self'.packages.m68k;

          formatter = pkgs.nixfmt;
        };
    };
}
