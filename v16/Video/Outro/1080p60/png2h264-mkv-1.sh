#!/bin/bash 

# Dateiname
DEST=video_h264

# Optionen
BITRATE=50000
FPS=60
EXT=png

# Initialisierung
MENCODER=`which mencoder`
MKVMERGE=`which mkvmerge`

DEST_EXT=.mkv
TMP_VID=${DEST}.tmpv

# Löschen bestehender tempörärer Dateien
rm -f "${TMP_VID}"

# Konvertieren
${MENCODER} -ovc x264 -x264encopts \
bitrate=${BITRATE}:subq=6:partitions=all:8x8dct:me=umh:frameref=5:bframes=3:b_pyramid=none:weight_b:pass=1 \
-oac copy -of rawvideo -o "${TMP_VID}" mf://*.$EXT -mf fps=$FPS

${MENCODER} -really-quiet -ovc x264 -x264encopts \
bitrate=${BITRATE}:subq=6:partitions=all:8x8dct:me=umh:frameref=5:bframes=3:b_pyramid=none:weight_b:pass=2 \
-oac copy -of rawvideo -o "${TMP_VID}" mf://*.$EXT -mf fps=$FPS

mkvmerge -o "${DEST}${DEST_EXT}" --forced-track 0:no --default-duration 0:25fps -d 0 -A -S "${TMP_VID}" --track-order 0:0