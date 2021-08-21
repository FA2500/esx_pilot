-----------------------------------------------------------------------------------------------
--SCRIPT CREADO PARA EL SERVIDOR DE FIVEM DE PLATA O PLOMO COMUNIDAD GAMER.
--SCRIPT CREADO TOTALMENTE POR THEMAYKELLLL1 [ MIGUEL ANGEL LOPEZ REYES ].
--PLATA O PLOMO COMUNIDAD GAMER ACEPTA NO VENDER / REGALAR / PASAR ESTOS SCRIPTS A OTRAS PERSONAS O COMUNIDADES
--SIN PERMISOS DEL CREADOR DE EL SCRIPT.
-----------------------------------------------------------------------------------------------

RegisterServerEvent('job_pilot:payment')
AddEventHandler('job_pilot:payment',function(payment)
	TriggerEvent('es:getPlayerFromId',source, function(user)
			user.addMoney((payment))
	end)
end)