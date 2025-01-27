{
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          lib,
          pkgs,
          self',
          ...
        }:
        let
          langs = lib.mapAttrsToList (k: _v: k) (
            lib.filterAttrs (k: v: k != ".git" && k != ".github" && v == "directory") (builtins.readDir ./.)
          );

          getProjects = lang: builtins.attrNames (builtins.readDir (./${lang}));

          makeOutputs =
            lang:
            builtins.listToAttrs (
              map (
                proj:
                let
                  name = "${lang}_${proj}";
                  path' = ./${lang}/${proj};
                in
                {
                  inherit name;
                  value = {
                    package = pkgs.callPackage path' {
                      inherit name;
                      version = "local";
                      src = path';
                    };
                    devShell = pkgs.mkShell {
                      inputsFrom = [ self'.packages.${name} ];
                      packages = with pkgs; [
                        deadnix
                        git
                        just
                        statix
                      ];
                    };
                  };
                }
              ) (getProjects lang)
            );

          mergeAttrs = attrsList: builtins.foldl' (acc: elem: acc // elem) { } attrsList;
          allOutputs = mergeAttrs (map makeOutputs langs);
        in
        {
          devShells = builtins.mapAttrs (_: v: v.devShell) allOutputs;
          packages = (builtins.mapAttrs (_: v: v.package) allOutputs) // {
            default = self'.packages.mkEnv;
            mkEnv = pkgs.writeShellApplication {
              name = "mkenv.sh";
              runtimeInputs = with pkgs; [ ];
              text = ''
                declare -A colors
                colors=(
                  ["nc"]="\033[0m"
                  ["black"]="\033[0;30m"
                  ["red"]="\033[0;31m"
                  ["green"]="\033[0;32m"
                  ["yellow"]="\033[0;33m"
                  ["blue"]="\033[0;34m"
                  ["magenta"]="\033[0;35m"
                  ["cyan"]="\033[0;36m"
                  ["white"]="\033[0;37m"
                )
                echo -e "''${colors["yellow"]}[#]''${colors["blue"]} Make sure you are in the project root directory.''${colors["nc"]}"
                echo -en "''${colors["yellow"]}[#]''${colors["blue"]} Run the script ?''${colors["nc"]} [''${colors["red"]}N''${colors["nc"]}/''${colors["green"]}y''${colors["nc"]}/''${colors["yellow"]}f(orce)''${colors["nc"]}]: "
                read -r resp
                if [[ $resp == "Y" || $resp == "y" ]]; then
                  for dir in $(echo */*); do
                    flake_output="''${dir/''\\//_}"
                    if ! [[ -f $dir/.envrc ]]; then
                      state="''${colors["green"]}[+]''${colors["blue"]} New .envrc''${colors["nc"]}:"
                      echo -e "use flake .#$flake_output" > "$dir/.envrc"
                      echo -e "$state $dir/.envrc ''${colors["blue"]}->''${colors["nc"]} use flake .#$flake_output"
                    fi
                    if ! [[ -f $dir/default.nix ]]; then
                      state="''${colors["green"]}[+]''${colors["blue"]} New''${colors["nc"]} default.nix:"
                      echo "{ name, version, src, stdenv }: stdenv.mkDerivation { inherit name version src ;}" > "$dir/default.nix"
                      echo -e "$state $dir/default.nix ''${colors["green"]}created''${colors["nc"]}"
                    fi
                  done
                elif [[ $resp == "" || $resp == "N" || $resp == "n" ]]; then
                  echo -e "''${colors["yellow"]}[#]''${colors["red"]} Aborted''${colors["nc"]}"
                elif [[ $resp == "F" || $resp == "f" ]]; then
                  for dir in $(echo */*); do
                    flake_output="''${dir/''\\//_}"
                    state="''${colors["yellow"]}FORCED''${colors["nc"]}: ''${colors["green"]}[+]''${colors["blue"]} New .envrc''${colors["nc"]}:"
                    echo -e "use flake .#$flake_output" > "$dir/.envrc"
                    echo -e "$state $dir/.envrc ''${colors["blue"]}->''${colors["nc"]} use flake .#$flake_output"
                    state="''${colors["yellow"]}FORCED''${colors["nc"]}: ''${colors["green"]}[+]''${colors["blue"]} New''${colors["nc"]} default.nix:"
                    echo "{ name, version, src, stdenv }: stdenv.mkDerivation { inherit name version src ;}" > "$dir/default.nix"
                    echo -e "$state $dir/default.nix ''${colors["green"]}created''${colors["nc"]}"
                  done
                else
                  echo -e "''${colors["red"]}[!]''${colors["blue"]} Input ''${colors["nc"]}$resp''${colors["blue"]} not valid, ''${colors["red"]}aborting''${colors["nc"]}"
                fi
              '';
            };
          };
        };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
}
