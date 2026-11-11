# Herdr Agents Remote

A drop-in replacement/enhancement for Herdr's built-in **Agents** sidebar panel: it keeps the shipped `agents` mod's features and adds agents on **remote machines** (`hc machine ls`) plus a **screen-based status guess** for agents that never report OSC 7501 status (e.g. Codex), local and remote.

## What it adds over the shipped `agents` mod

- **Remote-machine agents** — scans `terminals()` for live agent programs (`codex`, `claude`, `gemini`, `opencode`) that are not in `agents()`, covering agents that don't emit OSC 7501 reports. Addresses may be `machine/address` form; the machine name is shown on the row.
- **Screen-based status guessing (`guessRemote`)** — every 8 s runs `hc read <address>` on unreported agents and infers `working` (spinner glyphs, "esc to interrupt", "ctrl+c to stop/cancel", Working/Thinking) or `idle` (Codex "Ask Codex to do anything", Claude `Try "`). Ambiguous screens stay "unreported" (未回報).

Everything upstream still works: grouped/priority sorting, pinning, foldable sub-agent trees, focus on click (`pane.focus {pane}`, remote pane ids are machine-qualified), machine labels, the collapsible sidebar rail.

This is a **personal clone** of Herdr's shipped `agents` mod (`mod.json` records `cloned_from` 0.1.13) with the additions above. Upstream updates may require re-basing: re-clone upstream with `herdr-app do mod.clone '{"name":"agents","as":"agents-remote"}'` and re-apply the remote/guessing changes (or keep the diff you have).

## Requirements

- Herdr app, with `herdr-app` and `hc` on `PATH` (status guessing shells out to `hc read`).
- Remote machines configured via `hc machine ls`.

## Install

```powershell
./install.ps1
```

Copies `mod/` into `mods/agents-remote/` (backing up any existing folder under `~/.config/herdr-app/backups/herdr-agents-remote/<timestamp>/`) and runs `herdr-app check`.

## Use it in a layout

The mod ships with `place: "none"`, so it does not auto-appear. Point your layout's agents block at it, or add a block:

```json
{ "content": { "mod": "agents-remote" } }
```

## Limitations

- Status guessing is heuristic — it reads screen text, so it can be fooled by scrollback or unusual output.
- `blocked`/`done` can't be detected for non-reporting agents; they show `working`, `idle`, or `未回報`.
- Idle prompts for `gemini`/`opencode` are not yet covered — those will typically stay `working`-or-`unreported` guesses.

## Files

| Path | Purpose |
| --- | --- |
| `mod/main.js` | The mod: agents panel UI, remote-agent fallback, `guessRemote` status inference, sorting/pinning/sub-agent tree |
| `mod/mod.json` | Mod metadata (`place: "none"`, `cloned_from` upstream `agents` 0.1.13) |
| `mod/jsconfig.json` | Editor types for the mod (`herdr`, `gpui-kit`) |

`gpui-kit.d.ts` is intentionally not shipped — the app writes its own copy into each mod folder.

## License

MIT © 2026 art.huang. Derived from Herdr's shipped `agents` mod, which is part of the Herdr app.
