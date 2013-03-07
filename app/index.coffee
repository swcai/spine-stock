require('lib/setup')

Spine = require('spine')
{Stage} = require('spine.mobile')
Stocks = require('controllers/stocks')

class App extends Stage.Global
  constructor: ->
    super
    @log 'StockApp instantiated!'
    @stocks = new Stocks

    Spine.Route.setup(shim: true) 
    @log 'go StockList'
    @navigate '/stocks'

module.exports = App
