all: jelly_monsters.bin atlantis.bin spiders_of_mars.bin omega_race.bin

%.bin: %.o
	ld65 -t none -o $@ $<
	diff $@ orig/$@

%.o: %.asm
	ca65 -o $@ -l $<.prn $<

check: all

clean:
	rm -f *.o *.bin *.prn
