local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }

  -- Credits To @Kalu / @Kashnars For Doing the money part, I just took their wallet script and remade it https://forum.fivem.net/t/release-allcity-wallet-esx/145419 If you wan't me to remove it please pm me-->

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Keys['Y']) then
            getInventory()
            SendNUIMessage({
                action = "open",
                array = source
            })
            SetNuiFocus(true, true)
        end
    end
end)

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(500)
		TriggerServerEvent('allcity_wallet:getMoneys')
	end
	
end)

RegisterNetEvent("allcity_wallet:setValues")


RegisterNUICallback('NUIFocusOff', function()
	open = false
	SetNuiFocus(false, false)
	SendNUIMessage({type = 'close'})
end)

AddEventHandler("allcity_wallet:setValues", function(wallet, bank, black_money, society)

	SendNUIMessage({
		wallet = wallet,
		bank = bank,
		black_money = black_money
		})	

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

    local weaponsList = ESX.GetWeaponList()
    for i=1, #weaponsList, 1 do
        local weaponHash = GetHashKey(weaponsList[i].name)

        if HasPedGotWeapon(playerPed, weaponHash, false) and weaponsList[i].name ~= 'WEAPON_UNARMED' then
            local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
            table.insert(item, {weaponsList[i].name, ammo})
        end
    end
    
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
    TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', data.item, data.count)
end)

RegisterNUICallback('use', function(data)
    print(data.item)
    TriggerServerEvent('esx:useItem', data.item)
    SendNUIMessage({
        action = "close"
    })
end)
