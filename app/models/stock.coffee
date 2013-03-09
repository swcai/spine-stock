Spine   = require('spine')
$ = jQuery

class Stock extends Spine.Model
  @configure 'Stock', 'name', 'code', 'currentPrice'

  @extend Spine.Model.Local

  constructor: ->
    super

  endpoint: 'http://hq.sinajs.cn/list='

  load: (item) ->
    super
    console.log "load #{item}"
    @fetchPriceFromRemote item
    @saveLocal
    this

  fetchPriceFromRemote: (item) =>
    return unless item
    console.log "item #{item}"
    if item.code.charAt(0) == '6'
      valname = 'sh' + item.code
      url = @endpoint + 'sh' + item.code
    else
      valname = 'sz' + item.code
      url = @endpoint + 'sz' + item.code
    console.log "url #{url}"
    $.ajaxSetup({cache: true})
    $.getScript url, (data) =>
      $.ajaxSetup({cache: false})
      return unless data
      console.log "data #{data}"
      eval("data = hq_str_#{valname}")
      vals = data.split(",")
      item.updateAttributes(name: vals[0], currentPrice: vals[3])

module.exports = Stock
