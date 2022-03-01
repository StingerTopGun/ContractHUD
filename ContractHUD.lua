-- Contract HUD for FS22
--
-- This mod displays the status with percentage done of every active contract on the active farm always on the HUD
--
-- Author: StingerTopGun

ContractHUD = {}
ContractHUD.eventName = {}
ContractHUD.ModName = g_currentModName
ContractHUD.ModDirectory = g_currentModDirectory
ContractHUD.Version = "1.0.0.0"

ContractHUD.Colors = {}
ContractHUD.Colors[1]  = {'col_white', {1, 1, 1, 1}}
ContractHUD.Colors[2]  = {'col_black', {0, 0, 0, 1}}
ContractHUD.Colors[3]  = {'col_grey', {0.7411, 0.7450, 0.7411, 1}}
ContractHUD.Colors[4]  = {'col_blue', {0.0044, 0.15, 0.6376, 1}}
ContractHUD.Colors[5]  = {'col_red', {0.7835, 0.0034, 0.0030, 1}}
ContractHUD.Colors[6]  = {'col_green', {0.0395, 0.2015, 0.0242, 1}}
ContractHUD.Colors[7]  = {'col_cyan', {0.0003, 0.5647, 0.9822, 1}}
ContractHUD.Colors[8]  = {'col_orange', {1.0000, 0.1413, 0.0000, 1}}
ContractHUD.Colors[9]  = {'col_dgreen', {0.1062, 0.5234, 0.1450, 1}}
ContractHUD.Colors[10]  = {'col_sorange', {1.0000, 0.1830, 0.0210, 1}}

ContractHUD.HeadlineColor = 7 -- put here color index from above
ContractHUD.MissionTextColor = 10 -- default active mission color, put here color index from above

ContractHUD.activeMissons = 0

-- displayMode
-- 0 = display with bars, witout % number, with field work or fill type info
-- 1 = display without bars, with % number, with field work or fill type info - default
-- 2 = hide HUD
ContractHUD.displayMode = 1


function ContractHUD:registerActionEvents()
	g_inputBinding:registerActionEvent('CH_toggle_displaymode', self, ContractHUD.toggleDisplayMode, false, true, false, true)
end

function ContractHUD:update(dt)
	-- if zero active missions, check for new active missions (the.geremy)
	if ContractHUD.activeMissons == 0 then
    	local countContracts = 0

        for _, contract in ipairs(g_missionManager.missions) do
      	    if contract.status >= 1 and g_currentMission.player.farmId == contract.farmId then  -- only show active contracts, 0 is inactive i guess, and only from current farm
                countContracts = countContracts + 1
            end
        end

        ContractHUD.activeMissons = countContracts
    end
end

function ContractHUD:draw()
    -- added condition to display info only if any active mission (the.geremy)
	if g_client ~= nil and g_currentMission.hud.isVisible and ContractHUD.displayMode ~= 2 and ContractHUD.activeMissons ~= 0 then

		local posX = g_currentMission.hud.gameInfoDisplay.backgroundOverlay.overlay.x
        local posY = g_currentMission.hud.gameInfoDisplay.backgroundOverlay.overlay.y
		local size = g_currentMission.inGameMenu.hud.inputHelp.helpTextSize * 1.18 -- add 18%
        posY = posY + g_currentMission.hud.gameInfoDisplay.backgroundOverlay.overlay.height - g_currentMission.inGameMenu.hud.inputHelp.helpTextSize
        posX = posX - ( g_currentMission.inGameMenu.hud.inputHelp.helpTextOffsetY * 2 )

        local outputText = g_i18n:getText("CH_headline") .. ContractHUD.activeMissons
        local completion = 0
        local countContracts = 0

        local field_text = ""
        local field_work = ""
        local fruitTypeName = ""

        -- print haadline
        ContractHUD:renderText(posX, posY, size, outputText, false, ContractHUD.HeadlineColor)
        posY = posY - size  -- shift one line down because of headline

        for _, contract in ipairs(g_missionManager.missions) do
            if contract.status >= 1 and g_currentMission.player.farmId == contract.farmId then  -- only show active contracts, 0 is inactive i guess, and only from current farm

                -- handle color and completion
                if contract.status == 2 and contract.success == true then  -- contract finished, set completion to 100% and text green
                    completion = 1
                    textColor = 9  -- green
                elseif contract.status == 2 and contract.success == false then  -- contract failed
                    completion = contract.completion
                    textColor = 5  -- red
                else  -- contract active, get current completion and set text color
                    completion = contract.completion
                    textColor = ContractHUD.MissionTextColor
                end        

                -- handle field_text also for supplyTransport contract
                if contract.type.name == "supplyTransport" then -- check if supplyTransport contract
                    field_text = "Supply"
                else
                    field_text = g_i18n:getText("CH_field") .. " " .. contract.field.fieldId
                end

                -- add info about field work or fill type if supplyTransport contract
                if contract.type.name == "supplyTransport" then -- check if supplyTransport contract
                    field_work = ContractHUD:getFillTypeTitle(contract.fillType) -- fillType has only index, we need to change it to field type name
					-- contracted liters contract.contractLiters
                elseif contract.type.name ~= nil then
                    field_work = ContractHUD:firstToUpper(contract.type.name) -- make first letter Upper case, other type missions like sow, fertilize, harvest....
                else
                    field_work = "other"
                end

                -- displayMode
                -- 0 = display with bars, witout % number, with field work or fill type info
                -- 1 = display without bars, with % number, with field work or fill type info - default
                -- 2 = hide HUD
                if ContractHUD.displayMode == 0 then
                    if contract.type.name == "supplyTransport" then
                        if completion == 0 then -- when 0%, display remianing time
                            outputText = field_text .. " - " .. field_work .. " - " .. ContractHUD:getRemainingTime(contract)
                        else -- else progress bar                            
                            outputText = field_text .. " - " .. field_work .. " " .. ContractHUD:buildProgressBar(completion)
                        end
                    else -- other then supplyTransport contracts
                        if completion == 0 then -- when 0%, display fuit type title
                            if contract.type.name == "sow" then
                                outputText = field_text .. " - " .. field_work .. " - " .. ContractHUD:getFruitTypeName(contract.fruitType)
                            elseif contract.type.name == "harvest" then
                                outputText = field_text .. " - " .. field_work .. " - " .. ContractHUD:getFillTypeTitle(contract.fillType)
                            else
                                outputText = field_text .. " - " .. field_work
                            end
                        else -- else progress bar
                            outputText = field_text .. " " .. ContractHUD:buildProgressBar(completion)
                        end
                    end
                elseif ContractHUD.displayMode == 1 then -- 1 = display without bars, with % number, with field work or fill type info - default
                    if contract.type.name == "supplyTransport" then
                        if completion == 0 then -- when 0%, display contracted liters
                            outputText = field_text .. " - " .. field_work .. " - " .. ContractHUD:formatLitters(contract.contractLiters)
                        else -- else display percentage
                            outputText = field_text .. " - " .. field_work .. " - " .. string.format("%.1f", (math.floor(completion * 1000) / 10)) .. " %" -- set percentage to one dec like 95.6%
                        end
                    else -- other then supplyTransport contracts
                        if completion == 0 then -- when 0%, display fruit type title
                            if contract.type.name == "sow" then
                                outputText = field_text .. " - " .. field_work .. " - " .. ContractHUD:getFruitTypeName(contract.fruitType)
                            elseif contract.type.name == "harvest" then
                                outputText = field_text .. " - " .. field_work .. " - " .. ContractHUD:getFillTypeTitle(contract.fillType)                                
                            else
                                outputText = field_text .. " - " .. field_work
                            end
                        else -- else display percentage
                            outputText = field_text .. " - " .. string.format("%.1f", (math.floor(completion * 1000) / 10)) .. " %" -- set percentage to one dec like 95.6%
                        end
                    end
                end

                ContractHUD:renderText(posX, posY, size, outputText, false, textColor)

                posY = posY - size  -- shift one line down

                -- handle counting
                countContracts = countContracts + 1      
            end
        end

        ContractHUD.activeMissons = countContracts
	end
end

function ContractHUD:formatLitters(number)
  -- fhis fill format any number
  -- example
     -- 1234 >> 1.234
     -- 123456789.1234 >> 123.456.789
     -- -123456789.1234 >> 123.456.789

  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
  local result = ""

  -- reverse the int-string and append a comma to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1,")

  -- this will return exactly the same number
  -- reverse the int-string back remove an optional comma and put the 
  -- optional minus and fractional part back
  --  int = int:reverse():gsub("(%d%d%d)", "%1,")

  -- reverse the int-string back remove an optional comma and put the 
  -- optional minus and fractional part back
  -- return minus .. int:reverse():gsub("^,", "") .. fraction

  -- but I need only positive numbers without fraction and with dot separator
  result = int:reverse():gsub("^,", "")
  return result:gsub(",", ".") .. " l"
  
end

function ContractHUD:buildProgressBar(completion)
    -- constract text progress bar like this: [||||||||¦:::::]
    local maxPositions = 20                    
    local currentLevel5 = math.floor((completion / 0.05))
    local modulo5 = (completion % 0.05)
    local currentLevel25 = math.floor((modulo5 / 0.025))
    local remain = maxPositions - currentLevel5 - currentLevel25
    local barText = "["

    -- add progress by 5 %
    for i = 1, currentLevel5 do
        barText = barText .. "|"
    end

    -- add progress 2.5%
    for i = 1, currentLevel25 do
        barText = barText .. "¦"
    end

    -- add empty
    for i = 1, remain do
        barText = barText .. ":"
    end

    barText = barText .. "]"
                                        
    return barText
end

function ContractHUD:getFruitTypeName(fruitTypeIndex)
    if fruitTypeIndex ~= nil and type(fruitTypeIndex) == "number" then 
        local fruitTypeTable = g_fruitTypeManager:getFruitTypeByIndex(fruitTypeIndex)
        return fruitTypeTable ~= nil and ContractHUD:firstToUpper(fruitTypeTable.name) or ""
    end
    return "NULL"
end

-- this function is for debugging purpose
function ContractHUD:getTableKeys(tableObject)
    if tableObject ~= nil and type(tableObject) == "table" then
        local keyset={}
        local n=0
        
        for k,v in pairs(tableObject) do
            n=n+1
            keyset[n]=k
        end

        -- print to log.txt
        print(table.concat(keyset,","))
        --returns concatenated string of table keys
        return table.concat(keyset,",")        
    end

    if tableObject == nil then
        return "NULL2"
    elseif  type(tableObject) == "string" then
        return tableObject
    else    
        return type(tableObject)
    end
end

function ContractHUD:getFillTypeTitle(fillTypeIndex)
    if fillTypeIndex ~= nil then
        local fillTypeDesc = g_fillTypeManager:getFillTypeByIndex(fillTypeIndex)
        return fillTypeDesc ~= nil and ContractHUD:firstToUpper(fillTypeDesc.title) or ""
    end
    return nil
end

function ContractHUD:firstToUpper(str)
    return (string.lower(str):gsub("^%l", string.upper))
end

function ContractHUD:getRemainingTime(contract)
    local environment = g_currentMission.environment

    local usedDaysToMinutes = (environment.currentDay - contract.contractDay) * 24 * 60
    local usedMinutes = MathUtil.msToMinutes(environment.dayTime - contract.contractTime)

    local remainingMinutes = contract.contractDuration - (usedDaysToMinutes + usedMinutes)

    if remainingMinutes > 0 then
        local hours = math.floor(remainingMinutes / 60)
        local minutes = remainingMinutes - hours * 60
        local seconds = (remainingMinutes - math.floor(remainingMinutes)) * 60

        return string.format("%02d:%02d:%02d", hours, minutes, seconds)
    end

    return string.format("%02d:%02d:%02d", 0, 0, 0) -- return formated remianing time
end

function ContractHUD:renderText(x, y, size, text, bold, colorId)
	setTextColor(unpack(self.Colors[colorId][2]))
	setTextBold(bold)
	setTextAlignment(RenderText.ALIGN_RIGHT)
	renderText(x, y, size, text)

	-- Back to defaults
	setTextBold(false)
	setTextColor(unpack(self.Colors[1][2])) --Back to default color which is white
	setTextAlignment(RenderText.ALIGN_LEFT)
end

function ContractHUD.toggleDisplayMode()
    -- keep it simple
    if ContractHUD.displayMode >= 2 then  -- 2 = hidden, highest value
        ContractHUD.displayMode = 0
    else
        ContractHUD.displayMode = ContractHUD.displayMode + 1
    end
end

addModEventListener(ContractHUD)
FSBaseMission.registerActionEvents = Utils.appendedFunction(FSBaseMission.registerActionEvents, ContractHUD.registerActionEvents);
