#!/bin/bash
# Install the APOD Service for login.
#   Noah Taheij, noah@taheij.nl
#
# Invoke on login using a method appropriate to your desktop manager

###########################################

sudo mkdir -p /etc/apod
sudo chmod 755 /etc/apod
sudo cp apod.sh /etc/apod/apod

if [ "$EUID" -ne 1]; then
    echo "You need to be root to run this script."
    exit
fi

case "$1" in
    "gnome1")
        echo "/etc/apod/apod gnome1" >> /etc/profile
    ;;
    "gnome22")
        echo "/etc/apod/apod gnome22" >> /etc/profile
    ;;
    "gnome24")
        echo "/etc/apod/apod gnome24" >> /etc/profile
    ;;
    "gnome3")
        echo "/etc/apod/apod gnome3" >> /etc/profile
    ;;
    "kde")
        echo "/etc/apod/apod kde" >> /etc/profile
    ;;
    "fvwm")
        echo "/etc/apod/apod fvwm" >> /etc/profile
    ;;
    "fvwm-xv")
        echo "/etc/apod/apod fvwm" >> /etc/profile
    ;;
    "xfce")
        echo "/etc/apod/apod xfce" >> /etc/profile
    ;;
    "xfce4")
        echo "/etc/apod/apod xfce4" >> /etc/profile
    ;;
    "e17")
        echo "/etc/apod/apod e17" >> /etc/profile
    ;;
    "hsetroot")
        echo "/etc/apod/apod hsetroot" >> /etc/profile
    ;;
    "i3wm")
        echo "/etc/apod/apod i3wm" >> /etc/profile
    ;;
    *)
        echo "Usage: install.sh gnome1|gnome22|gnome24|gnome3|kde|fvwm|fvwm-xv|xfce|xfce4|hsetroot|i3wm"
    ;;
esac

echo "Installed succesfully."