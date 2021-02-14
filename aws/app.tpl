#!/bin/bash
apt-get -y update; apt-get install -y docker.io git python3-pip postgresql-client
usermod -aG docker ubuntu
pip3 install toml-cli
su - ubuntu -c "git clone https://github.com/servian/TechChallengeApp.git"
su - ubuntu -c "cd TechChallengeApp; toml set --toml-path conf.toml DbUser ${PGUSER}"
su - ubuntu -c "cd TechChallengeApp; toml set --toml-path conf.toml DbPassword ${PGPASS}"
su - ubuntu -c "cd TechChallengeApp; toml set --toml-path conf.toml DbHost ${PGHOST}"
su - ubuntu -c "cd TechChallengeApp; toml set --toml-path conf.toml DbName ${DBNAME}"
su - ubuntu -c "cd TechChallengeApp; toml set --toml-path conf.toml ListenHost 0.0.0.0"
su - ubuntu -c "cd TechChallengeApp; docker build -t servian/techchallengeapp:latest ."
while [ true ]
do
    PGPASSWORD=${PGPASS} psql -h ${PGHOST} -U ${PGUSER} -p 5432 ${DBNAME} -c '\d tasks'
    RET=$?
    # Connecting DB successfully, SQL execution failed.
    if [ "$RET" = "0" ]; then
        echo "DB initialized already."
        break
    # Connecting DB successfully, SQL execution Successful.
    elif [ "$RET" = "1" ]; then
        echo "Table tasks not found. Initializing..."
        su - ubuntu -c "docker run --rm --tty servian/techchallengeapp:latest updatedb -s"
    # Connecting DB failed.
    else
        echo "Connecting DB failed with return code: $RET. Retrying after 10 seconds ..."
        sleep 10
    fi
done
su - ubuntu -c "docker run --name techchallengeapp -p 80:3000 -d servian/techchallengeapp:latest serve"
