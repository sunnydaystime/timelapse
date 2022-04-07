# create new capture directory on synology
clear
#set interval of images
read -r  -p "Set capture interval in seconds  " interval
interval=$((interval*1000))

#set image resolution
echo "Set your image resolution  "

select res in 1080p 4k
do
echo "Image resolution set at $res"
if [ $res=1080p ]
then
  width=1920
  height=1080
  break
elif [ $res=4k ]
then
  width=4096
  height=2160
  break
fi
done


# set time hours
read -r -p "Set how many hours you want to record the timeslapse  " hours
hours=$((hours*3600000))
# set time minutes
read -r -p "Set how many minutes you want to record the timeslapse  " minutes

minutes=$((minutes*60000))
# set time seconds
read -r -p "Set how many seconds you want to record the timeslapse  " seconds
seconds=$((seconds*1000))

duration=$((hours*minutes*seconds))

# set iso
read -r -p "Enter ISO setting  " iso
if [[ $iso -ge 100 && $iso -le 800 ]]
then
  echo "ISO within range  "
else
  echo "ISO not within range  "
  exit
fi

# set shutter
#read -r -p "Set shutter settings  " shutter

# set white balance
echo "Set white balance  "

select awb in off auto sun cloud shade tungsten fluorescent incandescent flash horizon
  do
    echo "White balance set at $awb "
    break
  done

#  echo $awb

#set exposure
echo "Set exposure"

select exp in off auto night nightpreview backlight spotlight sports snow beach verylong fixedfps antishake fireworks
do
  echo "Exposure set at $exp "
  break
done

read -r -p "Set image quality  " quality
if [[ $quality -ge 1 && $quality -le 100 ]]
then
  echo "Quality within range  "
else
  echo "Quality not within range  "
  exit
fi

#change back time values to human readable
hours=$((hours/3600000))
minutes=$((minutes/60000))
seconds=$((seconds/1000))

intervalsec=$(($interval/1000))

clear

# preview section — create preview images before timelapse
echo "* Here are your values *  "
echo "your white balance setting is:  " $awb
echo "your exposure setting is  " $exp
echo  "your ISO is:  " $iso
echo "your image quality is  " $quality
echo "Your timelapse interval in seconds is:  " $intervalsec
echo "Your resolution is:  " $res
echo "Your timelapse will last for:  " $hours" hours " "$minutes" "minutes " "$seconds" "seconds"

while true; do
  read -r -p "Create preview image before capture? (Y/N)"  answer
  case $answer in
    [Yy]* ) echo "y";
    raspistill -o /media/share/timelapse-test/test%04d.jpg -q $quality -awb $awb -ex $exp -w $width -h $height;
    echo"File created.";
    break;;
    [Nn]* ) echo "n";
    break;;
    * ) echo "Please answer question";;
  esac
done

read -r -p "Continue to timelapse  "  continue

case $continue in
  [Yy]* ) echo "Starting timelapse";;
  [Nn]* ) echo "Exiting";exit;;
esac
#while [[ $flag = true ]]; do
#  sudo raspistill  -o image%04d.jpg -w 1920 -h 1080
#  echo "Look in photos for preview picture. Continue with timelapse?"
#  read continue
#  if [[ $continue = y ]]; then
#    $flag = true
###  $flag = false
  #  echo "Taking another preview picture"
#  fi
#done

sudo mkdir /media/share/timelapse-$(date +"%m-%d-%Y")
echo "Creating directory timelapse-"$(date +"%m-%d-%Y")" on Sunnydays3"
echo "Done"
echo "Saving image files to Sunnydays3 "

#echo $duration
#echo $interval
#echo $quality
#echo $awb
#echo $exp
#echo $width
#echo $height

sudo raspistill -t $duration -tl $interval -o /media/share/timelapse-$(date +"%m-%d-%Y")/image%04d.jpg -q $quality -awb $awb -ex $exp -w $width -h $height

echo "Timelapse done"
# save to folder

# create timelapse video question
