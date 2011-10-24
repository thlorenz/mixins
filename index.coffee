
showMixins = (mixins) ->
  mixins.map((x) -> x.getInfo()).join("\n")

compose = (mixins) ->
  mixins: mixins
  add: (context) ->
    for mixin in mixins
      do (mixin) => mixin.add.call(this, context)
    null
  getInfo: -> showMixins @mixins

Mixable = ->
  mixins: []
  addMixin: (mixin, context) ->
    mixin.add.call(this, context)
    @mixins.push mixin
  showMixins: -> showMixins @mixins


# Testing

aging =
  add: (context) ->
    @age  = context.age
    @howOld = -> console.log "Age:", @age
  getInfo: -> "aging mixin: adds age property and howOld log"
identity =
  add: (context) ->
    @nick = context.nick
    @who = -> console.log "Name:", @nick
  getInfo: -> "identity mixin: adds nick property and who log"

personality = compose [ aging, identity ]

t = new Mixable
t.addMixin personality, { age: 2, nick: "Teega" }
console.log t.showMixins()
