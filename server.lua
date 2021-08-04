QBCore = nil
Binds = {}
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

CreateThread(function()
    Wait(500)
    local fetch = json.decode(LoadResourceFile(GetCurrentResourceName(), "./database.json"))
    if fetch then
        for k,v in pairs(fetch) do
            print(k)
            Binds[k] = {}
            for bind,_ in pairs(Config.Binds) do
                if v[bind] then
                    Binds[k][bind] = v[bind]
                else
                    Binds[k][bind] = Config.Binds[bind]
                end
            end
        end
    end
end)

RegisterNetEvent("qb-binds:server:openUI")
AddEventHandler("qb-binds:server:openUI", function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local steam = xPlayer.PlayerData.steam

    TriggerClientEvent("qb-binds:client:openUI", src, Binds[steam])
end)

RegisterServerEvent("qb-binds:server:edit")
AddEventHandler("qb-binds:server:edit", function(data)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local steam = xPlayer.PlayerData.steam

    for k,v in pairs(Binds[steam]) do
        if v['name'] == data["bind"] then
            Binds[steam][k]['bind'] = data.key
            break
        end
    end

    TriggerClientEvent("qb-binds:client:updateUI", src, Binds[steam])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Binds), -1)
end)

RegisterServerEvent("qb-binds:server:init")
AddEventHandler("qb-binds:server:init", function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local steam = xPlayer.PlayerData.steam

    if not Binds[steam] then
        print("[Binds] " .. steam .. ' just created.')
        Binds[steam] = Config.Binds
        SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Binds), -1)
    end

    TriggerClientEvent("qb-binds:client:updateUI", src, Binds[steam])
end)

QBCore.Commands.Add("binds", "Open Binds Menu", {}, false, function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local steam = xPlayer.PlayerData.steam

    TriggerClientEvent("qb-binds:client:openUI", src, Binds[steam])
end)