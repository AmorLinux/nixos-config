{ config, pkgs, ... }: {
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.containers.omniroute = {
    image = "diegosouzapw/omniroute:latest";
    ports = [ "127.0.0.1:20128:20128" ];
    volumes = [ "/.omniroute:/app/data" ];
    autoStart = true;
  };

  # PostgreSQL de desarrollo. Puerto bindeado SOLO a 127.0.0.1 (no expuesto
  # a la red); user/password simples aceptables por eso. Volumen nombrado
  # (evita los problemas de permisos de PG en bind mounts del host).
  # Connection string (EF Core / psql):
  #   Host=127.0.0.1;Port=5432;Username=dev;Password=dev;Database=dev
  # Reset total de la BD: docker volume rm postgres-data
  virtualisation.oci-containers.containers.postgres = {
    image = "postgres:18.6-alpine"; # pineada; igualar a pkgs.postgresql si cambia
    ports = [ "127.0.0.1:5432:5432" ];
    volumes = [ "postgres-data:/var/lib/postgresql/data" ];
    environment = {
      POSTGRES_USER = "dev";
      POSTGRES_PASSWORD = "dev";
      POSTGRES_DB = "dev";
    };
    autoStart = true;
  };
}
