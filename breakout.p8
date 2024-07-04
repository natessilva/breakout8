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
	cls(5)
	draw_state()
end
-->8
-- ball
function update_ball()
	old_ball={
		x=ball.x,
		y=ball.y,
		r=ball.r
	}
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
	local ocx,ocy=collide(old_ball,paddle)
	local xo, yo = collide(ball, paddle)
	if not ocx
	 and not ocy
	 and xo
	 and yo then
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
		local obxo,obyo = collide(old_ball,b)
		local bxo, byo = collide(ball, b)
		if not obxo and not obyo and bxo and byo then
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
	local frame=flr(t/5) % 4
	if state == 'start' then
		frame=0
	end
 sspr(34+frame*8,2,4,4,ball.x-ball.r,ball.y-ball.r)
--	circfill(ball.x, ball.y, ball.r, 7)
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
	paddle.x = mid(0, paddle.x, 128 - paddle.w)
end

function draw_paddle()
	sspr(10,0,paddle.w,paddle.h,paddle.x,paddle.y)
--	rectfill(paddle.x, paddle.y, paddle.x + paddle.w, paddle.y + 3, 6)
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
	spd = 1.5
	ball = {
		x = 57.5,
		y = 118.5,
		dy = -.7 * spd,
		dx = .7 * spd,
		r = 2
	}
	paddle = {
		x = 50,
		y = 120,
		h = 8,
		w = 19
	}
	bricks = {}
	level1_bricks()
	state = 'start'
	t=0
end

function update_state()
	t+=1
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
	 sspr(83,1,10,5,b.x,b.y)
--		rectfill(b.x, b.y, b.x + b.w, b.y + b.h, 9)
	end
end

__gfx__
00000000000011101111111011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000001bbb1bbbbbbb1bbb10000000000000000000000000000000000000000000000000000000011111111000000000000000000000000000000000000
007007000013bb32b3bb33b2b3b31000000640000006400000046000000440000000000000000000000164444446100000000000000000000000000000000000
0007700000123b423433443234321000004446000044440000444400006446000000000000000000000144464544100000000000000000000000000000000000
00077000000123212222222122210000004444000064460000644400004444000000000000000000000144544444100000000000000000000000000000000000
00700700000011101111111011100000000640000004400000046000000460000000000000000000000011111111000000000000000000000000000000000000
__sfx__
0001000000000090100a02011020000002b0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
