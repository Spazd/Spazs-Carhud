local QBCore = exports['qb-core']:GetCoreObject()


-- Fuel payment
RegisterServerEvent("carfill:checkmoney")
AddEventHandler("carfill:checkmoney", function(costs,loc)
    local src = source
    local target = QBCore.Functions.GetPlayer(src)

    if not costs
    then
        costs = 0
    end

    if target.Functions.RemoveMoney('cash', costs, "bought-fuel") then
       
        TriggerClientEvent("RefuelCarServerReturn", src)
    else
        TriggerClientEvent("QBCore:Notify", src, "Your car has been refilled", "success")
    end
end)


