Spine = require('spine')
$ = Spine.$
Stock = require('models/stock')

# not to be used at this point
class StockDetail extends Spine.Controller
  title: 'Stock Detail'

  constructor: ->
    super
    @log "StockDetail instantiatized! #{@el.html()} #{@$el.html()}"
    Stock.bind('change', @render)
    @active (params) -> @change(params.id)

  render: =>
    return unless @item
    @html require('views/stocks/details')(@item)
    
  back: ->
    @navigate('/stocks', trans: 'left')

  change: (id) ->
    @item = Stock.find(id)
    @render()


class StockListItem extends Spine.Controller
  tag: 'li'
  title: 'Stocks'

  constructor: ->
    super
    @log 'StockListItem instantiated!'
    Stock.bind('refresh update', @render)

  click: (e) ->
    @navigate('/stocks', @item.id, trans: 'right')

  render: =>
    console.log "render #{require('views/stocks/item')(@item).html()}"
    @html require('views/stocks/item')(@item)


class StockListView extends Spine.Controller
  tag: 'ul'
  ###
  attributes:
    'data-role':  'listview'
    'data-split-icon': 'gear'
    'data-inset': 'true'
  ###

  constructor: ->
    super
    @log 'StockListView instantialized!'
    Stock.bind('refresh', @addAll)
    Stock.bind('create', @addOne)
    @log "el #{@el.html()} #{@$el.html()}"

  addOne: (item) =>
    @log "addOne in StockListView"
    stock = new StockListItem(item: item)
    @append stock.render
    # enforce listview update
    @el.listview 'refresh'

  addAll: =>
    Stock.each(@addOne)


class StockList extends Spine.Controller
  events:
    'tap #stocklist_button_refresh'  : 'addAll'
    'tap #stocklist_button_openpanel': 'openStockAddPanel'
    'tap #stocklist_button_cancel'   : 'closeStockAddPanel'
    'tap #stocklist_button_add'      : 'addStock'
    'keypress #stocklist_input_code' : 'keyinput'

  elements:
    '#stocklist_input_code': 'code_input'
    '#stocklist_panel_add': 'StockAddPanel'
    '#stocklist_listview': 'listview'

  constructor: ->
    super
    @log "StockList instantiatized! #{@el.html()} #{@$el.html()}"
    @listview = new StockListView(el: '#stocklist_listview')

  addAll: ->
    # @listview.addAll
    # Stock.refresh Stock.all()
    # @listview.el.remove()
    # Stock.fetch()

  openStockAddPanel: ->
    @code_input.removeAttr 'disabled'
    @StockAddPanel.panel 'open'

  closeStockAddPanel: ->
    @code_input.attr('disabled', 'true') 
    @StockAddPanel.panel 'close'

  addStock: ->
    code = @code_input.val()
    Stock.createStockAsync code
    @code_input.val ''
    @StockAddPanel.panel 'close'

  keyinput: (e) =>
    if e.keyCode == 13
      e.preventDefault()
      @log "keyinput - #{@addStock}"
      @addStock()

class StockAppStack extends Spine.Stack
  constructor: ->
    super

    @log 'StockAppStack instantiated!'
    @list = new StockList(el: "#stocklist_page")
    @detail = new StockDetail(el: "#stockdetail_page")

    console.log "start fetch"
    Stock.fetch()
    console.log "fetch done"

    @route '/stocks/:id', (params) -> @detail.active(params)
    @route '/stocks', (params) -> @list.active(params)


module.exports = StockAppStack
