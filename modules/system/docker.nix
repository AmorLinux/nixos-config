{ config, pkgs, ... }: {
  virtualisation.docker.enable = true;

  # ==========================================
  # OMNIROUTE (AI gateway, MIT)
  # No está en nixpkgs: corre como contenedor Docker.
  # Dashboard: http://localhost:20128
  # ==========================================
  virtualisation.oci-containers.containers.omniroute = {
    image = "diegosouzapw/omniroute:latest";
    ports = [ "127.0.0.1:20128:20128" ];
    volumes = [ "omniroute-data:/app/data" ];
    autoStart = true;
  };
}
