-------------------------------------------
-------------------CONFIG------------------
-------------------------------------------

--Please Change the variable value according to your own

local forPilotOnly = false
local JobName = "Pilot"
local Airport = { x = -961.88, y = -2985.00, z = 13.00}
local Airplane = { x = -934.08, y = -3181.32, z = 13.00}
local location = 
{
	[1] = {name = "Cayo Perico Airport",x = 4246.16, y = -4583.31 , z = 4.00},
	[2] = {name = "Grand Senora Airport",x = 1365.34, y = 3090.59 , z = 40.53}
}
local airplaneName = "shamal"
local multiplier = 2

-------------------------------------------
------------------VARIABLES----------------
-------------------------------------------

local payment = 0
local possibility = 0
local PlayerData

local isInJobPilot = false
local number = 0
local plateab = "FAAA"
local isToDestination = false
local isToHangar = false
local finalPayment = 0

local px = 0
local py = 0
local pz = 0 

local blips = {
	{title="Pilot Departure", colour=66, id=16, x = -961.88, y = -2985.00, z = 13.00},
}

-------------------------------------------
--------------------BLIPS------------------
-------------------------------------------

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipScale(info.blip, 0.9)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

function setDestination(location,number)
	blip_destination = AddBlipForCoord(location[number].x,location[number].y, location[number].z)
	SetBlipSprite(blip_destination, 1)
	SetNewWaypoint(location[number].x,location[number].y)
end

-------------------------------------------
------------------CITIZENS-----------------
-------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if forPilotOnly == true then
			if PlayerData == nill then
				while ESX.GetPlayerData() == nil do
					Citizen.Wait(1)
				end
				PlayerData = ESX.GetPlayerData()
			end
		end
		
		if(forPilotOnly == true and PlayerData.job.name!=JobName) then
			Citizen.Wait(1000)
		else
			if isInJobPilot == false then
				DrawMarker(1,Airport.x,Airport.y,Airport.z, 0, 0, 0, 0, 0, 0, 1.5001, 1.5001, 0.6001,255,255,51, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(Airport.x, Airport.y, Airport.z, GetEntityCoords(GetPlayerPed(-1),true)) < 1.5 then
					drawTxt("PRESS E TO START TRANSPORTING THE PASSENGERS",2, 1, 0.45, 0.03, 0.80,255,255,51,255)
					if IsControlJustPressed(1,38) then
						isInJobPilot = true
						isToDestination = true
						number = math.random(1, 2)
						-- [INFO] TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, number)
						px = location[number].x
						py = location[number].y
						pz = location[number].z
						distance = round(GetDistanceBetweenCoords(Airport.x, Airport.y, Airport.z, px,py,pz))
						finalPayment = distance * multiplier
						-- [INFO] TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, distance)
						spawn_plane()
						setDestination(location,number)
					end
				end
			end
			if isToDestination == true then
				Airport_Destination = location[number].name
				drawTxt("TAKE THE PLANE AND HEAD TO "..Airport_Destination .." AND DELIVER THE PASSENGERS",4, 1, 0.45, 0.92, 0.70,255,255,255,255)
				DrawMarker(1,location[number].x,location[number].y,location[number].z, 0, 0, 0, 0, 0, 0, 8.0, 8.0, 0.6001,255,255,51, 200, 0, 0, 0, 0)
				if GetDistanceBetweenCoords(px,py,pz, GetEntityCoords(GetPlayerPed(-1),true)) < 3 then
					drawTxt("PRESS E TO CONFIRM YOUR DESTINATION",2, 1, 0.45, 0.03, 0.80,255,255,51,255)
					if IsControlJustPressed(1,38) then
						possibility = math.random(1, 100)
						if (possibility > 70) and (possibility < 90) then
							payment = math.random(100, 200)
							TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"Taking Tips : "..payment.."$")
							TriggerServerEvent("job_pilot:payment", payment)
						end
						isToDestination = false
						isToHangar = true
						RemoveBlip(blip_destination)
						SetNewWaypoint(Airport.x,Airport.y)
					end
				end
			end
			if isToHangar == true then
				drawTxt("HEAD BACK TO THE AIRPORT TO COLLECT YOUR MONEY",4, 1, 0.45, 0.92, 0.70,255,255,255,255)
				DrawMarker(1,Airport.x,Airport.y,Airport.z, 0, 0, 0, 0, 0, 0, 8.0, 8.0, 0.6001,255,255,51, 200, 0, 0, 0, 0)
					if GetDistanceBetweenCoords(Airport.x,Airport.y,Airport.z, GetEntityCoords(GetPlayerPed(-1),true)) < 3 then
						drawTxt("PRESS E TO BE CHARGED",2, 1, 0.45, 0.03, 0.80,255,255,51,255)
						if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1), true), GetHashKey(airplaneName))  then
							if IsControlJustPressed(1,38) then
								if IsInVehicle() then
									TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"Thanks for doing the delivery, take your pay: "..finalPayment.."$")
									TriggerServerEvent("job_pilot:payment", finalPayment)
									isToDestination = false
									isToHangar = false
									isInJobPilot = false
									finalPayment = 0
									px = 0
									py = 0
									pz = 0
									local vehicleu = GetVehiclePedIsIn(GetPlayerPed(-1), false)
									SetEntityAsMissionEntity( vehicleu, true, true )
									deleteCar( vehicleu )
								else
									TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"We will not pay you if you do not Return Company VEHICLE, I'm sorry.")
								end
							end
						else
							TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0},"We will not pay you if you do not Return Company VEHICLE, I'm sorry.")
						end
					end
			end
			if IsEntityDead(GetPlayerPed(-1)) then
				isInJobPilot = false
				number = 0
				isToDestination = false
				isToHangar = false
				finalPayment = 0
				px = 0
				py = 0
				pz = 0
			end
		end
	end
end)

-------------------------------------------
----------------FUNCTION-------------------
-------------------------------------------

function spawn_plane()
	Citizen.Wait(0)

	local myPed = GetPlayerPed(-1)
	local player = PlayerId()
	local vehicle = GetHashKey(airplaneName)

	RequestModel(vehicle)

	while not HasModelLoaded(vehicle) do
		Wait(1)
	end

	local plate = math.random(100, 900)
	local spawned_car = CreateVehicle(vehicle, Airplane.x,Airplane.y,Airplane.z, 431.436, - 996.786, 25.1887, true, false)

	local plate = "FAAA"..math.random(100, 300)
    SetVehicleNumberPlateText(spawned_car, plate)
	SetVehicleOnGroundProperly(spawned_car)
	SetVehicleLivery(spawned_car, 2)
	SetPedIntoVehicle(myPed, spawned_car, - 1)
	SetModelAsNoLongerNeeded(vehicle)
	Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end

function round(num, numDecimalPlaces)
	local mult = 5^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function IsInVehicle()
  local ply = GetPlayerPed(-1)
  if IsPedSittingInAnyVehicle(ply) then
    return true
  else
    return false
  end
end

-------------------------------------------
-----------Additional Function-------------
-------------------------------------------

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end
