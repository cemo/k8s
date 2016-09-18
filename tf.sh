#!/bin/bash
set -e
set -o pipefail

# FORMATTING ###################################################################

DEFAULT=`tput sgr0`
BOLD=`tput bold`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
CYAN=`tput setaf 6`

# FUNCTIONS ####################################################################

# log - log to console with color output
function log {
  if [ $# -lt 2 ]; then
    local log_msg="$1"
  else
    local log_type="$1"
    local log_msg="$2"
  fi
  case "$log_type" in
    info) echo -e "\n${BOLD}${CYAN}${log_msg}${DEFAULT}" ;;
    error) echo -e "\n${BOLD}${RED}ERROR: ${log_msg}${DEFAULT}\n" ;;
    *) echo -e "\n${log_msg}" ;;
  esac
}

# remote-config - read and set the config for remote state
TF_REMOTE_CONFIG="${TF_REMOTE_CONFIG:-$(git rev-parse --show-toplevel)/.remote}"
if [ ! -f "$TF_REMOTE_CONFIG" ]; then
  unset TF_REMOTE_CONFIG
fi
function remote-config {
  local var="$1"
  local tfvar=TF_VAR_$var
  if [ -n "${!tfvar}" ]; then
    return 0
  fi
  if [ -n "$TF_REMOTE_CONFIG" ]; then
    eval $tfvar="$(jq -r ".$var" "$TF_REMOTE_CONFIG")"
    [ "${!tfvar}" == "null" ] && unset $tfvar
  fi
  while [ -z "${!tfvar}" ]; do
    read -p "${BOLD}Enter value for '$var': ${DEFAULT}" $tfvar
  done
  eval $tfvar="$(echo "${!tfvar}" | tr '[:upper:]' '[:lower:]')"
  export $tfvar
}

# MAIN #########################################################################

# Set config
remote-config remote_state_region
remote-config remote_state_bucket
remote-config remote_state_kms_key_id
remote-config name
remote-config environment

# Set the s3 key
if [ -z "$TF_VAR_s3_key" ]; then
  export TF_VAR_s3_key="${TF_VAR_name}/${TF_VAR_environment}/$(basename `pwd`).tfstate"
fi

# Log S3 info
log info "S3 INFO"
echo "${BOLD}REGION:${DEFAULT} $TF_VAR_remote_state_region"
echo "${BOLD}BUCKET:${DEFAULT} $TF_VAR_remote_state_bucket"
echo "${BOLD}KEY:   ${DEFAULT} $TF_VAR_s3_key"
echo

# Clean up any old state to avoid conflicts with the remote
find . -name "*.tfstate*" -type f -delete

# Configure the remote state
terraform remote config \
  -backend=s3 \
  -backend-config="region=$TF_VAR_remote_state_region" \
  -backend-config="bucket=$TF_VAR_remote_state_bucket" \
  -backend-config="encrypt=true" \
  -backend-config="kms_key_id=$TF_VAR_remote_state_kms_key_id" \
  -backend-config="key=$TF_VAR_s3_key"

# Get any modules
log info "Getting modules..."
terraform get

# Execute terraform
log info "Executung terraform..."
terraform $@
