Spine   = require('spine')
$ = jQuery

class Stock extends Spine.Model
  @configure 'Stock', 'name', 'code', 'currentPrice'

  constructor: ->
    super

  @endpoint: 'http://hq.sinajs.cn/list='

  @createStockAsync: (code) ->
    return unless code
    console.log "code #{code}"
    if code.charAt(0) == '6'
      valname = 'sh' + code
      url = Stock.endpoint + 'sh' + code
    else
      valname = 'sz' + code
      url = Stock.endpoint + 'sz' + code
    console.log "url #{url}"
    $.ajaxSetup
      cache: true

    $.getScript url, (data) =>
      $.ajaxSetup
        cache: false

      eval "data = hq_str_#{valname}" 
      console.log "data = #{data}"
      return unless data
      vals = data.split "," 
      Stock.create
        code: code
        name: vals[0]
        currentPrice: vals[3]

module.exports = Stock
