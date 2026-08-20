{ config, pkgs, ... }: {
  users.users."amoreira" = {
    isNormalUser = true;
    description = "Ariel Moreira";
    extraGroups = [ "networkmanager" "wheel" "docker" ];

    # ⚠️ Contraseña para la PRIMERA instalación.
    # Cámbiala por la tuya antes de instalar (después puedes migrar a hashedPassword).
    initialPassword = "cambiame123";
  };
}
