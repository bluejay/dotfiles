{ config, pkgs, specialArgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = specialArgs.username;
  home.homeDirectory = specialArgs.homeDirectory;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # cli tools
    git-lfs
    entr
    jq
    just
    thefuck
    httpie
    ripgrep
    direnv
    
    # services
    tailscale
    awscli2

    # LSP Servers for nvim
    nil 		       # LSP for Nix
    rust-analyzer  # LSP for Rust

    # Debuggers
    lldb

    # Other
    hledger
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    "./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jaypalekar/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.shellAliases = {
    config = "nvim ~/.config/home-manager";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  ### Git
  programs.git = {
    enable = true;
    
    lfs.enable = true;

    extraConfig = {
      fetch.prune = true;
      pull.rebase = true; 
      push.autoSetupRemote = true;
      core.excludesfile = ''
        .DS_Store
        *.swp
      '';
    };
  };

  ### direnv
  programs.direnv.enable = true;
 
  ### zsh
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
    initExtra = ''
      # Function to check if in Nix shell, get its name, and show in the prompt
      nix_shell_info() {
        if [[ -n "$IN_NIX_SHELL" ]]; then
          if [[ -n "$SHELL_NAME" ]]; then
            echo "($SHELL_NAME)"
          else
            echo "(nix)"
          fi
        fi
      }

      # Modify your prompt to include the Nix shell info
      PROMPT='$(nix_shell_info)'$PROMPT

      # Generate Just completion script
      if [ ! -f ${config.xdg.dataHome}/zsh/site-functions/_just ]; then
        mkdir -p ${config.xdg.dataHome}/zsh/site-functions
        ${pkgs.just}/bin/just --completions zsh > ${config.xdg.dataHome}/zsh/site-functions/_just
      fi
    '';
  };

  ### Neovim
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      # Themes and visuals
      {
        plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          p.lua
          p.nix
          p.rust
          p.python
          p.javascript
          p.typescript
          p.json
          p.yaml
          p.toml
          p.markdown
          p.vim
          p.bash
          p.ocaml
        ]));
        type = "lua";
        config = ''
          require('nvim-treesitter.configs').setup({
            highlight = { enable = true },
            indent = { enable = true },
          })
        '';
      }
    ];

    extraLuaConfig = ''
    '';
  };

  ### tmux
  programs.tmux = {
    enable = true;
    extraConfig = ''
      # use Shift+Tab instead of Ctrl-b
      set-option -g prefix BTab
      unbind C-b
      bind-key BTab send-prefix

      # Position the status bar at the top
      set-option -g status-position top

      # Set the terminal to enable colors
      set-option -ga terminal-overrides ',xterm-256color:Tc'

      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1

      # Move between splits using letter keys
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
    '';

  };

  programs.gh = {
    enable = true;
  };
}
