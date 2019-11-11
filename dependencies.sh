#!/bin/bash

chmod +x pull-setup.sh rsync-pull.sh setupdb.sh
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
#apt-cache policy docker-ce
sudo apt install -y docker-ce docker-ce-cli containerd.io
#sudo systemctl status docker
sudo usermod -aG docker ${USER}
sudo apt install -y postgresql-client-common postgresql-client
#id -nG

source /home/ubuntu/.bashrc

# install postgres10 and pgadmin4 as docker
docker pull sameersbn/postgresql:10-2
docker pull fenglc/pgadmin4

# setup the params for postgres
mkdir ~/postgres
cd ~/postgres
docker volume create --driver local --name=pgvolume
docker volume create --driver local --name=pga4volume

docker network create --driver bridge pgnetwork

cat << EOF > pg-env.list
PG_MODE=primary
PG_PRIMARY_USER=postgres
PG_PRIMARY_PASSWORD=!postgres@
PG_DATABASE=suridb
PG_USER=postgres
PG_PASSWORD=!postgres@
PG_ROOT_PASSWORD=!postgres@
PG_TRUST_LOCALNET=true
PG_PRIMARY_PORT=5432
DB_USER=sparty
DB_PASS=sparty
DB_NAME=dbsuri
EOF

cat << EOF > pgadmin-env.list
PGADMIN_SETUP_EMAIL=pgadmin4@pgadmin.org
PGADMIN_SETUP_PASSWORD=admin
SERVER_PORT=5050
EOF


# making sure this isn't running
docker stop postgres pgadmin4
docker rm -v postgres pgadmin4

sudo mkdir -p /var/lib/postgresql /var/lib/pgadmin

docker run -itd --restart always --publish 5432:5432 \
  --volume=pgvolume:/var/lib/postgresql \
  --env-file=pg-env.list \
  --name="postgres" \
  --hostname="postgres" \
  --network="pgnetwork" \
  --detach \
  sameersbn/postgresql:10-2

docker run -itd --restart always --publish 5050:5050 \
  --volume=pga4volume:/var/lib/pgadmin \
  --env-file=pgadmin-env.list \
  --name="pgadmin4" \
  --network="pgnetwork" \
  --detach \
  fenglc/pgadmin4

pull-setup.sh
