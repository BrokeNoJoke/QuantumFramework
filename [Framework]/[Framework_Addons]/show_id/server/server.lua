RegisterNetEvent('NAT2K15:SENTID')
AddEventHandler('NAT2K15:SENTID', function(id)
	local src = source
	local playerdata = exports[Config.framework_name]:getdept(src)
	if(playerdata ~= nil) then
		TriggerClientEvent("NAT2K15:OPENIDUI", id, src, playerdata[src].char_name, playerdata[src].gender, playerdata[src].dob)
	end
end)
  
-- coming soon -- 
-- RegisterNetEvent('NAT2K15:MUGSHOTCREATED')
-- AddEventHandler('NAT2K15:MUGSHOTCREATED', function(id, name, gender, dob, txd) 
-- 	local src = source
-- 	TriggerClientEvent("NAT2K15:OPENIDUI", id, src, name, gender, dob, txd)
-- end)