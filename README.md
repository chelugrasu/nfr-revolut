
# NFR Revolut

A banking system inspired by the famous Revolut App. Made for vRP.


## Related

```lua
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
```
## Screenshots

![App Screenshot](https://i.imgur.com/zGVJ0Lz.png) 

![App Screenshot](https://i.imgur.com/Sq4Lbye.png) 

![App Screenshot](https://i.imgur.com/XjkhXMJ.png)  

![App Screenshot](https://i.imgur.com/xBbKInN.png) 

![App Screenshot](https://i.imgur.com/QQFrtOV.png) 

![App Screenshot](https://i.imgur.com/hJK7wrR.png) 

![App Screenshot](https://i.imgur.com/bk6ameL.png) 


##  Preview https://www.youtube.com/watch?v=9IBir-ysJJM


## Support

For support, add me on discord @cag_nfr .

