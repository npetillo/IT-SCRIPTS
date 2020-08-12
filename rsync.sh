#!/bin/bash


echo "Drag Source Files Here [Enter]"

read Source

echo "Drag Destination Here [Enter]"

read Destination

rsync -aihW --progress --log-file="$Destination/ingest.log" "$Source" "$Destination"