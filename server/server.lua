local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")
recievedName = nil
sentName = nil
lang = Config.MenuLanguage

RegisterCommand('testrewards', function(source, args)
	local user_id = vRP.getUserId({source})
	vRP.tryBankPayment({user_id,100000}) 
    vRPclient.notifycustom(source, {'Bank', 'You paid 10.000$', 5000})
end)

RegisterCommand("pin", function(player, args)
    local user_id = vRP.getUserId({player})
	local target_id = parseInt(args[1])
	local target_src = vRP.getUserSource({target_id})
	if target_src == nil then
		vRPclient.notify(player,{string.format(Config.Languages[lang]['notonline'])})
	else
		local target_Name = vRP.getPlayerName({target_src})
		if vRP.isUserHelper({user_id}) then
				exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {target_id}, function(result)
					if result then
						for _, v in pairs(result) do
							local target_Name = vRP.getPlayerName({target_src})
							TriggerClientEvent("chatMessage", player, "^6[SYSTEM]^0: "..target_Name.." PIN IS "..v.pin.." !")
						end
					end
				end)
		end
	end
end)

RegisterNetEvent("nfr_revolut:requestMoneyAmountInBank")
AddEventHandler(
    "nfr_revolut:requestMoneyAmountInBank",
    function()
        local _source = source
        local user_id = vRP.getUserId({_source})
        local userbankBalanace = vRP.getBankMoney({user_id})
        vRP.getUserIdentity{user_id,function(identity)
            if identity ~= nil then
                local playerName = ""..identity.firstname.." "..identity.name..""
                exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                    if result then
                        for _, v in pairs(result) do
                          TriggerClientEvent("nfr_revolut:updateBankBalance", _source, userbankBalanace, playerName, v.lastSentAmount, v.lastNameSent, v.lastIdSent, v.lastRecievedAmount, v.lastNameRecieved, v.lastIdRecieved, v.color, v.textcolor)
                        end
                    end
                end)
              end
          end}
    end
)
RegisterNetEvent("nfr_revolut:checkNumber")
AddEventHandler(
    "nfr_revolut:checkNumber",
    function()
        local _source = source
        local user_id = vRP.getUserId({_source})
        local userbankBalanace = vRP.getBankMoney({user_id})
        local metanumber = exports["oxmysql"]:executeSync("SELECT metadata FROM vrp_users WHERE id = ?", {user_id});
        local md = json.decode(metanumber[1].metadata);
        TriggerClientEvent("nfr_revolut:updateNumber", _source, md.number)
    end
)
RegisterNetEvent("nfr_revolut:updateProfilePage")
AddEventHandler(
    "nfr_revolut:updateProfilePage",
    function()
        local _source = source
        local user_id = vRP.getUserId({_source})
        local userbankBalanace = vRP.getBankMoney({user_id})
        local playerTag = vRP.getPlayerName({_source})
        vRP.getUserIdentity{user_id,function(identity)
            if identity ~= nil then
                local playerName = ""..identity.firstname.." "..identity.name..""
                    TriggerClientEvent("nfr_revolut:updateProfilePage", _source, playerTag, playerName)
              end
          end}
    end
)
RegisterNetEvent("nfr_revolut:updateRewardCoins")
AddEventHandler(
    "nfr_revolut:updateRewardCoins",
    function()
        local _source = source
        local user_id = vRP.getUserId({_source})
        local userbankBalanace = vRP.getBankMoney({user_id})
                exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                    if result then
                        for _, v in pairs(result) do
                          TriggerClientEvent("nfr_revolut:updateRewardCoins", _source, v.rewardCoins)
                        end
                    end
                end)
    end
)


RegisterNetEvent("nfr_revolut:verify")
AddEventHandler(
    "nfr_revolut:verify",
    function()
      local _source = source
  	local thePlayer = _source
  	local user_id = vRP.getUserId({thePlayer})
        exports.oxmysql:execute("SELECT * FROM nfr_revolut WHERE user_id = @user_id", {user_id = user_id}, function(rows)
            if #rows == 0 then
              exports.oxmysql:insert('INSERT INTO nfr_revolut (user_id) VALUES (?) ', {user_id}, function(id) end)
              Wait(100)
              exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                  if result then
                      for _, v in pairs(result) do
                        TriggerClientEvent("nfr_revolut:isVerified", _source, v.pin, v.verified, v.lastSentAmount, v.lastNameSent, v.lastIdSent, v.lastRecievedAmount, v.lastNameRecieved, v.lastIdRecieved)
                      end
                  end
              end)
            else
              exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                  if result then
                      for _, v in pairs(result) do
                        TriggerClientEvent("nfr_revolut:isVerified", _source, v.pin, v.verified, v.lastSentAmount, v.lastNameSent, v.lastIdSent, v.lastRecievedAmount, v.lastNameRecieved, v.lastIdRecieved)

                      end
                  end
              end)
            end
        end)
end)

RegisterNetEvent("nfr_revolut:cod")
AddEventHandler(
    "nfr_revolut:cod",
    function(randomcod)
      _source = source
      local user_id = vRP.getUserId({_source})
      vRP.getUserIdentity{user_id,function(identity)
            if identity ~= nil then
                local mail = {
                    sender = "Revolut",
                    subject = "Code Verification",
                    message = [==[
                        Buna ziua 👋, ]==].. identity.firstname ..[==[ ]==].. identity.name ..[==[!<br>
                        Codul de verificare este: ]==].. randomcod ..[==[ <br>
                    ]==]
                }
                exports["qb-phone"]:Mail(_source, mail)
            end
        end}
  end)

  RegisterNetEvent("nfr_revolut:codcorrect")
  AddEventHandler(
      "nfr_revolut:codcorrect",
      function(pinCode)
        _source = source
        local user_id = vRP.getUserId({_source})
        iverified = 1
        exports.oxmysql:update('UPDATE nfr_revolut SET pin = ?, verified = ?  WHERE user_id = ? ', {pinCode, iverified, user_id}, function(affectedRows) end)
    end)
    RegisterNetEvent("nfr_revolut:updateTheme")
    AddEventHandler(
        "nfr_revolut:updateTheme",
        function(color, textcolor)
          _source = source
          local user_id = vRP.getUserId({_source})
          exports.oxmysql:update('UPDATE nfr_revolut SET color = ?, textcolor = ?  WHERE user_id = ? ', {color, textcolor, user_id}, function(affectedRows) end)
      end)
      RegisterNetEvent("nfr_revolut:updatePin")
      AddEventHandler(
          "nfr_revolut:updatePin",
          function(newPin)
            _source = source
            local user_id = vRP.getUserId({_source})
            exports.oxmysql:update('UPDATE nfr_revolut SET pin = ? WHERE user_id = ? ', {newPin, user_id}, function(affectedRows) end)
        end)

RegisterNetEvent("nfr_revolut:action")
AddEventHandler(
    "nfr_revolut:action",
    function(data)
        local _source = source
        local user_id = vRP.getUserId({_source})
        local userbankBalanace = vRP.getBankMoney({user_id})
        local userBalance = vRP.getMoney({user_id})
        TriggerClientEvent("nfr_revolut:updateBankBalance", _source, userbankBalanace, user_id)
        if (data.action == "withdraw") then
            local amountToWithdraw = tonumber(data.amount)
            if amountToWithdraw <= 0 then
                vRPclient.notify(_source,{Config.Languages[lang]['nullamountwithdraw']})
                return
            end
            if amountToWithdraw > userbankBalanace then
                vRPclient.notify(_source,{Config.Languages[lang]['notenoughbankmoney']})
                return
            else
                vRP.setBankMoney({user_id,userbankBalanace - amountToWithdraw})
                vRP.setMoney({user_id,userBalance + amountToWithdraw})
                vRPclient.notify(_source,{""..Config.Languages[lang]['succeswithdraw'].." "..amountToWithdraw.."$"})
                return
            end
        end
        if (data.action == "deposit") then
            local amountToDeposit = tonumber(data.amount)
            if amountToDeposit <= 0 then
                vRPclient.notify(_source,{Config.Languages[lang]['nullamountdeposit']})
                return
            end
            if amountToDeposit > userBalance then
                vRPclient.notify(_source,{string.format(Config.Languages[lang]['notenoughcashmoney'])})
                return
            else
                vRP.setBankMoney({user_id,userbankBalanace + amountToDeposit})
                vRP.setMoney({user_id,userBalance - amountToDeposit})
                vRPclient.notify(_source,{string.format(""..Config.Languages[lang]['succesdeposit'].." "..amountToDeposit.."$")})
                return
            end
        end
        if (data.action == "transfer") then
            local target_user_id = data.userid
            local target_source = vRP.getUserSource({tonumber(target_user_id)})
            local amountToTransfer = tonumber(data.amount)
            if target_source == nil then
                vRPclient.notify(_source,{string.format(Config.Languages[lang]['playernotonline'])})
                return
            end
            if tonumber(target_user_id) == tonumber(user_id) then
                vRPclient.notify(source,{string.format(Config.Languages[lang]['cantsendtohimself'])})
                return
            end
            if amountToTransfer > userbankBalanace then
                vRPclient.notify(_source,{string.format{Config.Languages[lang]['notenoughmoneyinbank']}})
                return
            else
                local target_Name = vRP.getPlayerName({target_source})
                local player_Name = vRP.getPlayerName({_source})
                local target_bankBalance = vRP.getBankMoney({target_user_id})
                        --CEL CARE PRIMESTE
                        exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {target_user_id}, function(result)
                            if result then
                                for _, v in pairs(result) do
                                  if v.verified == 0 then
                                    vRPclient.notify(_source,{string.format(Config.Languages[lang]['playerdoesntowncard'])})
                                  else
                                    exports.oxmysql:prepare('SELECT * FROM vrp_user_identities WHERE user_id = ?', {user_id}, function(resul2)
                                        if resul2 then
                                              local icFirstName = resul2.firstname
                                              local icLastName = resul2.name
                                              local icName = icLastName.." "..icFirstName
                                              exports.oxmysql:prepare('SELECT * FROM vrp_user_identities WHERE user_id = ?', {target_user_id}, function(resul3)
                                                  if resul3 then
                                                    local target_icFirstName = resul3.firstname
                                                    local target_icLastName = resul3.name
                                                    local target_icName = target_icLastName.." "..target_icFirstName
                                                        exports.oxmysql:update('UPDATE nfr_revolut SET lastRecievedAmount = ?, lastNameRecieved = ?, lastIdRecieved = ?  WHERE user_id = ? ', {amountToTransfer, icName, user_id, target_user_id}, function(affectedRows) end)
                                                        vRPclient.notify(target_source,{string.format(""..Config.Languages[lang]['recievedfrom'].." "..amountToTransfer.."$ "..Config.Languages[lang]['recievedfromplayer'].." "..player_Name.."!")})
                                                        vRP.setBankMoney({target_user_id,target_bankBalance + amountToTransfer})
                                                        TriggerClientEvent("nfr_revolut:updateTransactions", _source)
                                                        --CEL CARE TRIMITE
                                                        vRP.setBankMoney({user_id,userbankBalanace - amountToTransfer})
                                                        exports.oxmysql:update('UPDATE nfr_revolut SET lastSentAmount = ?, lastNameSent = ?, lastIdSent = ?  WHERE user_id = ? ', {amountToTransfer, target_icName, target_user_id, user_id}, function(affectedRows) end)
                                                        vRPclient.notify(_source,{string.format(""..Config.Languages[lang]['sentto'].." "..amountToTransfer.."$ "..Config.Languages[lang]['sentfromplayer'].." "..target_Name.."")})
                                                    end
                                                  end)
                                          end
                                        end)
                                  end
                                end
                            end
                        end)
                        return
            end
        end
        if (data.action == "redeem1") then
            exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                if result then
                    for _, v in pairs(result) do
                        if v.rewardCoins >= data.price then
                            exports.oxmysql:update('UPDATE nfr_revolut SET rewardCoins=rewardCoins-'..data.price..' WHERE user_id = ?;', {user_id}, function(affectedRows) end)
                            vRP.giveBankMoney({user_id,Config.Reward1})
                            vRPclient.notify(_source,{""..Config.Languages[lang]['youredeem'].." "..Config.Reward1.."$ "..Config.Languages[lang]['with'].." "..data.price.." "..Config.Languages[lang]['rewardcoins']..""})
                        else
                            vRPclient.notify(_source,{Config.Languages[lang]['notenoughrewardcoins']})
                        end
                    end
                end
            end)
        end
        if (data.action == "redeem2") then
            exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                if result then
                    for _, v in pairs(result) do
                        if v.rewardCoins >= data.price then
                            exports.oxmysql:update('UPDATE nfr_revolut SET rewardCoins=rewardCoins-'..data.price..' WHERE user_id = ?;', {user_id}, function(affectedRows) end)
                            vRP.giveBankMoney({user_id,Config.Reward2})
                            vRPclient.notify(_source,{""..Config.Languages[lang]['youredeem'].." "..Config.Reward2.."$ "..Config.Languages[lang]['with'].." "..data.price.." "..Config.Languages[lang]['rewardcoins']..""})
                        else
                            vRPclient.notify(_source,{Config.Languages[lang]['notenoughrewardcoins']})
                        end
                    end
                end
            end)
        end
        if (data.action == "redeem3") then
            exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                if result then
                    for _, v in pairs(result) do
                        local coins = v.rewardCoins
                        if coins >= data.price then
                            local hasVeh = exports.oxmysql:executeSync("SELECT id FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle", {["@user_id"] = user_id, ["@vehicle"] = ""..Config.Reward3..""})
                            if #hasVeh == 0 then
                                exports.oxmysql:update('UPDATE nfr_revolut SET rewardCoins=rewardCoins-'..data.price..' WHERE user_id = ?;', {user_id}, function(affectedRows) end)
                                math.randomseed(os.time())
                                local tempPlate = "REWARDS"
                                exports.oxmysql:execute("INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,vehicle_plate,veh_type,garage) VALUES(@user_id,@vehicle,@vehicle_plate,@veh_type,@garage)",{
                                    user_id = user_id,
                                    vehicle = Config.Reward3,
                                    vehicle_plate = tempPlate,
                                    veh_type = 'car',
                                    garage = 'House Garage',
                                    vehname = MasinaFra,
                                })
                    
                                vRPclient.notify(_source,{""..Config.Languages[lang]['youredeem'].." "..Config.Languages[lang]['car'].." "..Config.Languages[lang]['with'].." "..data.price.." "..Config.Languages[lang]['rewardcoins']..""})
                            else
                            vRPclient.notify(_source,{Config.Languages[lang]['alreadyown']})
                            end
                        else
                            vRPclient.notify(_source,{Config.Languages[lang]['notenoughrewardcoins']})
                        end
                    end
                end
            end)
        end
    end
)
