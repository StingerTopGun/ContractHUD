# FS22 Contract HUD

Helpful small HUD displaying the current completion percentage of all active contracts. Hud is hidden if no active contracts!

![](screenshots/final_example.png?raw=true)

### Hotkeys:
ALT + M&ensp;=>&ensp;Toggle between 5 possible modes (display mode 0 is default)

If you dont want to display decimals in percentage value, open zip file and change line 46 in ContractHUD.lua file:
- from:&emsp;ContractHUD.displayDecimals = true
- to:&emsp;&emsp;ContractHUD.displayDecimals = false

If you want headline to match cyan game color, open zip file and change line 37 in ContractHUD.lua file:
- from:&emsp;ContractHUD.HeadlineColor = 13
- to:&emsp;&emsp;ContractHUD.HeadlineColor = 7

If you want to change default display mode, open zip file and change line 60 in ContractHUD.lua file:
- from:&emsp;ContractHUD.displayMode = 0
- to:&emsp;&emsp;ContractHUD.displayMode = 3 -- mode number, in this example I want to have display mode 3 as default

Version 1.2.0.7: (the.geremy)
- formating number error fixed

Version 1.2.0.6: (the.geremy)
- change in display mode 3:
    <br>&ensp;Display mode: 3
    <br>&ensp;&emsp;- field mission - display field number and field work type and also crop type if available, if progress display % number and bar
    <br>&ensp;&emsp;- transport mission - display crop type, if progress display % number instead of required amount also display destination

Version 1.2.0.5: (the.geremy)
- added display modes
- now you can choose from this display modes:
    <br>&ensp;Display mode: 0
    <br>&ensp;&emsp;- field mission - display field number and field work type and also crop type if available, if progress display bar (default)
    <br>&ensp;&emsp;- transport mission - display mission type and crop type, if progress display bar instead of remaining time (default)
    <br>&ensp;Display mode: 1
    <br>&ensp;&emsp;- field mission - display field number and field work type and also crop type if available, if progress display bar
    <br>&ensp;&emsp;- transport mission - display mission type and crop type, if progress display % number instead of required amount
    <br>&ensp;Display mode: 2
    <br>&ensp;&emsp;- field mission - display field number and field work type and also crop type if available, if progress display % number and bar
    <br>&ensp;&emsp;- transport mission - display mission type and crop type, if progress display % number and bar instead of required amount
    <br>&ensp;Display mode: 3
    <br>&ensp;&emsp;- field mission - display field number and field work type and also crop type if available, if progress display % number and bar
    <br>&ensp;&emsp;- transport mission - display crop type, display % number and also display destination
    <br>&ensp;Display mode: 4
    <br>&ensp;&emsp;- HUD hidden

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
