# kawakudari for MSX-BACON

Kawakudari game for [MSX-BACON](https://github.com/hra1129/msx_basic_compiler/)

## run on MSX BASIC

- [kawa-kdr.bas](kawa-kdr.bas)

## run on MSX-BACON

```sh
msx_bacon kawa-kdr.bas kawa-kdr.asm
zma kawa-kdr.asm kawa-kdr.bin
```

use [BACONLDR.BIN](https://github.com/hra1129/msx_basic_compiler/blob/main/msx_basic_compiler/baconloader/BACONLDR.BIN) from [MSX-BACON](https://github.com/hra1129/msx_basic_compiler/)
```MSX
bload"BACONLDR.BIN",r
bload"hello.bin",r
```
