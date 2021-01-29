# based on michael abrahamsen's custom blur lock (https://michaelabrahamsen.com/posts/custom-lockscreen-i3lock/)
lighticon="$HOME/.config/i3/lock/lock-light.png"
darkicon="$HOME/.config/i3/lock/lock-dark.png"
tmpbg='/tmp/screen.png'

# take a screenshot
scrot -z "$tmpbg"

# set a threshold value to determine if we should use the light icon or dark
# icon
VALUE="60" #brightness value to compare to

# determine the color of the screenshot
# thanks to [i3lock-fancy](https://github.com/meskarune/i3lock-fancy) for the
# idea of getting the background color to change the icons
COLOR=$(convert "$tmpbg" -gravity center -crop 100x100+0+0 +repage -colorspace hsb \
    -resize 1x1 txt:- | awk -F '[%$]' 'NR==2{gsub(",",""); printf "%.0f\n", $(NF-1)}');

# change the color ring colors to leave the middle of the feedback ring
# transparent and the outside to use either dark or light colors based on the 
# screenshot
if [ "$COLOR" -gt "$VALUE" ]; then #light background, use dark icon
    icon="$darkicon"
else # dark background so use the light icon
    icon="$lighticon"
fi

# blur the screenshot by resizing and scaling back up
convert "$tmpbg" -filter Gaussian -thumbnail 20% -sample 500% -brightness-contrast -10 "$tmpbg"

# overlay the icon onto the screenshot
convert "$tmpbg" "$icon" -gravity center -composite "$tmpbg"

# lock the screen with the color parameters
i3lock -i "$tmpbg"
