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
          # the name of the application, should match name in CMakeLists.txt:
          applicationName = "Sample";

          # creator code for the application, should match creator in CMakeLists.txt:
          applicationCreator = "????";

          # whether to use the universal interfaces (true) or multiversal (false):
          useUniversalInterfaces = false;

          application = retroPkgs:
            let
              stdenv = if useUniversalInterfaces then
                retroPkgs.stdenvUniversal
              else
                retroPkgs.stdenv;
            in stdenv.mkDerivation {
              name = applicationName;
              src = ./.;

              nativeBuildInputs = [
                # build tools and useful tools available in the development shell
                pkgs.cmake
                pkgs.ninja
                pkgs.nixfmt
                inputs'.Retro68.packages.tools
              ];

              buildInputs = [
                # libraries used by the application
              ];

              # set an environment variable to the full path of the compiler,
              # for use by c_cpp_properties.json for VSCode Intellisense
              FULL_COMPILER_PATH =
                "${stdenv.cc}/bin/${retroPkgs.targetPlatform.config}-g++";
            };
        in {

          packages.m68k =
            application inputs'.Retro68.legacyPackages.pkgsCross.m68k;
          packages.powerpc =
            application inputs'.Retro68.legacyPackages.pkgsCross.powerpc;

          packages.fat = pkgs.runCommand "fat" { } ''
            mkdir -p $out
            ${inputs'.Retro68.packages.tools}/bin/Rez -o $out/${applicationName}.bin \
              --copy ${self'.packages.m68k}/${applicationName}.bin \
              --copy ${self'.packages.powerpc}/${applicationName}.bin \
              --data ${self'.packages.powerpc}/${applicationName}.bin \
              --type 'APPL' --creator '${applicationCreator}'
          '';

          # package to build when `nix build` is run without extra arguments
          # (choice of `m68k`, `powerpc`, or `fat`)
          packages.default = self'.packages.fat;

          # platform/package configuration to use for `nix develop` without extra arguments:
          # (choice of `m68k` or `powerpc`)
          devShells.default = self'.packages.m68k;

          formatter = pkgs.nixfmt;
        };
    };
}
