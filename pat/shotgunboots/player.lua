require "/scripts/rect.lua"

local oldInit = init or function() end
local oldUpdate = update or function() end

local minimumFallDistance = 14
local minimumFallVel = 40

function init(...)
	oldInit(...)
	status.removeEphemeralEffect("pat_shotgunboots")
end

function update(dt, ...)
	oldUpdate(dt, ...)
	
	if status.statPositive("pat_shotgunboots")
	and not mcontroller.zeroG()
	and self.fallDistance > minimumFallDistance
	and -self.lastYVelocity > minimumFallVel then
		local r = rect.translate(mcontroller.boundBox(), mcontroller.position())
		local r2 = r[2]
		r[2] = r[4]
		r[4] = r2
		local i = r[2] > r[4] and 4 or 2
		r[i] = r[i] - 6
		
		if world.rectCollision(r, {"Block", "Platform", "Dynamic"}) then
			status.removeEphemeralEffect("pat_shotgunboots")
			status.addEphemeralEffect("pat_shotgunboots")
			
			local yVel = mcontroller.yVelocity()
			local projectileCount = math.ceil(math.abs(yVel) / 7.5)
			mcontroller.setYVelocity(math.max(0, yVel + (projectileCount * 10)))
			self.fallDistance = 0
			
			for _ = 1, projectileCount do
				local angle = vec2.rotate({0, -1}, sb.nrand(0.15, 0))
				local params = {
					speed = sb.nrand(15, 200),
					power = 5 * status.stat("powerMultiplier")
				}
				world.spawnProjectile("pat_shotgunboots_bullet", mcontroller.position(), entity.id(), angle, false, params)
			end
		end
	end
end
