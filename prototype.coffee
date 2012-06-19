ctx = document.getElementById('arena').getContext('2d')
###
radius = 5
line = [300, 10, 300, 400]
ball = [50, 50]
mass = 1
velo = [18, 0]
gravity = 1

ctx.beginPath()
ctx.moveTo line[0], line[1]
ctx.lineTo line[2], line[3]
ctx.stroke()

ctx.beginPath()
ctx.moveTo ball[0], ball[1]
for t in [0..100]
	y = 0.5 * gravity * t * t + velo[1] * t + ball[1]
	x = t * velo[0] + ball[0]
	ctx.lineTo x, y
ctx.stroke()



A = line[3] - line[1]
B = line[0] - line[2]
C = line[0] * line[3] - line[1] * line[2]

console.log A, B, C
if B == 0
	t = -((-C + A * ball[0])/(A * velo[0]))
else
	t = (-2 * A * velo[0] - 2 * B * velo[1] + Math.sqrt(-8 * B * gravity * (-C + A * ball[0] + B * ball[1]) + 4 * Math.pow(A * velo[0] + B * velo[1],2)))/(2 * B *gravity)

console.log t
###
###
a = 2 * line[1] * velo[0] - 2 * line[3] * velo[0] - 2 * line[0] * velo[1] + 2 * line[2] * velo[1]
b = Math.sqrt(-4 * (gravity * line[0] - 
          gravity * line[2]) * (2 * ball[1] * line[0] - 2 * ball[0] * line[1] - 
          2 * ball[1] * line[2] + 2 * line[1] * line[2] + 2 * ball[0] * line[3] - 
          2 * line[0] * line[3]) + Math.pow(-2 * line[1] * velo[0] + 
         2 * line[3] * velo[0] + 2 * line[0] * velo[1] - 
         2 * line[2] * velo[1], 2))
c = (2 * (gravity * line[0] - gravity * line[2]))

t_end = (a + b)/c
console.log (a - b)/c###
###
t_end = (2 * line[1] * velo[0] - 2 * line[3] * velo[0] - 2 * line[0] * velo[1] + 
    2 * line[2] * velo[1] + Math.sqrt(-4 * (gravity * line[0] - 
          gravity * line[2]) * (2 * ball[1] * line[0] - 2 * ball[0] * line[1] - 
          2 * ball[1] * line[2] + 2 * line[1] * line[2] + 2 * ball[0] * line[3] - 
          2 * line[0] * line[3]) + Math.pow(-2 * line[1] * velo[0] + 
         2 * line[3] * velo[0] + 2 * line[0] * velo[1] - 
         2 * line[2] * velo[1], 2)))/(2 * (gravity * line[0] - 
      gravity * line[2]))

t_end = t
console.log t_end

y = 0.5 * gravity * t_end * t_end + velo[1] * t_end + ball[1]
x = t_end * velo[0] + ball[0]

ctx.beginPath()
ctx.moveTo(x + radius, y);
ctx.arc(x, y, radius, 0, Math.PI*2, false);
ctx.stroke()
###



lines = [
	# [10, 10, 10, 450],
	# [10, 10, 330, 10],
	# [330, 10, 330, 450],
	# [330, 450, 10, 450],

	[30, 30, 30, 300],
	[30, 30, 350, 30],
	[30, 300, 300, 400],
	[350, 30, 350, 450],
	[30, 450, 350, 450],
	[300, 60, 300, 400],
	[100, 30, 200, 150]
]

addCircle = (x, y, rad) ->
	slice = Math.PI / 16
	for seg in [0..Math.PI*2] by slice
		lines.push [
			x + (rad * Math.cos(seg)),
			y + (rad * Math.sin(seg)),
			x + (rad * Math.cos(seg + slice)),
			y + (rad * Math.sin(seg + slice))
		]

addCircle 200, 200, 40
#addCircle 200, 200, 200
#addCircle 200, 20, 150

radius = 5

ball = [50, 50]
mass = 1
velo = [0, 18]
gravity = 1

t_end = 0
new_velo = []
new_ball = []
@energy = 0
@enerplier = 1

#velo = [-15.537863927195186, 6.524935599679632]
#ball = [30.545978163710686, 30] 
#velo = [-15.537863927195184, -23.866702981531702]
#ball = [300, 293.5223633143438] 
predict = ->
	candidates = for line in lines
		#calculate the time at which the collision will occur
		A = line[3] - line[1]
		B = line[0] - line[2]
		C = line[0] * line[3] - line[1] * line[2]

		if B == 0
			t_end = -((-C + A * ball[0])/(A * velo[0]))
		else
			det = Math.sqrt(-8 * B * gravity * (-C + A * ball[0] + B * ball[1]) + 4 * Math.pow(A * velo[0] + B * velo[1],2))
			a = (-2 * A * velo[0] - 2 * B * velo[1] + det)/(2 * B *gravity)
			b = (-2 * A * velo[0] - 2 * B * velo[1] - det)/(2 * B *gravity)
			#console.log a, b
			if a > 0 and b > 0
				t_end = Math.min(a, b)
			else
				t_end = Math.max(a, b)

		#if t_end < 0
		#	#console.log "causality violation"
		#	continue

		#calculate the position
		y = 0.5 * gravity * t_end * t_end + velo[1] * t_end + ball[1]
		x = t_end * velo[0] + ball[0]


		x_min = Math.min(line[0], line[2]) - 1
		x_max = Math.max(line[0], line[2]) + 1
		y_min = Math.min(line[1], line[3]) - 1
		y_max = Math.max(line[1], line[3]) + 1

		#ctx.fillRect(x - 3, y - 3, 6, 6)

		unless x_min <= x <= x_max && y_min <= y <= y_max
		#	console.log "Wrong sort of thing"
			continue

		if isNaN(t_end) or not isFinite(t_end) or t_end < 0.1
			continue

		#


		[t_end, x, y, line]
	
	if candidates.length > 0
		[t_end, x, y, line] = candidates.sort(
				(a, b) ->
					a[0] - b[0]
			)[0]
		#console.log line, t_end
		#calculate the angle it will intercept
		dy = gravity * t_end + velo[1]
		dx = velo[0]

		#and from that, calculate the angle of the deflection
		line_angle = Math.atan2(line[3] - line[1], line[2] - line[0])
		ball_angle = Math.atan2(dy, dx)
		defl_angle = 2 * line_angle - ball_angle
		magnitude  = Math.sqrt(dy * dy + dx * dx) * enerplier

		@energy = 0.5 * mass * magnitude * magnitude  - mass * gravity * y
		

		#for i in [0..100]
		#	ctx.fillRect(x + i * Math.cos(defl_angle), y + i * Math.sin(defl_angle), 1, 1)
		# for t in [0..100]
		# 	y1 = 0.5 * gravity * t * t + velo[1] * t + ball[1]
		# 	x1 = t * velo[0] + ball[0]
		# 	ctx.fillRect(x1, y1, 1, 1)
		new_velo = [magnitude * Math.cos(defl_angle), magnitude * Math.sin(defl_angle)]
		new_ball = [x, y]

		#console.log velo, ball, new_velo, new_ball, t_end
	else
		new_velo = velo #[0, 0]
		new_ball = [60, 60]
#calculate the energy of the thingy
#kinetic = (1/2) * mass * (velo[0] * velo[0] + velo[1] * velo[1]) # essentially 1/2 mv^2
#grav_pot = mass * gravity * ball[1]
#grav_pot = mass * gravity * y
#gravitational + kinetic = constant


###
ctx.beginPath()
ctx.moveTo(x, 0)
ctx.lineTo(x, 1000)
ctx.stroke()

ctx.beginPath()
ctx.moveTo(0, y)
ctx.lineTo(1000, y)
ctx.stroke() 
console.log t###

absepoch = +new Date
epoch = +new Date
@timecoef = 1
@baseline = 0

# document.getElementById('speed').onchange = ->
# 	setSpeed(document.getElementById('speed').value)

@setSpeed = (speed) ->
	t = timecoef * (new Date - epoch) / 1000
	@timecoef = speed
	epoch = (+new Date) - 1000 * t / timecoef

render = ->

	ctx.clearRect(0, 0, 1000, 1000)
	
	ctx.fillRect(100, 0, 1e14 * (energy - baseline), 5)

	ctx.beginPath()
	for line in lines
		ctx.moveTo line[0], line[1]
		ctx.lineTo line[2], line[3]
	ctx.stroke()

	t = timecoef * (new Date - epoch) / 1000
	
	#setSpeed 10 * Math.max(1, Math.min(Math.abs(t), Math.abs(t_end - t)))
	
	y = 0.5 * gravity * t * t + velo[1] * t + ball[1]
	x = t * velo[0] + ball[0]
	predict()
	#unless 0 < x < 500 or 0 < y < 500
	#	console.log new Date - absepoch

	if t >= t_end
		t = t_end
		y = 0.5 * gravity * t * t + velo[1] * t + ball[1]
		x = t * velo[0] + ball[0]

		epoch = +new Date
		velo = new_velo
		ball = new_ball
		#predict()
	#console.log t_end
	#console.log x, y
	ctx.beginPath()
	ctx.moveTo(x + radius, y);
	ctx.arc(x, y, radius, 0, Math.PI*2, false);
	ctx.stroke()

animloop = ->
	requestAnimFrame(animloop)
	render()

predict()
animloop()