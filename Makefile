all: code.f

clean:
	rm -f code.f
	rm -f final.f

code.f:
	cat ~/EmbeddedSystems_Proj_FT/src/jonesforth.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/utils.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/gpio.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/timer.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/led.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/i2c.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/lcd.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/dht.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/button.f >> code.f
	cat ~/EmbeddedSystems_Proj_FT/src/main.f >> code.f
	grep -v '^ *\\' code.f > final.f
