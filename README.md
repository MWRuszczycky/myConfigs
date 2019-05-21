# My Profile Configuration Files

Configuration files in `common/` currently work as is in all of the operating systems I currently use. Configuration files in `nixOS/` are specific to a Dell Inspiron laptop running NixOS. Configuraton files in `mint` are specific to a Dell XPS tower running Linux Mint.

List of configuration files, symlink locations and purpose.

| File          | Symlink               | Purpose                              |
|---------------|-----------------------|--------------------------------------|
| `bash_profile`| `~/.bash_profile`     | Run by XMonad at login               |
| `bashrc`      | `~/.bashrc`           | Run at start of each new shell       |
| `gitconfig`   | `~/.gitconfig`        | Configuration file for Git           |
| `ls-colors`   | No symlink            | Run by `.bashrc` to set `ls` colors  |
| `Xdefaults`   | `~/.Xdefaults`        | Color scheme for uxrvt terminal      |
| `xmobarrc`    | `~/.xmobarrc`         | Configurations for XMobar status bar |
| `Xmodmap`     | `~/.Xmodmap`          | Custom keyboard remappings           |
| `xmonad.hs`   | `~/.xmonad/xmonad.hs` | Configuration file for XMonad        |
