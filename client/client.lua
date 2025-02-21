local display = false
local playerTime = { hours = 0, minutes = 0, seconds = 0, totalSeconds = 0 }

-- Função para atualizar o tempo do jogador
CreateThread(function()
    while true do
        Wait(1000) -- Atualiza a cada segundo
        playerTime.totalSeconds = playerTime.totalSeconds + 1
        playerTime.seconds = playerTime.seconds + 1

        if playerTime.seconds >= 60 then
            playerTime.seconds = 0
            playerTime.minutes = playerTime.minutes + 1

            if playerTime.minutes >= 60 then
                playerTime.minutes = 0
                playerTime.hours = playerTime.hours + 1
            end
        end

        -- Atualiza a interface se estiver visível
        if display then
            SendNUIMessage({
                type = "UPDATE_TIME",
                playerTime = playerTime
            })
        end

        -- Salva o tempo no servidor a cada minuto
        if playerTime.seconds == 0 then
            TriggerServerEvent('rewards:updateTime', playerTime)
        end
    end
end)

-- Carregar tempo do jogador ao entrar no servidor
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('rewards:requestTime')
end)

-- Receber tempo do servidor
RegisterNetEvent('rewards:receiveTime')
AddEventHandler('rewards:receiveTime', function(timeData)
    if timeData then
        playerTime.hours = timeData.hours or 0
        playerTime.minutes = timeData.minutes or 0
        playerTime.seconds = timeData.seconds or 0
        playerTime.totalSeconds = timeData.total_seconds or 0
        
        if display then
            SendNUIMessage({
                type = "UPDATE_TIME",
                playerTime = playerTime
            })
        end
    end
end)

RegisterCommand('rewards', function(source, args)
    SetDisplay(not display)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    if bool then
        TriggerServerEvent('rewards:requestTime')
    end
    SendNUIMessage({
        type = bool and "OPEN_UI" or "CLOSE_UI",
        status = bool,
        playerTime = playerTime
    })
end

RegisterNUICallback('closeUI', function(data, cb)
    SetDisplay(false)
    cb('ok')
end)

RegisterNUICallback('redeemReward', function(data, cb)
    TriggerServerEvent('rewards:redeemReward', data.reward)
    cb('ok')
end)