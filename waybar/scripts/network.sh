#!/usr/bin/env bash

IFACE="eno1"
TMP="/tmp/${IFACE}_net.tmp"

RX_NOW=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX_NOW=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

if [[ -f $TMP ]]; then
  read RX_PREV TX_PREV < $TMP
else
  RX_PREV=$RX_NOW
  TX_PREV=$TX_NOW
fi

echo "$RX_NOW $TX_NOW" > $TMP

RX_DELTA=$((RX_NOW - RX_PREV))
TX_DELTA=$((TX_NOW - TX_PREV))

# Convert bytes/s en KB/s ou MB/s
function fmt() {
  local VAL=$1
  if (( VAL > 1048576 )); then
    printf "%dM" $((VAL/1048576))
  elif (( VAL > 1024 )); then
    printf "%dK" $((VAL/1024))
  else
    printf "%dB" "$VAL"
  fi
}

echo "↓ $(fmt $RX_DELTA) ↑ $(fmt $TX_DELTA)"

