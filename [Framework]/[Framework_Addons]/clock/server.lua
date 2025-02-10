local playTime = {}
local playerData = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000);
        for k, v in pairs(playTime) do
            playTime[k] = playTime[k] + 1;
        end
    end
end)


RegisterServerEvent("NAT2K15:CHECKSQL")
AddEventHandler("NAT2K15:CHECKSQL", function(steam, discord, first_name, last_name, twt, currdept, dob, gender, data)
    local src = source
    local deptCheck = false
    for departments, table in pairs(config.departmentInfo) do
        if (string.lower(departments) == string.lower(currdept)) then
            deptCheck = true
            break;
        end
    end
    if (playerData[src] ~= nil) then
        if ((playerData[src].dept) ~= currdept) then 
            TriggerEvent('Duty:Toggle', src, playerData[src], false, true) 
            Citizen.Wait(500)
            TriggerEvent('Duty:Toggle', src, data, true, deptCheck) 
        else
            TriggerEvent('Duty:Toggle', src, data, true, deptCheck)
        end
    else
        TriggerEvent('Duty:Toggle', src, data, true, deptCheck)
    end
end)


AddEventHandler('playerDropped', function ()
    local src = source
    if (playerData[src] ~= nil) then
        TriggerEvent('Duty:Toggle', src, playerData[src], false, true)
    end
end)


RegisterNetEvent('Duty:Toggle')
AddEventHandler('Duty:Toggle', function(src, data, status, deptCheck)
    if (deptCheck) then
        local deptInfo = config.departmentInfo[data.dept]
        if (status) then
            playTime[src] = 0
            playerData[src] = { src = src, dept = data.dept, name = data.first_name .. ' ' .. data.last_name, discord = data.discord, lastPos = GetEntityCoords(GetPlayerPed(src), true), index = 0, timeafk = 0 }
            DutyLogging(src, deptInfo.webhook, deptInfo.startEmbedColour, deptInfo.startEmbedTitle, GetPlayerName(src), playerData[src].name, deptInfo.fullName, data.discord, 'Just Started', "Just Started", deptInfo.embedThumbnail)
        else
            local time = getTotalTime(data.src, playTime[data.src])
            DutyLogging(src, deptInfo.webhook, deptInfo.endEmbedColour, deptInfo.endEmbedTitle, GetPlayerName(src), data.name, deptInfo.fullName, data.discord, time.time, time.afk, deptInfo.embedThumbnail)
            playerData[src] = nil
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for i, v in ipairs(playerData) do
            local ped = GetPlayerPed(v.src)
            if ped then
                local pos = GetEntityCoords(ped, true)
                playerData[v.src].lastPos = pos
                if pos == playerData[v.src].lastPos then
                    if(playerData[v.src].index >= config.afk.defaultTimeAfk) then
                        playerData[v.src].timeafk = playerData[v.src].timeafk + 1; 
                    end
                    playerData[v.src].index = playerData[v.src].index + 1;
                else 
                    playerData[v.src].lastPos = pos
                    playerData[v.src].index = 0;
                end
            end
        end
    end
end)
 


function getTotalTime(src, time)
    if (time ~= nil and playerData[src]) then
        local currTime = os.time();
        local endTime = currTime + time;

        local timeDiff = endTime - currTime;

        if timeDiff < 60 then
            -- Less than 1 minute
            return {time = string.format("%d second(s)", timeDiff), afk = formatTime(playerData[src].timeafk)}
        elseif timeDiff < 3600 then
            -- Less than 1 hour
            local minutes = math.floor(timeDiff / 60)
            local seconds = timeDiff % 60
            return {time = string.format("%d minute(s) %d second(s)", minutes, seconds), afk = formatTime(playerData[src].timeafk)}
        else
            -- 1 hour or more
            local hours = math.floor(timeDiff / 3600)
            local minutes = math.floor((timeDiff % 3600) / 60)
            local seconds = timeDiff % 60
            return {time = string.format("%d hour(s) %d minute(s) %d second(s)", hours, minutes, seconds), afk = formatTime(playerData[src].timeafk)}
        end
    else
        return 'Time not found'
    end
end

function formatTime(timeDiff) 
    if timeDiff < 60 then
        -- Less than 1 minute
        return string.format("%d second(s)", timeDiff)
    elseif timeDiff < 3600 then
        -- Less than 1 hour
        local minutes = math.floor(timeDiff / 60)
        local seconds = timeDiff % 60
        return string.format("%d minute(s) %d second(s)", minutes, seconds)
    else
        -- 1 hour or more
        local hours = math.floor(timeDiff / 3600)
        local minutes = math.floor((timeDiff % 3600) / 60)
        local seconds = timeDiff % 60
        return {time = string.format("%d hour(s) %d minute(s) %d second(s)", hours, minutes, seconds), afk = playerData[src].timeafk}
    end
end

function getTime()
    local date = os.date('*t')
    if (date.month < 10) then
        date.month = '0' .. tostring(date.month)
    end
    if (date.day < 10) then
        date.day = '0' .. tostring(date.day)
    end
    if (date.hour < 10) then
        date.hour = '0' .. tostring(date.hour)
    end
    if (date.min < 10) then
        date.min = '0' .. tostring(date.min)
    end
    if (date.sec < 10) then
        date.sec = '0' .. tostring(date.sec)
    end
    return date.month .. '/' .. date.day .. '/' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec
end

function DutyLogging(src, webhook, colour, title, playerName, DeptName, department, discord, time, afk, thumbnail)
    local embed = {
        {
             ["fields"] = {
                {
                    ["name"] = "**Player Name**",
                    ["value"] = '`' .. playerName .. ' [#' .. src .. ']`',
                    ["inline"] = true
                },
                {
                    ["name"] = "**Character Name**",
                    ["value"] = '`' .. DeptName .. '`',
                    ["inline"] = true
                },
                {
                    ["name"] = "**Discord**",
                    ["value"] = '<@' .. discord .. '> `[' .. discord .. ']`',
                    ["inline"] = false
                },
                {
                    ["name"] = "**Active Department**",
                    ["value"] = '`' .. department .. '`',
                    ["inline"] = false
                },
                {
                    ["name"] = "**Time**",
                    ["value"] = '`' .. time .. '`',
                    ["inline"] = true
                },
                {
                    ["name"] = "**AFK Time**",
                    ["value"] = '`' .. afk .. '`',
                    ["inline"] = true
                },
            },
            ["color"] = colour,
            ["title"] = title,
            ["footer"] = {
                ["text"] = getTime(),
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Patrol Logger', embeds = embed }), { ['Content-Type'] = 'application/json' }) 
    PerformHttpRequest(config.mainWebhook, function(err, text, headers) end, 'POST', json.encode({ username = 'Patrol Logger', embeds = embed }), { ['Content-Type'] = 'application/json' }) -- main discord
end

