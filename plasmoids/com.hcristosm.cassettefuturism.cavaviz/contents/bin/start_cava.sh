#!/bin/bash
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$DIR/cava.conf"
RUNTIME_CONF="/tmp/plasma-cavaviz-runtime.conf"
OUT="/tmp/plasma-cavaviz-bars"

pkill -f "cava -p $RUNTIME_CONF" 2>/dev/null

SINK="$(pactl get-default-sink 2>/dev/null)"
if [ -n "$SINK" ]; then
    MONITOR="${SINK}.monitor"
else
    MONITOR="auto"
fi

sed "s/^source = auto/source = ${MONITOR}/" "$CONF" > "$RUNTIME_CONF"

exec cava -p "$RUNTIME_CONF" 2>/tmp/plasma-cavaviz.log | while IFS= read -r line; do
    printf '%s' "$line" > "$OUT"
done
