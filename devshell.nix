{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    config,
    ...
  }: let
    inherit (pkgs) stdenv go go-tools delve golangci-lint;
    inherit (stdenv) isLinux isDarwin;
  in {
    devshells.default = {
      env = [
        {
          name = "GOROOT";
          value = go + "/share/go";
        }
      ];

      packages = with lib;
        mkMerge [
          [
            go
            go-tools
            delve
            golangci-lint
          ]
          # platform dependent CGO dependencies
          (mkIf isLinux [
            pkgs.gcc
          ])
          (mkIf isDarwin [
            pkgs.darwin.cctools
          ])
        ];
    };
  };
}
