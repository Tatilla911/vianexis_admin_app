#!/usr/bin/env bash
# Sync Flutter sound assets to Android res/raw with vn_* names.
# Source of truth: assets/sounds/
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ASSETS="$ROOT/assets/sounds"
RAW="$ROOT/android/app/src/main/res/raw"

declare -A MAP=(
  ["alarm/alarm1.mp3"]="vn_alarm_1.mp3"
  ["alarm/alarm2.mp3"]="vn_alarm_2.mp3"
  ["alarm/alarm3.mp3"]="vn_alarm_3.mp3"
  ["message/message1.mp3"]="vn_message_1.mp3"
  ["message/message2.mp3"]="vn_message_2.mp3"
  ["message/message3.mp3"]="vn_message_3.mp3"
  ["message/message4.mp3"]="vn_message_4.mp3"
  ["ring/ring1.mp3"]="vn_ring_1.mp3"
  ["ring/ring2.mp3"]="vn_ring_2.mp3"
  ["ring/ring3.mp3"]="vn_ring_3.mp3"
  ["ring/ring4.mp3"]="vn_ring_4.mp3"
  ["sign/sign1.mp3"]="vn_sign_1.mp3"
  ["sign/sign2.mp3"]="vn_sign_2.mp3"
  ["sign/sign3.mp3"]="vn_sign_3.mp3"
  ["sign/sign4.mp3"]="vn_sign_4.mp3"
)

mkdir -p "$RAW"

for rel in "${!MAP[@]}"; do
  src="$ASSETS/$rel"
  dst="$RAW/${MAP[$rel]}"
  if [[ ! -f "$src" ]]; then
    echo "Missing source asset: $src" >&2
    exit 1
  fi
  cp "$src" "$dst"
  echo "Synced $rel -> ${MAP[$rel]}"
done

echo "Done. ${#MAP[@]} files synced to $RAW"
