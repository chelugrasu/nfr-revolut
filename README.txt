-- FUNCTION FOR REWARD COINS

function vRP.tryBankPayment(user_id,amount)
  local bank = vRP.getBankMoney(user_id)
  if amount >= 0 and bank >= amount then
        if amount >= 20000 then
           exports.oxmysql:query('SELECT * FROM nfr_revolut WHERE user_id = ?', {user_id}, function(result)
                        if result then
                            for _, v in pairs(result) do
                                local rewardCoins = v.rewardCoins
                                local price = 20000
                                local howMuch = amount/price
                                exports.oxmysql:update('UPDATE nfr_revolut SET rewardCoins=rewardCoins+'..howMuch..' WHERE user_id = ?;', {user_id}, end)
                            end
                        end
                    end)
        end
    vRP.setBankMoney(user_id,bank-amount)
    return true
  else
    return false
  end
end