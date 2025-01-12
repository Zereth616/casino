QBCore = exports['qb-core']:GetCoreObject()
local currentCasinoChips = 0
local currentWinnings = 0

-- Fetch current casino chips from the server
local function fetchCurrentCasinoChips()
    TriggerServerEvent('getCurrentCasinoChips')
end

-- Open the slot machine UI
local function openSlotMachineUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "open",
        chips = currentCasinoChips,
        winnings = currentWinnings,
    })
end

-- Start the slot machine (trigger server event)
local function startSlotMachine()
    TriggerServerEvent('startSlotMachine')
end

-- Check current casino chips
local function checkCasinoChips()
    TriggerServerEvent('checkCasinoChips')
end

-- When receiving the chips count from the server
RegisterNetEvent('casino:chipsCheckResponse', function(chipsCount)
    currentCasinoChips = chipsCount
    if currentCasinoChips >= 50 then
        openSlotMachineUI()
    else
        QBCore.Functions.Notify("Insufficient casino chips to play the slot machine.")
    end
end)

Citizen.CreateThread(function()
    fetchCurrentCasinoChips()

    -- Create the slot machine objects based on configuration
    for _, prop in ipairs(Config.SlotMachineProps) do
        local slotMachineEntity = CreateObject(GetHashKey(prop.model), prop.coords.x, prop.coords.y, prop.coords.z, false, true, true)
        SetEntityAsMissionEntity(slotMachineEntity, true, true)

         -- Set the heading for the slot machine entity
        SetEntityHeading(slotMachineEntity, prop.heading)

        exports.ox_target:addSphereZone({
            coords = prop.coords,
            radius = 1.5,
            options = {
                {
                    label = "Play Slot Machine",
                    icon = "money-bill-wave",
                    onSelect = function()
                        checkCasinoChips()
                    end
                }
            }
        })
    end
end)

-- Close the UI
RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('closeSlotMachine')
    cb('ok')
end)

-- Update chips count
RegisterNetEvent('casino:currentChipsResponse', function(chipsCount)
    currentCasinoChips = chipsCount
end)

-- Handle inserting chips response
RegisterNetEvent('slotmachine:insertChipsResponse')
AddEventHandler('slotmachine:insertChipsResponse', function(response)
    if response.success then
        currentCasinoChips = response.newChipsAmount
        SendNUIMessage({
            action = "update",
            chips = currentCasinoChips,
            winnings = currentWinnings
        })
    else
        QBCore.Functions.Notify(response.message, "error")
    end
end)

-- Spin the slot machine (check if sufficient chips)
RegisterNUICallback('spin', function(data, cb)
    if currentCasinoChips >= 50 then
        TriggerServerEvent('removeCasinoChips', 50)
        TriggerServerEvent('slotmachine:spin') -- Start the spin
        cb('ok')
    else
        QBCore.Functions.Notify("Not enough chips to spin!", "error")
        cb('notOk')
    end
end)

RegisterNUICallback('cashOut', function(data, cb)
    -- Get the current winnings from the UI (assuming it's a string)
    local currentWinnings = tonumber(data.currentWinnings)
    
    -- Let's say we're adding chips instead of removing them
    local chipsToAdd = currentWinnings  -- The number of chips to add

    -- Add chips server-side
    TriggerServerEvent('addCasinoChips', chipsToAdd)
    cb('ok')
end)
RegisterNUICallback('cashOut', function(data, cb)
    local currentWinnings = tonumber(data.currentWinnings) or 0  -- Ensure this is a number
    if currentWinnings > 0 then
        TriggerEvent('addCasinoChips', currentWinnings)  -- Add winnings to player inventory
        cb({ status = 'ok', winnings = currentWinnings })
    else
        cb({ status = 'fail' })
    end
end)