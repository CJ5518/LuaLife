# LuaLife
Game of life but it's sort of in Lua and Love2d

The actual core game of life is in [LuaLifeC](https://github.com/CJ5518/LuaLifeC) which provides massive performance gains. Lua is fast, sure, but not as fast as C.

# Usage
The project runs on [Love2D.](https://love2d.org/)

Simply build LuaLifeC and place the library in the local folder of the cloned repo so that this program can find it, then run `love .` to run the demo mode.

I was going to make a command line argument interface to run specific profiles but never got around to it.
