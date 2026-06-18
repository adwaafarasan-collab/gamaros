# GAMAROS - Architecture & Technical Overview

## Project Structure

```
GAMAROS/
├── project.godot                 # Godot project configuration
├── ARCHITECTURE.md              # This file
├── README.md                    # Project overview
│
├── Scripts/
│   ├── GameManager.gd          # Singleton: Game state, level management
│   ├── Hero/
│   │   └── Hero.gd             # Player character controller
│   ├── Voice/
│   │   ├── VoiceManager.gd     # Voice input processing & commands
│   │   └── VoiceProcessor.gd   # [TODO] Real voice recognition
│   ├── AI/
│   │   ├── NPCBase.gd          # Base class for NPCs
│   │   ├── AIBehaviorTree.gd   # [TODO] Behavior tree for AI
│   │   └── DialogueSystem.gd   # [TODO] NPC dialogue engine
│   ├── Localization/
│   │   └── LocalizationManager.gd # Translation & language handling
│   ├── Game Logic/
│   │   ├── LevelManager.gd     # Level progression & objectives
│   │   └── CombatSystem.gd     # [TODO] Combat mechanics
│   ├── Utils/
│   │   ├── Constants.gd        # Global constants
│   │   └── Helpers.gd          # Utility functions
│   └── Menu/
│       └── MainMenuController.gd # Main menu UI logic
│
├── Scenes/
│   ├── Menu/
│   │   ├── MainMenu.tscn       # Main menu screen
│   │   ├── SettingsMenu.tscn   # [TODO] Settings screen
│   │   └── PauseMenu.tscn      # [TODO] Pause menu
│   ├── Setup/
│   │   ├── AgeSelection.tscn   # [TODO] Age selection screen
│   │   └── DifficultySelection.tscn # [TODO] Difficulty selection
│   ├── Levels/
│   │   ├── Level1.tscn         # [TODO] First level
│   │   ├── Level2.tscn         # [TODO] Second level
│   │   └── LevelTemplate.tscn  # [TODO] Base level template
│   └── NPCs/
│       ├── FriendlyNPC.tscn    # [TODO] Ally NPC
│       └── EnemyNPC.tscn       # [TODO] Enemy NPC
│
├── Assets/
│   ├── 3D/
│   │   ├── Models/             # 3D character models
│   │   ├── Environments/       # Level environments
│   │   └── Props/              # Interactive objects
│   ├── Audio/
│   │   ├── Music/              # Background music
│   │   ├── SFX/                # Sound effects
│   │   └── Voice/              # Voice lines (pre-recorded)
│   ├── Textures/               # 3D textures & materials
│   └── UI/
│       ├── icon.svg            # Game icon
│       ├── Buttons/            # UI button graphics
│       └── Fonts/              # Custom fonts (Arabic support)
│
└── Localization/
    ├── strings.json            # String translations
    ├── translations.ar.translation  # [TODO] Godot .translation file (AR)
    └── translations.en.translation  # [TODO] Godot .translation file (EN)
```

## Core Systems

### 1. **Game Manager** (Singleton)
- Central hub for all game state
- Manages: Current level, player stats, difficulty, age group
- Signals: game_started, game_paused, level_changed, game_over
- Auto-loaded in project.godot

### 2. **Voice Manager** (Singleton)
- Processes voice input (will integrate Web Speech API)
- Recognizes voice commands
- Handles NPC text-to-speech responses
- Supports: Arabic & English
- Auto-loaded in project.godot

### 3. **Localization Manager** (Singleton)
- Provides translations for all UI text
- Manages language switching
- Age-group content filtering
- Supports: Arabic & English
- Auto-loaded in project.godot

### 4. **Hero (Player Character)**
- Inherits: CharacterBody3D
- Controls: Movement, combat, health, state
- Responds to voice commands
- States: IDLE, MOVING, ATTACKING, DEFENDING, INJURED, CAPTURED
- Key Feature: "Never defeated" - Can be captured/injured but always recovers

### 5. **NPC Base Class**
- Inherits: Node3D
- Implements: Dialogue, behavior state machine
- Types: neutral, ally, enemy
- Features: Multi-line dialogue, voice responses

### 6. **Level Manager**
- Tracks level objectives
- Manages progression
- Calculates completion percentage

## Age Customization System

### Age Groups:
1. **3-6 Years**: Simple vocabulary, longer time limits, reduced difficulty
2. **7-12 Years**: Intermediate challenges, standard difficulty
3. **13-17 Years**: Advanced puzzles, competitive difficulty
4. **18+ Years**: Expert challenges, time pressure

### Customization Applied To:
- Difficulty multiplier (0.5x to 1.2x)
- Time limits per level
- Vocabulary complexity
- Content filtering (violence, scary elements)
- Educational focus

## Voice Command System

### Supported Commands (Arabic & English):
- "هجوم" / "attack" → Hero attacks
- "دفاع" / "defend" → Hero defends
- "تحرك" / "move" → Hero moves
- "تحدث" / "talk" → Dialogue with NPCs
- "ساعدني" / "help" → Request assistance
- "اركض" / "run" → Sprint

### Future Enhancements:
- Context-aware commands
- Multi-word voice phrases
- Emotional voice tone analysis

## Development Phases

### ✅ Phase 1: Foundation (CURRENT)
- [x] Project initialization
- [x] Core GameManager
- [x] Voice system framework
- [x] Localization system
- [x] Hero controller skeleton
- [x] NPC base class
- [ ] Main menu UI
- [ ] Age selection screen

### Phase 2: Core Gameplay
- [ ] 3D level design
- [ ] Combat system
- [ ] Puzzle mechanics
- [ ] AI behavior trees
- [ ] Inventory system
- [ ] Dialogue system

### Phase 3: Polish & Release
- [ ] Visual effects
- [ ] Sound design
- [ ] Performance optimization
- [ ] Testing & QA
- [ ] Beta testing with target audience

## Technical Decisions

### Why Godot 4.x?
- ✅ Open source & free
- ✅ Excellent mobile support (iOS/Android)
- ✅ Native 3D capabilities
- ✅ GDScript (Python-like, easy to learn)
- ✅ Built-in localization support
- ✅ Active community

### Voice Integration
- **Web Speech API** (for HTML5 version)
- **Azure Cognitive Services** (for cloud backup)
- **Godot AudioStreamPlayer** (for TTS responses)

### Asset Creation
- 3D Models: Blender (free)
- Textures: Substance Designer or GIMP
- Audio: Audacity (free) + professional voice actors (Arabic)
- UI Fonts: Include Arabic-supporting fonts (e.g., Cairo, Amiri)

## Next Steps

1. Create main menu UI scene
2. Build age selection screen
3. Implement difficulty selection
4. Create first test level
5. Integrate Web Speech API for real voice recognition
6. Build basic combat system
7. Create NPC dialogue system

## Resources & References

- Godot Docs: https://docs.godotengine.org
- GDScript Guide: https://docs.godotengine.org/en/stable/getting_started/scripting/gdscript/index.html
- Web Speech API: https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API
- Arabic Font Support: https://github.com/google/noto-sans-arabic
