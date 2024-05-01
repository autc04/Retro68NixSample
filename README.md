A sample program for Retr68
========

... with a special focus on demonstrating a Nix-based build setup.


## Install Nix
First, make sure you have Nix installed.
If you're not on NixOS and you haven't already installed Nix, 
I recommend the Determinate Nix Instlaler, a third-party installer for the Nix package manager:
https://install.determinate.systems/.

## Set Up Binary Cache (optional)

A binary cache will save you from compiling all of Retro68 yourself if
it has already been built by a CI build. The binary cache currently contains binaries
for x86_64 Linux and for x86_64 macOS
Apple Silicon users are out of luck for now as there is a shortage of
free build servers for that platform. You can skip this step.

First, install Cachix according to the instructions at https://www.cachix.org/

Then, run `cachix use autc04` to set up your system to use the `autc04` binary cache from cachix.org.

## Update the lockfile

The `flake.lock` file defines what version of Retro68 is being used.
Use the `nix flake update` command to update everything to the newest version.

## Running a complete build

You can build the entire project from scratch using the `nix build` command.
The output can be found as a MacBinary file in the `result` directory created by that command.

By default, a fat binary (a combination of M68K and PowerPC code) is created.
You can also use `nix build .#m68k` or `nix build .#powerpc` to build only for one architecture.

## Entering a dev shell

Use `nix develop` to enter a development shell with tools for 68K development.
Alternatively, use `nix develop .#powerpc` to get a developmnet shell with PowerPC tools instead.

### Build using CMake

In your development shell, environment variables are automatically set up
so that you do not need to set a toolchain file for CMake:

```
mkdir build
cd build
cmake .. -G Ninja
ninja
```

## Install DirEnv (optional)

Direnv is a tool that will automatically set up the Nix development shell as soon
as you change into this directory. See https://direnv.net/.

After installing it according to the instructions, use the `direnv allow` command
to tell direnv that it is allowed to trust this directory.

## Direnv in VS Code (optional)

This workspace recommends the Martin Kühl's direnv extension;
this extension uses direnv (if installed) to provide the development environment to 
commands run by VSCode.

With this installed, you should be able to use vscode's built-in CMake support to
build your code from the IDE.
