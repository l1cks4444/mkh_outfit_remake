function notifytrigger(target, message, ntype)
    TriggerClientEvent('esx:showNotification', target, message)
end

function sendToDiscord(title, message)
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Discord.username,
        embeds = {{
            title = title,
            description = message,
            color = Config.Discord.color
        }}
    }), { ['Content-Type'] = 'application/json' })
end

ESX = exports['es_extended']:getSharedObject()

local oldBuckets = {}

RegisterCommand('changeoutfit', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local allowed = false
    for _, group in ipairs(Config.AllowedGroups) do
        if xPlayer and xPlayer.getGroup and xPlayer.getGroup() == group then
            allowed = true
            break
        end
    end
    if not allowed then
        notifytrigger(source, Config.Language.no_permission.text, Config.Language.no_permission.type)
        return
    end
    local targetId = tonumber(args[1])
    if not targetId then
        notifytrigger(source, Config.Language.invalid_id.text, Config.Language.invalid_id.type)
        return
    end
    if not Config.AllowSelfChange then
        if targetId == source then
            notifytrigger(source, Config.Language.self_select.text, Config.Language.self_select.type)
            return
        end
    end
    local targetPlayer = ESX.GetPlayerFromId(targetId)
    if not targetPlayer then
        notifytrigger(source, Config.Language.player_not_found.text, Config.Language.player_not_found.type)
        return
    end
    local adminName = GetPlayerName(source) or 'Unbekannt'
    local targetName = GetPlayerName(targetId) or 'Unbekannt'

    local function getDiscordId(src)
        for _, v in ipairs(GetPlayerIdentifiers(src)) do
            if string.sub(v, 1, string.len("discord:")) == "discord:" then
                return string.sub(v, 9)
            end
        end
        return 'Unbekannt'
    end
    local adminDiscord = getDiscordId(source)
    local targetDiscord = getDiscordId(targetId)
    local adminId = source
    local userId = targetId
    local webhookMsg = ("**Admin:** %s (ID: %s, Discord: <@%s>)\n**User:** %s (ID: %s, Discord: <@%s>)"):format(adminName, adminId, adminDiscord, targetName, userId, targetDiscord)
    TriggerClientEvent('esx_changeoutfit:start', targetId)
    notifytrigger(source, (Config.Language.menu_opened.text):format(targetName), Config.Language.menu_opened.type)
    sendToDiscord(Config.Discord.title, webhookMsg)
end)

RegisterNetEvent('mkh_outfit:toBucket')
AddEventHandler('mkh_outfit:toBucket', function(newBucket)
    local src = source
    oldBuckets[src] = GetPlayerRoutingBucket(src)
    SetPlayerRoutingBucket(src, newBucket)
    print("Old Dim: "..oldBuckets[src]..", New Dim: "..newBucket.."")
end)

RegisterNetEvent('mkh_outfit:restoreBucket')
AddEventHandler('mkh_outfit:restoreBucket', function()
    local src = source
    if oldBuckets[src] then
        SetPlayerRoutingBucket(src, oldBuckets[src])
        print("Restored to: "..oldBuckets[src].." Dim")
        oldBuckets[src] = nil
    end
end)
