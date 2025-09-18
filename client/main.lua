local oldcoords = nil
local ischanging = false


RegisterNetEvent('esx_changeoutfit:start', function()
    print("Start")

    if ischanging then return end
    ischanging = true

    local playerPed = PlayerPedId()
    oldcoords = GetEntityCoords(playerPed)

    SetEntityCoords(playerPed, -75.3554, -819.2252, 326.1750)

    TriggerServerEvent('mkh_outfit:toBucket', 2)
    FreezeEntityPosition(playerPed, true)

    TriggerEvent('esx_skin:openSaveableMenu', function()
        print("Menu W")

        playerPed = PlayerPedId()
        if oldcoords then
            SetEntityCoords(playerPed, oldcoords.x, oldcoords.y, oldcoords.z)
        end


        TriggerServerEvent('mkh_outfit:restoreBucket')

        FreezeEntityPosition(playerPed, false)
        ischanging = false
    end)
end)
