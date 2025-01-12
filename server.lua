QBCore = exports['qb-core']:GetCoreObject()

-- Existing event to start the slot machine game
RegisterNetEvent('startSlotMachine')
AddEventHandler('startSlotMachine', function()
    local playerId = source
    local Player = QBCore.Functions.GetPlayer(playerId)

    if not Player then
        print("[ERROR] Player not found: " .. playerId)
        return
    end

    -- Check if the player has enough casino chips
    local chipsCount = GetPlayerCasinoChips(playerId)
    
    if chipsCount >= Config.SlotMachineCost then
        -- Remove casino chips from inventory
        local success = exports.ox_inventory:RemoveItem(playerId, 'casinochips', Config.SlotMachineCost)
        if success then
            print("[INFO] Successfully removed chips from player: " .. playerId)
            -- Spin the slot machine and determine winnings...
            local winnings = math.random(0, 100) -- Example logic for winnings
            TriggerClientEvent('slotmachine:winningsReceived', playerId, winnings) -- Send winning data back to client
        else
            print("[ERROR] Failed to remove chips for player: " .. playerId)
            TriggerClientEvent('slotmachine:insertChipsResponse', playerId, {
                success = false,
                message = 'Failed to remove chips from inventory.'
            })
        end
    else
        print("[ERROR] Insufficient casino chips for player: " .. playerId)
        TriggerClientEvent('slotmachine:insertChipsResponse', playerId, {
            success = false,
            message = 'Insufficient casino chips'
        })
    end
end)

RegisterNetEvent('checkCasinoChips')
AddEventHandler('checkCasinoChips', function()
    local src = source
    local chipsCount = QBCore.Functions.GetPlayer(src).Functions.GetItemByName('casinochips')
    TriggerClientEvent('casino:chipsCheckResponse', src, chipsCount and chipsCount.amount or 0)
end)


RegisterServerEvent('removeCasinoChips')
AddEventHandler('removeCasinoChips', function(amount)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    if amount == nil or amount <= 0 then
        print("[ERROR] Invalid chip removal amount from player: " .. src)
        TriggerClientEvent('casino:removeChipsResponse', src, false)
        return
    end

    local success = player.Functions.RemoveItem('casinochips', amount)

    if success then
        print("[INFO] Successfully removed " .. amount .. " chips from player: " .. src)
        TriggerClientEvent('casino:removeChipsResponse', src, true)
    else
        print("[ERROR] Failed to remove chips for player: " .. src)
        TriggerClientEvent('casino:removeChipsResponse', src, false)
    end
end)
RegisterNetEvent('addCasinoChips')
AddEventHandler('addCasinoChips', function(chipsToAdd)
    local playerId = source

    -- Use ox_inventory to add the chips directly to the player's inventory
    local success = exports.ox_inventory:AddItem(playerId, 'casinochips', chipsToAdd)

    if success then
        TriggerClientEvent('ox:notify', playerId, { text = 'You received ' .. chipsToAdd .. ' casino chips!', type = 'success' })
    else
        TriggerClientEvent('ox:notify', playerId, { text = 'Failed to add chips to inventory.', type = 'error' })
    end
end)

