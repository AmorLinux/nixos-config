{ config, pkgs, ... }: {
  # ==========================================
  # STACK DE VIRTUALIZACIÓN (KVM/QEMU + libvirt)
  # Reemplaza a VMware: 100% open source
  # ==========================================
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;            # TPM emulado (requerido por Windows 11)
      ovmf.enable = true;             # Firmware UEFI para invitados
      ovmf.packages = [ pkgs.OVMFFull.fd ];
    };
  };

  # Redirección de USB a las máquinas virtuales (desde virt-manager)
  virtualisation.spiceUSBRedirection.enable = true;

  # Interfaz gráfica para administrar las VMs
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [ virt-viewer ];
}
