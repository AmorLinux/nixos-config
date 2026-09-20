{ config, pkgs, ... }: {
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.containers.omniroute = {
    image = "diegosouzapw/omniroute:latest";
    ports = [ "127.0.0.1:20128:20128" ];
    volumes = [ "/.omniroute:/app/data" ];
    autoStart = true;
  };
}
