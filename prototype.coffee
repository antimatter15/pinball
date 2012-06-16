ctx = document.getElementById('arena').getContext('2d')

lines = [
  [10, 10, 10, 300],
  [10, 10, 300, 10],
  [10, 300, 300, 400],
  [300, 10, 300, 400],
  [100, 10, 200, 150]
]


lines = for line in lines
	x_min = Math.min(line[0], line[2])
	x_max = Math.max(line[0], line[2])
	y_min = Math.min(line[1], line[3])
	y_max = Math.max(line[1], line[3])
	[x_min, y_min, x_max, y_max]

radius = 5

ball = [50, 50]
mass = 1
velo = [0, 18]
gravity = 1

t_end = 0
new_velo = []
new_ball = []



predict = ->
	candidates = for line in lines
		#calculate the time at which the collision will occur
		t_end = (2 * line[1] * velo[0] - 2 * line[3] * velo[0] - 2 * line[0] * velo[1] + 
		    2 * line[2] * velo[1] - Math.sqrt(-4 * (gravity * line[0] - 
		          gravity * line[2]) * (2 * ball[1] * line[0] - 2 * ball[0] * line[1] - 
		          2 * ball[1] * line[2] + 2 * line[1] * line[2] + 2 * ball[0] * line[3] - 
		          2 * line[0] * line[3]) + Math.pow(-2 * line[1] * velo[0] + 
		         2 * line[3] * velo[0] + 2 * line[0] * velo[1] - 
		         2 * line[2] * velo[1], 2)))/(2 * (gravity * line[0] - 
		      gravity * line[2]))

		#if t_end < 0
		#	#console.log "causality violation"
		#	continue

		#calculate the position
		y = 0.5 * gravity * t_end * t_end + velo[1] * t_end + ball[1]
		x = t_end * velo[0] + ball[0]

		ctx.fillRect(x - 3, y - 3, 6, 6)

		x_min = Math.min(line[0], line[2])
		x_max = Math.max(line[0], line[2])
		y_min = Math.min(line[1], line[3])
		y_max = Math.max(line[1], line[3])
		unless x_min <= x <= x_max && y_min <= y <= y_max
			#console.log "Wrong sort of thing"
			continue

		[t_end, x, y]
	
	if candidates.length > 0
		[t_end, x, y] = candidates.sort(
				(a, b) ->
					a[0] - b[0]
			)[0]
		
		#calculate the angle it will intercept
		dy = gravity * t_end + velo[1]
		dx = velo[0]

		#and from that, calculate the angle of the deflection
		line_angle = Math.atan2(line[3] - line[1], line[2] - line[0])
		ball_angle = Math.atan2(dy, dx)
		defl_angle = -line_angle  #2 * line_angle - ball_angle
		magnitude  = Math.sqrt(dy * dy + dx * dx)

		for i in [0..100]
			ctx.fillRect(x + i * Math.cos(defl_angle), y + i * Math.sin(defl_angle), 1, 1)

		new_velo = [magnitude * Math.cos(defl_angle), magnitude * Math.sin(defl_angle)]
		new_ball = [x, y]

#calculate the energy of the thingy
#kinetic = (1/2) * mass * (velo[0] * velo[0] + velo[1] * velo[1]) # essentially 1/2 mv^2
#grav_pot = mass * gravity * ball[1]
#grav_pot = mass * gravity * y
#gravitational + kinetic = constant



###ctx.beginPath()
ctx.moveTo(x, 0)
ctx.lineTo(x, 1000)
ctx.stroke()

ctx.beginPath()
ctx.moveTo(0, y)
ctx.lineTo(1000, y)
ctx.stroke() 
console.log t
###

epoch = +new Date

render = ->

	ctx.clearRect(0, 0, 1000, 1000)

	ctx.beginPath()
	for line in lines
		ctx.moveTo line[0], line[1]
		ctx.lineTo line[2], line[3]
	ctx.stroke()

	t = 10 * (new Date - epoch) / 1000
	predict()
	if t >= t_end
		t = t_end
		epoch = +new Date
		velo = new_velo
		ball = new_ball
		#predict()
	y = 0.5 * gravity * t * t + velo[1] * t + ball[1]
	x = t * velo[0] + ball[0]
	ctx.beginPath()
	ctx.moveTo(x + radius, y);
	ctx.arc(x, y, radius, 0, Math.PI*2, false);
	ctx.stroke()

animloop = ->
	requestAnimFrame(animloop)
	render()

predict()
animloop()