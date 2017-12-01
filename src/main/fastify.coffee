fs = require('fs')
path = require 'path'
rp = require('request-promise-native')

URL_SSL = "https://raw.githubusercontent.com/p2pweb/gitbox-config/master/ssl.json"


low = require('lowdb')
FileSync = require('lowdb/adapters/FileSync')
adapter = new FileSync(path.join(__data,'fastify.conf'))
db = low(adapter)

update_ssl = (callback)->
    url = URL_SSL+"?"+(new Date()-0)
    rp(url, {timeout: 30000}).then(
        (o)=>
            o = JSON.parse o
            db.set('ssl', o).write()
            callback?(o[1], o[2])
        (err)=>
            setTimeout(
                =>
                    update_ssl(callback)
                3000
            )
    )

TIME_DAY = 86400

module.exports = (root)->
    [time, key, cer] = (db.get('ssl').value() or [0])

    now = parseInt((new Date()-0)/1000)
    diff = (now - time) or now

    if diff > 30*TIME_DAY
        if diff < 60*TIME_DAY
            update_ssl()
            fastify_init(key, cer)
        else
            update_ssl(fastify_init)
    else
        fastify_init(key, cer)

fastify_init = (key, cert)=>
    fastify = require('fastify')(
        #http2:true
        https: {
          allowHTTP1:true
          key
          cert
        }
    )
    fastify.get(
        '/'
        (request, reply) =>
            reply.send({ hello: 'world' })
    )

    fastify.addHook(
        'preHandler'
        (req, reply, next) =>
            reply.header 'Access-Control-Allow-Origin', "*"
            reply.header 'Access-Control-Allow-Credentials', "true"
            next()
    )

# Run the server!
    fastify.listen(
        2016
        (err) =>
            if (err)
                throw err
            console.log("server listening on #{fastify.server.address().port}")
    )



