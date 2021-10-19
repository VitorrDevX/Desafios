RegisterCommand('iniciar', function(source, args)
    ------------------------------------------------------------------------------------
    -- Notificar
    ------------------------------------------------------------------------------------
    function notificar (text)
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandThefeedPostTicker(true, true)
    end
    ------------------------------------------------------------------------------------
    -- Como usar o comando
    ------------------------------------------------------------------------------------
    if args[1] == nil then
        notificar('~r~Use /iniciar carro')
    end
    ------------------------------------------------------------------------------------
    -- Variaveis
    ------------------------------------------------------------------------------------
    local cds1 = vec3(-1519.75, -2840.4147949219, 13.94820022583) -- Criar o veiculo
    local cds2 = vec3(-1516.1329345703, -2823.8356933594, 14.308841705322) -- Criar o ped
    local cds3 = vec3(-316.57788085938, -1052.3162841797, 76.791954040527) -- Andando com o carro
    local pedmodel = `a_m_m_bevhills_01`
    local model = GetHashKey(args[1])
    ------------------------------------------------------------------------------------
    -- Baixando os modelos e requisitando
    ------------------------------------------------------------------------------------
    RequestModel(pedmodel) 
    repeat 
        Wait(0) 
    until HasModelLoaded(pedmodel)
    RequestModel(model) 
    repeat 
        Wait(0)
    until HasModelLoaded(model)
    SetModelAsNoLongerNeeded(pedmodel)
    SetModelAsNoLongerNeeded(model)
    notificar('~y~Desafio Iniciado !')
    notificar('~g~Peds carregados !')
    ------------------------------------------------------------------------------------
    -- Criando o veiculo e o ped
    ------------------------------------------------------------------------------------
    local veiculo = CreateVehicle(model, cds1, 88.414749145508, true, true) -- Criando o carro
    local ped = CreatePed(4, pedmodel, cds2, 88.414749145508, true, true) -- Criando o ped
    ------------------------------------------------------------------------------------
    -- Fazendo o ped ir e entrar no carro
    ------------------------------------------------------------------------------------
    TaskGoStraightToCoord(ped, cds1, 1.0, 20000) -- Fazendo o NPC ir até o carro
    TaskEnterVehicle(ped, veiculo, 10000, -1, 1.0, 1.0) -- Fazendo o NPC entrar no carro
    TaskVehicleDriveToCoord(ped, veiculo, cds3, 30.0)
    Wait(10000)
    notificar('~b~Desafio Concluido !')
    -- SetPedFiringPattern(ped, patternHash)
    -- TaskAimGunAtCoord(ped, x, y, z, time, p5, p6)
    -- TaskShootAtCoord(ped, x, y, z, duration, firingPattern)
    -- TaskLeaveVehicle(ped, vehicle, flags)
    -- GiveWeaponComponentToPed(ped, weaponHash, componentHash)
    -- GiveWeaponToPed(ped, weaponHash, ammoCount, isHidden, equipNow)
end)

RegisterCommand('desafio', function(source, args)
    ------------------------------------------------------------------------------------
    -- Notificar
    ------------------------------------------------------------------------------------
    function notificar (text)
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandThefeedPostTicker(true, true)
    end
    ------------------------------------------------------------------------------------
    -- Notificando
    ------------------------------------------------------------------------------------
    if args[1] == nil then
        notificar('~r~Agora use /iniciar carro')
    end
end)
