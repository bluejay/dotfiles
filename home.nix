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
    entr
    jq
    thefuck
    
    # services
    tailscale

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
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
  };

  ### Neovim
  programs.neovim = {
    enable = true;

    plugins = let
      fromGitHub = {user, repo, rev, buildScript ? ":"}: pkgs.vimUtils.buildVimPlugin {
        pname = "${pkgs.lib.strings.sanitizeDerivationName repo}";
        version = rev;
        src = builtins.fetchGit {
          url = "https://github.com/${user}/${repo}.git";
          inherit rev;
        };
        inherit buildScript;
      };    
    in
    with pkgs.vimPlugins; [
      # Themes and visuals
      { plugin = (fromGitHub { 
          user = "AlexvZyl"; 
          repo = "nordic.nvim"; 
          rev  = "6819225c693aa7ae0c0b1945aa17fe43218945f3";
        });
        type = "lua";
        config = ''
          vim.opt.termguicolors = true
          vim.cmd('colorscheme nordic')
          require'nordic'.setup({ telescope = { style = 'flat' }})
        '';
      }

      { plugin = vim-airline;
        type = "lua";
        config = ''
          vim.g.airline_theme = 'nordic'
        '';
      }

      # General Use
      vim-fugitive
      vim-rooter
      vim-signature

      { plugin = camelcasemotion;
        type = "lua";
        config = ''
          vim.call('camelcasemotion#CreateMotionMappings', ',')

          -- use ,i to map between inner words in camelcase
          vim.api.nvim_set_keymap('v', ',i', '<Esc>l,bv,e', {})
          vim.api.nvim_set_keymap('o', ',i', ':normal v,i<CR>', {})
        '';
      }

      { plugin = nerdtree;
        type = "lua";
        config = ''
          -- Show hidden files in NERDTree
          vim.g.NERDTreeShowHidden = 1

          -- Open NERDTree with Ctrl-g
          vim.api.nvim_set_keymap('n', '<C-g>', ':NERDTreeToggle<CR>', { silent = true })
        '';
      }


      { plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require('telescope.builtin')
          vim.keymap.set('n', '<C-p>', telescope.find_files, {})
          vim.keymap.set('n', '<C-_>', telescope.live_grep, {})
        '';
      }

      # LSP and Code Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      luasnip

      { plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
            require('nvim-treesitter.configs').setup {
              indent = { enable = true },
              highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
              },
            }
        '';
      }

      # DAP and debuggers
      nvim-dap
      telescope-dap-nvim


    ];

    extraLuaConfig = ''
      ${builtins.readFile ./nvim/general.lua}

      ${builtins.readFile ./nvim/completion.lua}
      ${builtins.readFile ./nvim/debugger.lua}
      ${builtins.readFile ./nvim/lsp.lua}
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
