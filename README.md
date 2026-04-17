# Badminton Score Tracker

A standalone watchOS app for scoring badminton singles matches with full BWF rules.

## Features

- Split-screen tap interface — left half scores you, right half scores opponent
- Service court indicator (R/L) derived from server's score parity
- Full BWF win conditions: first to 21, deuce at 20-all, cap at 29-all
- Unlimited undo — restores score, server, and court side for any prior state
- Haptic feedback on point scored, win, and loss

## Tech Stack

| Layer | Technology |
|---|---|
| Platform | watchOS 26.4+ (standalone, no iPhone companion required) |
| Language | Swift 5.0 |
| UI | SwiftUI |
| State | `@Observable` (Observation framework) |
| Persistence | None — in-memory only |

## Project Structure

```
Badminton Score Tracker Watch App/
├── Models/
│   ├── Player.swift        # Player, CourtSide, GameStatus enums
│   ├── MatchEvent.swift    # Undo snapshot
│   └── MatchState.swift    # BWF game logic (@Observable)
├── Views/
│   ├── PreGameView.swift   # Who serves first?
│   ├── ScoringView.swift   # Split-tap live scorer
│   └── GameOverView.swift  # Result + new game
└── ContentView.swift       # Root view coordinator

Badminton Score Tracker Watch AppTests/
└── Badminton_Score_Tracker_Watch_AppTests.swift  # 15 unit tests
```

## Getting Started

1. Open `Badminton Score Tracker.xcodeproj` in Xcode 26.4+
2. Select the **Badminton Score Tracker Watch App** scheme
3. Run on Apple Watch simulator or physical device (watchOS 26.4+)

For physical device: connect iPhone via USB, enable Developer Mode on both iPhone and Watch, select Watch as run destination.

## Running Tests

Select the **Badminton Score Tracker Watch AppTests** target and press ⌘U.

Tests cover: service court sides, service transfer, win conditions (21-point, deuce, 29-all cap), and all undo scenarios.
