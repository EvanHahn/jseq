
############################################################################################################
TRM                       = require 'coffeenode-trm'
rpr                       = TRM.rpr.bind TRM
badge                     = 'jsEq/tests'
log                       = TRM.get_logger 'plain',     badge
info                      = TRM.get_logger 'info',      badge
whisper                   = TRM.get_logger 'whisper',   badge
alert                     = TRM.get_logger 'alert',     badge
debug                     = TRM.get_logger 'debug',     badge
warn                      = TRM.get_logger 'warn',      badge
help                      = TRM.get_logger 'help',      badge
echo                      = TRM.echo.bind TRM


#-----------------------------------------------------------------------------------------------------------
module.exports = ( eq, ne ) ->
  R = {}

  ### 1. simple tests ###

  #---------------------------------------------------------------------------------------------------------
  ### 1.1. positive ###

  R[ "NaN eqs NaN"                                        ] = -> eq NaN, NaN
  R[ "finite integer n eqs n"                             ] = -> eq 1234, 1234
  R[ "emtpy list eqs empty list"                          ] = -> eq [], []
  R[ "emtpy pod eqs empty pod"                            ] = -> eq {}, {}
  R[ "number eqs number of same value"                    ] = -> eq 123.45678, 123.45678
  R[ "number pod eqs primitive number of same value"      ] = -> eq 5, new Number 5
  R[ "string pod eqs primitive string of same value"      ] = -> eq 'helo', new String 'helo'
  R[ "regex lit's w same pattern, flags are eq"           ] = -> eq /^abc[a-zA-Z]/, /^abc[a-zA-Z]/
  R[ "pods w same properties are eq"                      ] = -> eq { a:'b', c:'d' }, { a:'b', c:'d' }
  R[ "pods that only differ wrt prop ord are eq"          ] = -> eq { a:'b', c:'d' }, { c:'d', a:'b' }

  #---------------------------------------------------------------------------------------------------------
  ### 1.2. negative ###

  R[ "pod doesn't eq list"                                ] = -> ne {}, []
  R[ "pod in a list doesn't eq list in list"              ] = -> ne [{}], [[]]
  R[ "integer n doesn't eq rpr n"                         ] = -> ne 1234, '1234'
  R[ "empty list doesn't eq false"                        ] = -> ne [], false
  R[ "list w an integer doesn't eq one w rpr n"           ] = -> ne [ 3 ], [ '3' ]
  R[ "regex lit's w diff. patterns, same flags aren't eq" ] = -> ne /^abc[a-zA-Z]/, /^abc[a-zA-Z]x/
  R[ "regex lit's w same patterns, diff. flags aren't eq" ] = -> ne /^abc[a-zA-Z]/, /^abc[a-zA-Z]/i
  R[ "+0 should ne -0"                                    ] = -> ne +0, -0
  R[ "pods that only differ wrt prop ord aren't eq"       ] = -> ne { a:'b', c:'d' }, { c:'d', a:'b' }

  #=========================================================================================================
  ### 2. complex tests ###
  #---------------------------------------------------------------------------------------------------------
  R[ "list w named member eqs other list w same member" ] = ->
    d = [ 'foo', null, 3, ]; d[ 'extra' ] = 42
    e = [ 'foo', null, 3, ]; e[ 'extra' ] = 42
    return eq d, e

  #---------------------------------------------------------------------------------------------------------
  R[ "list w named member doesn't eq list w same member, other value" ] = ->
    d = [ 'foo', null, 3, ]; d[ 'extra' ] = 42
    e = [ 'foo', null, 3, ]; e[ 'extra' ] = 108
    return ne d, e

  #---------------------------------------------------------------------------------------------------------
  R[ "date eqs other date pointing to same time" ] = ->
    d = new Date "1995-12-17T03:24:00"
    e = new Date "1995-12-17T03:24:00"
    return eq d, e

  #---------------------------------------------------------------------------------------------------------
  R[ "date does not eq other date pointing to other time" ] = ->
    d = new Date "1995-12-17T03:24:00"
    e = new Date "1995-12-17T03:24:01"
    return ne d, e

  #---------------------------------------------------------------------------------------------------------
  R[ "circular arrays w same layout and same values are eq (1)" ] = ->
    d = [ 1, 2, 3, ]; d.push d
    e = [ 1, 2, 3, ]; e.push d
    return eq d, e

  #---------------------------------------------------------------------------------------------------------
  R[ "circular arrays w same layout and same values are eq (2)" ] = ->
    d = [ 1, 2, 3, ]; d.push d
    e = [ 1, 2, 3, ]; e.push e
    return eq d, e

  #---------------------------------------------------------------------------------------------------------
  ### joshwilsdon's test (https://github.com/joyent/node/issues/7161) ###
  R[ "joshwilsdon" ] = ->
    d1 = [ NaN, undefined, null, true, false, Infinity, 0, 1, "a", "b", {a: 1}, {a: "a"},
      [{a: 1}], [{a: true}], {a: 1, b: 2}, [1, 2], [1, 2, 3], {a: "1"}, {a: "1", b: "2"} ]
    d2 = [ NaN, undefined, null, true, false, Infinity, 0, 1, "a", "b", {a: 1}, {a: "a"},
      [{a: 1}], [{a: true}], {a: 1, b: 2}, [1, 2], [1, 2, 3], {a: "1"}, {a: "1", b: "2"} ]
    errors = []
    count = 0
    for v1, idx1 in d1
      for idx2 in [ idx1 ... d2.length ]
        count += 1
        v2 = d2[ idx2 ]
        if idx1 == idx2
          unless eq v1, v2
            errors.push "eq #{rpr v1}, #{rpr v2}"
        else
          unless ne v1, v2
            errors.push "ne #{rpr v1}, #{rpr v2}"
    #.......................................................................................................
    # whisper count
    return [ count, errors, ]


  #---------------------------------------------------------------------------------------------------------
  return R


