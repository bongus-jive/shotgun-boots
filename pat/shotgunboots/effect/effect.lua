function init()
  animator.setPartTag("muzzleFlash", "variant", math.random(1, 3))
	effect.addStatModifierGroup({{stat = "pat_shotgunboots", effectiveMultiplier = 0}})
end

function update(dt)
	animator.setFlipped(mcontroller.facingDirection() == -1)
	
	local state = animator.animationState("fire")
	if state == "wait" and mcontroller.onGround() then
		animator.setAnimationState("fire", "reload")
	end
	
	if state ~= "off" then
		status.addEphemeralEffect("pat_shotgunboots")
	else
		script.setUpdateDelta(0)
	end
end