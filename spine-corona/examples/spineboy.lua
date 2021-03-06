
-- This example shows simple usage of displaying a skeleton with queued animations.

local spine = require "spine-corona.spine"

local json = spine.SkeletonJson.new()
json.scale = 1
local skeletonData = json:readSkeletonDataFile("examples/spineboy/spineboy.json")

local skeleton = spine.Skeleton.new(skeletonData)
function skeleton:createImage (attachment)
	-- Customize where images are loaded.
	return display.newImage("examples/spineboy/images/" .. attachment.name .. ".png")
end
skeleton.group.x = 150
skeleton.group.y = 325
skeleton.flipX = false
skeleton.flipY = false
skeleton.debug = true -- Omit or set to false to not draw debug lines on top of the images.
skeleton:setToSetupPose()

-- AnimationStateData defines crossfade durations between animations.
local stateData = spine.AnimationStateData.new(skeletonData)
stateData:setMix("walk", "jump", 0.2)
stateData:setMix("jump", "walk", 0.4)

-- AnimationState has a queue of animations and can apply them with crossfading.
local state = spine.AnimationState.new(stateData)
state:setAnimation("walk", false)
state:addAnimation("jump", false)
state:addAnimation("walk", true)

local lastTime = 0
local animationTime = 0
Runtime:addEventListener("enterFrame", function (event)
	-- Compute time in seconds since last frame.
	local currentTime = event.time / 1000
	local delta = currentTime - lastTime
	lastTime = currentTime

	-- Update the state with the delta time, apply it, and update the world transforms.
	state:update(delta)
	state:apply(skeleton)
	skeleton:updateWorldTransform()
end)

