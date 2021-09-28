///////////////
// OVERWORLD //
///////////////

::OverPlayer <- class extends PhysAct {
	//0 = right
	//1 = up
	//2 = left
	//3 = down

	constructor(_x, _y) {
		base.constructor(_x, _y)

		if(game.owx == 0 && game.owy == 0) {
			x = _x
			y = _y
		}
		else {
			x = game.owx
			y = game.owy
		}

		shape = Rec(x, y, 7, 7, 0)
		if(gvPlayer == 0) gvPlayer = this
	}

	function run() {
		base.run()

		if((x - 8) % 16 == 0) hspeed = 0
		if((y - 8) % 16 == 0) vspeed = 0

		shape.setPos(x, y)
		game.owx = x
		game.owy = y

		local level = ""
		if(actor.rawin("StageIcon")) {//Find what level was landed on
			foreach(i in actor["StageIcon"]) {
				if(hitTest(shape, i.shape)) {
					level = i.level
					break
				}
			}
		}

		//Move right
		if(getcon("right", "hold") && (!placeFree(x + 16, y) || debug) && hspeed == 0 && vspeed == 0) {
			if(level == "" || game.owd == 0) {
				hspeed = 1
				game.owd = 2
			}
			else if(game.completed.rawin(level)) hspeed = 1
		}

		//Move up
		if(getcon("up", "hold") && (!placeFree(x, y - 16) || debug) && hspeed == 0 && vspeed == 0) {
			if(level == "" || game.owd == 1) {
				vspeed = -1
				game.owd = 3
			}
			else if(game.completed.rawin(level)) vspeed = -1
		}

		//Move left
		if(getcon("left", "hold") && (!placeFree(x - 16, y) || debug) && hspeed == 0 && vspeed == 0) {
			if(level == "" || game.owd == 2) {
				hspeed = -1
				game.owd = 0
			}
			else if(game.completed.rawin(level)) hspeed = -1
		}

		//Move down
		if(getcon("down", "hold") && (!placeFree(x, y + 16) || debug) && hspeed == 0 && vspeed == 0) {
			if(level == "" || game.owd == 3) {
				vspeed = 1
				game.owd = 1
			}
			else if(game.completed.rawin(level)) vspeed = 1
		}

		x += hspeed
		y += vspeed

		if(hspeed == 0 && vspeed == 0) drawSprite(game.characters[game.playerchar], 0, x - camx, y - camy)
		else drawSprite(game.characters[game.playerchar], getFrames() / 8, x - camx, y - camy)
	}

	function _typeof() { return "OverPlayer" }
}

::StageIcon <- class extends PhysAct {
	level = ""
	visible = true

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {
		if(visible) {
			if(game.completed.rawin(level)) drawSprite(sprLevels, 1, x - camx, y - camy)
			else drawSprite(sprLevels, 0, x - camx, y - camy)
		}

		if(game.allcoins.rawin(level)) drawSprite(sprLevels, 2, x - camx, y - camy)
		if(game.allenemies.rawin(level)) drawSprite(sprLevels, 3, x - camx, y - camy)
		if(game.allsecrets.rawin(level)) drawSprite(sprLevels, 4, x - camx, y - camy)

		//Selected
		if(getcon("jump", "press") || getcon("pause", "press") || getcon("shoot", "press")) {
			if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.hspeed == 0 && gvPlayer.vspeed == 0) if(level != "") startPlay("res/" + level + ".json")
		}
	}

	function _typeof() { return "StageIcon" }
}

::WorldIcon <- class extends PhysAct {
	level = ""
	world = ""
	visible = true
	px = 0
	py = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {
		if(world == "" && level != "") {
			local arr = split(level, ",")
			world = arr[0]
			px = arr[1].tointeger()
			py = arr[2].tointeger()
			print("World: " + world + "\nX: " + px + "\nY: " + py)
		}

		//Selected
		if(getcon("jump", "press") || getcon("pause", "press") || getcon("shoot", "press")) {
			if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.hspeed == 0 && gvPlayer.vspeed == 0) if(level != "") {
				game.owx = px
				game.owy = py
				startOverworld("res/" + level + ".json")
			}
		}
	}

	function _typeof() { return "WorldIcon" }
}

::startOverworld <- function(world) {
	//Clear actors and start creating new ones
	gvPlayer = 0
	actor.clear()

	//Load map to play
	gvMap = Tilemap(world)
	game.world = world

	//Get tiles used to mark actors
	local actset = -1
	local tilef = 0
	for(local i = 0; i < gvMap.tileset.len(); i++)
	{
		if(spriteName(gvMap.tileset[i]) == "actors.png")
		{
			actset = gvMap.tileset[i]
			tilef = gvMap.tilef[i]
			break
		}
	}
	if(actset == -1)
	{
		print("Map does not use actors.png. No actors to load.")
		return
	}

	//Get layer for actors
	local actlayer = -1
	foreach(i in gvMap.data.layers)
	{
		if(i["type"] == "objectgroup" && i["name"] == "actor")
		{
			actlayer = i
			break
		}
	}
	if(actlayer == -1)
	{
		print("Map does not have an actor layer. No actors to load.")
		return
	}

	//Start making actors
	foreach(i in actlayer.objects)
	{
		local n = i.gid - tilef

		//Get the tile number and make an actor
		//according to the image used in actors.png
		switch(n)
		{
			case 0:
				//newActor(Tux, i.x, i.y - 16)
				if(gvPlayer == 0) newActor(OverPlayer, i.x + 8, i.y - 8)
				break

			case 1:
				local c = actor[newActor(StageIcon, i.x + 8, i.y - 8)]
				c.level = i.name
				c.visible = i.visible
				break

			case 2:
				local c = actor[newActor(WorldIcon, i.x + 8, i.y - 8)]
				c.level = i.name
				break
		}
	}

	gvGameMode = gmOverworld

	if(gvPlayer != 0) {
		camx = gvPlayer.x - (screenW() / 2)
		camy = gvPlayer.y - (screenH() / 2)
	}
	else {
		camx = 0
		camy = 0
	}

	update()
}

::gmOverworld <- function() {
	gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), 21, 17, "bg")
	gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), 21, 17, "fg")
	if(debug) gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), 21, 17, "solid")

	//Actor types are explicitly called this way to ensure the player is drawn on top
	if(actor.rawin("StageIcon")) foreach(i in actor["StageIcon"]) i.run()
	if(actor.rawin("WorldIcon")) foreach(i in actor["WorldIcon"]) i.run()
	if(gvPlayer != 0) gvPlayer.run()

	drawDebug()

	if(keyPress(k_escape)) startMain()

	//Follow player
	local px = 0
	local py = 0
	local ux = gvMap.w - screenW()
	local uy = gvMap.h - screenH()

	if(gvPlayer != 0)
	{
		px = (gvPlayer.x + gvPlayer.hspeed * 24) - (screenW() / 2)
		py = (gvPlayer.y + gvPlayer.vspeed * 16) - (screenH() / 2)
	} else {
		px = camx
		py = camy
	}

	camx += (px - camx) / 16
	camy += (py - camy) / 16

	if(camx > ux) camx = ux
	if(camx < 0) camx = 0
	if(camy > uy) camy = uy
	if(camy < 0) camy = 0
}