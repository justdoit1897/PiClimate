all: code.f

clean:
	rm -f code.f
	rm -f final.f

code.f:
	cat ~/EmbeddedSystems_Proj_FT/working/useful_jf.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/working/utils.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/working/gpio_FT.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/working/timer.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/working/dht_sensor.f >> code.f
	grep -v '^ *\\' code.f > final.f
# cat lcd.f >> code.f
# cat led.f >> code.f
# cat pad.f >> code.f
# cat hdmi.f >> code.f
# cat timer.f >> code.f
# cat button.f >> code.f
# cat main.f >> code.f
	