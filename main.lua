local game_data = require("game_data")

function love.load()
  debugging = true
  screen_width = 480
  screen_height = 480
  scrollY = 0
  font = love.graphics.newFont(14)
  love.graphics.setFont(font)
  love.window.setMode(screen_width,screen_height)
  love.window.setTitle('Little Game')
  current_scene = game_data.starting_scene
  display_content = {status_info="",messages={},choices={}}
  loadScene(current_scene)
end


function love.update(dt)
  -- scroll message area text with arrow keys
  local scrollSpeed = 80
  if love.keyboard.isDown("down") then
      scrollY = scrollY - scrollSpeed * dt
  elseif love.keyboard.isDown("up") then
      scrollY = scrollY + scrollSpeed * dt
  end
  if scrollY > 0 then
    scrollY = 0
  end
  -- get last 99 messages in display_content.messages and set message_text
  local length = #display_content.messages
  local start_index = math.max(1,length-100)
  message_text = ""
  for i = start_index, length do
    message_text = message_text .. display_content.messages[i] .. "\n"
  end
  -- get size of wrapped message text and limit scrolling
  local _, wrappedText = font:getWrap(message_text, screen_width)
  local textHeight = #wrappedText * font:getHeight()
  -- if the text extends past the display area
  if textHeight > 300 then
    -- if we've scrolled to the last line don't go further
    if scrollY < -textHeight + 300 then
      scrollY = -textHeight + 300
    end
  else
    -- if it doesn't extend past the display area, don't scroll
    scrollY = 0
  end
end

function love.draw()
  local x, y = 100, 100
  local width, height = 400, 200

  love.graphics.printf(display_content.status_info,8,5,love.graphics.getWidth())
  love.graphics.line(0,30,screen_width,30)
  love.graphics.line(0,330,screen_width,330)
  love.graphics.setScissor(0, 30, screen_width, 300)
  love.graphics.push()
  love.graphics.translate(0, scrollY)
  love.graphics.printf(message_text,8,35,screen_width)
  love.graphics.pop()
  love.graphics.setScissor()

end

function love.mousepressed(x, y, button)
  if button == 1 then -- left mouse button
    for _, item in ipairs(display_content.choices) do
      if itemClicked(x,y,item) then
        selected_choice = nil
      end
    end
  end
end

function loadScene(scene_name)
  scene = game_data.scenes[scene_name]
  display_content.status_info=scene.title
  display_content.choices = {}
  if scene.description then
    table.insert(display_content.messages,scene.description)
  end
  if scene.interactions then
    for _,interaction in ipairs(scene.interactions) do
      table.insert(display_content.choices,interaction.text)
      -- add interactions to choices
    end
  end
  if scene.things then
    table.insert(display_content.messages,"You see:")
    for _,name in ipairs(scene.things) do
      t = game_data.things[name]
      table.insert(display_content.messages,t.description)
      if t.interactions then
        for _,interaction in ipairs(t.interactions) do
          table.insert(display_content.choices,name .. ": " .. interaction.text)
          -- add interactions to choices
        end
      end
    end
  end
  if scene.actions then
    -- process actions
  end
  if debugging then
    print("loadScene:" .. display_content.status_info)
    for _,s in ipairs(display_content.messages) do
      print(s)
    end
    for _,i in ipairs(display_content.choices) do
      print(i)
    end
  end
end

function itemClicked(x,y,item)
  if x >= item.x and x <= item.x + item.width and
     y >= item.y and y <= item.y + item.height then
      return true
  end
  return false
end

function removeByValue(tbl, val)
  for i = #tbl, 1, -1 do  -- iterate backwards to avoid shifting issues
    if tbl[i] == val then
      table.remove(tbl, i)
    end
  end
end

function valueInTable(tbl, val)
  for index, name in pairs(tbl) do
    if name == val then
      return true
    end
  end
  return false
end