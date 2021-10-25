local Tunnel = module("vrp","lib/Tunnel")
vRP = Tunnel.getInterface("vRP")
funcs = Tunnel.getInterface("hp:funcs")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARS
-----------------------------------------------------------------------------------------------------------------------------------------
local ped = PlayerPedId()
local blipCoords = vec3(-1954.8822021484, 3301.7270507813, 32.960235595703)
local deitarDict = "amb@world_human_sunbathe@female@back@idle_a"
local deitarAnim = "idle_a"
local macas = {
    "v_med_bed2",
    "v_med_bed1",
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function drawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.39, 0.39)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 235)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function requestAnimDict(dict)
    RequestAnimDict(dict)
    repeat
        Wait(0)
    until HasAnimDictLoaded(dict)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CODE
-----------------------------------------------------------------------------------------------------------------------------------------
texto = true

CreateThread(function()
    if texto == true then
        for i,v in pairs (macas) do 
            local hash = GetHashKey(v) 
            repeat
                Wait(0)
                local pedCoords = GetEntityCoords(ped) 
                local maca = GetClosestObjectOfType(pedCoords, 3.0, hash, false) 
                macaCds = GetEntityCoords(maca) 
                dist = #(macaCds - pedCoords) 
                if dist < 3.0 then
                    drawText3D(macaCds.x, macaCds.y, macaCds.z, "~o~E ~g~Tratamento \n~o~G~g~ Deitar")
                    if IsControlJustPressed(0, 38) then
                        if funcs.checkToogle() == false then
                            if funcs.pagamento() == true then
                                texto = false
                                requestAnimDict(deitarDict)
                                SetEntityCoords(ped, macaCds)
                                SetEntityHeading(ped, 162.7467)
                                TaskPlayAnim(ped, deitarDict, deitarAnim, 4.0, 4.0, -1, 1, 0.0, true, true, true)
                                TriggerEvent('Notify', 'sucesso', "Seu tratamento foi iniciado, aguarde a vida ficar cheia")
                                darVida()
                            end
                        else
                            TriggerEvent('Notify', 'negado', "Existem parámedicos em serviço, deite na maca e aguarde te darem o tratamento!")
                        end
                    end
                    if IsControlJustPressed(0, 47) then
                        requestAnimDict(deitarDict)
                        SetEntityCoords(ped, macaCds)
                        SetEntityHeading(ped, 162.7467)
                        TaskPlayAnim(ped, deitarDict, deitarAnim, 4.0, 4.0, -1, 1, 0.0, true, true, true)
                        TriggerEvent('Notify', 'sucesso', "Você deitou na maca , aguarde o médico dar o tratamento!")
                    end
                end
            until false
        end
    end
end)

function darVida()
    Wait(1000)
    FreezeEntityPosition(ped, true)
	repeat
        SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId()) + 10)
        Wait(1500)
	until GetEntityHealth(ped) >= 400
    FreezeEntityPosition(ped, false)
    ClearPedTasks(ped)
    TriggerEvent('Notify', 'aviso', "Seu tratamento acabou")
    texto = true
end
