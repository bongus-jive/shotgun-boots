function init()
	effect.addStatModifierGroup({{stat = "pat_shotgunboots", effectiveMultiplier = 0}})
end

function update(dt)
	animator.setFlipped(mcontroller.facingDirection() == -1)

	local state = animator.animationState("fire")
	
	if state == "off" then
		return script.setUpdateDelta(0)
	end

	if state == "wait" and mcontroller.onGround() then
		animator.setAnimationState("fire", "reload")
	end

	status.addEphemeralEffect("pat_shotgunboots")
end
