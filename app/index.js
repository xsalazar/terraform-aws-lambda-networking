const redis = require('ioredis')
const { Octokit } = require('@octokit/core')

// This function tests that the configured Redis cluster is reachable from the Lambda function
async function testRedisReachability() {
  let redisClient
  try {
    const redisHost = process.env.REDIS_HOST ?? 'host.docker.internal'
    const redisPort = process.env.REDIS_PORT ?? 6379
    redisClient = new redis(redisPort, redisHost, {
      connectTimeout: 5000,
      commandTimeout: 5000,
    })

    redisClient.on('error', function () {}) // Supress error events

    const result = await redisClient.ping()
    console.log(`Success: ${result}`)
    return true
  } catch (e) {
    console.log('🚫 Failed to connect to Redis')
  } finally {
    redisClient.disconnect()
  }

  return false
}

// This function tests that the Lambda function can make a request to an API on the public internet
async function testPublicInternetReachability() {
  try {
    const octokit = new Octokit()
    const result = await octokit.request('GET /zen')
    console.log(`Success: ${result.data}`)
    return true
  } catch (e) {
    console.log('🚫 Failed to connect to the public internet')
  }

  return false
}

exports.handler = async (event, context) => {
  const isRedisReachable = await testRedisReachability()
  const isInternetReachable = await testPublicInternetReachability()

  if (isRedisReachable && isInternetReachable) {
    return '🚀 Everything looks good!'
  }

  return '😭 Uh oh, check CloudWatch to see what went wrong'
}
