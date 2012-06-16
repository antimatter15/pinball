ctx = document.getElementById('arena').getContext('2d')
line = [10, 300, 90, 400]

ctx.beginPath()
ctx.moveTo line[0], line[1]
ctx.lineTo line[2], line[3]
ctx.stroke()

ball = [20, 20]
velo = [1, 5]
g = 1

ctx.beginPath()
ctx.moveTo ball[0], ball[1]
for t in [0..100]
	y = 0.5 * g * t * t + velo[1] * t + ball[1]
	x = t * velo[0] + ball[0]
	ctx.lineTo x, y
ctx.stroke()


ctx.strokeStyle = 'red'

x = 40.72
y = 338.407
ctx.beginPath()
ctx.moveTo(x, 0)
ctx.lineTo(x, 1000)
ctx.stroke()

ctx.beginPath()
ctx.moveTo(0, y)
ctx.lineTo(1000, y)
ctx.stroke()
