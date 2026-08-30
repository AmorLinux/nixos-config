{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    htop fastfetch python3 nodejs gcc dotnet-sdk
    cargo rustc jdk jetbrains.idea-community android-studio unityhub
    vscodium discord zoom-us qbittorrent dbeaver-bin
  ];
}
