{ config, pkgs, ... }:
let
    home-manager = builtins.fetchTarball{
        url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    };
in
{
    imports = [
        (import "${home-manager}/nixos")
    ];

    home-manager.users.jacob = {
        nixpkgs.config.allowUnfree = true;

        home.packages = with pkgs;[
            fzf
            neofetch
            zsh
            vscode
            exa
            oh-my-zsh
            ncdu
            neovim
        ];

        programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableAutosuggestions = true;
            dotDir = ".config/zsh";
            plugins = (import ./zsh/plugins.nix) pkgs;
            shellAliases = import ./zsh/aliases.nix;

            history = {
                expireDuplicatesFirst = true;
                ignoreSpace = false;
                save = 15000;
                share = true;
            };
            envExtra = "
                source ~/.config/zsh/plugins/zsh-git-prompt/git-prompt.zsh
                export EDITOR=nvim;
            ";
            oh-my-zsh = {
                enable = true;
                plugins = [ 
                    "git" 
                ];
            };
        };

        programs.fzf = {
            enable = true;
            enableZshIntegration = true;
            defaultOptions = [
                "--height 40%"
                "--layout=reverse"
                "--border"
                "--inline-info"
            ];
        };

        programs.vscode = {
            enable = true;
            extensions = (import ./vscode-extensions.nix) pkgs;
        };

        programs.git = {
            enable = true;
            userName = "Jacob Turner";
            userEmail = "jacob11turner@gmail.com";
        };

    };
}
