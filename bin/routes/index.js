var express, fs, getPosts, path, postsFile, router;

express = require('express');

router = express.Router();

fs = require('fs');

path = require('path');

postsFile = path.join(__dirname, '../content/posts.json');

getPosts = function() {
  return JSON.parse(fs.readFileSync(postsFile, 'utf8'));
};


/* GET home page. */

router.get('/', function(req, res) {
  var posts;
  posts = getPosts();
  return res.render('index', {
    title: 'Matts Hoglund',
    posts: posts._data
  });
});

module.exports = router;
