function dist(ax, ay, bx, by)
	return abs(bx - ax) + abs(by - ay)
end

function min_fscore(open, fscore)
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
	local neighbors = {}
	if x > 0 and grid(x-1, y) then
		add(neighbors, vton(x-1, y, width))
	end
	if y > 0 and grid(x, y-1) then
		add(neighbors, vton(x, y-1, width))
	end
	if x < width-1 and grid(x+1, y) then
		add(neighbors, vton(x+1, y, width))
	end
	if y < height-1 and grid(x, y+1) then
		add(neighbors, vton(x, y+1, width))
	end
	return neighbors
end

function vton(x, y, width)
	return x + y * width
end

function ntov(n, width)
	return n%width, flr(n/width)
end

function is_empty(t)
 for _,_ in pairs(t) do
  return false
 end
 return true
end

function a_star(startx, starty, goalx, goaly, grid, width, height)
 local	start = vton(startx, starty, width)
 local	goal = vton(goalx, goaly, width)
 if start == goal then return nil end
	local closed = {}
	local open = {[start] = true}
	local from = {}
	local gscore = {[start]=0}
	local fscore = {[start]=dist(startx, starty, goalx, goaly)}
	while not is_empty(open) do
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
	return nil
end

function first_move(startx, starty, goalx, goaly, grid, width, height)
	local result = a_star(startx, starty, goalx, goaly, grid, width, height)
	if result == nil then return nil, nil end
	local current = vton(goalx, goaly, width)
	local start = vton(startx, starty, width)
	while result[current] ~= start do
		current = result[current]
	end
	return ntov(current, width)
end
