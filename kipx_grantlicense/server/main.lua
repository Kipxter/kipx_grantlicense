local ESX, QBCore = nil, nil

if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- Unified Notification Function
function SendNotify(source, title, description, time, notifyType)
    TriggerClientEvent('kipxgrantlicense:notif', source, title, description, time, notifyType)
end

RegisterNetEvent('kipxgrantlicense:grantWeaponLicense')
AddEventHandler('kipxgrantlicense:grantWeaponLicense', function(target)
    local src = source
    local xPlayer, xTarget

    if Config.Framework == 'esx' then
        xPlayer = ESX.GetPlayerFromId(src)
        xTarget = ESX.GetPlayerFromId(target)
        if not xPlayer or not xTarget then return end

        local job = xPlayer.getJob()
        if (job.name == 'police' or job.name == 'sheriff') and job.grade >= 11 then
            MySQL.Async.fetchScalar('SELECT type FROM user_licenses WHERE owner = @owner AND type = @type', {
                ['@owner'] = xTarget.identifier,
                ['@type'] = 'weapon'
            }, function(result)
                if result then
                    SendNotify(xTarget.source, 'License', '🛑 You already have a weapon license.', 5000, 'error')
                    SendNotify(xPlayer.source, 'License', '❗ Citizen already has a weapon license.', 5000, 'error')
                else
                    MySQL.Async.execute('INSERT INTO user_licenses (owner, type) VALUES (@owner, @type)', {
                        ['@owner'] = xTarget.identifier,
                        ['@type'] = 'weapon'
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            SendNotify(xPlayer.source, 'License', '✅ Weapon license granted successfully.', 5000, 'success')
                            SendNotify(xTarget.source, 'License', '📜 You have been granted a weapon license.', 5000, 'success')
                        else
                            SendNotify(xPlayer.source, 'License', '❌ Failed to grant the weapon license.', 5000, 'error')
                        end
                    end)
                end
            end)
        else
            SendNotify(xPlayer.source, 'Permission', '🚫 You do not have the required rank to perform this action.', 5000, 'error')
        end

    elseif Config.Framework == 'qbcore' then
        xPlayer = QBCore.Functions.GetPlayer(src)
        xTarget = QBCore.Functions.GetPlayer(target)
        if not xPlayer or not xTarget then return end

        local job = xPlayer.PlayerData.job
        if (job.name == 'police' or job.name == 'sheriff') and job.grade.level >= 11 then
            MySQL.Async.fetchScalar('SELECT type FROM user_licenses WHERE owner = @owner AND type = @type', {
                ['@owner'] = xTarget.PlayerData.citizenid,
                ['@type'] = 'weapon'
            }, function(result)
                if result then
                    SendNotify(xTarget.PlayerData.source, 'License', '🛑 You already have a weapon license.', 5000, 'error')
                    SendNotify(xPlayer.PlayerData.source, 'License', '❗ Citizen already has a weapon license.', 5000, 'error')
                else
                    MySQL.Async.execute('INSERT INTO user_licenses (owner, type) VALUES (@owner, @type)', {
                        ['@owner'] = xTarget.PlayerData.citizenid,
                        ['@type'] = 'weapon'
                    }, function(rowsChanged)
                        if rowsChanged > 0 then
                            SendNotify(xPlayer.PlayerData.source, 'License', '✅ Weapon license granted successfully.', 5000, 'success')
                            SendNotify(xTarget.PlayerData.source, 'License', '📜 You have been granted a weapon license.', 5000, 'success')
                        else
                            SendNotify(xPlayer.PlayerData.source, 'License', '❌ Failed to grant the weapon license.', 5000, 'error')
                        end
                    end)
                end
            end)
        else
            SendNotify(xPlayer.PlayerData.source, 'Permission', '🚫 You do not have the required rank to perform this action.', 5000, 'error')
        end
    end
end)
