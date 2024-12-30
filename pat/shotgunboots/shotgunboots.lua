require "/scripts/vec2.lua"

local ShotgunBoots = {}
pat_ShotgunBoots = ShotgunBoots

function ShotgunBoots:init()
	self.minimumFallDistance = 14
	self.minimumFallVel = 40
	self.collisionKinds = {"Block", "Platform", "Dynamic", "Slippery"}
	status.removeEphemeralEffect("pat_shotgunboots")
end

function ShotgunBoots:update(dt)
	self.dt = dt
	if status.statPositive("pat_shotgunboots") and self:detectFall() then
		self:fire()
	end
end

function ShotgunBoots:detectFall()
	if mcontroller.zeroG() or _ENV.self.fallDistance <= self.minimumFallDistance or -_ENV.self.lastYVelocity <= self.minimumFallVel then
		return false
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
	box[4] = box[4] + (_ENV.self.lastYVelocity * self.dt) - 2

	return world.rectCollision(box, self.collisionKinds)
end

function ShotgunBoots:fire()
	status.addEphemeralEffect("pat_shotgunboots")

	local yVelocity = mcontroller.yVelocity()
	local projectileCount = math.ceil(math.abs(yVelocity) / 7.5)
	
	mcontroller.setYVelocity(math.max(0, yVelocity + (projectileCount * 10)))
	_ENV.self.fallDistance = 0

	local mPos = mcontroller.position()
	local entityId = entity.id()
	local params = {}
	params.powerMultiplier = status.stat("powerMultiplier")

	for _ = 1, projectileCount do
		params.speed = sb.nrand(25, 150)
		local angle = vec2.rotate({0, -1}, sb.nrand(0.15, 0))
		world.spawnProjectile("pat_shotgunboots_bullet", mPos, entityId, angle, false, params)
	end
end

local _init = init
function init()
	_init()
	ShotgunBoots:init()
end

local _update = update
function update(dt)
	ShotgunBoots:update(dt)
	_update(dt)
end
