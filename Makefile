# Can't rely on Processing's export since it
# uses an old version of Processing.js which has bugs

build: minify

minify:
	cat RetroPanel.pde RetroFont.pde RetroLabel.pde RetroUtils.js RetroWidget.pde \
		Asteroid.pde BoundingCircle.pde Bullet.pde Ship.pde SoundManager.js Asteroids.pde \
		Sprite.pde Starfield.pde Timer.pde Utils.pde ParticleSystem.pde Keyboard.pde > build/build.js
	
