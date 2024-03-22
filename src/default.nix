{ config, lib, pkgs, ... }:

let
  cfg = config.programs.craftos-pc;
  jsonFormat = pkgs.formats.json { };
  defaultConfig = (builtins.fromJSON "${builtins.readFile ./global.json}");
in
{
  meta.maintainers = [ lib.maintainers.tomodachi94 ];

  options.programs.craftos-pc = {
    enable = lib.mkEnableOption "ComputerCraft emulator";

    package = lib.mkPackageOption pkgs "craftos-pc" { };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = jsonFormat.type; };
      default = (defaultConfig // {
        # Overrides
        configReadOnly = true;
        lastVersion = "v${cfg.package.version}";
      });
      example = lib.literalExpression ''
        {
          computerSpaceLimit = 200000;
          standardsMode = true;
        };
      '';
      description = ''Configuration written to {file}`$XDG_DATA_HOME/craftos-pc/config/global.json`.
      
    For more on valid options and their defaults, please see the documentation at https://www.craftos-pc.cc/docs/config.

    This module changes two defaults:
      - configReadOnly is set to true, as the Nix Store is read-only and any write operation from the application would fail. Unfortunately, this means that _all_ computer-specific config files must be specified through Home-Manager.
    - lastVersion is set to the _current_ version of the current Nix package, as this is a piece of state and is not deterministic.

    These defaults can be overrided if desired, but they have been deliberately set to avoid breakage, so exercise caution.
    '';
    };

    computers = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          id = lib.mkOption {
            type = lib.types.ints.s32; # https://github.com/MCJack123/craftos2/issues/350
            description = ''
              ID of the computer configured in
              {file}`$XDG_DATA_HOME/craftos-pc/computer/`.
            '';
          };
          settings = lib.mkOption {
            type = lib.types.submodule { freeformType = jsonFormat.type; };
            example = lib.literalExpression ''
              {
                computerSpaceLimit = 200000;
                standardsMode = true;
              };
            '';
          };
        };
      });
      default = [ ];
      description = ''
        List of computers to be configured in {file}`$XDG_DATA_HOME/craftos-pc/computer/`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];


    xdg.dataFile =
      let
        globalConfig = lib.optionalAttrs (cfg.settings != defaultConfig) {
          "craftos-pc/config/global.json" = { source = (jsonFormat.generate "craftos-pc-global.json" cfg.settings); };
        };
        computerConfigToAttrs = i: {
          "craftos-pc/config/${builtins.toString i.id}.json" = { source = (jsonFormat.generate "craftos-pc-computer-${builtins.toString i.id}.json" i.settings); };
        };
      in
      globalConfig // (lib.foldl' lib.mergeAttrs { } (map computerConfigToAttrs cfg.computers));
  };

}
