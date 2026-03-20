#!/bin/bash

OUTPUT="eDP-1"
TOUCH_NAME="NTRG0001:01 1B96:1B05"
LAST=""

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

apply_rotation() {
  ORIENTATION="$1"

  [ "$ORIENTATION" = "$LAST" ] && return

  xrandr --output "$OUTPUT" --rotate "$ORIENTATION"
  rotate_touch "$ORIENTATION"
  LAST="$ORIENTATION"
}

monitor-sensor | while read -r line; do
  case "$line" in
    *"normal"*) apply_rotation normal ;;
    *"bottom-up"*) apply_rotation inverted ;;
    *"right-up"*) apply_rotation right ;;
    *"left-up"*) apply_rotation left ;;
  esac
done