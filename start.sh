#!/bin/bash
set -e

if [ -z "$AZP_URL" ]; then
  echo 1>&2 "error: missing AZP_URL environment variable"
  exit 1
fi

if [ -z "$AZP_USERNAME" ]; then
  echo 1>&2 "error: missing AZP_USERNAME environment variable"
  exit 1
fi

if [ -z "$AZP_PSWD_FILE" ]; then
  if [ -z "$AZP_PSWD" ]; then
    echo 1>&2 "error: missing AZP_PSWD environment variable"
    exit 1
  fi

  AZP_PSWD_FILE=/azp/.pswd
  echo -n $AZP_PSWD > "$AZP_PSWD_FILE"
fi

unset AZP_PSWD

if [ -n "$AZP_WORK" ]; then
  mkdir -p "$AZP_WORK"
fi

export AGENT_ALLOW_RUNASROOT="1"

cleanup() {
  if [ -e config.sh ]; then
    print_header "Cleanup. Removing Azure Pipelines agent..."

    # If the agent has some running jobs, the configuration removal process will fail.
    # So, give it some time to finish the job.
    while true; do
      ./config.sh remove --unattended --auth Negotiate --username $("$AZP_USERNAME") --password $(cat "$AZP_PSWD_FILE") && break

      echo "Retrying in 30 seconds..."
      sleep 30
    done
  fi
}

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

# Let the agent ignore the token env variables
export VSO_AGENT_IGNORE=AZP_PSWD,AZP_PSWD_FILE

source ./env.sh

print_header "1. Configuring Azure Pipelines agent..."

./config.sh --unattended \
  --agent "${AZP_AGENT_NAME:-$(hostname)}" \
  --url "$AZP_URL" \
  --auth negotiate \
  --username "$AZP_USERNAME" \
  --password $(cat "$AZP_PSWD_FILE") \
  --pool "${AZP_POOL:-Default}" \
  --work "${AZP_WORK:-_work}" \
  --replace \
  --acceptTeeEula & wait $!
AZP_PSWD=***
print_header "2. Running Azure Pipelines agent..."

trap 'cleanup; exit 0' EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

# To be aware of TERM and INT signals call run.sh
# Running it with the --once flag at the end will shut down the agent after the build is executed
./run.sh "$@" &

wait $!