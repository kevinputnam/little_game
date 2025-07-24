local game_data = require("game_data")

function love.load()
  screen_width = 480
  screen_height = 480
  font = love.graphics.newFont(14)
  love.graphics.setFont(font)
  love.window.setMode(screen_width,screen_height)
  love.window.setTitle('Little Game')
  current_location = game_data.starting_location
  selected_thing = nil
  inventory = {}
  screen_message = nil
end

function love.draw()
  cloc = game_data.locations[current_location]
  love.graphics.printf(current_location .. ": " .. cloc.description,8,8,love.graphics.getWidth())
  --love.graphics.print(cloc.description,8,28)
  love.graphics.print("You also see:",8,48)
  onscreen_things = {}
  onscreen_actions = {}
  drawItems(cloc.things,onscreen_things,48,20)
  if selected_thing then
    drawThingData()
    love.graphics.print("Actions:",8,220)
    actions = {}
    for name, action in pairs(selected_thing.actions) do
      table.insert(actions,name)
    end
    drawItems(actions,onscreen_actions,220,20)
  else
    if screen_message then
      love.graphics.print(screen_message,8,220)
    end
  end
end

function drawItems(items,item_list,y,y_inc)
  for index, name in pairs(items) do
    y = y + y_inc
    i = {name = name, x = 18, y = y, height = 15,width = 100}
    table.insert(item_list,i)
    love.graphics.print("* " .. name,18,y)
  end
end

function drawThingData()
  love.graphics.print(selected_thing.name .. ": " ..selected_thing.description,8,200)
end

function item_clicked(x,y,item)
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

function process_action(name,action)
  screen_message = nil
  actions = {}
  if name == 'go' then
    current_location = action.location or "Limbo"
  elseif name == 'open' then
    actions = resolve_open(action)
  elseif name == 'talk' then
    print("Blah, blah, blah.")
  elseif name == 'say' then
    screen_message = action.text or "oops. there's no text"
  elseif name == 'take' then
    table.insert(inventory,selected_thing.name)
    removeByValue(game_data.locations[current_location].things,selected_thing.name)
  end
  selected_thing = nil
  for n, a in pairs(actions) do
    process_action(n,a)
  end
end

function resolve_open(action)
  if action.requires then
    if not valueInTable(inventory,action.requires) then
      return {say = {text = "I can't open it."}}
    end
  end
  return action.actions or {}
end

function love.mousepressed(x, y, button)
  if button == 1 then -- left mouse button
    for _, item in ipairs(onscreen_things) do
      if item_clicked(x,y,item) then
        selected_action = nil
        selected_thing = game_data.things[item.name]
        selected_thing.name = item.name
      end
    end
    for _, item in ipairs(onscreen_actions) do
      if item_clicked(x,y,item) then
        selected_action = game_data.things[selected_thing.name].actions[item.name]
        process_action(item.name,selected_action)
      end
    end
  end
end