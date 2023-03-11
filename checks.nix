{self, ...}: {
  perSystem = {
    self',
    lib,
    pkgs,
    ...
  }: let
    inherit (pkgs) stdenv;
    inherit (stdenv) isDarwin isLinux;
  in {
    checks =
      {
        golangci-lint =
          pkgs.runCommand "golangci-lint" {
            nativeBuildInputs =
              [
                pkgs.go
                pkgs.golangci-lint
              ]
              ++ (lib.optionals isLinux [pkgs.gcc])
              ++ (lib.optionals isDarwin [pkgs.darwin.cctools]);

            GOROOT = pkgs.go + "/share/go";
          } ''
            cp --no-preserve=mode -r ${self} source
            cd source
            HOME=$TMPDIR golangci-lint run
            touch $out
          '';
      } # merge in the package derivations to force a build of all packages during a `nix flake check`
      // (with lib; mapAttrs' (name: nameValuePair "package-${name}") self'.packages);
  };
}
