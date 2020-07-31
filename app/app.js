const express = require('express')
const { keys, set } = require('./redis')
const app = express()

app.get('/', async (req, res) => {
    res.json(await keys())
})

app.get('/:key/:value', async (req, res) => {
    const { key, value } = req.params
    await set(key, value)
    res.send(`Set ${key} to ${value}`)
})

module.exports = app;
