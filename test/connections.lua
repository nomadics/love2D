HOST_SERVER = 0
HOST_CLIENT = 1
HOST_BOTH = 2

TYPE_PLAYER = 0
TYPE_BULLET = 1
TYPE_DATA = 2
TYPE_PLAYER_REMOVE = 3
TYPE_HEALTH = 4



--local ip = "25.167.192.43"--temporary

function startHost(isPlayer)

	startRound()

	Net:init( "server" )
	Net:connect( nil, 27015 )
	Net.HostType = isPlayer and HOST_BOTH or HOST_SERVER
	
	Net.ips["server"] = -1
end

function startClient(ip)
	
	if not string.find(ip, ":") then
		ip = ip..":27015"
	end
	
	local i,p = ip:match( "^(.-):(%d+)$" )
	
	local port = p or 27015
	
	print(i,p)
	
	Net:init( "client" )
	Net:connect( i, tonumber(port) )
	Net.HostType = HOST_CLIENT
	--send({_type=TYPE_PLAYER})
end

function send(tbl)
	local s = Net.HostType
	if s==HOST_SERVER or s==HOST_BOTH then
		tbl.id=-1
		receive(tbl)
	elseif s==HOST_CLIENT then
		Net:send(tbl)
	end
end


function receive(tbl)
	--Host type... Do i need this?
	local s = Net.HostType
	--IP
	local oldid = tbl.id
	--userId
	--print(Net.ips[tbl.id])
	
	--tbl.id = Net.ips[tbl.id] or tbl.id
	--print(tbl.id)
	
	if s==HOST_BOTH or s==HOST_SERVER then
		local t = tbl._type
		
		
		if t==TYPE_DATA then
			Net:send({_type=t, sceneId=sceneId}, nil, nil, oldid)
		else
			--[[for v,i in pairs(Net.ips) do
				if i ~= tbl.id and i~=-1 then
					--print(tbl.id, v)
					Net:send(tbl, nil, nil, v)
				end
				--print(tbl.id,v)
				--print("player")
			end]]
		end
	end
	
	
	--Necessary?
	if (s==HOST_BOTH or s==HOST_CLIENT or s==HOST_SERVER) then-- lol
	
		--type of data
		local t = tbl._type
		
		--make bullets!
		if t==TYPE_BULLET then
			local p = playerhandler.players[tbl.id]
			if p and (s==HOST_BOTH or s==HOST_SERVER) then
				
			
				local larm = p.parts.torso.children.larm
				tbl.x = larm.x
				tbl.y = larm.y
				tbl.ang = larm.ang
				tbl.off = (larm.h/3)*2
				--tbl.id = oldid
					
				broadcast(tbl, tbl.id)
				
				if tbl.id~=0 then
					print(tbl.id,"not 0")
					makeBullet(tbl.name, p, tbl.x, tbl.y, tbl.ang, tbl.off)
				end
			elseif s==HOST_CLIENT and tbl.id ~= 0 then
				--print(tbl.id)
				makeBullet(tbl.name, p, tbl.x, tbl.y, tbl.ang, tbl.off)
			end
			
		end
		
		--Update players
		if t==TYPE_PLAYER then
			--if tbl.id~=0 then
				if s==HOST_CLIENT then
				--print(tbl.id)
				end
				--Do we have a player?
				local p = playerhandler.players[tbl.id]
				if not p then--No?
					--Make one! :3
					print("WTF", tbl.id, oldid)
					p = playerhandler.create(tbl.id, tbl.isLocal) 
					
					
				end
				--Setup positions
				p.nextX = tbl.x or 0
				p.nextY = tbl.y or 0
				p.nextmouseX = tbl.mouseX or 0
				p.nextmouseY = tbl.mouseY or 0
			
			--else
			--end
			
		elseif t==TYPE_DATA and s==HOST_CLIENT then
			dataThink(tbl.sceneId)
		elseif t==TYPE_PLAYER_REMOVE then
		
			local p = playerhandler.players[tbl.id]
			if p then
				playerhandler.remove(p)
			end
		
		elseif t==TYPE_HEALTH then
			local p = playerhandler.players[tbl.id]
			if p then
				p.health = tbl.health
			else
				print("no health p", oldid, tbl.id)
			end
		
		end
		
	end

end


function Net.event.server.userConnected( id ) 
	print("prepoop", id)
	--if id=="localhost" then return end
	
	if sceneId==2 and not playerhandler.players[id] then
		--playerhandler.create(id)
		print("poop")
	end
	
	print(sceneId, "sceneid") 
	for v,i in pairs(playerhandler.players) do
		print("v",v)
	end

end


function Net.event.client.connect( ip, port )

	send({_type=TYPE_DATA})
	print("Sent")

end

function Net.event.server.userTimedOut( ip )
	removePlayer(Net.ips[ip])
end


function Net.event.client.serverTimedOut( ip )
	for v,i in pairs(playerhandler.players) do
		playerhandler.remove(i)
	end
	playerhandler.players = {}
	setScene(1)
end


function removePlayer(id)

	local p = playerhandler.players[id]
	if p then
		print("remove")
		p.REMOVE = true
		print(id)
	
	else
		print("error?")
	end

end


function dataThink(id)
	--print("thunk")
	setScene(tonumber(id or 1))
	--if not playerhandler.players[0] then
		--playerhandler.create(0,true)
	--end
end

local l = 0
function netThink(dt)
	if Net.HostType==HOST_SERVER or Net.HostType==HOST_BOTH and l <= 0 then
		l = 1/tickrate
		for v,i in pairs(Net.ips) do
			if i~=-1 then-- and i~=0 then
				--print("lopl",v,i)
				sendData(v, i)
			end
		end
		
		for v,i in pairs(Net.ips) do
			
			local p = playerhandler.players[i]
			if p and p.REMOVE then
				playerhandler.remove(p)				
				Net.ips[v] = nil
				broadcast({_type=TYPE_PLAYER_REMOVE, id=ip})
			end
		end
		
	else
		l = l - dt
	end
end

function sendData(ip, id)

	if not playerhandler.players[id] then
		local p = playerhandler.create(id) 
		local t = {
			mouseX = 0,
			mouseY = 0,
			x = 0,
			y = 0,
			_type=TYPE_PLAYER,
			isLocal = true,
			id = id
		}
		
		Net:send(t, nil, nil, ip)
		
		
	end

	Net:send({_type=TYPE_DATA, sceneId=sceneId}, nil, nil, ip)

	for v,i in pairs(Net.ips) do
		if i ~= id then
			print(i)
			--print(i, ip)
			--print(i, id, ip)
			local t = i
			--if t==-1 then
			--	t = 0
			--end
			local p = playerhandler.players[t]
			if p then
			
				playerhandler.sendPlayer(p, ip)
				
				--print(t)
			end
		end
	end
end


function broadcast(tbl, who)
	who = who or -1
	for v,i in pairs(Net.ips) do
		if i ~= -1 and i ~= who then
			
			Net:send(tbl, nil, nil, v)
		end
	end

end