all: code.f

clean:
	rm -f code.f
	rm -f final.f

code.f:
	cat ./src/jonesforth.f >> code.f
	cat ./src/utils.f >> code.f
	cat ./src/gpio.f >> code.f
	cat ./src/time.f >> code.f
	cat ./src/i2c.f >> code.f
	cat ./src/lcd.f >> code.f
	cat ./src/led.f >> code.f
	cat ./src/button.f >> code.f
	cat ./src/dht.f >> code.f
	cat ./src/main.f >> code.f
	grep -v '^ *\\' code.f > final.f
