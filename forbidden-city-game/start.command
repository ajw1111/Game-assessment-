#!/bin/sh
# The Blue Vase — start the local server (game + macOS system voices).
cd "$(dirname "$0")" || exit 1
exec /usr/bin/python3 tts_server.py
