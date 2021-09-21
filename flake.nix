{

  description = "Duotonic colorscheme for {neo,}vim";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  };

  outputs =
    { self
    , nixpkgs
    , ...
    } @ rest:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        }
      );
    in
    {

      overlay = final: prev: rec {
        vim-colors-plain =
          with final; pkgs.vimUtils.buildVimPlugin {
            pname = "vim-colors-plain";
            version = "0.1.0";
            src = ./.;
          };
      };

      packages = forAllSystems (system:
        {
          inherit (nixpkgsFor."${system}") vim-colors-plain;
        }
      );

      defaultPackage =
        forAllSystems (system: self.packages."${system}".vim-colors-plain);

    };

}
