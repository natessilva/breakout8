pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
	init_game()
end

function _update60()
	update_state()
end

function _draw()
	cls(1)
	draw_state()
end
-->8
-- ball
function update_ball()
	ball.x += ball.dx
	ball.y += ball.dy
	turn = false
	-- right
	if ball.x + ball.r >= 127 and ball.dx > 0 then
		ball.dx *= -1
		turn = true
	end
	-- left
	if ball.x - ball.r <= 0 and ball.dx < 0 then
		ball.dx *= -1
		turn = true
	end
	-- bottom
	-- this should lose a life!!
	if ball.y + ball.r >= 127 and ball.dy > 0 then
		state = 'end'
	end

	--collide with paddle
	local xo, yo = collide(ball, paddle)
	if xo and yo and ball.dy > 0 then
		if xo < yo then
			ball.dx *= -1
		else
			ball.dy *= -1
		end
		turn = true
	end
	--top
	if ball.y - ball.r <= 0 and ball.dy < 0 then
		ball.dy *= -1
		turn = true
	end

	-- bricks
	xo = nil
	yo = nil
	for b in all(bricks) do
		local bxo, byo = collide(ball, b)
		if bxo and byo then
			if not xo or bxo < xo then
				xo = bxo
			end
			if not yo or byo < yo then
				yo = byo
			end
			del(bricks, b)
			sfx(0)
		end
	end

	if xo and yo then
		if xo < yo then
			ball.dx *= -1
		else
			ball.dy *= -1
		end
		turn = true
	end

	if turn then
		ball.x = flr(ball.x) + .5
		ball.y = flr(ball.y) + .5
	end
end

function draw_ball()
	circfill(ball.x, ball.y, ball.r, 7)
end

-->8
--paddle
function update_paddle()
	if btn(⬅️) then
		paddle.x -= 1.75
		if state == 'start' then
			ball.dx = abs(ball.dx) * -1
		end
	elseif btn(➡️) then
		paddle.x += 1.75
		if state == 'start' then
			ball.dx = abs(ball.dx)
		end
	end
	paddle.x = mid(0, paddle.x, 127 - paddle.w)
end

function draw_paddle()
	rectfill(paddle.x, paddle.y, paddle.x + paddle.w, paddle.y + 3, 6)
end
-->8
--utilities
function collide(ball, r)
	local ball_left = ball.x - ball.r
	local ball_right = ball.x + ball.r
	local ball_top = ball.y - ball.r
	local ball_bottom = ball.y + ball.r

	local r_left = r.x
	local r_right = r.x + r.w
	local r_top = r.y
	local r_bottom = r.y + r.h

	if ball_left < r_right
			and r_left < ball_right
			and ball_top < r_bottom
			and r_top < ball_bottom then
		local x_overlap = min(r_right - ball_left, ball_right - r_left)
		local y_overlap = min(r_bottom - ball_top, ball_bottom - r_top)
		return x_overlap, y_overlap
	end
	return nil, nil
end

function center_text(text, y, c)
	width = #text * 2
	print(text, 64 - width, y, c)
end
-->8
--game states/modes

function init_game()
	spd = 1.2
	ball = {
		x = 57.5,
		y = 117.5,
		dy = -.7 * spd,
		dx = .7 * spd,
		r = 2
	}
	paddle = {
		x = 50,
		y = 120,
		h = 8,
		w = 15
	}
	bricks = {}
	level1_bricks()
	state = 'start'
end

function update_state()
	if state == 'start' then
		update_start()
	elseif state == 'game' then
		update_game()
	elseif state == 'end' then
		update_end()
	end
end

function update_start()
	update_paddle()
	ball.x = flr(paddle.x + paddle.w / 2) + .5
	if btnp(❎) or btnp(🅾️) then
		state = 'game'
	end
end

function update_game()
	update_paddle()
	update_ball()
end

function update_end()
	if btnp(❎) or btnp(🅾️) then
		init_game()
		state = 'start'
	end
end

function draw_state()
	if state == 'start' then
		draw_start()
	elseif state == 'game' then
		draw_game()
	elseif state == 'end' then
		draw_end()
	end
end

function draw_start()
	cls(1)
	center_text("press button to start", 60, 7)
	draw_paddle()
	draw_bricks()
	draw_ball()
end

function draw_game()
	draw_paddle()
	draw_bricks()
	draw_ball()
end

function draw_end()
	cls(2)
	center_text("press button to re-play", 45, 7)
	center_text("u died", 75, 8)
end
-->8
--bricks

function level1_bricks()
	--9x5 bricks

	-- bricks are 10px x 5px

	-- 1px gutter in between bricks

	local x = 15
	local y = 15

	for i = 0, 8 do
		for j = 0, 4 do
			add(
				bricks, {
					x = x + i * 11,
					y = y + j * 6,
					w = 9,
					h = 4
				}
			)
		end
	end
end

function draw_bricks()
	for b in all(bricks) do
		rectfill(b.x, b.y, b.x + b.w, b.y + b.h, 9)
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000090300a0400c040000002b0700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
