{
  description = "Home-Manager module for the CraftOS-PC emulator";

  outputs = { self, nixpkgs, home-manager }: {
    homeManagerModules.default = ./src;
  };
}
