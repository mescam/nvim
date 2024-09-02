{
  description = "Neovim configuration with lazy.vim";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly.url = "github:neovim/neovim";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly }:
    let
      system = "x86_64-linux"; # Adjust this based on your system architecture
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [
          pkgs.neovim
          pkgs.ripgrep
          pkgs.fzf
          pkgs.git
          pkgs.nodejs
          pkgs.python3
          pkgs.pip
        ];

        # Include additional LSPs, linters, etc.
        buildInputs = [
          pkgs.lua-language-server
          pkgs.pyright
          pkgs.bash-language-server
          pkgs.efm-langserver  # For linting and formatting
        ];

        shellHook = ''
          export PATH=$HOME/.local/bin:$PATH
          alias vim=nvim
        '';
      };

      # Home Manager module for Neovim
      homeManagerConfigurations.default = home-manager.lib.homeManagerConfiguration {
        inherit system;
        pkgs = pkgs;

        home = {
          username = "your-username";
          homeDirectory = "/home/your-username";

          packages = [
            pkgs.neovim
            pkgs.ripgrep
            pkgs.fzf
            pkgs.git
            pkgs.nodejs
            pkgs.python3
          ];

          services.neovim = {
            enable = true;
            package = pkgs.neovim;
            withNodeJs = true;
            withPython = true;
            withRuby = false;
            withLua = true;
          };

          programs.neovim = {
            enable = true;
            package = pkgs.neovim;

            # Reference the directory containing your init.lua and other Lua files
            extraConfig = builtins.readFile ./init.lua;

          };
        };
      };

      # Standalone usage
      devShell.${system} = self.packages.${system}.default;
    };
}

