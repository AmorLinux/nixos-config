{ config, pkgs, ... }: {
  users.users."amoreira" = {
    isNormalUser = true;
    description = "Ariel Moreira";
    extraGroups = [ "networkmanager" "wheel" "docker" ];

    # 🔐 Contraseña provisional para que el repo compile e instale sin editar nada.
    # RECOMENDADO durante la instalación: genera tu hash con
    #     mkpasswd -m sha-512
    # y reemplaza la línea de abajo por:
    #     hashedPassword = "$6$...tu-hash...";
    # El hash sí es seguro commitearlo a GitHub (es irreversible).
    initialPassword = "cambiame123";
  };
}
