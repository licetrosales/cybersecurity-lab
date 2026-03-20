#!/bin/bash

DISPLAY="eDP-1"
TOUCH_ID="12"

monitor-sensor | while read -r line; do
  case "$line" in
    *"normal"*)
      xrandr --output "$DISPLAY" --rotate normal
      xinput set-prop "$TOUCH_ID" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
      ;;
    *"bottom-up"*)
      xrandr --output "$DISPLAY" --rotate inverted
      xinput set-prop "$TOUCH_ID" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
      ;;
    *"right-up"*)
      xrandr --output "$DISPLAY" --rotate right
      xinput set-prop "$TOUCH_ID" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
      ;;
    *"left-up"*)
      xrandr --output "$DISPLAY" --rotate left
      xinput set-prop "$TOUCH_ID" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
      ;;
  esac
done