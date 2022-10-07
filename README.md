# FS22 Contract HUD

Helpful small HUD displaying the current completion percentage of all active contracts

![](screenshots/example.png?raw=true)

### Hotkeys:
ALT + M  -  Toggle between 3 possible modes (progress bar, percentage [default], hidden)

Version 1.2.0.0: (the.geremy)
- added dynamic background with default width and height, so it will not shrink under this values
- matching colors of contract with status and ingame notification message colors

Version 1.1.0.4: (the.geremy)
- optimization and code clean up
- correction of % display when decimal part below 0.1
- try to match green color of completed mission message, no luck :D
- back to default white color

Version 1.1.0.3: (the.geremy)
- added translation support

Version 1.1.0.2: (the.geremy)
- row height adjustment + 18%

Version 1.1.0.1: (the.geremy)
- small displaying adjustments (in same cases text was too long)
- when zero progress show contracted litters or remaining time (percentage mode / progress bar mode)
- row height adjustment + 15%

Version 1.1.0.0: (the.geremy)
- autohide info when no active missions
- change of colors to see it better during day and night
- row height adjustment + 10%
- show percentage with one decimal number
- enhance info
    - show field work type (sow, cultivate, harvest...)
    - show also fruit type when available (barley, wheat, oat ...)
- when zero progress (progress bar / percentage) show other info (fruit type, remaining time, contracted litters)
- when progress show only field number and progress bar or percentage
- enhanced progress bar
    - now each bar means 5% exactly - | "full bar"
    - also show progress by 2.5% - ¦ "half bar"
- support for supplyTransport missions mod
    - when zero progress show fruit type, contracted litters and remaining time
    - when progress show fruit type and progress bar / fruit type and percentage
