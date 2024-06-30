pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
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
		w = 15
	}
end

function _update60()
	update_paddle()
	update_ball()
end

function _draw()
	cls(2)
	draw_paddle()
	draw_ball()
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
		--	 ball.dy*=-1
		--	 turn=true
	end

	--collide with paddle
	if rect_collide(
		ball.x-ball.r,
		ball.y-ball.r,
		ball.r*2,
		ball.r*2,
		paddle.x,
		120,
		paddle.w,
		4
	) then
		ball.dy *= -1
		turn = true
	end
	--top
	if ball.y - ball.r <= 0 and ball.dy < 0 then
		ball.dy *= -1
		turn = true
	end
	if turn then
		ball.x = flr(ball.x) + .5
		ball.y = flr(ball.y) + .5
	end
end

function draw_ball()
	circfill(ball.x, ball.y, ball.r)
end

-->8
--paddle
function update_paddle()
	if btn(⬅️) then
		paddle.x -= 1.75
	elseif btn(➡️) then
		paddle.x += 1.75
	end
	paddle.x = mid(0, paddle.x, 127 - paddle.w)
end

function draw_paddle()
	rectfill(paddle.x, 120, paddle.x + paddle.w, 123)
end
-->8
--utilities
function rect_collide(x1,y1,w1,h1,x2,y2,w2,h2)
	print(y2)
	return x1 < x2 + w2
			and x2 < x1 + w1
			and y1 < y2 + h2
			and y2 < y1 + h1
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
