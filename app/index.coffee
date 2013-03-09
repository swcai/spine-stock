require('lib/setup')

Spine = require('spine')
$ = Spine.$
StockAppStack = require('controllers/stocks')

class App extends Spine.Controller
  constructor: ->
    super
    @log 'StockApp instantiated!'
    @stack = new StockAppStack
    Spine.Route.setup(shim: true) 
    @log  'here we go'
    @navigate '/stocks'

module.exports = App
