# lua_grid_astar
Use the `astar.lua` file for the Lua 5.3 version and the `astar_p8.lua` for the PICO-8 compatible version. The algorithm in both files asumes that you are using grid based level (with x and y coordinates).

You must provide a `grid` function which returns `true` when the cell at `x, y` is free and `false` when it is a wall. The `a_star` function returns a table that allow you to build the complete patch from start to goal (or `nil` when no path found) whereas the `next_move` function simply returns the coordinates of the next cell (or `nil, nil` when no path found).

The Lua 5.3 version (`astar.lua`) contains an example of how to use the `a_star` and the `next_move` functions.
