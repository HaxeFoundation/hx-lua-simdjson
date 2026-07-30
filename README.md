# hx-lua-simdjson

[![Build Status](https://github.com/FourierTransformer/lua-simdjson/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/FourierTransformer/lua-simdjson/actions?query=branch%3Amaster)

A basic haxe-specific lua binding to [simdjson](https://simdjson.org). This
library is intended to be used only via the Haxe compiler.

## Requirements
 * hx-lua-simdjson only works on 64bit systems.
 * a lua build environment with support for C++11
   * g++ version 7+ and clang++ version 6+ or newer should work!

## Usage from Haxe

This project ships both halves of the integration:

1. The **native Lua module** (`hxsimdjson`), built and installed via luarocks
   from the rockspec in this repo:

   ```
   luarocks make hx-lua-simdjson-scm-1.rockspec
   ```

2. A **haxelib** that wires `haxe.Json` on the Lua target to that native module.

   ```
   haxelib install hx-lua-simdjson
   haxe -lua out.lua -lib hx-lua-simdjson ...
   ```

   Adding `-lib hx-lua-simdjson` transparently routes `haxe.Json.parse`
   (and `haxe.format.JsonParser.parse`) through simdjson. It does this with a
   build macro that rewrites `haxe.format.JsonParser.parse` at compile time
   (see `haxe/hxluasimdjson/Macro.hx`) — no std files are shadowed, so it does
   not need to be re-synced when the Haxe std changes across versions. On any
   non-Lua target the library is a no-op.

   The macro only affects parsing; `haxe.Json.stringify` continues to use the
   std printer.


## Publishing to haxelib (maintainers)

The library is published to [lib.haxe.org](https://lib.haxe.org/p/hx-lua-simdjson/)
by packaging the Haxe-facing files and running `haxelib submit`:

```
zip -r hx-lua-simdjson.zip haxelib.json extraParams.hxml README.md LICENSE haxe/
haxelib submit hx-lua-simdjson.zip
```

Notes:
 * `haxelib.json`'s `version` is the source of truth for the haxelib release;
   keep it aligned with the rockspec version so the luarock and haxelib match.
 * Only the Haxe layer is shipped in the haxelib zip — the vendored simdjson
   C++ in `src/` is delivered separately via the rockspec, not through haxelib.
 * `license` in `haxelib.json` must be one of haxelib's tokens
   (`GPL`/`LGPL`/`MIT`/`BSD`/`Public`/`Apache`), not an SPDX identifier.
 * Current owners/contributors (`jdonaldson`, `tobil4sk`) can each submit.

## Licenses
 * The jsonexamples, src/simdjson.cpp, src/simdjson.h are unmodified from the released version simdjson under the Apache License 2.0.
 * All other files/folders are apart of hx-lua-simdjson also under the Apache License 2.0.

## Acknowledgments
 * This library based heavily off of an early version of [lua-simdjson](https://github.com/FourierTransformer/lua-simdjson) by [FourierTransformer](https://github.com/FourierTransformer).
 * Special thanks to the main author of simdjson, [Daniel Lemire](https://github.com/lemire), as well as the supporting authors [John Keiser](https://github.com/jkeiser), and [Geoff Langdale](https://github.com/geofflangdale).
