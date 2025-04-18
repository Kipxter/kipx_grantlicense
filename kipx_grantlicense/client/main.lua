local ESX, QBCore = nil, nil

if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

Citizen.CreateThread(function()
    local licenseOptions = {
        {
            icon = 'fas fa-id-card',
            label = 'Grant Weapon License (Police/Sheriff)',
            groups = { 'police', 'sheriff' },
            onSelect = function(data)
                local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                TriggerServerEvent('kipxgrantlicense:grantWeaponLicense', targetId)
            end,
            distance = 2.0,
            canInteract = function(entity, distance, coords, name)
                local playerData
                if Config.Framework == 'esx' then
                    playerData = ESX.GetPlayerData()
                    return (playerData.job.name == 'police' or playerData.job.name == 'sheriff') and playerData.job.grade >= Config.GradeLevel
                elseif Config.Framework == 'qbcore' then
                    playerData = QBCore.Functions.GetPlayerData()
                    return (playerData.job.name == 'police' or playerData.job.name == 'sheriff') and playerData.job.grade.level >= Config.GradeLevel
                end
                return false
            end
        }
    }

    exports.ox_target:addGlobalPlayer(licenseOptions)
end)


RegisterNetEvent('kipxgrantlicense:notif', function(title, description, time, notifyType)
    if Config.Notification == 'oxlib' then
        lib.notify({
            title = title,
            description = description,
            duration = time,
            type = notifyType
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification(description)
    elseif Config.Notification == 'qbcore' then
        QBCore.Functions.Notify(description, notifyType, time)
    end
end)



