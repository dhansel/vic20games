all: jelly_monsters.crt pacman.crt atlantis.crt spiders_of_mars.crt omega_race.crt demon_attack.crt galaxian.crt spider_city.crt miner_2049er.crt donkey_kong_2000.crt donkey_kong_a000.crt pole_position_6000.crt pole_position_a000.crt

donkey_kong_2000.bin donkey_kong_a000.bin: donkey_kong.o donkey_kong.lnk
	ld65 -C donkey_kong.lnk donkey_kong.o

pole_position_6000.bin pole_position_a000.bin: pole_position.o pole_position.lnk
	ld65 -C pole_position.lnk pole_position.o

donkey_kong_2000.crt: donkey_kong_2000.bin
	echo -ne "\x00" > $@
	echo -ne "\x20" >> $@
	cat $< >> $@

pole_position_6000.crt: pole_position_6000.bin
	echo -ne "\x00" > $@
	echo -ne "\x60" >> $@
	cat $< >> $@

%.crt: %.bin
	echo -ne "\x00" > $@
	echo -ne "\xa0" >> $@
	cat $< >> $@

%.bin: %.o
	ld65 -t none -o $@ $<

%.o: %.asm
	ca65 -o $@ -l $<.prn $<

check: all

clean:
	rm -f *.o *.bin *.prn *.crt
