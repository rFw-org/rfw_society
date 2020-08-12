RegisterNetEvent("society:GetSocietyInfo")
AddEventHandler("society:GetSocietyInfo", function(society)
    local info = exports.rFw:GetSocietyInfo(society)
    TriggerClientEvent("society:GetSocietyInfo", source, info)
end)


RegisterNetEvent("society:SendItem")
AddEventHandler("society:SendItem", function(society, item, itemId, count, args)
    exports.rFw:TransferItemToSociety(source, society, item, itemId, count, args)
end)

RegisterNetEvent("society:TakeItem")
AddEventHandler("society:TakeItem", function(society, itemid, item, count, countSee)
    exports.rFw:TransferItemFromSocietyToPlayer(source, society, itemid, item, count, countSee)
end)

RegisterNetEvent("society:TestPatron")
AddEventHandler("society:TestPatron", function()
    local patron = exports.rFw:IsPlayerBoss(source)
    print("Is player boss ? "..tostring(patron))
end)