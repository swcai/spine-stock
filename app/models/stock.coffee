Spine   = require('spine')
$ = jQuery

class Stock extends Spine.Model
  @configure 'Stock', 'name', 'code', 'currentPrice'

  @extend Spine.Model.Local

  constructor: ->
    super
    # Spine.Model.host = 'http://hq.sinajs.cn'

  # @default: -> new @(name: 'GREE Electronics', code: '000651', 'currentPrice': 0.0)
  @endpoint: 'http://hq.sinajs.cn/list='

  @fetch: ->
    super
    @updateAll

  @updateAll: =>
    console.log "fetch #{@count()}"
    @fetchPriceFromSite item for item in @all()
    @saveLocal()
      
  @fetchPriceFromSite: (item) =>
    return unless item
    if item.code.charAt(0) == '6'
      valname = 'sh' + item.code
      url = @endpoint + 'sh' + item.code
    else
      valname = 'sz' + item.code
      url = @endpoint + 'sz' + item.code
    $.ajaxSetup({cache: true})
    $.getScript url, (data) =>
      $.ajaxSetup({cache: false})
      eval("data = hq_str_#{valname}")
      vals = data.split(",")
      item.updateAttributes(name: vals[0], currentPrice: vals[3])

module.exports = Stock
