---
name: godot-architecture
description: >-
  Comprehensive senior-level guide to Godot 4 game development architecture.
  Covers scene/node hierarchy, design patterns (composition over inheritance,
  signal-driven decoupling, autoloads, resources), project structure, and
  common pitfalls. Activate when the user asks about Godot architecture,
  scene design, GDScript patterns, or how to structure a Godot project.
---

# Godot Game Dev Architecture — Senior Dev Guide

> You are acting as a senior Godot developer with 10+ years of experience.
> Answer with concrete examples, GDScript snippets, and actionable advice.
> Always prefer Godot-native patterns over importing patterns from other engines.

---

## 1. The Core Philosophy: Everything Is a Node

Godot's fundamental building block is the **Node**. Unlike Unity (GameObjects + Components) or Unreal (Actors + Components), Godot uses a **unified tree of nodes** where each node IS its behavior — not a container for it.

```
Key Mantra: "Scene = reusable prefab + script + children"
```

### Node vs Scene vs Resource

| Concept      | What it is                                     | When to use                               |
|:-------------|:-----------------------------------------------|:------------------------------------------|
| **Node**     | A live object in the scene tree                | Behavior, rendering, physics, UI          |
| **Scene**    | A saved subtree of nodes (.tscn file)          | Reusable gameplay elements, levels, menus |
| **Resource** | A data container saved to disk (.tres/.res)    | Stats, configs, item definitions, shaders |

---

## 2. Scene Tree Architecture

### 2.1 The Scene Tree Is Your Game Loop

```
Root (Window)
└── Main (Node)
    ├── World (Node3D / Node2D)
    │   ├── TileMap
    │   ├── Player (CharacterBody2D)  <- instanced scene
    │   └── Enemies (Node)            <- container node
    │       ├── Goblin                <- instanced scene
    │       └── Orc                  <- instanced scene
    ├── UI (CanvasLayer)
    │   ├── HUD
    │   └── PauseMenu
    └── GameManager (Node)           <- or use Autoload
```

Rules of thumb:
- Keep the tree SHALLOW — deep nesting creates tight coupling.
- Use container nodes (Node, Node2D, Node3D) to group related children without adding behavior.
- A scene should be independently playable in the editor (F6 runs just that scene).

### 2.2 Scene Composition vs Inheritance

Bad — deep inheritance:
```gdscript
# Bad: inheritance chain couples unrelated concerns
class_name FlyingShootingEnemy extends ShootingEnemy  # extends Enemy extends Character
```

Good — compose scenes:
```
Enemy.tscn
├── CharacterBody2D       <- movement physics
├── HealthComponent.tscn  <- instanced scene: handles HP, death signal
├── HurtBox.tscn          <- instanced scene: detects hits
├── ShootComponent.tscn   <- instanced scene: fires projectiles
└── AnimationPlayer
```

Each component scene is self-contained and reusable across multiple enemies.

# ponytail: Godot instancing already gives you composition. A single flat
# CharacterBody2D with one script handles most indie game enemies just fine —
# don't over-engineer unless you have 20+ enemy types.

---

## 3. Signals — The Heart of Decoupling

Signals are Godot's observer/event pattern baked into the engine.
They prevent child->parent and sibling->sibling direct references.

### 3.1 Signal Direction Rule

```
CORRECT flow:   Child emits -> Parent (or Autoload) listens
WRONG flow:     Child holds reference to sibling -> tightly coupled
```

### 3.2 Practical Signal Patterns

```gdscript
# health_component.gd
class_name HealthComponent
extends Node

signal died
signal health_changed(new_hp: int, max_hp: int)

@export var max_health: int = 100
var health: int

func _ready() -> void:
    health = max_health

func take_damage(amount: int) -> void:
    health = max(0, health - amount)
    health_changed.emit(health, max_health)  # UI listens
    if health == 0:
        died.emit()                           # parent Enemy listens
```

```gdscript
# enemy.gd — parent connects to child signals
func _ready() -> void:
    $HealthComponent.died.connect(_on_died)
    $HealthComponent.health_changed.connect($HealthBar.update)

func _on_died() -> void:
    drop_loot()
    queue_free()
```

### 3.3 Signal Bus (Global Event Bus)

For truly decoupled cross-system events, use an Autoload as a signal bus:

```gdscript
# autoloads/event_bus.gd  (registered as "EventBus" in Project Settings)
extends Node

signal player_died
signal score_changed(new_score: int)
signal level_completed(level_id: String)
```

```gdscript
# Any scene can emit:
EventBus.player_died.emit()

# Any scene can listen — no direct reference needed:
func _ready() -> void:
    EventBus.score_changed.connect(_on_score_changed)
```

# ponytail: Only use an EventBus for truly global events (game state changes).
# Direct $ChildNode.signal.connect() is cleaner for local parent-child comms.

---

## 4. Autoloads (Singletons)

Autoloads are globally accessible nodes that persist across scene changes.
Register them in Project -> Project Settings -> Autoloads.

### 4.1 What Belongs in Autoloads

| Autoload Name   | Responsibility                                          |
|:----------------|:--------------------------------------------------------|
| GameManager     | Game state machine (main menu -> playing -> paused)     |
| SaveManager     | Save/load game data                                     |
| AudioManager    | Play SFX/music without losing audio on scene change     |
| EventBus        | Global signal hub (see section 3.3)                     |
| SceneManager    | Scene transitions with loading screens                  |

### 4.2 Scene Manager Example

```gdscript
# autoloads/scene_manager.gd
extends Node

func change_scene(path: String) -> void:
    # ponytail: use get_tree().change_scene_to_file() for simple cases
    var transition = preload("res://scenes/ui/transition.tscn").instantiate()
    get_tree().root.add_child(transition)
    await transition.animation_finished
    get_tree().change_scene_to_file(path)
    transition.queue_free()
```

### 4.3 Autoload Anti-Patterns

```gdscript
# BAD: Don't store scene-specific node refs in Autoloads
GameManager.current_player_node = $Player  # dangling ref after scene change!

# GOOD: One responsibility per Autoload, no scene-node references
```

---

## 5. The Resource System

Resources are data objects saved to .tres (text) or .res (binary) files.
They are reference-counted, loaded once, and shared across instances.

### 5.1 Custom Resources for Data

```gdscript
# resources/item_data.gd
class_name ItemData
extends Resource

@export var item_name: String = ""
@export var icon: Texture2D
@export var damage: int = 0
@export var is_stackable: bool = true

# Create .tres files in the editor: right-click FileSystem -> New Resource -> ItemData
# Drag-drop into @export slots in the Inspector — no parsing code needed.
```

Why this beats dictionaries and JSON:
- Type-safe, editor-inspectable, autocompleted
- No parsing code needed
- Drag-drop in Inspector

### 5.2 Shared vs Unique Resources

```gdscript
# DANGEROUS: Modifying a shared resource affects ALL instances
var stats = preload("res://resources/goblin_stats.tres")
stats.health -= 10  # Affects every Goblin!

# CORRECT: Duplicate for per-instance data
func _ready() -> void:
    stats = preload("res://resources/goblin_stats.tres").duplicate()
```

---

## 6. State Machines

### 6.1 Enum-Based FSM (Recommended for most cases)

```gdscript
# player.gd
class_name Player
extends CharacterBody2D

enum State { IDLE, RUN, JUMP, ATTACK, DEAD }
var state: State = State.IDLE

func _physics_process(delta: float) -> void:
    match state:
        State.IDLE:   _state_idle(delta)
        State.RUN:    _state_run(delta)
        State.JUMP:   _state_jump(delta)
        State.ATTACK: _state_attack(delta)
        State.DEAD:   pass

func _transition(new_state: State) -> void:
    if state == new_state:
        return
    state = new_state
```

### 6.2 Node-Based FSM (Complex AI, many states)

```
StateMachine.tscn (Node)
├── IdleState   (Node — idle_state.gd)
├── PatrolState (Node — patrol_state.gd)
├── ChaseState  (Node — chase_state.gd)
└── AttackState (Node — attack_state.gd)
```

# ponytail: The enum FSM handles 90% of cases. Only reach for node-based FSM
# when states have complex enter/exit logic or 10+ states.

---

## 7. Project Folder Structure

```
res://
├── autoloads/          # Singleton scripts
├── resources/          # .tres data files (items, stats, configs)
│   ├── items/
│   └── enemies/
├── scenes/             # .tscn files organized by feature
│   ├── actors/
│   │   ├── player/
│   │   └── enemies/
│   ├── levels/
│   ├── ui/
│   └── components/     # reusable component scenes
├── scripts/            # Pure GDScript utilities (no scene)
├── shaders/            # .gdshader files
├── assets/
│   ├── art/
│   ├── audio/
│   └── fonts/
├── addons/             # Plugin files (don't edit manually)
└── project.godot
```

Rules:
- Keep scene + script together in the same folder (player.tscn + player.gd)
- Prefix component scenes: health_component.tscn, hurt_box.tscn
- Autoloads go in autoloads/ and are named in project.godot

---

## 8. GDScript Best Practices

### 8.1 Type Everything

```gdscript
# BAD — runtime errors, no autocomplete
var speed = 200
func move(delta): position.x += speed * delta

# GOOD — caught at parse time, better performance
var speed: float = 200.0
func move(delta: float) -> void: position.x += speed * delta
```

### 8.2 Use @export for Designer Tunables

```gdscript
@export_group("Movement")
@export var walk_speed: float = 200.0
@export var run_speed: float = 400.0
@export var jump_force: float = 600.0

@export_group("Combat")
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.5
```

### 8.3 Cache Nodes with @onready

```gdscript
# Cache once in _ready() — avoid repeated $lookup calls in _process
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var health: HealthComponent = $HealthComponent
@onready var sprite: Sprite2D = $Sprite2D
```

---

## 9. Physics & Collision Architecture

| Node Type              | Use Case                                        |
|:-----------------------|:------------------------------------------------|
| StaticBody2D/3D        | Immovable walls, floors                         |
| CharacterBody2D/3D     | Player, enemies — manual velocity control       |
| RigidBody2D/3D         | Physics-simulated props, projectiles, debris    |
| Area2D/3D              | Triggers, hitboxes, hurtboxes, detection zones  |

### Hitbox / Hurtbox Pattern

```
Enemy.tscn
├── CharacterBody2D
├── CollisionShape2D          <- physical body collision
├── HurtBox (Area2D)          <- detects incoming attacks
│   └── CollisionShape2D
└── HitBox (Area2D)           <- deals damage on overlap
    └── CollisionShape2D
```

Use Collision Layers and Masks (Project Settings -> Physics) to control what
detects what — never use Groups for physics filtering.

```
Layer 1: World (static geometry)
Layer 2: Player
Layer 3: Enemies
Layer 4: Player Attacks (hitboxes)
Layer 5: Enemy Attacks (hitboxes)
```

---

## 10. Common Architectural Mistakes and Fixes

| Mistake                  | Symptom                              | Fix                              |
|:-------------------------|:-------------------------------------|:---------------------------------|
| God script               | One 2000-line script does everything | Split into components/states     |
| Sibling references       | get_parent().get_node("Sibling")     | Use signals or EventBus          |
| Spaghetti scene tree     | Deeply nested, no logical grouping   | Flatten, use container nodes     |
| Modifying shared Resources | All instances mutate together      | .duplicate() in _ready()         |
| Everything in Autoload   | Giant GameManager 500+ lines         | One Autoload per responsibility  |
| No class_name            | Can't type-hint custom nodes         | Add class_name MyNode at top     |
| String node paths        | get_node("../../UI/Label")           | @onready + direct scene design   |

---

## 11. Quick Reference — When to Use What

```
Need global state across scenes?          -> Autoload
Need reusable data (item stats, config)?  -> Custom Resource (.tres)
Need to decouple parent from child?       -> Signal (emit upward)
Need to decouple unrelated systems?       -> EventBus Autoload
Need to reuse a scene instance?           -> Scene instancing (@export PackedScene)
Need per-instance behavior variations?    -> Enum FSM or Component scenes
Need physics detection (no collision)?    -> Area2D/3D
Need editor-tunable values?               -> @export
Need to share code without inheritance?   -> Composition + component scenes
```

---

## 12. Further Reading

- Godot Docs Best Practices:    https://docs.godotengine.org/en/stable/tutorials/best_practices/
- Godot Docs Signals:           https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
- Godot Docs Resources:         https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
- GDQuest (video tutorials):    https://www.gdquest.com/
