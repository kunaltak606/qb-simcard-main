local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-simcard:useSimCard')
AddEventHandler('qb-simcard:useSimCard', function(number)
    local src = source
    TriggerClientEvent('qb-simcard:startNumChange', src, number)     
end)

RegisterServerEvent('qb-simcard:changeNumber')
AddEventHandler('qb-simcard:changeNumber', function(newNum)
    TriggerClientEvent('qb-simcard:success', source, newNum)
end)

QBCore.Functions.CreateUseableItem("sim_card", function(source, item)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)    
    TriggerClientEvent('qb-simcard:changeNumber', source, xPlayer)
end)

RegisterServerEvent('qb-simcard:changeNumber')
AddEventHandler('qb-simcard:changeNumber', function(MData)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `players` WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'", function(result)
        local MetaData = json.decode(result[1].metadata)
        local Charinfo = json.decode(result[1].charinfo)
        MetaData.phone = MData
        Charinfo.phone = MData
        QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `metadata` = '"..json.encode(MetaData).."' WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
        QBCore.Functions.ExecuteSql(false, "UPDATE `players` SET `charinfo` = '"..json.encode(Charinfo).."' WHERE `citizenid` = '"..xPlayer.PlayerData.citizenid.."'")
    end)
    xPlayer.Functions.SetMetaData("phone", MData)
end)
