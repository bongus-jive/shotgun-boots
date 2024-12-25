require "/scripts/vec2.lua"

local minimumFallDistance = 14
local minimumFallVel = 40

local collisionKinds = {"Block", "Platform", "Dynamic", "Slippery"}

local _init = init
function init()
	_init()
	status.removeEphemeralEffect("pat_shotgunboots")
end

local _update = update
function update(dt)
	_update(dt)

	if not status.statPositive("pat_shotgunboots") or mcontroller.zeroG() or self.fallDistance <= minimumFallDistance or -self.lastYVelocity <= minimumFallVel then
		return
	end

	local mPos = mcontroller.position()
	local mBoundBox = mcontroller.boundBox()
	local box = {
		mBoundBox[1] + mPos[1], mBoundBox[2] + mPos[2],
		mBoundBox[3] + mPos[1], mBoundBox[4] + mPos[2]
	}

	if box[4] > box[2] then
		box[2], box[4] = box[4], box[2]
	end
	box[4] = box[4] + (self.lastYVelocity * dt) - 2

	if not world.rectCollision(box, collisionKinds) then
		return
	end

	status.addEphemeralEffect("pat_shotgunboots")

	local yVelocity = mcontroller.yVelocity()
	local projectileCount = math.ceil(math.abs(yVelocity) / 7.5)
	self.fallDistance = 0

	mcontroller.setYVelocity(math.max(0, yVelocity + (projectileCount * 10)))

	local entityId = entity.id()
	local params = {}
	params.power = 5 * status.stat("powerMultiplier")

	for _ = 1, projectileCount do
		params.speed = sb.nrand(25, 150)
		local angle = vec2.rotate({0, -1}, sb.nrand(0.15, 0))
		world.spawnProjectile("pat_shotgunboots_bullet", mPos, entityId, angle, false, params)
	end
end
