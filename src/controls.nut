::autocon <- { //Has nothing to do with Transformers
	up = false
	down = false
	left = false
	right = false
}

::getcon <- function(control, state) {
	local keyfunc = 0
	local joyfunc = 0
	local hatfunc = 0

	switch(state) {
		case "press":
			keyfunc = keyPress
			joyfunc = joyButtonPress
			hatfunc = joyHatPress
			break
		case "release":
			keyfunc = keyRelease
			joyfunc = joyButtonRelease
			hatfunc = joyHatRelease
			break
		case "hold":
			keyfunc = keyDown
			joyfunc = joyButtonDown
			hatfunc = joyHatDown
			break
		default:
			return false
			break
	}

	switch(control) {
		case "up":
			if(keyfunc(config.key.up) || hatfunc(0, js_up) || (state == "hold" && joyY(0) < -js_max / 10) || autocon.up) return true
			if(state == "press" && joyAxisPress(0, 1, js_max / 20) == -1) return true
			if(state == "release" && joyAxisRelease(0, 1, js_max / 20) == -1) return true
			break
		case "down":
			if(keyfunc(config.key.down) || hatfunc(0, js_down) || (state == "hold" && joyY(0) > js_max / 10) || autocon.down) return true
			if(state == "press" && joyAxisPress(0, 1, js_max / 20) == 1) return true
			if(state == "release" && joyAxisRelease(0, 1, js_max / 20) == 1) return true
			break
		case "left":
			if(keyfunc(config.key.left) || hatfunc(0, js_left) || (state == "hold" && joyX(0) < -js_max / 10) || autocon.left) return true
			if(state == "press" && joyAxisPress(0, 0, js_max / 20) == -1) return true
			if(state == "release" && joyAxisRelease(0, 0, js_max / 20) == -1) return true
			break
		case "right":
			if(keyfunc(config.key.right) || hatfunc(0, js_right) || (state == "hold" && joyX(0) > js_max / 10) || autocon.right) return true
			if(state == "press" && joyAxisPress(0, 0, js_max / 20) == 1) return true
			if(state == "release" && joyAxisRelease(0, 0, js_max / 20) == 1) return true
			break
		case "jump":
			if(keyfunc(config.key.jump) || joyfunc(0, config.joy.jump)) return true
			break
		case "shoot":
			if(keyfunc(config.key.shoot) || joyfunc(0, config.joy.shoot)) return true
			break
		case "run":
			if(keyfunc(config.key.run) || joyfunc(0, config.joy.run)) return true
			break
		case "sneak":
			if(keyfunc(config.key.sneak) || joyfunc(0, config.joy.sneak)) return true
			break
		case "pause":
			if(keyfunc(config.key.pause) || joyfunc(0, config.joy.pause)) return true
			break
		case "swap":
			if(keyfunc(config.key.swap) || joyfunc(0, config.joy.swap)) return true
			break
		case "accept":
			if(keyfunc(config.key.accept) || joyfunc(0, config.joy.accept)) return true
			break
		case "leftPeek":
			if(keyfunc(config.key.leftPeek) || joyfunc(0, config.joy.leftPeek)) return true
			break
		case "rightPeek":
			if(keyfunc(config.key.rightPeek) || joyfunc(0, config.joy.rightPeek)) return true
			break
		case "downPeek":
			if(keyfunc(config.key.downPeek) || joyfunc(0, config.joy.downPeek)) return true
			break
		case "upPeek":
			if(keyfunc(config.key.upPeek) || joyfunc(0, config.joy.upPeek)) return true
			break
	}

	return false
}

::rebindKeys <- function() {
	resetDrawTarget()
	local done = false
	local keystep = 0

	update()

	while(!done) {
		drawBG()

		local message = gvLangObj["controls-menu"]["press-key-for"] + " "
		switch(keystep) {
			case 0:
				message += gvLangObj["controls-menu"]["up"]
				if(anyKeyPress() != -1) {
					config.key.up = anyKeyPress()
					keystep++
				}
				break
			case 1:
				message += gvLangObj["controls-menu"]["down"]
				if(anyKeyPress() != -1) {
					config.key.down = anyKeyPress()
					keystep++
				}
				break
			case 2:
				message += gvLangObj["controls-menu"]["left"]
				if(anyKeyPress() != -1) {
					config.key.left = anyKeyPress()
					keystep++
				}
				break
			case 3:
				message += gvLangObj["controls-menu"]["right"]
				if(anyKeyPress() != -1) {
					config.key.right = anyKeyPress()
					keystep++
				}
				break
			case 4:
				message += gvLangObj["controls-menu"]["jump"]
				if(anyKeyPress() != -1) {
					config.key.jump = anyKeyPress()
					keystep++
				}
				break
			case 5:
				message += gvLangObj["controls-menu"]["shoot"]
				if(anyKeyPress() != -1) {
					config.key.shoot = anyKeyPress()
					keystep++
				}
				break
			case 6:
				message += gvLangObj["controls-menu"]["run"]
				if(anyKeyPress() != -1) {
					config.key.run = anyKeyPress()
					keystep++
				}
				break
			case 7:
				message += gvLangObj["controls-menu"]["sneak"]
				if(anyKeyPress() != -1) {
					config.key.sneak = anyKeyPress()
					keystep++
				}
				break
			case 8:
				message += gvLangObj["controls-menu"]["pause"]
				if(anyKeyPress() != -1) {
					config.key.pause = anyKeyPress()
					keystep++
				}
				break
			case 9:
				message += gvLangObj["controls-menu"]["item-swap"]
				if(anyKeyPress() != -1) {
					config.key.swap = anyKeyPress()
					keystep++
				}
				break
			case 10:
				message += gvLangObj["controls-menu"]["menu-accept"]
				if(anyKeyPress() != -1) {
					config.key.accept = anyKeyPress()
					keystep++
				}
				break
			case 11:
				message += gvLangObj["controls-menu"]["cam-left-peek"]
				if(anyKeyPress() != -1) {
					config.key.leftPeek = anyKeyPress()
					keystep++
				}
				break
			case 12:
				message += gvLangObj["controls-menu"]["cam-right-peek"]
				if(anyKeyPress() != -1) {
					config.key.rightPeek = anyKeyPress()
					keystep++
				}
				break
			case 13:
				message += gvLangObj["controls-menu"]["cam-down-peek"]
				if(anyKeyPress() != -1) {
					config.key.downPeek = anyKeyPress()
					keystep++
				}
				break
			case 14:
				message += gvLangObj["controls-menu"]["cam-up-peek"]
				if(anyKeyPress() != -1) {
					config.key.upPeek = anyKeyPress()
					keystep++
				}
				break
			default:
				done = true
				break
		}
		message += "..."

		setDrawColor(0x00000080)
		drawRec(0, 0, 320, 24, true)
		drawText(font, 8, 8, message)
		update()
	}

	fileWrite("config.json", jsonWrite(config))
}

::rebindGamepad <- function() {
	resetDrawTarget()
	local done = false
	local joystep = 4

	update()

	while(!done) {
		drawBG()

		local message = gvLangObj["controls-menu"]["press-button-for"] + " "
		switch(joystep) {
			case 4:
				message += gvLangObj["controls-menu"]["jump"]
				if(anyJoyPress(0) != -1) {
					config.joy.jump = anyJoyPress(0)
					joystep++
				}
				if(getcon("pause", "press")) done = true;
				break
			case 5:
				message += gvLangObj["controls-menu"]["shoot"]
				if(anyJoyPress(0) != -1) {
					config.joy.shoot = anyJoyPress(0)
					joystep++
				}
				break
			case 6:
				message += gvLangObj["controls-menu"]["run"]
				if(anyJoyPress(0) != -1) {
					config.joy.run = anyJoyPress(0)
					joystep++
				}
				break
			case 7:
				message += gvLangObj["controls-menu"]["sneak"]
				if(anyJoyPress(0) != -1) {
					config.joy.sneak = anyJoyPress(0)
					joystep++
				}
				break
			case 8:
				message += gvLangObj["controls-menu"]["pause"]
				if(anyJoyPress(0) != -1) {
					config.joy.pause = anyJoyPress(0)
					joystep++
				}
				break
			case 9:
				message += gvLangObj["controls-menu"]["item-swap"]
				if(anyJoyPress(0) != -1) {
					config.joy.swap = anyJoyPress(0)
					joystep++
				}
				break
			case 10:
				message += gvLangObj["controls-menu"]["menu-accept"]
				if(anyJoyPress(0) != -1) {
					config.joy.accept = anyJoyPress(0)
					joystep++
				}
				break
			case 11:
				message += gvLangObj["controls-menu"]["cam-left-peek"]
				if(anyJoyPress(0) != -1) {
					config.joy.leftPeek = anyJoyPress(0)
					joystep++
				}
				break
			case 12:
				message += gvLangObj["controls-menu"]["cam-right-peek"]
				if(anyJoyPress(0) != -1) {
					config.joy.rightPeek = anyJoyPress(0)
					joystep++
				}
				break
			case 13:
				message += gvLangObj["controls-menu"]["cam-down-peek"]
				if(anyJoyPress(0) != -1) {
					config.joy.downPeek = anyJoyPress(0)
					joystep++
				}
				break
			case 14:
				message += gvLangObj["controls-menu"]["cam-up-peek"]
				if(anyJoyPress(0) != -1) {
					config.joy.upPeek = anyJoyPress(0)
					joystep++
				}
				break
			default:
				done = true
				break
		}
		message += "..."

		setDrawColor(0x00000080)
		drawRec(0, 0, 320, 24, true)
		drawText(font, 8, 8, message)
		update()
	}

	fileWrite("config.json", jsonWrite(config))
}
