{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    htop fastfetch python3 nodejs gcc dotnet-sdk
    cargo rustc jdk jetbrains.idea-community android-studio unityhub
    vscode discord zoom-us qbittorrent dbeaver-bin
  ];
}
