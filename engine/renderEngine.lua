-- A RenderEngine holds a world which it can render and controls the rendering process
-- It can also contain UIRenderers for UI rendering
local RenderEngine = {}
RenderEngine.metatable = {__index = RenderEngine}

function RenderEngine.new()
  local re = {}

  re.uiRenderers = {}

  setmetatable(re, RenderEngine.metatable)
  return re
end

function RenderEngine:render()
  if #self.uiRenderers == 0 and self.world == nil then
    -- Nothing to render
    return
  end
  
  -- Prepare rendering by setting general state. This should be reset if changed.
  love.graphics.scale(2,2) -- This should be calculated from resolution in the future

  if self.world then
    self.world:forTileRows(function(row, y)

      self.world:forTilesInRow(row, function(tile, x)
        tile:draw(love.graphics, (x-1)*self.world.scale, (y-1)*self.world.scale)
      end)

      self.world:forEntitiesOnRow(y, function(ent)
        ent:draw(love.graphics, (ent.x-1)*self.world.scale, (ent.y-1)*self.world.scale)
      end)
    end)
  end

  for r,renderer in ipairs(self.uiRenderers) do
    renderer.render(love.graphics)
  end
end

return RenderEngine
