SHELL=bash

all: build

executable:
	gcc -o executable source.c

prefix: executable
	dd if=executable bs=1 status=none skip=$$((0x0)) count=$$((0x00000660)) of=prefix

suffix: executable
	dd if=executable bs=1 status=none skip=$$((0x00000700)) of=suffix

prefix_col1 prefix_col2: prefix
	md5_fastcoll -p prefix -o prefix_col1 prefix_col2

good: prefix_col1 suffix
	cat prefix_col1 suffix > good
	chmod +x good

evil: prefix_col2 suffix
	cat prefix_col2 suffix > evil
	chmod +x evil

.PHONY: build
build: good evil

.PHONY: clean
clean:
	git checkout -- source.c
	rm -rf executable prefix suffix prefix_col1 prefix_col2 good evil

.PHONY: diff
diff:
	diff -y <(xxd -s 0x00000680 -l 128 good) <(xxd -s 0x00000680 -l 128 evil)

.PHONY: test
test:
	md5 good evil
	./good
	./evil

.PHONY: bytes
bytes:
	@xxd -s 0x00000693 -l 1 evil | awk 'BEGIN{OFS=""} { print "0x00000693: 0x", $$2 }'
	@xxd -s 0x000006ad -l 1 evil | awk 'BEGIN{OFS=""} { print "0x000006ad: 0x", $$2 }'
	@xxd -s 0x000006bb -l 1 evil | awk 'BEGIN{OFS=""} { print "0x000006bb: 0x", $$2 }'
	@xxd -s 0x000006d3 -l 1 evil | awk 'BEGIN{OFS=""} { print "0x000006d3: 0x", $$2 }'
	@xxd -s 0x000006ed -l 1 evil | awk 'BEGIN{OFS=""} { print "0x000006ed: 0x", $$2 }'
	@xxd -s 0x000006fb -l 1 evil | awk 'BEGIN{OFS=""} { print "0x000006fb: 0x", $$2 }'

.PHONY: patch-source
patch-source: BYTE?=$(shell xxd -s 0x00000693 -l 1 evil | awk '{ print $$2 }')
patch-source:
	git checkout -- source.c
	sed -i '' 's/bytes\[0\] == 0xff/bytes[0] == 0x${BYTE}/' source.c

.PHONY: patch
patch: patch-source
	gcc -o executable source.c
	dd if=executable bs=1 status=none skip=$$((0x00000700)) of=suffix
	cat prefix_col1 suffix > good
	cat prefix_col2 suffix > evil
	chmod +x evil
	chmod +x good