#!/bin/bash

monitor-sensor | while read -r line; do
  case "$line" in
    *"normal"*)
      xrandr --output eDP-1 --rotate normal
      ;;
    *"bottom-up"*)
      xrandr --output eDP-1 --rotate inverted
      ;;
    *"right-up"*)
      xrandr --output eDP-1 --rotate right
      ;;
    *"left-up"*)
      xrandr --output eDP-1 --rotate left
      ;;
  esac
done

