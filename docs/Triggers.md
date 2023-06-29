# Triggers

In Godot's coordinate system, the y axis points downwards, so take this into account when using move triggers.

## In the inspector:

* THE TARGET PATH: the target path is the path to your group. If your trigger is not as the same level in the hierarchy as your group, you'll need to:
  put two dots in front of the path for each level of the hierarchy you're going up,
  or put the groups' names and slashes for each level you're going down.
  This works like a file path in your file explorer.
  There are special, case sensitive, target paths:
  
  * PLAYERCAMERA: for the camera triggers.
  
  * PLAYER: needed for the arrow trigger, reverse trigger, Hide and Show player, and Alpha player.
  
  * GROUND: to change the ground's color and alpha.
  
  * LINE: to change the ground line's color and alpha.
  
  * BACKGROUND: same as GROUND.
  
  * SONG: for the song trigger.

* PROPERTY: this is the property that'll be tweened by the trigger. You can find a full list of them in the game's documentation in the GitHub repo.

* DURATION: This one is pretty self-explanatory. If it is set to`0.0` (default value) the action is instant.
- VALUE: the end value of the trigger. There are multiple types for it, notably: Vector2, for a set of coordinates, Int, for the reverse, Bool, for the toggle trigger, and PackedVector2Array, for the random trigger's group probabilities.
* RELATIVE: this property is useful for move, rotate, and scale since it decides wether the target value should be added to the start value or replace it.
  Here's an example using a move trigger:
  relative: Vector2(30, 10): moves 2 pixels to the right and 1 pixel down.
  normal: Vector2(61, 61): moves to coordinates 61, 61.

* EASING TYPE AND CURVE: the shape of the (imaginary) Bézier curve representing the easing of the action. The types are ease in, ease out, ease in-out, ease out-in, and constant. This last one modifies the property at the end of the duration and does so instantly. Here is a list containing all the possible curves:
  
  <img src="https://raw.githubusercontent.com/urodelagames/urodelagames.github.io/master/photos/tween_cheatsheet.png" title="" alt="easing curves" width="749">

## Tweened Properties

Here is a list of all the useful properties for triggers:

* General Properties
  
  * `position`: move triggers. Requires a `Vector2` or a `string`. Use a string to indicate a move target's position with an object. The object can be the player (using the `PLAYER` path). If the trigger is `relative`, it will act like a follow player x/y ; if it isn't, it will act like a `follow` trigger.
  
  * `rotation`: rotate trigger. Requires a `float` or a `string`. Use a string to copy the player's rotation (using the `PLAYER` path). If the trigger is `relative`, it will set its rotation to the player's with the rotation it had before the trigger ; if it isn't, it will just copy the icon's rotation.
  
  * `scale`: scale trigger. Requires a `Vector2` (for the scale x and scale y).
  
  * `skew`: scale trigger as well. Requires a float. Represents the skew angle.
  
  * `modulate`: color, pulse, and alpha triggers: Requires a `Color`. Modify the alpha of the `Color` to use it as an alpha trigger.
  
  * `toggle`: toggle trigger: Requires a `bool`. If it is activated, the group is toggled on. The opposite is true as well.
  
  * `random`: random and advanced random triggers. Requires a `bool` in the first element of `Value` and a `PackedVector2Array` in the second element. The first element determines if the randmoly chosen group is toggled on or off. Each `Vector2` of the `PackedVector2Array` represents a group, in the same order than in the editor. The `x` and `y` components represent the start and end of the probability pool. The random trigger generates a random number between 0 and 100 and if the number is between `x` and `y`, the group is toggled.

* `PLAYER`
  
  * `_x_direction`: reverse trigger. Requires an `int`. Possible values:
    
    * `1`: the player goes to the right. Non-reverse.
    
    * `-1`: the player goes to the left. Reverse.
  
  * `arrow_trigger_direction`: arrow trigger/rotate gameplay. Requires a `Vector2`. Possible values:
    
    * `Vector2(0.0, -1.0)` in code or `x:0.0, y:-1.0` in the inspector: horizontal gameplay.
    - `Vector2(-1.0, 0.0)` in code or `x:-1.0, y:0.0` in the inspector: vertical gameplay.
  - `modulate`: for the player alpha and player pulse triggers. Same as general.
  
  - `position`: for the teleport trigger. Same as general.
- `PLAYERCAMERA`
  
  - `zoom`: camera zoom trigger. Requires a `Vector2`. Represented as `zoom x` and `zoom y`. The default zoom is `1.25, 1.25`.
  - `static`: camera static trigger. Requires a `string`. Contains the object or group whose coordinates will be used for the static. I recommend using a Position2D node as the static objects. The second element of Value requires a `Vector2` and sets the static trigger's active axis (e.g. `x:1,y:0` makes it x-only). You can exit static using the `exitStatic` property in the inspector, which renders the Values useless.
  - `offset`: camera offset trigger. Requires a `Vector2`. The base `y` offset is -225 px so make sure to set the `y` component of the Vector2 to this if you only want to do horizontal offset.
  - `rotation`: camera rotate trigger. Same as general.
* `BACKGROUND`, `GROUND` and `LINE`:
  
  * `modulate`: color and alpha. Same as general.

* `SONG`
  
  * `seek`: song trigger. Requires a `float`. The target moment in the song in seconds.
