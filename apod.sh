#!/bin/bash
# Automatically download the Astronomy Picture of the Day and set it as
#   the wallpaper for your linux system, and keep a local copy if you desire.
#   User can modify paths at top of script to suit personal needs.
#   Feel free to modify this script as you see fit.
#   Noah Taheij, noah@taheij.nl
#
# Invoke on login using a method appropriate to your desktop manager

###########################################
# CHANGE THE FOLLOWING TO SUIT YOUR NEEDS
imgdir=$HOME/Pictures/apod
tmpimg=$imgdir/default.jpg

# base URL for the APOD website
baseurl=http://apod.nasa.gov/apod/
# base URL plus name of the page where the current picture can be found
sourceurl=${baseurl}astropix.html
tmpfile=/tmp/astropix.html
imgfile=$imgdir/apod.jpg

# attempt to retrieve the astropix page
echo getting page ${sourceurl}
wget ${sourceurl} -T 10 -q -O $tmpfile

if [ $? -ne 0 ]; then
    echo "Unable to retrieve page";
    exit 1;
else
    # extract the image url from the astropix page
    echo getting image url
    imgurl=`cat $tmpfile | grep -i "img src" | sed -e 's/.*<img src="\(.*\)".*/\1/i'`

    # get that image file
    echo getting image ${baseurl}${imgurl}
    wget ${baseurl}${imgurl} -T 10 -q -O $imgfile
    if [ $? -ne 0 ]; then
        echo "Unable to retrieve image"
        exit 2
    else
        case "$1" in
          #--gnome section
          # As far as I can tell, you need to set your wallpaper mode using the Gnome
          #   Control Center first.  I haven't figured out how to script the mode.
          "gnome1")
            #----gnome 1.x
            background-properties-capplet --init-session-settings --background-image="$imgfile"
          ;;
          "gnome22")
            #----gnome 2.x
            # first set no wallpaper, else it won't redraw, then set new wallpaper
            #--------2.2
            gconftool --type=string -s /desktop/gnome/background/picture_filename ""
            gconftool --type=string -s /desktop/gnome/background/picture_filename "$imgfile"
          ;;
          "gnome24")
            #--------2.4
            gconftool-2 -t string -s /desktop/gnome/background/picture_filename ""
            gconftool-2 -t string -s /desktop/gnome/background/picture_filename "$imgfile"
          ;;
          "gnome3")
            gsettings set org.gnome.desktop.background picture-uri "file://$tmpimg"
            sleep 3
            gsettings set org.gnome.desktop.background picture-uri "file://$imgfile"
          ;;
          "kde")
            #--KDE section
            # first set no wallpaper, else it won't redraw, then set new wallpaper
            # Wallpaper mode 6 is stretch to fit screen, look at KDE and DCOP docs
            #   to select a different mode.
            dcop kdesktop KBackgroundIface setWallpaper "" 6
            dcop kdesktop KBackgroundIface setWallpaper $imgfile 6
          ;;
          "fvwm")
            #--fvwm section
            # use built-in wallpaper utility
            fvwm-root "$imgfile"
          ;;
          "fvwm-xv")
            # use this one if you prefer to use xv
            xv -root -max "$imgfile" -quit
          ;;
          "xfce")
            # for versions < 4.6
            xfdesktop -reload
          ;;
          "xfce4")
            for i in 0 1; do
              PROPERTY="/backdrop/screen0/monitor${i}/image-path"
              IMAGE_PATH=`xfconf-query -c xfce4-desktop -p ${PROPERTY}`
              xfconf-query -c xfce4-desktop -p ${PROPERTY} -s "$tmpimg"
              sleep 3;
              xfconf-query -c xfce4-desktop -p ${PROPERTY} -s "$imgfile"
            done
          ;;
          "e17")
            BGWORKPATH=$HOME/.e/e/backgrounds/apod
            cp $imgfile $BGWORKPATH
            WD=`pwd`
            cd $BGWORKPATH
            $BGWORKPATH/build.sh
            enlightenment_remote -restart
            feh --bg-fill "$imgfile"
            cd $WD
          ;;
          "hsetroot")
            hsetroot -fill "$imgfile"
          ;;
	  "i3wm")
	    #set wallpaper using feh
	    feh --bg-fill "$imgfile"
	    #send message to i3wm to refresh the session with new settings
	    i3-msg restart
	  ;;
          *)
            echo "Usage: apod gnome1|gnome22|gnome24|gnome3|kde|fvwm|fvwm-xv|xfce|xfce4|hsetroot|i3wm"
          ;;
        esac
    fi
fi    
# Uncomment the following line if you want to open a mozilla window so you
#   can see what the picture is.
#mozilla ${sourceurl} &
