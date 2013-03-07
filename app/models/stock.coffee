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
    console.log item
    if item.code.charAt(0) == '6'
      url = @endpoint + 'sh' + item.code
    else
      url = @endpoint + 'sz' + item.code
    console.log url
    $.get url, (data) =>
        left = data.indexOf '"'
        right = data.lastIndexOf '"'
        vals = (data.substring left + 1, right).split(",")
        item.updateAttributes(name: vals[0], currentPrice: vals[3])

module.exports = Stock
