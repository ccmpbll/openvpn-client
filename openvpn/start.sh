#!/bin/bash

#Check Env for config file name
if [[ "${OPENVPN_CONF}" == "NONE" ]]; then
  echo "OpenVPN config not provided. Exiting."
  exit 1
fi  

#Check if config file exists
if [[ -f "${CONFIG_PATH}/${OPENVPN_CONF}" ]]; then
  echo "Using supplied OpenVPN config: ${CONFIG_PATH}/${OPENVPN_CONF}"
else
  echo "Supplied OpenVPN config ${CONFIG_PATH}/${OPENVPN_CONF} could not be found."
  exit 1
fi

#Add OpenVPN user/pass
if [[ "${OPENVPN_USER}" == "NONE" ]] || [[ "${OPENVPN_PASS}" == "NONE" ]] ; then
  if [[ ! -f /config/openvpn-credentials.txt ]] ; then
    echo "OpenVPN credentials not provided. Exiting."
    exit 1
  fi
  echo "Found existing OpenVPN credentials..."
else
  echo "Setting OpenVPN credentials..."
  echo "${OPENVPN_USER}" > /config/openvpn-credentials.txt
  echo "${OPENVPN_PASS}" >> /config/openvpn-credentials.txt
  chmod 600 /config/openvpn-credentials.txt
fi

if [[ -z "${OPENVPN_OPTS}" ]]; then
  OPENVPN_OPTS = "--auth-user-pass /config/openvpn-credentials.txt"  
else
  OPENVPN_OPTS+=" --auth-user-pass /config/openvpn-credentials.txt"
fi

#If we use LOCAL_NETWORK we need to grab network config info
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
