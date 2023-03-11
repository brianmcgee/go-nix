{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    # configure treefmt
    treefmt.config = {
      inherit (config.flake-root) projectRootFile;
      package = pkgs.treefmt;

      programs = {
        gofmt.enable = true;
        alejandra.enable = true;
      };

      settings.formatter = {
        alejandra.excludes = ["test/**/*"];
      };
    };

    # allows us to run treefmt with `nix fmt`
    formatter = config.treefmt.build.wrapper;
  };
}
