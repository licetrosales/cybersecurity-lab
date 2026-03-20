#!/bin/bash

DISPLAY="eDP-1"
TOUCH_NAME="NTRG0001:01 1B96:1B05"

rotate_touch() {
  case "$1" in
    normal)
      xinput set-prop "$TOUCH_NAME" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
      ;;
    inverted)
      xinput set-prop "$TOUCH_NAME" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
      ;;
    right)
      xinput set-prop "$TOUCH_NAME" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
      ;;
    left)
      xinput set-prop "$TOUCH_NAME" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
      ;;
  esac
}

monitor-sensor | while read -r line; do
  case "$line" in
    *"normal"*)
      xrandr --output "$DISPLAY" --rotate normal
      rotate_touch normal
      ;;
    *"bottom-up"*)
      xrandr --output "$DISPLAY" --rotate inverted
      rotate_touch inverted
      ;;
    *"right-up"*)
      xrandr --output "$DISPLAY" --rotate right
      rotate_touch right
      ;;
    *"left-up"*)
      xrandr --output "$DISPLAY" --rotate left
      rotate_touch left
      ;;
  esac
done