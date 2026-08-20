{ config, pkgs, ... }: {
  # Aquí estaba virtualisation.vmware.guest.enable = true, que solo servía
  # en la máquina virtual donde probaste la configuración.
  # En hardware real no se necesita nada por ahora.
  # Si más adelante usas QEMU/libvirt, puedes agregar por ejemplo:
  #   virtualisation.libvirtd.enable = true;
}
