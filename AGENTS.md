# AGENTS.md

## Purpose

`core-luarock` (LuaRocks rock name `wow-dev-core`) is a foundational package in the WoW-U
project, which helps disabled players play WoW alongside friends via accessibility automation.
This repo provides a shared abstraction layer over third-party WoW "unlocker" libraries
(Daemonic, NilName, Tinkr) — tools that expose low-level game-engine access normally blocked
by WoW's Lua API sandbox (raw object positions, line-of-sight tracing, movement heartbeats,
etc.). It defines an `AbstractUnlocker` interface plus concrete adapters, so consuming code
can call one consistent API regardless of which unlocker is active at runtime.

This repo has no dependency on other WoW-U repos — it is a foundational dependency *for* other
repos, not a consumer of them.

## Stack

- Pure Lua, `>= 5.1`, targeting WoW's embedded Lua environment.
- Packaged as a LuaRocks rock, `rockspec_format = "3.1"`.
- Full EmmyLua/LuaCATS `---@` annotations throughout (classes, params, returns, aliases).
  Preserve this discipline in all new code — every public method needs full annotations.

## Structure

```
README.md
wow-dev-core-1.0.7-1.rockspec        build manifest — only lists packaged modules
src/amstaffix/core/
  error.lua                          Error class
  abstract_unlocker.lua              the interface: ~30 abstract methods + 2 composite methods
  abstract_unlocker_old.lua          legacy variant — NOT packaged, do not use in new integrations
  daemonic/unlocker.lua              concrete adapter for the Daemonic unlocker
  nilname/unlocker.lua               concrete adapter for the NilName unlocker
  tinkr/unlocker.lua                 concrete adapter for the Tinkr unlocker
```

The rockspec's `modules` table is the source of truth for what actually ships — it packages
exactly 5 modules (`error`, `abstract_unlocker`, and the three `*.unlocker` adapters). Other
files present in `src/` (e.g. `abstract_unlocker_old.lua`) are intentionally excluded; check
the rockspec before assuming a file is part of the public package.

**Adapter parity is not guaranteed.** The Tinkr adapter is missing several methods
(`getUnitNpcFlags`, `getUnitTarget`, `getAnglesXYZ`, `getUnitFlags3` all `error("not
implemented in Tinkr")`). Don't assume all three adapters implement the full interface — check
the specific adapter file before relying on a method.

## Build / Validate

```
luarocks make wow-dev-core-1.0.7-1.rockspec
```

## Testing

Tests use [busted](https://olivinelabs.com/busted/). Run the whole suite from the repo root:

```
busted
```

- Specs mirror `src/amstaffix/core/` under `spec/amstaffix/core/`, one `*_spec.lua` file per
  module (e.g. `src/amstaffix/core/daemonic/unlocker.lua` -> `spec/amstaffix/core/daemonic/unlocker_spec.lua`).
  Test infrastructure (`spec_helper.lua`, `meta/`) lives directly under `spec/`, outside that mirror.
- `spec/spec_helper.lua` is the single place that stubs WoW globals (`UnitExists`, `bit`) and
  builds recorder-style mocks for the injected vendor tables (`dmc`/`nn`/`tinkr`); require it
  from a spec rather than re-implementing stubs locally.
- `.busted` sets `lpath` so specs can `require("amstaffix.core....")` directly against `src/`
  without installing the rock first.
- Adapter `:new()` mutates shared class-level tables (`self.__index = self`,
  `setmetatable(self, {...})`), so specs must reset `package.loaded["amstaffix..."]` entries
  between tests (`spec_helper.resetModules()`) to avoid state leaking across spec files.

Also validate packaging changes with `luarocks make` plus a manual load-check, e.g.:

```lua
require("amstaffix.core.abstract_unlocker")
require("amstaffix.core.daemonic.unlocker")
```

## Conventions

- **Classes**: prototype-based, via `:new()` + `setmetatable`, not any OOP library.
- **Adapter inheritance**: adapters use a two-level metatable chain — `self.__index = self`
  plus `setmetatable(self, { __index = AbstractUnlocker })` on the class table, then the
  instance from `AbstractUnlocker:new()` is reparented to the adapter class. This lets an
  adapter override specific methods while inheriting everything else (including the two
  composite methods) from `AbstractUnlocker`.
- **Naming**: camelCase methods, PascalCase classes.
- **Error handling**: methods return `(value, Error? err)` tuples using the shared `Error`
  class (`src/amstaffix/core/error.lua`) rather than throwing — except abstract/unimplemented
  methods, which call `error("not implemented")` (or `"not implemented in <unlocker>"` for
  adapter-specific gaps). Match whichever pattern the method you're touching already uses.
- **Indentation**: 4 spaces.
- **Annotations**: every method — abstract and concrete — carries full EmmyLua `---@param` /
  `---@return` / `---@nodiscard` annotations. New methods on `AbstractUnlocker` need the same
  annotation added to every adapter that implements them.
- **Composite methods**: `AbstractUnlocker` also has ~2 methods (e.g. `isUnitFacing`,
  `isObjectInLineOfSight`) built purely on top of the abstract primitives (`getObjectPosition`,
  `getObjectFacing`, `traceLine`). These live in `AbstractUnlocker` itself, not per-adapter,
  and should stay that way — don't duplicate this logic into adapters.

## Dependencies / Integration

- The rockspec declares only `lua >= 5.1` as a dependency.
- The three vendor unlocker libraries (Daemonic, NilName, Tinkr) are **not vendored** here —
  consumers inject them at construction time, e.g. `DaemonicUnlocker:new(DMC)`, where `DMC` is
  the global exposed by the Daemonic addon at runtime.
- Consuming repos should `require("amstaffix.core.abstract_unlocker")` (for typing/interface
  reference) and the specific adapter module they need, and treat `AbstractUnlocker` as the
  contract to code against rather than any single adapter.

## Versioning / Releasing

- The rockspec is pinned to a git tag (`source.tag`) and its own filename/`version`
  field encode the same version (e.g. `1.0.7-1` ↔ tag `v1.0.7`).
- When releasing a new version: bump the git tag, the rockspec filename, and the `version`
  field together — they must stay in sync.
- Never mutate a rockspec in place after its tag has been pushed. Create a new versioned
  rockspec file for each release; the old one must remain byte-for-byte identical to what
  the tag's tree contained.
- `source.url` must use `git+https://` (not `git+ssh://`). The SSH form requires a deploy
  key and blocks public installation via `luarocks install`.
