{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    inherit (inputs.gitignore.lib) gitignoreSource;
  in {
    packages = rec {
      gonix = pkgs.buildGoModule {
        name = "gonix";
        src = gitignoreSource ./.;
        vendorSha256 = "sha256-cgplYMWS6OzUTR0qBAUYYf7Pd2g0BuxLUGxXr0/tml4=";
      };
      # set gonix as the default package
      default = gonix;
    };
  };
}
