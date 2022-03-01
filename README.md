# FS22 Contract HUD

Helpful small HUD displaying the current completion percentage of all active contracts

![](screenshots/3_small.png?raw=true)

### Hotkeys:
ALT + W  -  Toggle between 3 possible modes (progress bar, percentage [default], hidden)

Version 1.1.0.0: (the.geremy)
- autohide info when no active missions
- change of colors to see it better during day and night
- row height adjustment
- show percentage with one decimal number
- enhance info
    - show field work type (sow, cultivate, harvest...)
    - show also fruit type when available (barley, wheat, oat ...)
- when zero progress (progress bar / percentage) show other info (fruit type, remaining time, contracted litters)
- when progress show only field number and progress bar or percentage
- enhanced progressBar
    - now each bar means 5% exactly - | "full bar"
    - also show progress by 2.5% - ¦ "half bar"
- support for supplyTransport missions mod
    - when zero progress show fruit type, contracted litters and remaining time
    - when progress show fruit type and progress bar / fruit type and percentage
