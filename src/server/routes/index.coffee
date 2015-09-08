express = require('express')
router = express.Router()
fs = require 'fs'
path = require 'path'

postsFile = path.join(__dirname, '../content/posts.json')
getPosts = -> JSON.parse(fs.readFileSync(postsFile, 'utf8'))

### GET home page. ###

router.get '/', (req, res) ->
  posts = getPosts()
  res.render 'index', title: 'Matts Hoglund', posts: posts._data

module.exports = router