#!/bin/bash

# Check if the Instrument with the Card Name "MC101" is connected to the Raspberry Pi
# Use "aplay -l" to find the Card Name of any connected audio devices
#if [ $(aplay -l | grep -c "MC101") -eq 0 ]; then
#  echo "MC101 not detected, skipping connection."
#else
#  echo "MC101 detected, connecting."

# Open audio interface between the Instrument Out and System In
#alsa_in -j "MC101_in" -d hw:CARD=MC101,DEV=0 -r 48000 &

# Open audio interface between System Out and Instrument In
#alsa_out -j "MC101_out" -d hw:CARD=MC101,DEV=0 -r 44100 &

#sleep 2

# Connect audio of Instrument Out to System In
#jack_connect MC101_in:capture_1 system:playback_1
#jack_connect MC101_in:capture_2 system:playback_2

# Connect System Microphone to Instrument In
#jack_connect system:capture_1 MC101_out:playback_1
#jack_connect system:capture_1 MC101_out:playback_2

#fi

# Open audio interface between M8 Out and System In
#alsa_in -j "M8_in" -d hw:CARD=M8,DEV=0 -r 48000 &
alsa_in -j "M8_in" -d hw:CARD=M8,DEV=0 -r 44100 &

# Open audio interface between System Out and M8 In
alsa_out -j "M8_out" -d hw:CARD=M8,DEV=0 -r 44100 &
#alsa_out -j "M8_out" -d hw:CARD=M8,DEV=0 -r 48000 &

sleep 2

# Connect audio of M8 Out to System In (This connects M8 Out to system playback, so you can hear the M8)
jack_connect M8_in:capture_1 system:playback_1
jack_connect M8_in:capture_2 system:playback_2

# Connect audio of System microphone to M8 In (This connects USB Card mic to M8, so you can record audio)
# There are 2 system:capture_1 because my USB card has a mono ADC. Should be changed to capture_1 and capture_2 if stereo ADC
jack_connect system:capture_1 M8_out:playback_1
jack_connect system:capture_1 M8_out:playback_2

#sleep 5

# Start M8C
pushd /home/patch/m8c-rpi4
./m8c
popd

# Clean up audio routing
killall -s SIGINT alsa_out alsa_in

# Shutdown after quitting M8C
#Sleep 2
#sudo shutdown now

