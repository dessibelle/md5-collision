# md5-collision

An md5 collision attack example.

Takes a super simple executable, splits it in two parts and computes an md5 collision using the first half (using [hashclash](https://github.com/cr-marcstevens/hashclash)). Then identifies a difference between the two prefix files, and uses that to toggle wether to execute a good or an evil payload contained within the executable.

### Example usage

```bash
make build patch
...
make test
md5 good evil
MD5 (good) = b1ab435e94e6657a37919146a4503fc9
MD5 (evil) = b1ab435e94e6657a37919146a4503fc9
./good
I am good
./evil
I am evil
```

