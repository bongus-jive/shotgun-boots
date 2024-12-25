function init()
	effect.addStatModifierGroup({{stat = "pat_shotgunboots", effectiveMultiplier = 0}})
end

function update(dt)
	animator.setFlipped(mcontroller.facingDirection() == -1)

	local state = animator.animationState("fire")

	if state ~= self.currentState then
		changedState(state)
	end
	
	if state == "off" then
		return
	end

	if state == "wait" and mcontroller.onGround() then
		animator.setAnimationState("fire", "reload")
	end

	status.addEphemeralEffect("pat_shotgunboots")
end

function changedState(state)
	self.currentState = state
	
	if animator.hasSound(state) then
		animator.setSoundPitch(state, sb.nrand(0.06, 1))
		animator.playSound(state)
	end
end
