Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
            SendNUIMessage({
                action = "close"
            })
        end

        if IsControlJustReleased(0, 178) then
            getInventory()
            SendNUIMessage({
                action = "open",
                array = source
            })
            SetNuiFocus(true, true)
        end
    end
end)


RegisterNUICallback('NUIFocusOff', function()
	open = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
end)

ESX = nil

Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent("esx:getSharedObject", function(sharedObject) ESX = sharedObject end)
        Citizen.Wait(50)
    end

    while ESX.IsPlayerLoaded() == false do
        Citizen.Wait(5)
    end

    PlayerData = ESX.GetPlayerData()
end)

function getInventory()
    PlayerData = ESX.GetPlayerData()
    local playerPed = PlayerPedId()
    local inventory = PlayerData["inventory"]
    
    local item = {
        ["name"] = "test", ["amount"] = 2
    }
    
    for i = 1, #inventory do
        if inventory[i]["count"] >= 1 then
            table.insert(item, {inventory[i]["name"], inventory[i]["count"]})
        end
    end
    
    SendNUIMessage({
        items  = item
    })

    local item = {}
end

RegisterNUICallback('NUIFocusOff', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback("drop", function(data)
    print(data.item, data.count)
    TriggerServerEvent('esx:removeInventoryItem', 'item_standard', data.item , data.count)
end)

RegisterNUICallback('use', function(data)
    print(data.item)
    TriggerServerEvent('esx:useItem', data.item)
    SendNUIMessage({
        action = "close"
    })
end)