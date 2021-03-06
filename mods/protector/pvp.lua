
-- get static spawn position
--local statspawn = (minetest.settings:get_pos("static_spawnpoint") or {x = 0, y = 1, z = 0})
--local statspawn = (minetest.setting_get_pos("static_spawnpoint") or {x = 0, y = 1, z = 0})
local statspawn = {x = 0, y = 1, z = 0}

if minetest.setting_get_pos("static_spawnpoint") ~= nil then
    statspawn = minetest.setting_get_pos("static_spawnpoint")
end

-- is pvp protection enabled and spawn protected
protector.pvp = minetest.settings:get_bool("protector_pvp")
protector.spawn = (tonumber(minetest.settings:get("protector_pvp_spawn")) or 30)

-- Disable PVP in your own protected areas
if minetest.settings:get_bool("enable_pvp") and protector.pvp then

	if minetest.register_on_punchplayer then

		minetest.register_on_punchplayer(
		function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)

			if not player
			or not hitter then
				print("[Protector] on_punchplayer called with nil objects")
			end

			if not hitter:is_player() then
				return false
			end

			-- no pvp at spawn area
			local pos = player:get_pos()

			if pos.x < statspawn.x + protector.spawn
			and pos.x > statspawn.x - protector.spawn
			and pos.y < statspawn.y + protector.spawn
			and pos.y > statspawn.y - protector.spawn
			and pos.z < statspawn.z + protector.spawn
			and pos.z > statspawn.z - protector.spawn then
				return true
			end

			if minetest.is_protected(pos, hitter:get_player_name()) then
				return true
			else
				return false
			end

		end)
	else
		print("[Protector] pvp_protect not active, update your version of Minetest")

	end
else
	print("[Protector] pvp_protect is disabled")
end
