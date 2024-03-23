# nix-craftos-pc
This is a Home-Manager module for the [CraftOS-PC emulator](https://craftos-pc.cc).

It includes options for:
* Configuring your global settings (the ones that apply to all computers)
* Configuring individual computers

It plans to include:
* Options for setting the root filesystem of computers to a specific directory
* Options for linking specific files from the store into individual computer directories

This will also become the home of the NixOS module for CraftOS-PC, which will include options for:
* Configuring plugins for CraftOS-PC
* Configuring custom ROMs for CraftOS-PC

## Usage

Add this to your `inputs` section of your flake:

```nix
nix-craftos-pc = {
  url = "github:tomodachi94/nix-craftos-pc";
};
```

Then, add it to your `modules` list inside of your HM configuration:

```nix
outputs = { nixpkgs, home-manager, nix-craftos-pc, ... }: {
  homeConfigurations.myUsername = home-manager.lib.homeManagerConfiguration {
    # ...
    modules = [
      nix-craftos-pc.homeManagerModules.default
      ./home.nix
    ];
  };
};
```

Run `nix flake lock --update-input nix-craftos-pc` to update your flake inputs, and you should be able to access all options through the `programs.craftos-pc` module.

## Support

Feel free to open an issue if you encounter any issues. For a more informal space for discussion, feel free to join the [Discord server](https://discord.gg/Xs3VKNJrMb).

## Stability

`nix-craftos-pc` is in eternal beta. The maintainers will attempt to keep the module's options stable, but they will inevitably change as `nix-craftos-pc` and CraftOS-PC itself evolve.

## License

`nix-craftos-pc` is copyrighted by individual contributors and is licensed under the MIT License.

`src/global.json` is copyrighted by JackMacWindows and licensed under the MIT License. It is used under the provisions of that license.
