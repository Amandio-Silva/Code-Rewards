-- Função para inicializar o tempo do jogador
function InitializePlayerTime(source)
    local license = GetPlayerIdentifier(source, 0)
    if license then
        exports.oxmysql:insert('INSERT IGNORE INTO player_playtime (license) VALUES (?)', {license})
    end
end

-- Função para salvar o tempo do jogador
function SavePlayerTime(source, hours, minutes, seconds, totalSeconds)
    local license = GetPlayerIdentifier(source, 0)
    if license then
        exports.oxmysql:execute('UPDATE player_playtime SET hours = ?, minutes = ?, seconds = ?, total_seconds = ? WHERE license = ?', {
            tonumber(hours) or 0,
            tonumber(minutes) or 0,
            tonumber(seconds) or 0,
            tonumber(totalSeconds) or 0,
            license
        }, function(affectedRows)
            if affectedRows then
                print(string.format('Tempo atualizado para o jogador %s: %d:%02d:%02d', license, hours, minutes, seconds))
            else
                print(string.format('Erro ao atualizar tempo para o jogador %s', license))
            end
        end)
    end
end

-- Função para carregar o tempo do jogador
function LoadPlayerTime(source, cb)
    local license = GetPlayerIdentifier(source, 0)
    if license then
        exports.oxmysql:query('SELECT hours, minutes, seconds, total_seconds FROM player_playtime WHERE license = ?', {license},
            function(result)
                if result and result[1] then
                    cb(result[1])
                else
                    InitializePlayerTime(source)
                    cb({hours = 0, minutes = 0, seconds = 0, total_seconds = 0})
                end
            end)
    end
end

-- Evento quando um jogador se conecta
AddEventHandler('playerConnecting', function()
    local source = source
    InitializePlayerTime(source)
end)

-- Registrar evento para atualizar tempo
RegisterNetEvent('rewards:updateTime')
AddEventHandler('rewards:updateTime', function(timeData)
    local source = source
    SavePlayerTime(source, timeData.hours, timeData.minutes, timeData.seconds, timeData.totalSeconds)
end)

-- Registrar evento para carregar tempo
RegisterNetEvent('rewards:requestTime')
AddEventHandler('rewards:requestTime', function()
    local source = source
    LoadPlayerTime(source, function(timeData)
        TriggerClientEvent('rewards:receiveTime', source, timeData)
    end)
end)

-- Evento de resgatar recompensa
RegisterNetEvent('rewards:redeemReward')
AddEventHandler('rewards:redeemReward', function(reward)
    local source = source
    local playerId = source
    local license = GetPlayerIdentifier(source, 0)

    if not license then
        TriggerClientEvent('rewards:notify', playerId, 'Erro: Identificador inválido!')
        return
    end

    LoadPlayerTime(source, function(timeData)
        if timeData.hours >= reward.hours then
            -- Verifica se o jogador já resgatou a recompensa
            exports.oxmysql:query('SELECT * FROM player_rewards WHERE license = ? AND reward_name = ?', {license, reward.name}, function(result)
                if result and #result > 0 then
                    TriggerClientEvent('rewards:notify', playerId, 'Você já resgatou esta recompensa!')
                else
                    print(string.format('Jogador %s resgatou a recompensa: %s', playerId, reward.name))

                    local user_id = vRP.getUserId({playerId})
                    if user_id then
                        if reward.type == "money" then
                            vRP.giveMoney({user_id, reward.amount})
                            TriggerClientEvent('rewards:notify', playerId, 'Você recebeu ' .. reward.amount .. ' moedas!')

                        elseif reward.type == "weapon" then
                            for _, weapon in ipairs(reward.items) do
                                vRP.giveWeapon({user_id, weapon})
                            end
                            TriggerClientEvent('rewards:notify', playerId, 'Você recebeu suas armas!')

                        elseif reward.type == "items" then
                            for _, item in ipairs(reward.items) do
                                vRP.giveInventoryItem({user_id, item.name, item.amount, true})
                            end
                            TriggerClientEvent('rewards:notify', playerId, 'Você recebeu seus itens!')
                        end

                        -- Regista o resgate no banco de dados
                        exports.oxmysql:insert('INSERT INTO player_rewards (license, reward_name) VALUES (?, ?)', {license, reward.name})
                    else
                        TriggerClientEvent('rewards:notify', playerId, 'Erro: ID de usuário não encontrado!')
                    end
                end
            end)
        else
            TriggerClientEvent('rewards:notify', playerId, 'Você ainda não tem horas suficientes para resgatar esta recompensa!')
        end
    end)
end)
