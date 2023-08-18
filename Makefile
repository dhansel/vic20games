all: jelly_monsters.bin pacman.bin atlantis.bin spiders_of_mars.bin omega_race.bin demon_attack.bin galaxian.bin donkey_kong_2000.bin donkey_kong_a000.bin

donkey_kong_2000.bin donkey_kong_a000.bin: donkey_kong.o donkey_kong.lnk
	ld65 -C donkey_kong.lnk donkey_kong.o

%.bin: %.o
	ld65 -t none -o $@ $<

%.o: %.asm
	ca65 -o $@ -l $<.prn $<

check: all

clean:
	rm -f *.o *.bin *.prn
