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
