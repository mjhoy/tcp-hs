implementing userspace tcp
==========================

sources:

- [`rust-tun` crate source][rust-tun]
- [haskell FFI example][haskell-ffi]
- [utun example from macOS internals][mac-utun-example]

[rust-tun]: https://github.com/meh/rust-tun/blob/master/src/platform/macos/device.rs
[haskell-ffi]: https://wiki.haskell.org/FFI_complete_examples
[mac-utun-example]: http://newosxbook.com/src.jl?tree=listings&file=17-15-utun.c

Note that you'll need to run as root to create the utun device. e.g.:

```
$ cabal build
[... build output ...]
Linking [executable path]
$ sudo [executable path]
```

Setting up the interface (OSX):

```
ifconfig # look for the created utun interface

# here `utun8` was the new interface.
# associate with an ip and ping:
sudo ifconfig utun8 10.10.10.1 10.10.10.2 up
ping -c1 10.10.10.2
```
