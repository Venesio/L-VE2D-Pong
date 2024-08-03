function love.load()
	list = { 1, -1}
	list2 = {'bip1','bip2','bip3','bip4'}

	pontosP1 = 0
	pontosP2 = 0
	
	bola = {}
	bola.x = 400
	bola.y = 300
	bola.spdX = 0
	bola.spdY = 0
	bola.facing = list[love.math.random( #list )]
	bola.spdMultiplier = 0.5
	bola.lastSpd = 7
	
	playersWidth = 20
	playersHeight = 100
	
	p1 = {}
	p1.y = 300
	p1.spd = 0
	p1.x = 30 + playersWidth
	
	p2 = {}
	p2.y = 300
	p2.x = 800 - playersWidth - 30
	p2.spd = 7
	p2.teLiga = false
	p2.margem = love.math.random(400,700)
	
	gameStarted = false
	
	sounds = {}
	sounds.start = love.audio.newSource('sounds/start.wav','static')
	sounds.bip1 = love.audio.newSource('sounds/bip1.wav','static')
	sounds.bip2 = love.audio.newSource('sounds/bip2.wav','static')
	sounds.bip3 = love.audio.newSource('sounds/bip3.wav','static')
	sounds.bip4 = love.audio.newSource('sounds/bip4.wav','static')
	sounds.music = love.audio.newSource('sounds/music.wav','stream')
	sounds.lose = love.audio.newSource('sounds/lose.wav','static')
	sounds.intro = love.audio.newSource('sounds/intro.wav','static')

	sounds.music:setLooping(true)
	sounds.intro:setLooping(true)
	
	sounds.music:setVolume(0.2)
	sounds.intro:setVolume(0.2)
	
	saiDai = 0
	
	sounds.intro:play()
	
	deveTerUmJeitoMaisFacil = false
	
end

function love.keypressed(key)
	if key == 'space' and not gameStarted then
		gameStarted = true
		bola.spdX = bola.lastSpd + pontosP1 * 0.1
		p1.spd = 7
		sounds.intro:stop()
		sounds.music:play()
		saiDai = 500
		
	end
	if key == 'r' and gameStarted then
		sounds.intro:stop()
		sounds.music:stop()
		love.load()

	end
end

function gameOver(whoLost)
	if whoLost == 'p1' then
		pontosP2 = pontosP2 + 1
		bola.lastSpd = 7
		sounds.lose:play()
		sounds.music:stop()
	elseif whoLost == 'p2' then
		pontosP1 = pontosP1 + 1
		bola.lastSpd = bola.spdX
		sounds.start:play()
	end
	gameStarted = false
	primeiraJogada = false
	bola.spdX = 0
	bola.spdY = 0
	bola.x = 400
	bola.y = 300
	bola.facing = list[love.math.random( #list )]
	p1.y = 300
	p2.y = 300
	p1.spd = 0
end

function love.update(dt)
	bola.x = bola.x + bola.spdX * bola.facing
	bola.y = bola.y + bola.spdY
	
	if gameStarted then
		p1.cima = love.keyboard.isDown('up')
		p1.baixo = love.keyboard.isDown('down')
	end
	
	if bola.y >= 600 or bola.y <= 0 then
		bola.spdY = bola.spdY * -1
		sounds.bip3:play()

	end
	
	if p1.cima and p1.y > 0 + playersHeight / 2 then
		p1.y = p1.y - p1.spd
	elseif p1.baixo and p1.y < 600 - playersHeight / 2 then
		p1.y = p1.y + p1.spd
	end
	
	if bola.x > p2.margem then
		p2.teLiga = true
	else
		p2.teLiga = false
	end
	
	if bola.x < p1.x + 10 and ((bola.y <= p1.y and bola.y > p1.y - playersHeight / 2) or (bola.y >= p1.y and bola.y < p1.y + playersHeight / 2)) then
		bola.facing = 1
		sounds.bip1:play()
		p2.margem = love.math.random(350,750)
		if not primeiraJogada then
			primeiraJogada = true
			bola.spdY = bola.lastSpd + pontosP1 * 0.1
		end
		
	end
	
	if bola.x > p2.x - 10 and ((bola.y <= p2.y and bola.y > p2.y - playersHeight / 2) or (bola.y >= p2.y and bola.y < p2.y + playersHeight / 2)) then
		bola.facing = -1
		sounds.bip2:play()
		if not primeiraJogada then
			primeiraJogada = true
			bola.spdY = bola.lastSpd + pontosP1 * 0.1
		end
		
	end
	
	if bola.x < 0 then
		gameOver('p1')
		
	end
	if bola.x > 800 then
		gameOver('p2')
		
	end
	
	if p2.teLiga then
		if bola.y > p2.y and p2.y < 600 - playersHeight / 2 then
			p2.y = p2.y + p2.spd
		elseif bola.y < p2.y and p2.y > 0 + playersHeight / 2 then	
			p2.y = p2.y - p2.spd
		end
	end
	
end

function love.draw()
	love.graphics.circle('fill',bola.x,bola.y,20)
	love.graphics.rectangle('fill',p1.x - playersWidth,p1.y - playersHeight / 2,playersWidth,playersHeight)
	love.graphics.rectangle('fill',p2.x,p2.y - playersHeight / 2,playersWidth,playersHeight)
	love.graphics.line(400,0,400,600)
	love.graphics.print(pontosP1,200,20,0,3,3)
	love.graphics.print(pontosP2,600,20,0,3,3)
	love.graphics.print('Press SPACE to play!',220,320 + saiDai,0,3,3)
	
end