const redis = require("ioredis")
const redisHost = process.env.REDIS_HOST
const redisPort = process.env.REDIS_PORT
const client = new redis(redisPort, redisHost)

async function set(key, value) {
    await client.set(key, value)
}

async function keys() {
    return await client.keys('*');
}

module.exports.set = set
module.exports.keys = keys
