Spine = require('spine')
{Panel} = require('spine.mobile')
$ = Spine.$
Stock = require('models/stock')

class StockAdd extends Panel
  title: 'Stock Add'

  elements:
    'form': 'form'

  events:
    'submit form': 'submit'

  constructor: ->
    super

    @log 'StockAdd instantiated!'

    @addButton('Cancel', @back)
    @addButton('Add', @submit).addClass('right')

    @active @render

  render: ->
    @log 'StockAdd renderred!'
    @html require('views/stocks/add')()
    $('input').focus

  back: ->
    @navigate('/stocks', trans: 'left')

  submit: (e) ->
    e.preventDefault()
    stock = Stock.fromForm(@form)
    console.log stock
    if stock.save()
      @navigate('/stocks', trans: 'left')

  deactive: ->
    super
    @form.blur()


class StockDetails extends Panel
  title: 'Stock Details'

  constructor: ->
    super

    @log 'StockDetails instantiated!'
    Stock.bind('change', @render)
    @active (params) -> @change(params.id)
    @addButton('back', @back)

  render: =>
    return unless @item
    @html require('views/stocks/details')(@item)
    
  back: ->
    @navigate('/stocks', trans: 'left')

  change: (id) ->
    @item = Stock.find(id)
    @render


class StockList extends Panel
  events:
    'tap .item': 'click'

  title: 'Stocks'

  constructor: ->
    super

    @log 'StockList instantiated!'
    Stock.bind('refresh change', @render)
    @active Stock.updateAll
    @addButton('Refresh', @render)
    @addButton('Add', @add).addClass('right')

  click: (e) ->
    console.log 'click'
    console.log $(e.currentTarget)
    item = Stock.all()[$(e.currentTarget).index()]
    @navigate('/stocks', item.id, trans: 'right')

  add: ->
    @navigate('/stocks/add', trans:  'right')

  render: =>
    console.log "render #{Stock.count()}"
    items = Stock.all()
    console.log require('views/stocks/item')(items)
    @html require('views/stocks/item')(items)


class Stocks extends Spine.Controller
  constructor: ->
    super

    @log 'Stocks instantiated!'
    @list = new StockList
    @detail = new StockDetails
    @add = new StockAdd

    console.log "start fetch"
    Stock.fetch()
    console.log "fetch done"

    @routes
      '/stocks/add':    (params) -> @add.active(params)
      '/stocks/:id':    (params) -> @detail.active(params)
      '/stocks':        (params) -> @list.active(params)


module.exports = Stocks
