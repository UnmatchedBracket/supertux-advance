::drawBG <- 0
::drawBG2 <- 0
::gvHorizon <- 0
::gvParallaxMap <- 0
::gvLightBG <- false

::dbgNone <- function() {
	setDrawColor(0xff)
	drawRec(0, 0, screenW(), screenH(), true)
}

::dbgEcho <- function() {
	//drawImage(gvScreen, 0, 0)
	drawImage(gvPlayScreen, camxprev - camx, camyprev - camy)
	setDrawColor(0x20)
	drawRec(0, 0, screenW(), screenH(), true)
}

::dbgCave <- function() {
	gvLightBG = true
	for(local i = 0; i < 6; i++) {
		for(local j = 0; j < 6; j++) {
			drawSprite(bgIridia, 0, ((-camx / 8) % 100) + (i * 100), ((-camy / 8) % 56) + (j * 56))
		}
	}

	for(local i = 0; i < 4; i++) {
		for(local j = 0; j < 4; j++) {
			drawSprite(bgCaveHoles, 0, ((-camx / 4) % 400) + (i * 400), ((-camy / 4) % 392) + (j * 392))
		}
	}
}

::dbgCaveEarth <- function() {
	gvLightBG = true
	for(local i = 0; i < 6; i++) {
		for(local j = 0; j < 6; j++) {
			drawSprite(bgCaveEarth0, 0, ((-camx / 8) % 100) + (i * 100), j * 56)
		}
	}

	for(local i = 0; i < 4; i++) {
		for(local j = 0; j < 4; j++) {
			drawSprite(bgCaveEarth1, 0, ((-camx / 4) % 512) + (i * 512), 0)
		}
	}
}

::dbgCaveBlue <- function() {
	gvLightBG = true
	for(local i = 0; i < 6; i++) {
		for(local j = 0; j < 6; j++) {
			drawSprite(bgCaveBlue0, 0, ((-camx / 8) % 100) + (i * 100), j * 56)
		}
	}

	for(local i = 0; i < 4; i++) {
		for(local j = 0; j < 4; j++) {
			drawSprite(bgCaveBlue1, 0, ((-camx / 4) % 512) + (i * 512), 0)
		}
	}
}

::dbgForest <- function() {
	if(gvMap != 0) {
		for(local i = 0; i < 3; i++)
			drawSprite(bgWoodedMountain, 0, ((-camx / 16) % 640) + (i * 640), (screenH() / 2) - 120)
		for(local i = 0; i < 2; i++)
			drawSprite(bgForest2, 0, ((-camx / 8) % 755) + (i * 755), gvHorizon - camy - 300 - ((gvHorizon - (camy + gvScreenH)) / 1.25))
		for(local i = 0; i < 5; i++)
			drawSprite(bgForest0, 0, ((-camx / 2) % 128) + (i * 128), gvHorizon - camy - 180 - ((gvHorizon - (camy + gvScreenH)) / 2))
		for(local i = 0; i < 5; i++)
			drawSprite(bgForest1, 0, (-camx % 128) + (i * 128), gvHorizon - camy - 240)
	}
	else {
		for(local i = 0; i < 3; i++)
			drawSprite(bgWoodedMountain, 0, ((-camx / 8) % 640) + (i * 640), (screenH() / 2) - 120)
		for(local i = 0; i < 5; i++)
			drawSprite(bgForest0, 0, ((-camx / 2) % 128) + (i * 128), screenH() - camy - 180)
		for(local i = 0; i < 5; i++)
			drawSprite(bgForest1, 0, (-camx % 128) + (i * 128), screenH() - camy - 240)
	}
}

::dbgDeepForest <- function() {
	for(local i = 0; i < 3; i++)
		drawSprite(bgWoodedMountain, 0, ((-camx / 16) % 640) + (i * 640), (screenH() / 2) - 120)
	for(local i = 0; i < 4; i++)
		drawImage(bgDeepForest0, ((-camx / 12) % 160) + (i * 160), 0)
	for(local i = 0; i < 4; i++)
		drawImage(bgDeepForest1, ((-camx / 8) % 176) + (i * 176), 0)
	for(local i = 0; i < 4; i++)
		drawImage(bgDeepForest2, ((-camx / 4) % 384) + (i * 384), 0)
}

::dbgWoodedMountain <- function() {
	for(local i = 0; i < 3; i++)
		drawSprite(bgWoodedMountain, 0, ((-camx / 16) % 640) + (i * 640), (screenH() / 2) - 120)
}

::dbgAurora <- function() {
	for(local i = 0; i < 2; i++) drawSprite(bgAurora, 0, ((-camx / 16) % 720) + (i * 720), screenH() - 240)
}

::dbgPennyton <- function() {
	dbgAurora()
	for(local i = 0; i < 3; i++) drawSprite(bgPennyton1, 0, ((-camx / 4) % 480) + (i * 480), gvHorizon - camy - 96 - ((gvHorizon - (camy + gvScreenH)) / 1.25))
	if(drawWeather == dweSnow) {
		setDrawColor(0x60606040)
		drawRec(0, 0, screenW(), screenH(), true)
		for(local i = 0; i < (screenW() / 32) + 4; i++) {
			for(local j = 0; j < (screenH() / 32) + 4; j++) {
				drawSpriteEx(weSnow, 0, -(sin(getFrames().tofloat() / 32.0) * 16.0) + (i * 32) - (camx % 32) - 32, ((getFrames() / 2) % 32) + (j * 32) - 32 - (camy % 32), 0, 0, 0.5, 0.5, 1)
			}
		}
	}
	for(local i = 0; i < 3; i++) drawSprite(bgPennyton0, 0, ((-camx / 2) % 480) + (i * 480), gvHorizon - camy - 112 - ((gvHorizon - (camy + gvScreenH)) / 1.5))
}

::dbgAuroraNight <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraNight, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgIceForest <- function() {
	if(gvMap != 0) {
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest, 0, ((-camx / 16) % 640) + (i * 640), 0)
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest2, 0, ((-camx / 8) % 480) + (i * 480), gvHorizon - camy - 192)
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest1, 0, ((-camx / 4) % 640) + (i * 640), gvHorizon - camy - 256)
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest0, 0, ((-camx / 2) % 800) + (i * 800), gvHorizon - camy - 320)
	}
	else {
		for(local i = 0; i < 2; i++) drawSprite(bgIceForest, 0, ((-camx / 8) % 640) + (i * 640), (screenH() / 2) - 120)
		for(local i = 0; i < 4; i++) drawSprite(bgForest0, 0, ((-camx / 2) % 128) + (i * 128), screenH() - camy - 180)
		for(local i = 0; i < 4; i++) drawSprite(bgForest1, 0, (-camx % 128) + (i * 128), screenH() - camy - 180)
	}
}

::dbgSnowNight <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowNight, 0, ((-camx / 8) % 800) + (i * 800), (screenH() / 2) - 120)
	}
}

::dbgSnowPlain <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowPlain, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

::dbgRiverCity <- function() {
	for(local i = 0; i < 3; i++) {
		drawSprite(bgRiverCity, 0, ((-camx / 8) % 380) + (i * 380), (screenH() / 2) - 120)
	}
}

::dbgOcean <- function() {
	for(local i = 0; i < 2; i++) {
		for(local j = 0; j < 16; j++) {
			drawSprite(bgOcean, j, ((-camx / 32) % 480) + (i * 480), j * 8)
		}
	}

	for(local i = 0; i < 2; i++) {
		for(local j = 30; j >= 16; j--) {
			drawSprite(bgOcean, j, (((-camx) / fabs(31 - j)) * (j / 16.0) % 480) + (i * 480), j * 8)
		}
	}
}

::dbgOceanSunset <- function() {
	for(local i = 0; i < 2; i++) {
		for(local j = 0; j < 16; j++) {
			drawSprite(bgOceanSunset, j, ((-camx / 32) % 480) + (i * 480), j * 8)
		}
	}

	for(local i = 0; i < 2; i++) {
		for(local j = 30; j >= 16; j--) {
			drawSprite(bgOceanSunset, j, (((-camx) / fabs(31 - j)) * (j / 16.0) % 480) + (i * 480), j * 8)
		}
	}
}

::dbgOceanNight <- function() {
	dbgStarSky()

	for(local i = 0; i < 2; i++) {
		for(local j = 0; j < 16; j++) {
			drawSprite(bgOceanNight, j, ((-camx / 64) % 480) + (i * 480), j * 8)
		}
	}

	for(local i = 0; i < 2; i++) {
		for(local j = 30; j >= 16; j--) {
			drawSprite(bgOceanNight, j, (((-camx) / fabs(31 - j)) * (j / 16.0) % 480) + (i * 480), j * 8)
		}
	}
}

::dbgOceanMoving <- function() {
	dbgStarSky()

	for(local i = 0; i < 2; i++) {
		for(local j = 0; j < 16; j++) {
			drawSprite(bgOceanNight, j, (((-camx - getFrames()) / 64) % 480) + (i * 480), j * 8)
		}
	}

	for(local i = 0; i < 2; i++) {
		for(local j = 30; j >= 16; j--) {
			drawSprite(bgOceanNight, j, (((-camx - getFrames() * 4) / fabs(31 - j)) * (j / 16.0) % 480) + (i * 480), j * 8)
		}
	}
}

::dbgStarSky <- function() {
	for(local i = 0; i < 3; i++) {
		drawImage(bgStarSky, (i * 360), (screenH() / 2) - 120)
	}
	drawSprite(bgMoon, 0, gvScreenW - 128, 64)
}

::dbgUnderwater <- function() {
	gvLightBG = true
	drawSprite(bgUnderwater, 0, 0, (screenH() / 2) - 120)
}

::dbgCastle <- function() {
	drawSprite(bgCastle, 0, 0, (screenH() / 2) - 120)
	drawSprite(bgCastle, 0, 320, (screenH() / 2) - 120)
}

::dbgFortMagma <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFortMagma, 0, ((-camx / 8) % 960) + (i * 960), (screenH() / 2) - 120)
	}
}

::dbgTheatre <- function() {
	drawSprite(bgCharSel, 0, screenW() / 2, 0)
}

::dbgSwitchPalace <- function() {
	setDrawColor(0xff)
	drawRec(0, 0, screenW(), screenH(), true)
	for(local i = 0; i < 6; i++) drawSprite(bgSwitch1, 0, (-camx / 4 % 84) + (i * 84), 0)
	for(local i = 0; i < 4; i++) drawSprite(bgSwitch0, 0, (-camx / 2 % 168) + (i * 168), gvMap.h - 400 - camy / 2)
}

::dbgSunsetMountain <- function() {
	//drawImage(gvScreen, 0, 0)
	for(local i = 0; i < 2; i++) {
		drawImage(bgSunsetMountain, (i * 940) - (camx / 8.0), 0)
	}
}