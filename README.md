# DDJ_Boombs
Very nice bomb game (BOOM)

Boombs is a platform/action/puzzle game.

**Bugs:**
1. PLAYER:
* Can't stand on top of crates
* jumping fails sometimes (probably because to jump, player needs to be on floor, and the floor tracking is not very good??)
* Solutions:
    1. KinematicBody2D interacts wierdly with RigidBodoy2D. Might consider changing the Palayer scene to RigidBodoy2D
    2. Do the interactions manually.

**Need improvement:**
1. Bomb throwing recoil should be less dinamic. Big throws propel the player too much, and small throws too little

**Implemented features:**
1. Player can move to the left and to the right (jump for now)
2. Player throws bombs
3. Click on bombs to detonate them
4. Bombs have a timer until automatic detonation
5. Throwing a bomb gives a recoil force to the player proportional to thorw force
6. A bomb explosion applies a force to every physics objects within its radius.
7. Any bomb within the explosion radius of another bomb will explode as well.

**Features to add:**
1. BOMBS:
* Player can only throw two bombs. One for each mouse button
* Instead of needing to click on the bomb for it to explode. A second click on the mouse button of the bomb detonates it.
2. Enemies
3. An actual plot
4. Goal
