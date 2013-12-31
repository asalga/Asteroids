# Can't rely on Processing's export since it
# uses an old version of Processing.js which has bugs

build: minify

minify:
	cat Asteroid.pde BoundingCircle.pde Bullet.pde Ship.pde SoundManager.js Asteroids.pde Sprite.pde Starfield.pde Timer.pde Utils.pde ParticleSystem.pde > build/build.js
	
