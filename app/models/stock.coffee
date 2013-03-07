Spine   = require('spine')
$ = jQuery

class Stock extends Spine.Model
  @configure 'Stock', 'name', 'code', 'currentPrice'

  @extend Spine.Model.Local

  constructor: ->
    super
    Spine.Model.host = 'http://hq.sinajs.cn'

  # @default: -> new @(name: 'GREE Electronics', code: '000651', 'currentPrice': 0.0)
  @endpoint: 'http://hq.sinajs.cn/list='

  @fetch: ->
    super
    console.log 'aaa'
    @fetchPriceFromSite item for item in @all()
    @saveLocal()

  @fetchPriceFromSite: (item) ->
    return unless item
    console.log item
    ###
    if code.charAt(0) == '6'
      url = @endpoint + 'sh' + code
    else
      url = @endpoint + 'sz' + code
    ###
    console.log Spine.Model.host
    url = "#{@endpoint}sh601006"
    console.log url
    $.get url, (data) =>
        left = data.indexOf '"'
        right = data.lastIndexOf '"'
        items = (data.substring left + 1, right).split(",")
        item.name = items[0]
        item.currentPrice = items[3]
        console.log item

module.exports = Stock
