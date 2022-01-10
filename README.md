# DDJ_Boombs
Very nice bomb game (BOOM)

Boombs is a action/puzzle/platform game.

Bugs:
	PLAYER:
		- Can't stand on top of crates
		- jumping fails sometimes (probably because to jump, player needs to be on floor, and the floor tracking is not very good??)
		Solutions:
			1. KinematicBody2D interacts wierdly with RigidBodoy2D. Might consider changing the Palayer scene to RigidBodoy2D
			2. Do the interactions manually.

Need improvement:
	- Bomb throwing recoil should be less dinamic. Big throws propel the player too much, and small throws too little

Implemented features:
	

Features to add:
	BOMBS:
		- Player can only throw two bombs. One for each mouse button
		- Instead of needing to click on the bomb for it to explode. A second click on the mouse button of the bomb detonates it.
	
	- Enemies
	- Plot
	- Goal
