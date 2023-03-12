{ lib, pkgs, ... }:
let
    inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  languages.go.enable = true;

  packages = with lib; mkMerge [
    [ pkgs.golangci-lint ]

    # cgo support
    (mkIf isDarwin [
        pkgs.darwin.cctools
    ])
    (mkIf isLinux [
        pkgs.gcc
    ])
  ];

  scripts.lint.exec = "golangci-lint run";
}
