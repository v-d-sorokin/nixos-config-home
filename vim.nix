{ pkgs ? import <nixpkgs> {} }:

let
  vimrc = import ./vimrc.nix { pkgs = pkgs; };
  my_vim = pkgs.vim_configurable.customize {
    # Specifies the vim binary name.
    # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
    # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
    name = "vi";
    vimrcConfig.customRC = vimrc.config;
    # Use the default plugin list shipped with nixpkgs
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [
        { names = [
            # Here you can place all your vim plugins
            # They are installed managed by `vam` (a vim plugin manager)
            "Syntastic"
            "ctrlp"
            "haskell-vim"
            "Solarized"
            "vim-nix"
            "rainbow"
            "rainbow_parentheses"
            "stylish-haskell"
            "ghc-mod-vim"
            "vimproc"
            "haskellConceal"
            "haskellConcealPlus"
        ]; }
    ];
  };
in
  my_vim
