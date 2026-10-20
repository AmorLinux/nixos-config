{ config, pkgs, ... }: {
  virtualisation.docker.enable = true;

  virtualisation.oci-containers.containers.omniroute = {
    image = "diegosouzapw/omniroute:latest";
    ports = [ "127.0.0.1:20128:20128" ];
    volumes = [ "/.omniroute:/app/data" ];
    autoStart = true;
  };

  # PostgreSQL de desarrollo. NOTAS:
  # - El backend oci-containers resuelto es PODMAN (unidades podman-*),
  #   que exige imágenes fully-qualified (docker.io/...) para evitar
  #   ambigüedad de registro.
  # - PG18 cambió el layout de la imagen oficial: VOLUME /var/lib/postgresql
  #   y PGDATA=/var/lib/postgresql/18/docker; el mount correcto es
  #   /var/lib/postgresql (NO /var/lib/postgresql/data como en <=17).
  # - Puerto bindeado SOLO a 127.0.0.1 (no expuesto a la red); por eso
  #   user/password simples de dev son aceptables.
  # Connection string (EF Core / psql):
  #   Host=127.0.0.1;Port=5432;Username=dev;Password=dev;Database=dev
  # Reset total de la BD: sudo podman volume rm postgres-data
  virtualisation.oci-containers.containers.postgres = {
    image = "docker.io/library/postgres:18.6-alpine"; # pineada; igualar a pkgs.postgresql si cambia
    ports = [ "127.0.0.1:5432:5432" ];
    volumes = [ "postgres-data:/var/lib/postgresql" ];
    environment = {
      POSTGRES_USER = "dev";
      POSTGRES_PASSWORD = "dev";
      POSTGRES_DB = "dev";
    };
    autoStart = true;
  };
}
