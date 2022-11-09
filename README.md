# md5-collision

An md5 collision attack example.

Takes a super simple executable, splits it in two parts and computes an md5 collision using the first half (using [hashclash](https://github.com/cr-marcstevens/hashclash)). Then identifies a difference between the two prefix files, and uses that to toggle wether to execute a good or an evil payload contained within the executable.

### Example usage

```bash
make build patch
...
make test
md5 good
MD5 (good) = ab0d5b4559a1e8d4117242345b9124f7
./good
I am good
md5 evil
MD5 (evil) = ab0d5b4559a1e8d4117242345b9124f7
./evil
I am evil
```

