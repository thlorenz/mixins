#############################################
# A) enables extending prototype, but has no encapsulation
#############################################

personality = ->
  @howOld = -> console.log "Age:", @age
  @who = -> console.log "Name:", @name
  @
personality::give = (age, name) -> @age = age; @name = name

Teega = personality::give.call(@, age, name)

personality.call(Teega.prototype)

t = new Teega( 2, "Teega" )

#####################
# B) Using encapsulation which requires applying mixin to returned object
# instead of prototype because we are returning a newly generated object
# from the 'constructor'
# ####################

personality = ->
  @howOld = -> console.log "Age:", @age()
  @who = -> console.log "Name:", @name()
  @

Teega = (age, name) ->
  age:  -> age
  name: -> name

t = Teega( 2, "Teega" )
personality.call(t)


##########################################
# Repeating A and B with add mixin function
##########################################
# A) using @:: (this.prototype) here

Object::addMixin = (mixin) -> mixin.call @::

personality = ->
  @howOld = -> console.log "Age:", @age
  @who = -> console.log "Name:", @name
  @

Teega = (age, name) ->
  @age = age
  @name = name

Teega.addMixin personality

t = new Teega( 2, "Teega" )

##########################################
# B) using actual @ (this instead of prototype here)

Object::addMixin = (mixin) -> mixin.call @

personality = ->
  @howOld = -> console.log "Age:", @age()
  @who = -> console.log "Name:", @name()
  @

Teega = (age, name) ->
  age:  -> age
  name: -> name

t = Teega( 2, "Teega" )
t.addMixin personality

########################################
# This idea taken from a google tech talk

counter = 0

### This does not work (only inlining functions seems to work)
Tracked = -> @id = counter++
Logged  = -> @log = -> console.log @id
###

# So we need to use javascript here
`
function Tracked() { this.id = counter++; }
function Logged() {
  this.log = function() { console.log(this.id); };
}
`

ItemType = -> Tracked.call @; Logged.call @
ItemType.prototype = Object.create null, { type: { value: 'generic' } }

i = new ItemType()

SubItemType = -> ItemType.call this
SubItemType:: = Object.create(ItemType::, type: value: "sub")

si = new SubItemType()

########################################
# Expanding on that idea to use mixin combined with state

Object::addMixin = (mixin) -> mixin.call @
Object::addState = (add, context) -> add.call @, context

personality = ->
  @howOld = -> console.log "Age:", @age
  @who = -> console.log "Name:", @nick
  @

addPersonality = (context) ->
  @age = context.age
  @nick = context.nick

t = { }
t.addMixin personality
t.addState(addPersonality, { age: 2.5, nick: "Teega" })

########################################
# Combining mixin and state

Object::addMixin = (mixin, context) ->
  mixin.call @
  if context and @__addMixinContext__
    @__addMixinContext__ context
    delete @__addMixinContext__

personality = ->
  @howOld = -> console.log "Age:", @age
  @who = -> console.log "Name:", @nick
  @__addMixinContext__  = (context) ->
    @age  = context.age
    @nick = context.nick
  @
t = { }
t.addMixin personality, { age: 2, nick: "Teega" }

########################################
# Adding multiple mixins

Object::addMixin = (mixin, context) ->
  mixin.call @
  if context and @__addMixinContext__
    @__addMixinContext__ context
    delete @__addMixinContext__
aging = ->
  @howOld = -> console.log "Age:", @age
  @__addMixinContext__  = (context) ->
    @age  = context.age
  @
identity = ->
  @who = -> console.log "Name:", @nick
  @__addMixinContext__  = (context) ->
    @nick = context.nick
  @

t = { }
t.addMixin aging, { age: 2 }
t.addMixin identity, { nick: "Teega" }

########################################
# Composing multiple mixins

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
t.showMixins()
