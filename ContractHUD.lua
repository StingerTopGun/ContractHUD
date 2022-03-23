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
ContractHUD.Colors[5]  = {'col_red', {0.7215, 0.0392, 0.0156, 1}}	
ContractHUD.Colors[6]  = {'col_green', {0.6313, 0.9372, 0.2627, 1}}

ContractHUD.activeMissons = 0

-- displayMode
-- 0 = full display - default
-- 1 = display without bars
-- 2 = hide HUD
ContractHUD.displayMode = 0


function ContractHUD:registerActionEvents()
	g_inputBinding:registerActionEvent('CH_toggle_displaymode', self, ContractHUD.toggleDisplayMode, false, true, false, true)
end

function ContractHUD:draw()
	if g_client ~= nil and g_currentMission.hud.isVisible and ContractHUD.displayMode ~= 2 then
		
		local posX = g_currentMission.hud.gameInfoDisplay.backgroundOverlay.overlay.x
        local posY = g_currentMission.hud.gameInfoDisplay.backgroundOverlay.overlay.y
		local size = g_currentMission.inGameMenu.hud.inputHelp.helpTextSize
        posY = posY + g_currentMission.hud.gameInfoDisplay.backgroundOverlay.overlay.height - g_currentMission.inGameMenu.hud.inputHelp.helpTextSize
        posX = posX - ( g_currentMission.inGameMenu.hud.inputHelp.helpTextOffsetY * 2 )

        local outputText = g_i18n:getText("CH_headline") .. ContractHUD.activeMissons
        local completion = 0
        local countContracts = 0

        ContractHUD:renderText(posX, posY, size, outputText, false, 1)
        posY = posY - size  -- shift one line down because of headline

        for _, contract in ipairs(g_missionManager.missions) do
            if contract.status >= 1 and g_currentMission.player.farmId == contract.farmId then  -- only show active contracts, 0 is inactive i guess, and only from current farm
                    
                -- handle color and completion
                if contract.status == 2 and contract.success == true then  -- contract finished, set completion to 100% and text green
                    completion = 1
                    textColor = 6  -- green
                elseif contract.status == 2 and contract.success == false then  -- contract failed
                    completion = contract.completion
                    textColor = 5  -- red
                else  -- contract active, get current completion and set text white
                    completion = contract.completion
                    textColor = 1  -- white
                end

                outputText = contract.type["name"] .. " - " .. g_i18n:getText("CH_field") .. " " .. contract.field.fieldId .. " - " .. math.floor((completion * 100) + 0.5) .. " %"

                -- generate status bar
                if ContractHUD.displayMode ~= 1 then
                    local maxPositions = 20
                    local currentLevel = math.floor((completion * 20) + 0.5)
                    local barText = "["
                    -- add progress
                    for i = 1, currentLevel do
                        barText = barText .. "|"
                    end
                    -- add empty
                    for i = 1, maxPositions - currentLevel do
                        barText = barText .. ":"
                    end
                    barText = barText .. "]"

                    outputText = outputText .. " " .. barText
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

function ContractHUD.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
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
