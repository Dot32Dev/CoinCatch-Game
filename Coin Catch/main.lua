function love.load()
  --love.window.setTitle("Coin Catch!")
  math.randomseed(os.time())
  colour = {169, 132, 112}
  love.graphics.setBackgroundColor(colour[1]/256, colour[2]/256, colour[3]/256)
  font=love.graphics.newFont("LilitaOne-Regular.ttf",80)
  love.graphics.setFont(font)
  coins = 0
  textSize = 40
  gameState = 1
  timer = 100
  exists = love.filesystem.getInfo("icon.png")
  highScore = "failed to load"

  PickupCoin = love.audio.newSource("Pickup_Coin2.wav", "static")
  PickupCoin:setVolume(0.5)
  PickupCoin2 = love.audio.newSource("Pickup_Coin2mod.wav", "static")
  PickupCoin2:setVolume(0.5)
  menu = love.audio.newSource("whoosh.wav", "static")
  menu:setVolume(0.5)
  gameOver = love.audio.newSource("agression.wav", "static")
  gameOver:setVolume(0.5)

  player = {}
  player.size = 40
  player.x = love.graphics.getWidth()/2
  player.xV = 0

  masterCoin = {}
  masterCoin.gravity = 0.75
  masterCoin.time = 0.5
  masterCoin.timer = masterCoin.time
  masterCoin.colours = {}
  masterCoin.colours[1]={} masterCoin.colours[2]={} masterCoin.colours[3]={}

  masterCoin.colours[1].a = {0.7, 0.6, 0.4}
  masterCoin.colours[1].b = {0.9, 0.8, 0.4}
  masterCoin.colours[2].a = {0.5, 0.7, 0.7}
  masterCoin.colours[2].b = {0.7, 0.9, 0.9}
  masterCoin.colours[3].a = {0.7, 0.7, 0.2}
  masterCoin.colours[3].b = {0.9, 0.9, 0.2}
end

function love.update(fuckyou)
  textSize = textSize+ (40-textSize)*0.1
  player.xV = player.xV * 0.9
  player.x = player.x + player.xV
  if love.keyboard.isDown("right") or love.keyboard.isDown("d") then player.xV = player.xV +1 end
  if love.keyboard.isDown("left") or love.keyboard.isDown("a") then player.xV = player.xV -1 end
  if love.keyboard.isDown("space") and gameState == 1 then gameState = 2 menu:stop() menu:play() end

  for i,v in ipairs(masterCoin) do
    v.y = v.y+v.yV
    v.yV = v.yV + 0.25*masterCoin.gravity
  end

  for i=#masterCoin,1,-1 do
    local v = masterCoin[i]
      if v.y > love.graphics.getHeight()-110 or gameState == 3 then
        table.remove(masterCoin, i)
      end
      if math.abs(v.x-player.x) < 40 and v.y > love.graphics.getHeight()-110-player.size then
        getCoin(v.level)
        table.remove(masterCoin, i)
      end
  end

  if gameState == 2 then
    timer = timer - 1*fuckyou*3
    masterCoin.timer = masterCoin.timer - fuckyou
    if masterCoin.timer < 0 then spawnCoin() masterCoin.timer = masterCoin.time end

    if timer < 0 then gameState = 3 file() gameOver:stop() gameOver:play() end
  end

end

function love.draw()
  if gameState == 2 then
    drawStage()
    drawPlayer()
    drawCoins()
    drawTimer()
    if player.x < player.size/2 or player.x > love.graphics.getWidth()-player.size/2 then player.x = player.x-player.xV player.xV = player.xV*-0.5 end
  end

  if gameState == 1 then
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.printf("Coin Catch!",0,love.graphics.getHeight()/5,love.graphics.getWidth(), "center")
    love.graphics.printf(--[["Arrow keys/WASD to move. Collect as many coins as you can before the time runs out! \n"--]]"<Press space to start the game>",0,love.graphics.getHeight()/5 + 100,love.graphics.getWidth()/0.4, "center", nil, 0.4, 0.4)
    --love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
  end

  if gameState == 3 then
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.printf("Time out",0,love.graphics.getHeight()/5,love.graphics.getWidth(), "center")
    love.graphics.printf("Your score was "..coins,0,love.graphics.getHeight()/5 + 100,love.graphics.getWidth()/0.4, "center", nil, 0.4, 0.4)
    love.graphics.printf("The high score is "..highScore,0,love.graphics.getHeight()/4 + 100,love.graphics.getWidth()/0.3, "center", nil, 0.3, 0.3)--"\n The high score is "..highScore
    --love.graphics.printf(text, x, y, limit, align, r, sx, sy, ox, oy, kx, ky)
  end
end

function love.mousepressed( x, y, button, istouch, presses )
  -- if love.keyboard.isDown("p") then timer = 5 end
  -- if love.keyboard.isDown("o") then coins = coins + 1 end
end

function getCoin(level)
  textSize = textSize + 20
  if level == 1 then
    coins = coins + 1
    PickupCoin:stop() PickupCoin:play()
  end
  if level == 2 then
    coins = coins + 10
    PickupCoin2:stop() PickupCoin2:play()
  end
end

function drawStage()
  love.graphics.setColor(0.2, 0.2, 0.2)
  love.graphics.print("", 0, 0, nil, 0.4, 0.4)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight()-100, love.graphics.getWidth(), 100)
  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.print(coins, 30, love.graphics.getHeight()-60, nil, textSize/80, textSize/80, font:getWidth(coins)*textSize/80/2, font:getHeight()*textSize/80/2)
end

function drawPlayer()
  love.graphics.setColor(0.8, 0.8, 0.8)
  love.graphics.rectangle("fill", player.x-player.size/2, love.graphics.getHeight()-100-player.size, player.size, player.size)
  love.graphics.setColor(0.9, 0.9, 0.9)
  love.graphics.rectangle("fill", player.x-player.size*0.8/2, love.graphics.getHeight()-100-player.size*0.9, player.size*0.8, player.size*0.8)
end

function spawnCoin()
  coin = {}
  coin.x = math.random(0, love.graphics.getWidth())
  coin.y = - 40
  coin.yV = 1*masterCoin.gravity
  coin.level = math.ceil(math.random(1,11)/10)--1

  table.insert(masterCoin, coin)
end

function drawCoins()
  for i,v in ipairs(masterCoin) do
    love.graphics.setColor(masterCoin.colours[v.level].a[1], masterCoin.colours[v.level].a[2], masterCoin.colours[v.level].a[3])
    love.graphics.circle("fill", v.x, v.y, 20)
    love.graphics.setColor(masterCoin.colours[v.level].b[1], masterCoin.colours[v.level].b[2], masterCoin.colours[v.level].b[3])
    love.graphics.circle("fill", v.x, v.y, 17)
  end
end

function drawTimer()
  love.graphics.setColor(0.7, 0.2, 0.2)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight()-10, love.graphics.getWidth()*timer/100, 10)
  love.graphics.setColor(0.5, 0.2, 0.2)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight()-10, love.graphics.getWidth()*timer/100-10, 10)
end

function file()
  if love.filesystem.getInfo("highScore.txt") == nil then
    love.filesystem.write("highScore.txt",coins)
  end

  highScore = love.filesystem.read("highScore.txt")
  thonky = tonumber(highScore)

  if thonky < coins then
    love.filesystem.write("highScore.txt",coins)
    highScore = coins
  end

end
