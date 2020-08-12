local open = false
local society = {
    money = 0,
    inventory = {},
    name = "",
}
local pInv = {}
local pBoss = false

RegisterNetEvent("society:GetSocietyInfo")
AddEventHandler("society:GetSocietyInfo", function(info)
    society.money = info.money
    society.inventory = info.inventory
end)

RegisterNetEvent("rFw:InvRefresh")
AddEventHandler("rFw:InvRefresh", function(inv, weight)
    pInv = inv
end)

RegisterCommand("society", function(source, args, rawCommand)
    OpenSocietyMenu(args[1])
end, false)

RegisterNetEvent("society:OpenMenu")
AddEventHandler("society:OpenMenu", function(society)
    OpenSocietyMenu(society)
end)


RMenu.Add('society', 'main', RageUI.CreateMenu("Society menu", "Undefined for using SetSubtitle"))
RMenu:Get('society', 'main'):SetSubtitle("~b~Society menu")
RMenu:Get('society', 'main'):DisplayGlare(false)
RMenu:Get('society', 'main').Closed = function()
    open = false
end

RMenu.Add('society', 'inventory_society', RageUI.CreateSubMenu(RMenu:Get('society', 'main'), "Inventory", "~b~Society inventory"))
RMenu:Get('society', 'inventory_society').EnableMouse = false

RMenu.Add('society', 'inventory_player', RageUI.CreateSubMenu(RMenu:Get('society', 'main'), "Inventory", "~g~Player ~b~inventory"))
RMenu:Get('society', 'inventory_player').EnableMouse = false



function OpenSocietyMenu(societyName)
    if open then
        open = false
        return
    else
        open = true
        RageUI.Visible(RMenu:Get('society', 'main'), true)
        TriggerServerEvent("society:GetSocietyInfo", societyName)
        pInv = exports.rFw:GetPlayerInv()
        pInv = pInv.inv
        pBoss = exports.rFw:GetPlayerBossStatus()
        society.name = societyName

        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(RMenu:Get('society', 'main'), function()
                    RageUI.Item.Separator("↓ Society: ~b~"..tonumber(society.money).."$ ~s~↓")
                    RageUI.Item.Button('Society inventory', nil, {RightLabel = "→"}, true, {}, RMenu:Get('society', 'inventory_society'))
                    RageUI.Item.Button('Player inventory', nil, {RightLabel = "→"}, true, {}, RMenu:Get('society', 'inventory_player'))
                    RageUI.Item.Separator("↓ Action patron ↓")
                    RageUI.Item.Button("Test patron", nil, { }, pBoss == true, {
                        onSelected = function()
                            TriggerServerEvent("society:TestPatron")
                        end,
                    })
                end)


                RageUI.IsVisible(RMenu:Get('society', 'inventory_society'), function()

                    for k,v in pairs(society.inventory) do
                        RageUI.Item.Button(v.label.." x"..v.count, nil, { }, true, {
                            onSelected = function()
                                local amount = KeyboardAmount()
                                if amount ~= nil and amount > 0 and amount <= v.count then
                                    TriggerServerEvent("society:TakeItem", society.name, v.itemId, v.item, amount, v.count)
                                end
                            end,
                        })
                    end
                end)

                RageUI.IsVisible(RMenu:Get('society', 'inventory_player'), function()
                    for k,v in pairs(pInv) do
                        RageUI.Item.Button(v.label.." x"..v.count, nil, { }, true, {
                            onSelected = function()
                                local amount = KeyboardAmount()
                                if amount ~= nil and amount > 0 and amount <= v.count then
                                    TriggerServerEvent("society:SendItem", society.name, v.item, v.itemId, amount, v.args)
                                end
                            end,
                        })
                    end
                end)
                Wait(1)
            end
        end)
    end
end