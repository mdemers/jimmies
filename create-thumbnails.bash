# Author: Cifro Nix, http://about.me/Cifro
#
# usage:
# ./create-thumbnails.sh 
# will produce thumbnails with name "<id>.jpg" with size 220x122
#
# different size:
# ./create-thumbnails.sh 640x360 -big 
# will produce thumbnails with name "<id>-big.jpg" with size 640x360

#Edited for Islandora pre-processing, mdemers 2016-04-19

videoDir=/cygdrive/z/COPYCOLLECTION/NADA_video/NADA_video_test_004
tnDir=/cygdrive/z/COPYCOLLECTION/NADA_video/NADA_video_test_004
tnSize=${1-"220x122"}
tnSuffix=${2-""}

for i in $videoDir/*.mp4; do
	# filename: <videoDir>/<id>_<yyyy-mm-dd>_<video-title>.<flv|mp4|f4v>
	#vid=`echo "$i" 2>&1 | cut -d '.' -f 2`;
    vid=`basename "$i" .mp4`;
    if [ -f "$i" ] && [ ! -f "$tnDir/$vid.jpg" ]; then
		# get video duration, v1
		#ff=`$(ffmpeg -i "$i" 2>&1)`;
		#d="${ff#*Duration: }"
		#echo "${d%%,*}"

		# get video duration, v2
		fulltime=`ffmpeg -i "$i" 2>&1 | grep 'Duration' | cut -d ' ' -f 4 | sed s/,//`;

		hour=`echo $fulltime | cut -d ':' -f 1`;
		minute=`echo $fulltime | cut -d ':' -f 2`;
		second=`echo $fulltime | cut -d ':' -f 3 | cut -d '.' -f 1`;


		seconds=`expr 3600 \* $hour + 60 \* $minute + $second`;
		ss=`expr $seconds / 2`; # from the middle of video
		#echo "$vid: $ss / $seconds";


		# create thumbnail from middle of video
		output=`ffmpeg -itsoffset -2 -ss $ss -i "${i}" -vcodec mjpeg -vframes 1 -an -f rawvideo "${tnDir}/${vid}.jpg"`;

		if [ -f "$tnDir/$vid.jpg" ]; then
			echo "$(tput setaf 2)Thumbnail $tnDir/$vid.jpg [$tnSize] saved$(tput sgr0)";
		else
			echo "$(tput setaf 1)Error: Thumbnail $vid$tnSuffix.jpg [$tnSize] was not saved$(tput sgr0)";
		fi
	else
		echo "$(tput setaf 6)Notice: Thumbnail $tnDir/$vid$tnSuffix.jpg already exists.$(tput sgr0)";
	fi
done
