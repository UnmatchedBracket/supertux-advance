/*=======*\
| ENEMIES |
\*=======*/

::NMEloader <- class extends Actor {
	e = 0 //Enemy class to create
	m = 0 //Respawn mode
	a = 0 //Current actor ID

	function step() {

	}
}

::Enemy <- class extends PhysAct {
	health = 1
	hspeed = 0.0
	vspeed = 0.0

	function run() {
		//Collision with player
		if(gvPlayer != 0) {
			if(hitTest(shape, gvPlayer.shape)) { //8 for player radius
				if(y > gvPlayer.y && vspeed < gvPlayer.vspeed) gethurt()
				else if(gvPlayer.rawin("anSlide")) {
					if(gvPlayer.anim == gvPlayer.anSlide) gethurt()
					else hurtplayer()
				}
				else hurtplayer()
			}
		}

		//Collision with fireball
		if(actor.rawin("Fireball")) foreach(i in actor["Fireball"]) {
			if(hitTest(shape, i.shape)) {
				hurtfire()
				deleteActor(i.id)
			}
		}
	}

	function gethurt() {} //Spiked enemies can just call hurtplayer() here
	function hurtplayer() { //Default player damage
		gvPlayer.vspeed = -4
		if(gvPlayer.x < x) gvPlayer.hspeed = -2
		else gvPlayer.hspeed = 2
		}
	function hurtfire() {} //If the object is hit by a fireball
	function _typeof() { return "Enemy" }
}

::Deathcap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0

	constructor(_x, _y) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 4, 6, 0)
	}

	function run() {
		base.run()

		if(!squish) {
			if(placeFree(x, y + 1)) vspeed += 0.1
			if(placeFree(x, y + vspeed)) y += vspeed
			else vspeed /= 2

			if(y > gvMap.h + 8) deleteActor(id)

			if(flip) {
				if(placeFree(x - 1, y)) x -= 1
				else if(placeFree(x - 2.0, y - 1.0)) {
					x -= 1.0
					y -= 0.5
				} else if(placeFree(x - 2.0, y - 2.0)) {
					x -= 1.0
					y -= 1.0
				} else flip = false
				/*
				There's a simpler way to do this in theory,
				but it doesn't work in practice.
				It should be this:

				else if(placeFree(x - 1.0, y - 1.0)) {
					x -= 1.0
					y -= 1.0
				}

				But for whatever reason, this prevents any
				movement over a slope that looks like \_.
				Instead, they just turn around when they reach
				the bottom of a slope facing right.

				This weird trick of checking twice ahead works,
				though. Credit to Admiral Spraker for giving me
				the idea. Another fine example of (/d/d/d).
				*/


				if(x <= 0) flip = false
			}
			else {
				if(placeFree(x + 1, y)) x += 1
				else if(placeFree(x + 2.0, y - 1.0)) {
					x += 1.0
					y -= 0.5
				} else if(placeFree(x + 2.0, y - 2.0)) {
					x += 1.0
					y -= 1.0
				} else flip = true

				if(x >= gvMap.w) flip = true
			}

			drawSpriteEx(sprDeathcap, wrap(getFrames() / 6, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		}
		else {
			squishTime += 0.05
			if(squishTime >= 1) deleteActor(id)
			drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		}

		shape.setPos(x, y)
		setDrawColor(0xff0000ff)
		if(debug) shape.draw()
	}

	function hurtplayer() {
		if(squish) return

		gvPlayer.vspeed = -4
		if(gvPlayer.x < x) gvPlayer.hspeed = -2
		else gvPlayer.hspeed = 2
	}

	function gethurt() {
		if(squish) return

		if(gvPlayer.rawin("anSlide")) {
			if(gvPlayer.anim == gvPlayer.anSlide) {
				local c = newActor(DeadNME, x, y)
				actor[c].sprite = sprDeathcap
				actor[c].vspeed = -abs(gvPlayer.hspeed * 1.5)
				actor[c].hspeed = (gvPlayer.hspeed / 4)
				actor[c].spin = (gvPlayer.hspeed * 4)
				actor[c].angle = 180
				deleteActor(id)
			}
			else if(keyDown(config.key.jump)) gvPlayer.vspeed = -8
			else gvPlayer.vspeed = -4
			if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
				gvPlayer.anim = gvPlayer.anJumpU
				gvPlayer.frame = gvPlayer.anJumpU[0]
			}
		}
		else if(keyDown(config.key.jump)) gvPlayer.vspeed = -8
		else gvPlayer.vspeed = -4
		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}

		squish = true
	}

	function hurtfire() {
		newActor(Poof, x, y)
		deleteActor(id)
	}

	function _typeof() { return "Deathcap" }
}

::PipeSnake <- class extends Enemy {
	ystart = 0
	timer = 60
	up = false
	flip = 1

	constructor(_x, _y) {
		base.constructor(_x, _y)
		ystart = y
		shape = Rec(x, y, 4, 12, 0)
		timer = randInt(60)
	}

	function run() {
		base.run()

		if(up && y > ystart - 24) y -= 2
		if(!up && y < ystart) y += 2

		timer--
		if(timer == 0) {
			up = !up
			timer = 60
		}

		shape.setPos(x, y + 16)
		if(flip == 1) drawSpriteEx(sprSnake, getFrames() / 8, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
		if(flip == -1) drawSpriteEx(sprSnake, getFrames() / 8, floor(x - camx), floor(y - camy) - 8, 0, 2, 1, 1, 1)
	}

	function gethurt() { hurtplayer() }

	function hurtfire() {
		newActor(Poof, x, y + 14)
		deleteActor(id)
	}

	function _typeof() { return "Snake" }
}

//Dead enemy effect for enemies that get sent flying,
//like when hit with a melee attack
::DeadNME <- class extends Actor {
	sprite = 0
	frame = 0
	hspeed = 0.0
	vspeed = 0.0
	angle = 0.0
	spin = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)
		vspeed = -6.0
	}

	function run() {
		vspeed += 0.5
		x += hspeed
		y += vspeed
		angle += spin
		if(y > gvMap.h + 32) deleteActor(id)
		drawSpriteEx(sprite, frame, floor(x - camx), floor(y - camy), angle, 0, 1, 1, 1)
	}
}