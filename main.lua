local game_data = require("game_data")

function love.load()
  screen_width = 480
  screen_height = 480
  love.window.setMode(screen_width,screen_height)
  love.window.setTitle('Little Game')
  current_location = game_data.starting_location
  selected_thing = nil
  inventory = {}
end

function love.draw()
  love.graphics.print(current_location,8,8)
  cloc = game_data.locations[current_location]
  love.graphics.print(cloc.description,8,28)
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
    if selected_action then
      love.graphics.print("Selected action: " .. selected_action.name,8,300)
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

function process_action(name,action)
  if name == 'go' then
    current_location = action.location or "Limbo"
  elseif name == 'open' then
    print("Open sesame.")
  elseif name == 'talk' then
    print("Blah, blah, blah.")
  elseif name == 'say' then
    print("Hi!")
  elseif name == 'take' then
    table.insert(inventory,selected_thing.name)
    removeByValue(current_location,selected_thing.name)
  end
  selected_thing = nil
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