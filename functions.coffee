Object::pipe = (fn) -> fn @

class FunctionWrapper
  constructor: (fn) -> @fn = fn
  fwd: (f) -> _f (params) => f.fn(@fn(params))
  times: (count) ->
    f = null
    for i in [1..count]
      do => f = if not f then this else f.fwd this
    f
_f = (fn) -> new FunctionWrapper fn

moveLeft  = _f (x) -> x.x--; x
moveRight = _f (x) -> x.x++; x
moveDown  = _f (x) -> x.y--; x
moveUp    = _f (x) -> x.y++; x

moveNE    = moveUp.fwd moveRight
moveSE    = moveDown.fwd moveRight
moveNW    = moveUp.fwd moveLeft
moveSW    = moveDown.fwd moveLeft

knightNE  = moveUp.fwd moveNE
knightSE  = moveDown.fwd moveSE
knightNW  = moveUp.fwd moveNW
knightSW  = moveDown.fwd moveSW
knightMoves = [ knightNE, knightSE, knightNW, knightSW ]

bishopMoves = [
  moveNE, moveSE

]

charCodeOffset  = 'A'.charCodeAt(0) - 1
prettyPosition  = (p) -> [ String.fromCharCode(p.x + charCodeOffset), p.y ]
isLegalPosition = (p) -> p.x > 0 and p.x < 9 and p.y > 0 and p.y < 9

class ChessPiece
  constructor: (x, y) ->
    @x = x.charCodeAt(0) - charCodeOffset
    @y = y
  position: -> prettyPosition({ @x, @y })
  legalMoves: ->
    @moves
      .map((x) => x.fn({ @x, @y }))
      .filter(isLegalPosition)
      .map(prettyPosition)

class Knight extends ChessPiece
  moves: knightMoves
knight = new Knight('B', 4)


