const express = require('express')
const axios = require('axios')
const { keys, set } = require('./redis')
const app = express()
app.set('view engine','ejs')

app.get('/', async (req, res) => {
    res.json(await keys())
})

app.get('/redis', async (req, res) => {
    const { key, value } = req.query
    await set(key, value)
    res.send(`Set ${key} to ${value}`)
})

app.get('/gif/:tag', async (req, res) => {
    const { tag } = req.params
    const result = await axios.get(`http://api.giphy.com/v1/gifs/random?api_key=${process.env.GIPHY_API_KEY}&tag=${tag}`)
    res.render('gifs', {url: result.data.data.embed_url })
})

module.exports = app;
