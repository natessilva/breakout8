pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
	init_paddle()
	mode_upd = {
		start = upd_start,
		game = upd_game,
		over = upd_over
	}
	mode_draw = {
		start = draw_start,
		game = draw_game,
		over = draw_over
	}
	init_game()
end

function _update60()
	mode_upd[mode]()
end

function _draw()
	mode_draw[mode]()
end
-->8
--core
function update(o)
	o.x += o.dx
	o.y += o.dy
end

function draw(o)
	sspr(
		o.sx,
		o.sy,
		o.w,
		o.h,
		o.x,
		o.y
	)
end

-- checks if a will collide
-- with b after movement
function collide(a, b, dx, dy)
	return a.x + dx < b.x + b.w
			and b.x < a.x + dx + a.w
			and a.y + dy < b.y + b.h
			and b.y < a.y + dy + a.h
end

function center_text(t, y, c)
	print(t, 64 - #t * 2, y, c)
end
-->8
--ball
function spawn_ball()
	add(
		balls, {
			sx = 34,
			sy = 2,
			w = 4,
			h = 4,
			x = paddle.x + paddle.w / 2 - 2,
			y = paddle.y - 4,
			dx = 1,
			dy = -1
		}
	)
end

function update_ball(ball)
	update(ball)
	-- wall boundaries
	if ball.x <= 0 or ball.x >= 128 - ball.w then
		ball.dx *= -1
		sfx(0)
	end
	if ball.y <= 0 then
		ball.dy *= -1
		sfx(0)
	end

	-- paddle
	if not collide(
		ball,
		paddle,
		0,
		0
	)
			and collide(
		ball,
		paddle,
		0,
		ball.dy
	) then
		ball.dy *= -1
		sfx(0)
	end

	--bricks
	for b in all(bricks) do
		if collide(ball, b, 0, ball.dy) then
			ball.dy *= -1
			del(bricks, b)
			sfx(0)
		elseif collide(ball, b, ball.dx, 0) then
			ball.dx *= -1
			del(bricks, b)
			sfx(0)
		end
	end

	if ball.y > 128 then
		del(balls, ball)
		if #balls == 0 then
			mode = 'over'
		end
	end
end
-->8
--paddle
function init_paddle()
	paddle = {
		sx = 11,
		sy = 0,
		w = 18,
		h = 6,
		x = 10,
		y = 100,
		dx = 0,
		dy = 0
	}
end

function update_paddle()
	if btn(⬅️) then
		paddle.dx -= 0.35
	elseif btn(➡️) then
		paddle.dx += 0.35
	end
	paddle.dx *= .8
	update(paddle)
	paddle.x = mid(0, paddle.x, 128 - paddle.w)
end
-->8
--bricks
function init_bricks()
	for i = 0, 9 do
		for j = 0, 3 do
			add(
				bricks, {
					sx = 83,
					sy = 1,
					w = 10,
					h = 5,
					x = 14 + i * 10,
					y = 18 + j * 5
				}
			)
		end
	end
end
-->8
--modes
function init_game()
	balls = {}
	spawn_ball()
	bricks = {}
	init_bricks()
	mode = 'start'
end

function upd_start()
	update_paddle()

	balls[1].x = paddle.x + paddle.w / 2 - balls[1].w / 2
	if btnp(❎) or btnp(🅾️) then
		mode = 'game'
	end
end

function draw_start()
	draw_game()
	center_text("press amy button to start", 60, 7)
end

function upd_game()
	foreach(balls, update_ball)
	update_paddle()
end

function draw_game()
	cls(5)
	draw(paddle)
	foreach(bricks, draw)
	foreach(balls, draw)
end

function upd_over()
	if btnp(❎) or btnp(🅾️) then
		init_game()
	end
end

function draw_over()
	cls(2)
	center_text("game over", 60, 7)
	center_text("press any key to retry", 67, 7)
end

__gfx__
00000000000001101111111011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000001bb1bbbbbbb1bbb10000000000000000000000000000000000000000000000000000000011111111000000000000000000000000000000000000
0070070000013b32b3bb33b2b3b31000000640000006400000046000000440000000000000000000000164444446100000000000000000000000000000000000
0007700000012b423433443234321000004446000044440000444400006446000000000000000000000144464544100000000000000000000000000000000000
00077000000013212222222122210000004444000064460000644400004444000000000000000000000144544444100000000000000000000000000000000000
00700700000001101111111011100000000640000004400000046000000460000000000000000000000011111111000000000000000000000000000000000000
__sfx__
0001000000000090100a02011020000002b0400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
