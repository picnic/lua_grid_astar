
function dist(ax, ay, bx, by)
	-- distance between a and b assuming there is no diagonal movement
	return math.abs(bx - ax) + math.abs(by - ay)
end

function min_fscore(open, fscore)
	-- find the cell having the smallest fscore
	local key, min
	for k, v in pairs(open) do
		if min == nil or fscore[k] < min then
			key = k
			min = fscore[k]
		end
	end
	return key
end

function find_neighbors(x, y, grid, width, height)
	-- find all free cells next to the (x, y) cell
	local neighbors = {}
	-- left cell
	if x > 0 and grid(x-1, y) then
		table.insert(neighbors, vton(x-1, y, width))
	end
	-- top cell
	if y > 0 and grid(x, y-1) then
		table.insert(neighbors, vton(x, y-1, width))
	end
	-- right cell
	if x < width-1 and grid(x+1, y) then
		table.insert(neighbors, vton(x+1, y, width))
	end
	-- bottom cell
	if y < height-1 and grid(x, y+1) then
		table.insert(neighbors, vton(x, y+1, width))
	end
	return neighbors
end

function vton(x, y, width)
	-- convert a vector to a number
	return x + y * width
end

function ntov(n, width)
	-- convert a number to a vector
	return n%width, math.floor(n/width)
end

function a_star(startx, starty, goalx, goaly, grid, width, height)
	-- the A* algorithm as described here:
	-- https://en.wikipedia.org/wiki/A*_search_algorithm
 	local start = vton(startx, starty, width)
 	local goal = vton(goalx, goaly, width)
 	if start == goal then return nil end
	local closed = {}
	local open = {[start] = true}
	local from = {}
	local gscore = {[start]=0}
	local fscore = {[start]=dist(startx, starty, goalx, goaly)}
	while next(open) ~= nil do -- while open not empty
		local current = min_fscore(open, fscore)
		local currentx, currenty = ntov(current, width)
		if current == goal then
			return from
		end
		open[current] = nil
		closed[current] = true

		local neighbors = find_neighbors(currentx, currenty, grid, width, height)
		for i, neighbor in pairs(neighbors) do
			if not closed[neighbor] then
				local neighborx, neighbory = ntov(neighbor, width)
				open[neighbor] = true
				local t_gscore = gscore[current] + 1
				from[neighbor] = current
				gscore[neighbor] = t_gscore
				fscore[neighbor] = gscore[neighbor] + dist(neighborx, neighbory, goalx, goaly)
			end
		end
	end
	return nil -- no way found
end

function print_xy(n, width)
	local x, y = ntov(n, width)
	print("x="..x.." y="..y)
end

function print_path(result, x, y, width)
	-- print the found path, from goal to start
	if result == nil then return print("No way found") end
	local current = vton(x, y, width)
	repeat
		print_xy(current, width)
		current = result[current]
	until current == nil
end

function first_move(startx, starty, goalx, goaly, grid, width, height)
	-- find the first move
	local result = a_star(startx, starty, goalx, goaly, grid, width, height)
	if result == nil then return nil end
	local current = vton(goalx, goaly, width)
	local start = vton(startx, starty, width)
	while result[current] ~= start do
		current = result[current]
	end
	return ntov(current, width)
end

function grid(x, y)
	-- this function should be customized
	-- return true when (x, y) is a free cell and false for walls
	if x == 1 and y ~= 4 then return false end
	if x == 3 and y ~= 0 and y ~= 2 then return false end
	return true
end

res = a_star(0, 0, 4, 4, grid, 5, 5)
print_path(res, 4, 4, 5)
print(first_move(0, 0, 4, 4, grid, 5, 5))
