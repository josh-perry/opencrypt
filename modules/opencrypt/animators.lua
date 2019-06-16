local Animator = {}
Animator.metatable = {__index = Animator}

function Animator:new(tracks, frames, ent)
  local a = {}

  a.tracks = tracks
  a.frames = frames
  a.ent = ent

  local fullw = ent.texture:getWidth()
  local fullh = ent.texture:getHeight()
  local w = fullw / frames
  local h = fullh / tracks
  a.quads = {}
  for t=1,tracks do
    a.quads[t] = {}
    for f=1,frames do
      a.quads[t][f] = love.graphics.newQuad((f-1) * w, (t-1) * h, w,h, fullw,fullh)
    end
  end

  setmetatable(a, self.metatable)
  return a
end

function Animator:newChild()
  local child = {}
  child.metatable = {__index = child}

  setmetatable(child, self.metatable)
  return child
end

function Animator:draw(graphics, track, progress, x,y, flip)
  local sx = 1
  if flip then
    sx = -1
  end
  local xoff = self.ent.texture:getWidth()/2/self.frames
  graphics.draw(self.ent.texture, self.quads[track][math.floor(progress * self.frames) + 1], xoff+x,y, 0, sx,1, xoff)
end

local MusicAnimator = Animator:newChild()

function MusicAnimator:new(music, ...)
  local ma = Animator.new(self, ...)

  ma.music = music

  return ma
end

function MusicAnimator:draw(graphics, track, x,y, flip)
  Animator.draw(self, graphics, track, self.music:progressToNextBeat(), x,y, flip)
end

local animators = {Animator=Animator, MusicAnimator=MusicAnimator}
return animators