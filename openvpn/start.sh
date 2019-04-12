#!/bin/bash
VPN_PROVIDER="${OPENVPN_PROV,,}"
VPN_PROVIDER_CONFIGS="/etc/openvpn/${VPN_PROVIDER}"

if [[ "${OPENVPN_PROV}" == "**None**" ]] || [[ -z "${OPENVPN_PROV-}" ]]; then
  echo "OpenVPN provider not set. Exiting."
  exit 1
elif [[ ! -d "${VPN_PROVIDER_CONFIGS}" ]]; then
  echo "Could not find OpenVPN provider: ${OPENVPN_PROV}"
  echo "Please check your settings."
  exit 1
fi

echo "Using OpenVPN provider: ${OPENVPN_PROV}"

if [[ -n "${OPENVPN_CONF-}" ]]; then
  readarray -t OPENVPN_CONF_ARRAY <<< "${OPENVPN_CONF//,/$'\n'}"
  ## Trim leading and trailing spaces from all entries. Inefficient as all heck, but works like a champ.
  for i in "${!OPENVPN_CONF_ARRAY[@]}"; do
    OPENVPN_CONF_ARRAY[${i}]="${OPENVPN_CONF_ARRAY[${i}]#"${OPENVPN_CONF_ARRAY[${i}]%%[![:space:]]*}"}"
    OPENVPN_CONF_ARRAY[${i}]="${OPENVPN_CONF_ARRAY[${i}]%"${OPENVPN_CONF_ARRAY[${i}]##*[![:space:]]}"}"
  done
  if (( ${#OPENVPN_CONF_ARRAY[@]} > 1 )); then
    OPENVPN_CONF_RANDOM=$((RANDOM%${#OPENVPN_CONF_ARRAY[@]}))
    echo "${#OPENVPN_CONF_ARRAY[@]} servers found in OPENVPN_CONF, ${OPENVPN_CONF_ARRAY[${OPENVPN_CONF_RANDOM}]} chosen randomly"
    OPENVPN_CONF="${OPENVPN_CONF_ARRAY[${OPENVPN_CONF_RANDOM}]}"
  fi

  if [[ -f "${VPN_PROVIDER_CONFIGS}/${OPENVPN_CONF}.ovpn" ]]; then
    echo "Starting OpenVPN using config ${OPENVPN_CONF}.ovpn"
    OPENVPN_CONF="${VPN_PROVIDER_CONFIGS}/${OPENVPN_CONF}.ovpn"
  else
    echo "Supplied config ${OPENVPN_CONF}.ovpn could not be found."
    echo "Using default OpenVPN gateway for provider ${VPN_PROVIDER}"
    OPENVPN_CONF="${VPN_PROVIDER_CONFIGS}/default.ovpn"
  fi
else
  echo "No VPN configuration provided. Using default."
  OPENVPN_CONF="${VPN_PROVIDER_CONFIGS}/default.ovpn"
fi

# add OpenVPN user/pass
if [[ "${OPENVPN_USER}" == "**None**" ]] || [[ "${OPENVPN_PASS}" == "**None**" ]] ; then
  if [[ ! -f /config/openvpn-credentials.txt ]] ; then
    echo "OpenVPN credentials not set. Exiting."
    exit 1
  fi
  echo "Found existing OpenVPN credentials..."
else
  echo "Setting OpenVPN credentials..."
  mkdir -p /config
  echo "${OPENVPN_USER}" > /config/openvpn-credentials.txt
  echo "${OPENVPN_PASS}" >> /config/openvpn-credentials.txt
  chmod 600 /config/openvpn-credentials.txt
fi

## If we use LOCAL_NETWORK we need to grab network config info
if [[ -n "${LOCAL_NETWORK-}" ]]; then
  eval $(/sbin/ip r l | awk '{if ($1 ~ /0.0.0.0|default/ && $5!="tun0") {print "GW="$3"\nINT="$5; exit}}')
fi

if [[ -n "${LOCAL_NETWORK-}" ]]; then
  if [[ -n "${GW-}" ]] && [[ -n "${INT-}" ]]; then
    for localNet in ${LOCAL_NETWORK//,/ }; do
      echo "adding route to local network ${localNet} via ${GW} dev ${INT}"
      /sbin/ip r a "${localNet}" via "${GW}" dev "${INT}"
    done
  fi
fi

exec openvpn ${OPENVPN_OPTS} --config "${OPENVPN_CONF}"
