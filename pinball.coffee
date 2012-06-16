canvas = document.getElementById 'arena'
arena = canvas.getContext '2d'

arena.fillText 'super aweosme', 10, 10

Array::scale = (coef) ->
  val * coef for val, x in this

Array::sub = (arr) ->
  this.add arr.scale(-1)

Array::add = (arr) ->
  val + arr[x] for val, x in this

class Thing
  @a = [0,0] #acceleration
  @v = [0,0] #velocity
  @p = [0,0] #position
  @m = 1 #mass
  
  @pin = false
  @gravity = false
  
  frame: ->
    @v = @v.add(@a)
    @v = @v.add(@gravity) if @gravity
    if @pin
      @v.add(@p.sub(@pin).scale(4)) #modify to the spring constant
    @p = @p.add(@v)
    arena.drawSomething


