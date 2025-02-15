local display = false
local isBankOpened = false
local closestATM, atmPos
lang = Config.MenuLanguage
Citizen.CreateThread(function()
    function SetDisplay(bool)
        display = bool
        SetNuiFocus(bool, bool)
        SendNUIMessage(
            {
                type = "ui",
                status = bool
            }
        )
    end




    RegisterNetEvent("nfr_revolut:updateBankBalance")
    AddEventHandler("nfr_revolut:updateBankBalance", function(balance, playerName, lastSentAmount, lastNameSent, lastIdSent, lastRecievedAmount, lastNameRecieved, lastIdRecieved, color, textcolor)
        SendNUIMessage({type = "updateBankBalance", balance = balance, playerNume = playerName, lastSentAmount = lastSentAmount, lastNameSent = lastNameSent, lastIdSent = lastIdSent, lastRecievedAmount = lastRecievedAmount, lastNameRecieved = lastNameRecieved, lastIdRecieved = lastIdRecieved, color = color, textcolor = textcolor})
    end)
    RegisterNetEvent("nfr_revolut:updateProfilePage")
    AddEventHandler("nfr_revolut:updateProfilePage", function(playerTag, playerName)
        SendNUIMessage({type = "updateProfilePage", playerTag = playerTag, playerName = playerName})
    end)
    RegisterNetEvent("nfr_revolut:updateRewardCoins")
    AddEventHandler("nfr_revolut:updateRewardCoins", function(rewardCoins)
        SendNUIMessage({type = "updateRewardCoins", rewardCoins = rewardCoins})
    end)
    RegisterNetEvent("nfr_revolut:updateNumber")
    AddEventHandler("nfr_revolut:updateNumber", function(number)
        SendNUIMessage({type = "updateNumber", number = number})
    end)
    RegisterNetEvent("nfr_revolut:updateTransactions")
    AddEventHandler("nfr_revolut:updateTransactions", function(rewardCoins)
        TriggerServerEvent(GetCurrentResourceName()..":requestMoneyAmountInBank")
    end)
    RegisterNUICallback("updateBankBalance", function()
        if display then
            TriggerServerEvent(GetCurrentResourceName()..":requestMoneyAmountInBank")
        end
    end)
    RegisterNUICallback("updateProfilePage", function()
        if display then
            TriggerServerEvent(GetCurrentResourceName()..":updateProfilePage")
        end
    end)
    RegisterNUICallback("updatePin", function(data)
        if display then
            local newPin = data.newPin
            TriggerServerEvent(GetCurrentResourceName()..":updatePin", newPin)
        end
    end)
    RegisterNUICallback("exit", function()
        if display then
            TriggerScreenblurFadeOut(750)
            SetDisplay(false)
            isBankOpened = false
        end
    end)
    RegisterNUICallback("verify", function()
        if display then
            TriggerServerEvent("nfr_revolut:verify")
        end
    end)
    RegisterNUICallback("checkNumber", function(data)
        if display then
            TriggerServerEvent("nfr_revolut:checkNumber")
        end
    end)
    RegisterNetEvent("nfr_revolut:isVerified")
      AddEventHandler("nfr_revolut:isVerified", function(pin, verified, lastSentAmount, lastNameSent, lastIdSent, lastRecievedAmount, lastNameRecieved, lastIdRecieved)
        if verified >= 1 then
            SendNUIMessage({type = "openVerified", pin = pin, lastSentAmount = lastSentAmount, lastNameSent = lastNameSent, lastIdSent = lastIdSent, lastRecievedAmount = lastRecievedAmount, lastNameRecieved = lastNameRecieved, lastIdRecieved = lastIdRecieved })
        else
            SendNUIMessage({type = "openRegister"})
        end
    end)

    RegisterNUICallback("action", function(data)
        if display then
            TriggerServerEvent("nfr_revolut:action", data.data)
        end
    end)
    RegisterNUICallback("updateRewardCoins", function(data)
        if display then
             TriggerServerEvent("nfr_revolut:updateRewardCoins")
        end
    end)
    
    RegisterNUICallback("cod", function(data)
      if display then
        local randomcod = tostring(data.cod)
        TriggerServerEvent("nfr_revolut:cod", randomcod)
      end
    end)
    RegisterNUICallback("updateTheme", function(data)
        if display then
          TriggerServerEvent("nfr_revolut:updateTheme", data.color, data.textcolor)
        end
    end)
    RegisterNUICallback("codcorrect", function(data)
      if display then
        local pinCode = tostring(data.pinCode)
        TriggerServerEvent("nfr_revolut:codcorrect", pinCode)
        TriggerServerEvent(GetCurrentResourceName()..":requestMoneyAmountInBank")
      end
    end)

end)

Citizen.CreateThread(function()
	local inRange = false
	local shown = false

    while true do
    	inRange = false
        Citizen.Wait(0)
        if NearBank() and not isBankOpened and NearBank() then
            	inRange = true

            if IsControlJustReleased(0, Config.KeyToOpenMenu) then
				SetDisplay(true)
                TriggerScreenblurFadeIn(750)
                TriggerServerEvent(GetCurrentResourceName()..":requestMoneyAmountInBank")
            end
        elseif NearBank() then
        	Citizen.Wait(300)
        else
        	Citizen.Wait(1000)
        end

        if inRange and not shown then
        	shown = true
            exports['nfr_textui']:Show(''..Config.KeyToOpenMenuText..'', ''..Config.Languages[lang]['toopen']..'')
        elseif not inRange and shown then
        	shown = false
            exports['nfr_textui']:Hide()
        end
    end
end)

Citizen.CreateThread(function()
	local inRange = false
	local shown = false

    while true do
    	inRange = false
        Citizen.Wait(0)
        if NearATM() and not isBankOpened and NearATM() then
            	inRange = true

            if IsControlJustReleased(0, Config.KeyToOpenMenu) then
				SetDisplay(true)
                TriggerScreenblurFadeIn(750)
                TriggerServerEvent(GetCurrentResourceName()..":requestMoneyAmountInBank")
            end
        elseif NearATM() then
        	Citizen.Wait(300)
        else
        	Citizen.Wait(1000)
        end

        if inRange and not shown then
        	shown = true
        	exports['nfr_textui']:Show(''..Config.KeyToOpenMenuText..'', ''..Config.Languages[lang]['toopen']..'')
        elseif not inRange and shown then
        	shown = false
        	exports['nfr_textui']:Hide()
        end
    end
end)



Citizen.CreateThread(function()
    while display do
        Citizen.Wait(10)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 106, display)
    end
end)



function NearATM()
    local pos = GetEntityCoords(GetPlayerPed(-1))

    for k, v in pairs(Config.ATMs) do
        local dist = GetDistanceBetweenCoords(v.x, v.y, v.z, pos.x, pos.y, pos.z, true)

        if dist <= 1 then
            return true
        end
    end
end

function NearBank()
    local pos = GetEntityCoords(GetPlayerPed(-1))

    for k, v in pairs(Config.banks) do
        local dist = GetDistanceBetweenCoords(v.x, v.y, v.z, pos.x, pos.y, pos.z, true)

        if dist <= 1.5 then
            return true
        end
    end
end

Citizen.CreateThread(
    function()
        if Config.ShowBankBlips then
            for _, bankCoords in ipairs(Config.banks) do
                local bankBlip = AddBlipForCoord(bankCoords.x, bankCoords.y, bankCoords.z)
                SetBlipSprite(bankBlip, bankCoords.id)
                SetBlipDisplay(bankBlip, 4)
                SetBlipScale(bankBlip, 0.9)
                SetBlipColour(bankBlip, 2)
                SetBlipAsShortRange(bankBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(tostring(bankCoords.name))
                EndTextCommandSetBlipName(bankBlip)
            end
        end
    end
)

Citizen.CreateThread(
    function()
        if Config.ShowATMBlips then
            for _, atmCoords in ipairs(Config.ATMs) do
                local atmBlip = AddBlipForCoord(atmCoords.x, atmCoords.y, atmCoords.z)
                SetBlipSprite(atmBlip, atmCoords.id)
                SetBlipDisplay(atmBlip, 4)
                SetBlipScale(atmBlip, 0.9)
                SetBlipColour(atmBlip, 2)
                SetBlipAsShortRange(atmBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(tostring(atmCoords.name))
                EndTextCommandSetBlipName(atmBlip)
            end
        end
    end
)
RegisterNetEvent('chatMessage')
AddEventHandler('chatMessage', function(author, color, text)
    local args = { text }
    if author ~= "" then
      table.insert(args, 1, author)
    end
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = color,
        multiline = true,
        args = args
      }
    })
  end)