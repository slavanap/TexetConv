rem mencoder in.avi -o test_ _.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=%d -channels 2 -ovc xvid -xvidencopts bitrate=%d:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1


mencoder in.avi -o test_V800_A128.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=128 -channels 2 -ovc xvid -xvidencopts bitrate=800:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120
mencoder in.avi -o test_V800_A64.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=64 -channels 2 -ovc xvid -xvidencopts bitrate=800:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120
mencoder in.avi -o test_V800_A32.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=32 -channels 2 -ovc xvid -xvidencopts bitrate=800:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120

mencoder in.avi -o test_V500_A128.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=128 -channels 2 -ovc xvid -xvidencopts bitrate=500:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120
mencoder in.avi -o test_V500_A64.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=64 -channels 2 -ovc xvid -xvidencopts bitrate=500:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120
mencoder in.avi -o test_V500_A32.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=32 -channels 2 -ovc xvid -xvidencopts bitrate=500:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120

mencoder in.avi -o test_V300_A128.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=128 -channels 2 -ovc xvid -xvidencopts bitrate=300:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120
mencoder in.avi -o test_V300_A64.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=64 -channels 2 -ovc xvid -xvidencopts bitrate=300:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120
mencoder in.avi -o test_V300_A32.avi -noodml -of avi -bps -oac lavc -srate 44100 -lavcopts acodec=mp2:abitrate=32 -channels 2 -ovc xvid -xvidencopts bitrate=300:max_bframes=0:quant_type=h263:vhq=0:rc_buffer=1000000 -ofps 15 -vf-add scale=160:-2 -vf-add expand=160:128:-1:-1:1 -endpos 120

@echo.
@echo Done.

pause