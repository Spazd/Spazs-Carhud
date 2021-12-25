local QBCore = exports['qb-core']:GetCoreObject()

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local fueling = false

local hudfps = 1500

RegisterCommand("examplehud",function()
    TriggerEvent('HUD:Init')
end)
RegisterCommand('hud', function(source, args, rawCommand)
    if toghud then 
        toghud = false
    else
        toghud = true
    end
end)

RegisterNetEvent('hud:toggleui')
AddEventHandler('hud:toggleui', function(show)
    if show == true then
        toghud = true
    else
        toghud = false
    end
end)


local display = false

RegisterCommand("hudmenu", function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        QBCore.Functions.Notify("You cant use that on car!")
    else
        SetDisplay(not display)
    end
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterNUICallback("kapatButton", function(data)
    SetNuiFocus(false, false)
    SetDisplay(false)
end)

RegisterNUICallback("dusukfpstrigger", function()
    -- body
    QBCore.Functions.Notify("You choose low fps your pc performance gonna increase perfectly")
    hudfps = 1500

end)

RegisterNUICallback("normalfpstrigger", function()
    -- body
    QBCore.Functions.Notify("You choose normal fps your pc performance gonna increase normal")
    hudfps = 500

end)

RegisterNUICallback("yuksekfpstrigger", function()
    -- body
    QBCore.Functions.Notify("You choose high fps your pc performance dont changed")
    hudfps = 50

end)

RegisterNUICallback("cokyuksekfpstrigger", function()
    -- body
    QBCore.Functions.Notify("Very high option is bad for pc performance care that!")
    hudfps = 0

end)


Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display)
    end
end)

----------------------------------


-- gas filling
DecorRegister("CurrentFuel", 3)

Fuel = 0

local gasStations = {
    {49.41872, 2778.793, 58.04395,600},
    {263.8949, 2606.463, 44.98339,600},
    {1039.958, 2671.134, 39.55091,900},
    {1207.26, 2660.175, 37.89996,900},
    {2539.685, 2594.192, 37.94488,1500},
    {2679.858, 3263.946, 55.24057,1500},
    {2005.055, 3773.887, 32.40393,1200},
    {1687.156, 4929.392, 42.07809,900},
    {1701.314, 6416.028, 32.76395,1200},
    {179.8573, 6602.839, 31.86817,600},
    {-94.46199, 6419.594, 31.48952,600},
    {-2554.996, 2334.402, 33.07803,600},
    {-1800.375, 803.6619, 138.6512,600},
    {-1437.622, -276.7476, 46.20771,600},
    {-2096.243, -320.2867, 13.16857,600},
    {-724.6192, -935.1631, 19.21386,600},
    {-526.0198, -1211.003, 18.18483,600},
    {-70.21484, -1761.792, 29.53402,600},
    {265.6484,-1261.309, 29.29294,600},
    {819.6538,-1028.846, 26.40342,780},
    {1208.951,-1402.567, 35.22419,900},
    {1181.381,-330.8471, 69.31651,900},
    {620.8434, 269.1009, 103.0895,780},
    {2581.321, 362.0393, 108.4688,1500},
    {1785.363, 3330.372, 41.38188,1200},
    {-319.537, -1471.5116, 30.54118,600},
    {-66.58, -2532.56, 6.14, 400}
}

function getVehicleInDirection(coordFrom, coordTo)
    local offset = 0
    local rayHandle
    local vehicle

    for i = 0, 100 do
        rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)   
        a, b, c, d, vehicle = GetRaycastResult(rayHandle)
        
        offset = offset - 1

        if vehicle ~= 0 then break end
    end
    
    local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
    
    if distance > 3000 then vehicle = nil end

    return vehicle ~= nil and vehicle or 0
end

local showGasStations = false

RegisterNetEvent('CarPlayerHud:ToggleGas')
AddEventHandler('CarPlayerHud:ToggleGas', function()
    showGasStations = not showGasStations
   for _, item in pairs(gasStations) do
        if not showGasStations then
            if item.blip ~= nil then
                RemoveBlip(item.blip)
            end
        else
            item.blip = AddBlipForCoord(item[1], item[2], item[3])
            SetBlipSprite(item.blip, 361)
            SetBlipScale(item.blip, 0.7)
            SetBlipAsShortRange(item.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Gas Station")
            EndTextCommandSetBlipName(item.blip)
        end
    end
end)

Citizen.CreateThread(function()
    showGasStations = true
    TriggerEvent('CarPlayerHud:ToggleGas')
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function IsNearGasStations()
    local location = {}
    local hasFound = false
    local pos = GetEntityCoords(PlayerPedId(), false)
    for k,v in ipairs(gasStations) do
        if(Vdist(v[1], v[2], v[3], pos.x, pos.y, pos.z) < 22.0)then
            location = {v[1], v[2], v[3],v[4]}
            hasFound = true
        end
    end


    if hasFound then return location,true end
    return {},false
end


RegisterNetEvent("RefuelCar")
AddEventHandler("RefuelCar",function()
    local w = `WEAPON_PetrolCan` 
    local curw = GetSelectedPedWeapon(PlayerPedId())
    if curw == w then
        coordA = GetEntityCoords(PlayerPedId(), 1)
        coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 100.0, 0.0)
        targetVehicle = getVehicleInDirection(coordA, coordB)
        if DoesEntityExist(targetVehicle) then
            SetPedAmmo( PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), 0 )

            if DecorExistOn(targetVehicle, "CurrentFuel") then 
                curFuel = DecorGetInt(targetVehicle, "CurrentFuel")
                
                curFuel = curFuel + 30
                if curFuel > 100 then
                    curFuel = 100
                end
                DecorSetInt(targetVehicle, "CurrentFuel", curFuel)
            else
                DecorSetInt(targetVehicle, "CurrentFuel", 50)
            end

            DecorSetInt(targetVehicle, "CurrentFuel", 100)
            QBCore.Functions.Notify("Refueled")
        else
            QBCore.Functions.Notify("No Target")
        end
    else
        QBCore.Functions.Notify("Need a Gas Can")
    end
end)

local petrolCan = {title = "Petrol Can", name = "PetrolCan", costs = 100, description = {}, model = "WEAPON_PetrolCan"}

RegisterNetEvent("RefuelCarServerReturn")
AddEventHandler("RefuelCarServerReturn",function()

    local veh = TargetVehicle()
    local curFuel = DecorGetInt(veh, "CurrentFuel")
    local timer = (100 - curFuel) * 200

    fueling = true
    
    refillVehicle()

    QBCore.Functions.Progressbar("drilling_", "Refueling...", timer, false, true, {}, {}, {}, {}, function()
    end)
    Citizen.Wait(timer)
        DecorSetInt(veh, "CurrentFuel", 100)
        endanimation()
        
        fueling = false
end)

function refillVehicle()
    ClearPedSecondaryTask(PlayerPedId())
    loadAnimDict( "weapon@w_sp_jerrycan" ) 
    TaskPlayAnim( PlayerPedId(), "weapon@w_sp_jerrycan", "fire", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
end

function endanimation()
    shiftheld = false
    ctrlheld = false
    tabheld = false
    ClearPedTasksImmediately(PlayerPedId())
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end

function TargetVehicle()
    playerped = PlayerPedId()
    coordA = GetEntityCoords(playerped, 1)
    coordB = GetOffsetFromEntityInWorldCoords(playerped, 0.0, 100.0, 0.0)
    targetVehicle = getVehicleInDirection(coordA, coordB)
    return targetVehicle
end

function round( n )
    return math.floor( n + 0.5 )
end

Fuel = 45
DrivingSet = false
LastVehicle = nil
lastupdate = 0
local fuelMulti = 0

RegisterNetEvent("carHud:FuelMulti")
AddEventHandler("carHud:FuelMulti",function(multi)
    fuelMulti = multi
end)

alarmset = false

RegisterNetEvent("CarFuelAlarm")
AddEventHandler("CarFuelAlarm",function()
    if not alarmset then
        alarmset = true
        local i = 5
        QBCore.Functions.Notify("Low fuel")
        while i > 0 do
            PlaySound(-1, "5_SEC_WARNING", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            i = i - 1
            Citizen.Wait(300)
        end
        Citizen.Wait(60000)
        alarmset = false
    end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- CONFIG --
local showCompass = true
-- CODE --
local compass = "Loading GPS"

local lastStreet = nil
local lastStreetName = ""
local zone = "Unknown";

function playerLocation()
    return lastStreetName
end

function playerZone()
    return zone
end

-- Thanks @marxy
function getCardinalDirectionFromHeading(heading)
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >=135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end
end

-- Seatbelt

local seatbelt = false
local ShowingBeltIcon = false 
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

RegisterNetEvent("seatbelt")
AddEventHandler("seatbelt", function(belt)
    seatbelt = belt
end)

IsCar = function(veh)
  local vc = GetVehicleClass(veh)
  return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
end 

Fwv = function (entity)
  local hr = GetEntityHeading(entity) + 90.0
  if hr < 0.0 then hr = 360.0 + hr end
  hr = hr * 0.0174533
  return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local ped = GetPlayerPed(-1)
        local car = GetVehiclePedIsIn(ped)
        
        if car ~= 0 and IsVehicleEngineOn(car, true) and (wasInCar or IsCar(car)) then
            wasInCar = true
            
            if ShowingBeltIcon == false and not IsPlayerDead(PlayerId()) then
                TriggerEvent("seatbelt", false)
                ShowingBeltIcon = true
            end

            if beltOn then 
                DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
                DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
            end

            speedBuffer[2] = speedBuffer[1]
            speedBuffer[1] = GetEntitySpeed(car)
            
            if (speedBuffer[2] ~= nil and not beltOn and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > 19.25 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255))
            or (speedBuffer[2] ~= nil and beltOn and GetEntitySpeedVector(car, true).y > 1.0 and speedBuffer[1] > 48 and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255)) then
         
                local co = GetEntityCoords(ped)
                local fw = Fwv(ped)

                SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                SetEntityVelocity(ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                Citizen.Wait(1)
                SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
            end
        
            velBuffer[2] = velBuffer[1]
            velBuffer[1] = GetEntityVelocity(car)
        
            if IsControlJustReleased(0, 29) and GetLastInputMethod(0) then
                beltOn = not beltOn 
                
                if beltOn then
                    Citizen.Wait(10)
                    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'seatbelt', 0.9)
                    QBCore.Functions.Notify("Seat belt enabled")
                        
                    TriggerEvent("seatbelt", true)  
                    ShowingBeltIcon = true 
                else 
                    QBCore.Functions.Notify("Seat belt disabled")
                    TriggerServerEvent('InteractSound_SV:PlayOnSource', 'seatbeltoff', 0.9)
            
                    TriggerEvent("seatbelt", false)  
                    ShowingBeltIcon = true  
                end
            end
          
        elseif wasInCar then
            wasInCar = false
            beltOn = false
            speedBuffer[1], speedBuffer[2] = 0.0, 0.0
            
            if ShowingBeltIcon == true and not IsPlayerDead(PlayerId()) then
                TriggerEvent("seatbelt", true)  
                ShowingBeltIcon = false 
            end
        end
    end
end)
-- Harness

local harness = false
local harnessDur = 0
RegisterNetEvent("harness")
AddEventHandler("harness", function(belt, dur)
    harness = belt
    harnessDur = dur
end)

local nos = 0
local nosEnabled = false
RegisterNetEvent("noshud")
AddEventHandler("noshud", function(_nos, _nosEnabled)
    if _nos == nil then
        nos = 0
    else
        nos = _nos
    end
    nosEnabled = _nosEnabled
end)

local time = "12:00"

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(h,m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)

local counter = 0
local Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936
local uiopen = false
local colorblind = false
local compass_on = false

local mphmi = true

RegisterNUICallback("mphtrigger", function()
    -- body
    QBCore.Functions.Notify("The speed type is mph now!")
    mphmi = true
    if mphmi == true then
        Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936
    else
        Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
    end
end)

RegisterNUICallback("kmhtrigger", function()
    -- body
    QBCore.Functions.Notify("The speed type is kmh now!")
    mphmi = false
    if mphmi == true then
        Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 2.236936
    else
        Mph = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6
    end
end)
RegisterNetEvent('option:colorblind')
AddEventHandler('option:colorblind',function()
    colorblind = not colorblind
end)

Citizen.CreateThread(function()
    
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
    currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
    intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
    zone = tostring(GetNameOfZone(x, y, z))
    local area = GetLabelText(zone)
    playerStreetsLocation = area

    if not zone then
        zone = "UNKNOWN"
    end

    if intersectStreetName ~= nil and intersectStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
    elseif currentStreetName ~= nil and currentStreetName ~= "" then
        playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
    else
        playerStreetsLocation = "[" .. area .. "]"
    end

    while true do
        Citizen.Wait(hudfps)
        local player = PlayerPedId()
        local x, y, z = table.unpack(GetEntityCoords(player, true))
        local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
        currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
        intersectStreetName = GetStreetNameFromHashKey(intersectStreetHash)
        zone = tostring(GetNameOfZone(x, y, z))
        local area = GetLabelText(zone)
        playerStreetsLocation = area

        if not zone then
            zone = "UNKNOWN"
        end

        if intersectStreetName ~= nil and intersectStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | " .. intersectStreetName .. " | [" .. area .. "]"
        elseif currentStreetName ~= nil and currentStreetName ~= "" then
            playerStreetsLocation = currentStreetName .. " | [" .. area .. "]"
        else
            playerStreetsLocation = "[".. area .. "]"
        end
        street = playerStreetsLocation
        local veh = GetVehiclePedIsIn(player, false)
        if IsVehicleEngineOn(veh) then          

            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                }) 
            end
            if mphmi == true then
                Mph = math.ceil(GetEntitySpeed(veh) * 2.236936)
            else
                Mph = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 3.6)
            end

            local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end

            local atl = false
            if IsPedInAnyPlane(player) or IsPedInAnyHeli(player) then
                atl = string.format("%.1f", GetEntityHeightAboveGround(veh) * 3.28084)
            end

            local engine = false
            if GetVehicleEngineHealth(veh) < 400.0 then
                engine = true
            end

            local GasTank = false
            if GetVehiclePetrolTankHealth(veh) < 3002.0 then
                GasTank = true
            end

            SendNUIMessage({
              open = 2,
              mph = Mph,
              fuel = math.ceil(Fuel),
              street = street,
              belt = seatbelt,
              harness = harness,
              harnessDur = harnessDur,
              nos = nos,
              nosEnabled = nosEnabled,
              time = hours .. ':' .. mins,
              colorblind = colorblind,
              atl = atl,
              engine = engine,
              GasTank = GasTank,
            }) 
        else

            if uiopen and not compass_on then
                SendNUIMessage({
                  open = 3,
                }) 

                uiopen = false
            end
        end
    end
end)

RegisterCommand("pusula",function ()
    -- body
    TriggerEvent('carHud:compass')
end)
RegisterCommand("harness",function ()
    -- body
    TriggerEvent('harness')
end)

RegisterNetEvent('carHud:compass')
AddEventHandler('carHud:compass', function()
    compass_on = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(hudfps)
        local player = PlayerPedId()
        if IsVehicleEngineOn(GetVehiclePedIsIn(player, false)) then
            -- in vehicle
            SendNUIMessage({
                open = 2,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
        elseif compass_on == true then
            -- has compass toggled
            if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                })
            end

            local hours = GetClockHours()
            if string.len(tostring(hours)) == 1 then
                trash = '0'..hours
            else
                trash = hours
            end
    
            local mins = GetClockMinutes()
            if string.len(tostring(mins)) == 1 then
                mins = '0'..mins
            else
                mins = mins
            end

            SendNUIMessage({
                open = 4,
                time = hours .. ':' .. mins,
                direction = math.floor(calcHeading(-GetEntityHeading(player) % 360)),
            })
            
        else
            Citizen.Wait(1000)
        end
    end
end)


Citizen.CreateThread(function()

    while true do

        Citizen.Wait(500)
        local player = PlayerPedId()

        if (IsPedInAnyVehicle(player, false)) then

            local veh = GetVehiclePedIsIn(player,false)

            if GetPedInVehicleSeat(veh, -1) == player then

                if not DrivingSet then

                    if LastVehicle ~= veh then
                        if not DecorExistOn(veh, "CurrentFuel") then
                            Fuel = math.random(80,100)
                        else
                            Fuel = DecorGetInt(veh, "CurrentFuel")
                        end
                    else
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end

                    DrivingSet = true
                    LastVehicle = veh
                    lastupdate = 0

                    if not DecorExistOn(veh, "CurrentFuel") then 
                        Fuel = math.random(30,60)
                        DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    end

                else

                    if Fuel > 105 then
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end                     
                    if Fuel == 101 then
                        Fuel = DecorGetInt(veh, "CurrentFuel")
                    end

                end

                if ( lastupdate > 300) then
                    DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    lasteupdate = 0
                end

                lastupdate = lastupdate + 1

                if Fuel > 0 then
                    if IsVehicleEngineOn(veh) then
                        local fueltankhealth = GetVehiclePetrolTankHealth(veh)
                        if fueltankhealth == 1000.0 then
                            SetVehiclePetrolTankHealth(veh, 4000.0)
                        end
                        local algofuel = GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 3.6
                        if algofuel > 160 then
                            algofuel = algofuel * 1.8
                        else
                            algofuel = algofuel / 2.0
                        end
                        algofuel = algofuel / 15000

                        if algofuel == 0 then
                            algofuel = 0.0001
                        end

                        if IsPedInAnyBoat(PlayerPedId()) then
                            algofuel = 0.0090
                        end
                        if fuelMulti == 0 then fuelMulti = 1 end
                        local missingTankHealth = (4000 - fueltankhealth) / 1000

                        if missingTankHealth > 1 then
                            missingTankHealth = missingTankHealth * (missingTankHealth * missingTankHealth * 12)
                        end

                        local factorFuel = (algofuel + fuelMulti / 10000) * (missingTankHealth+1)
                        Fuel = Fuel - factorFuel
                        
                    end
                end



                if Fuel <= 4 and Fuel > 0 then
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        local decayChance = math.random(20,100)
                        if decayChance > 90 then
                            SetVehicleEngineOn(veh,0,0,1)
                            SetVehicleUndriveable(veh,true)
                            Citizen.Wait(100)
                            SetVehicleEngineOn(veh,1,0,1)
                            SetVehicleUndriveable(veh,false)
                        end
                    end
                     
                end

                if Fuel < 15 then
                    if not IsThisModelABike(GetEntityModel(veh)) then
                        TriggerEvent("CarFuelAlarm")
                    end
                end

                if Fuel < 1 then

                    if Fuel ~= 0 then
                        Fuel = 0
                        DecorSetInt(veh, "CurrentFuel", round(Fuel))
                    end

                    if IsVehicleEngineOn(veh) or IsThisModelAHeli(GetEntityModel(veh)) then
                        SetVehicleEngineOn(veh,0,0,1)
                        SetVehicleUndriveable(veh,false)
                    end

                end

            end

        else

            if DrivingSet then
                DrivingSet = false
                DecorSetInt(LastVehicle, "CurrentFuel", round(Fuel))
            end
            Citizen.Wait(2500)
        end
    end

end)

Controlkey = {["generalUse"] = {38,"E"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["generalUse"] = table["generalUse"]
end)



Citizen.CreateThread(function()
    local bool = false
    local counter = 0
    while true do

        if counter == 0 then
            loc,bool = IsNearGasStations()
            counter = 5
        end
        counter = counter - 1
        if bool == true then

            local veh = TargetVehicle()
            local player = PlayerPedId()

            if not IsPedInAnyVehicle(player, false) and not fueling and DoesEntityExist(veh) and IsEntityAVehicle(veh) and #(GetEntityCoords(veh) - GetEntityCoords(player)) < 5.0 and #(GetEntityCoords(veh) - GetEntityCoords(player)) > 0.5 then

                curFuel = DecorGetInt(veh, "CurrentFuel")
                costs = (100 - curFuel)
                if costs < 0 then
                    costs = 0
                end
                info = string.format("Press [~g~" .. Controlkey["generalUse"][2] .. "~s~] to refuel your vehicle | ~g~$%s + tax", round(costs))
                local crd = GetEntityCoords(veh)
                DrawMarker(2,crd["x"],crd["y"],crd["z"]+1.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 100, 15, 15, 130, 0, 0, 0, 0)
                DisplayHelpText(info)
                if IsControlJustPressed(1, Controlkey["generalUse"][1]) then
                    if curFuel >= 100 then
                        PlaySound(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
                        QBCore.Functions.Notify("Your gas tank is full.")
                    else
                        costs = math.ceil(costs)
                        TriggerServerEvent("carfill:checkmoney",round(costs),loc)
                    end
                end
            else
                Citizen.Wait(1000)
            end
            Citizen.Wait(5)
        else
            Citizen.Wait(1000)
        end
    end
end)


-- Compass shit

-- Heavy Math Calcs
local imageWidth = 100 -- leave this variable, related to pixel size of the directions
local containerWidth = 100 -- width of the image container

-- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
local width =  0;
local south = (-imageWidth) + width
local west = (-imageWidth * 2) + width
local north = (-imageWidth * 3) + width
local east = (-imageWidth * 4) + width
local south2 = (-imageWidth * 5) + width

function calcHeading(direction)
    if (direction < 90) then
        return lerp(north, east, direction / 90)
    elseif (direction < 180) then
        return lerp(east, south2, rangePercent(90, 180, direction))
    elseif (direction < 270) then
        return lerp(south, west, rangePercent(180, 270, direction))
    elseif (direction <= 360) then
        return lerp(west, north, rangePercent(270, 360, direction))
    end
end

function rangePercent(min, max, amt)
    return (((amt - min) * 100) / (max - min)) / 100
end

function lerp(min, max, amt)
    return (1 - amt) * min + amt * max
end


-- Map stuff below
local x = -0.025
local y = -0.015
local w = 0.16
local h = 0.25

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do Wait(0) end
    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

    SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', x, y, w, h)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', x + 0.17, y + 0.09, 0.072, 0.162)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.035, -0.03, 0.18, 0.22)
    Wait(5000)
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        BeginScaleformMovieMethod(minimap, 'HIDE_SATNAV')
        EndScaleformMovieMethod()
    end
end)

CreateThread(function()
    while true do
        Wait(2000)
        SetRadarZoom(1150)
        local player = PlayerPedId()

        if Config.AlwaysShowRadar == false then
            if IsPedInAnyVehicle(player, false) then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
        elseif Config.AlwaysShowRadar == true then
            DisplayRadar(true)
        end
    end
end)
