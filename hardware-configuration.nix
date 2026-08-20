# ⚠️ IMPORTANTE: Este archivo fue generado dentro de una máquina virtual VMware.
# NO lo uses para instalar en tu PC real: los UUIDs de disco y módulos no coinciden.
# Durante la instalación, después de particionar, ejecuta:
#   nixos-generate-config --root /mnt
# y reemplaza este archivo con el /mnt/etc/nixos/hardware-configuration.nix generado.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ahci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/63ce7523-02f2-4de3-9b83-b4d0599aa11d";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/DEE3-E824";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  virtualisation.vmware.guest.enable = true;
}
