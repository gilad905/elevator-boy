# Copilot Instructions

## Project Overview
Godot 4.4 game project using GDScript. An elevator-themed game with NPCs, items, and floor-based gameplay.

## Project Structure
- `scripts/globals/` — Autoloads and static utility classes (`Settings`, `State`, `Funcs`, `Nodes`, `NPCs`)
- `scripts/npc/` — NPC classes inheriting from base `Npc` class (`class_npc.gd`)
- `scripts/item/` — Item classes inheriting from base `Item` class (`class_item.gd`)
- `scripts/room/` — Room classes inheriting from base `Room` class (`class_room.gd`)
- `scripts/elevator/` — Elevator-specific scripts (door, mover)
- `scenes/` — Mirrors the script folder structure
- `resources/` — Shared resources (tweens, themes, export settings)
- `assets/` — Textures, fonts, HTML templates

## GDScript Conventions

### Naming
- Classes: PascalCase (`Npc`, `Person`, `Item`, `Room`)
- Functions and variables: snake_case (`init_level`, `patience_sec`, `fall_y`)
- Constants: snake_case (`zero_angle`, `full_angle`, `result_duration`)
- Enums: PascalCase type name, PascalCase values (`Npc.Type.Person`, `Item.Type.Life`)
- Private/internal members: leading underscore (`_ready`, `_on_npc_patience_ended`)

### Style
- Always use return type annotations (e.g., `-> void`, `-> float`, `-> Dictionary`)
- Always start code comments with a lowercase letter — never capitalize the first word
- Use `signal` declarations at the top of class files
- Use `_static_init()` for one-time class setup
- Signal callbacks follow the `_on_<source>_<signal_name>` pattern

### Patterns
- Factory pattern via `Funcs.get_scene_by_type()` for loading scenes by enum type
- Type enums on base classes for subclass routing (`Npc.Type`, `Item.Type`)
- Tween-based animations using Godot's fluent tween API
- JSON-based state persistence via `State` class
- `Settings` is the only registered autoload; other globals use static methods
