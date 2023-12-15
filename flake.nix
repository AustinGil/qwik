{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, rust-overlay, nixpkgs }:
    let
      b = builtins;
      devShell = system: _pkgs:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
        in
        {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              bashInteractive
              gitMinimal

              nodejs_20

              # Qwik optimizer deps
              (rust-bin.fromRustupToolchainFile
                ./rust-toolchain)
              cargo
              clippy
              wasm-pack
            ];
          };
        };
    in
    {
      devShells = b.mapAttrs (devShell) nixpkgs.legacyPackages;
    };
}
