express        = require 'express'
cookieParser   = require 'cookie-parser'
bodyParser     = require 'body-parser'
flash          = require 'connect-flash'
passport       = require 'passport'
compression    = require 'compression'
session        = require 'express-session'
MemoryStore    = require('memorystore') session
lowercasePaths = require 'express-lowercase-paths'
sqlite3        = require('sqlite3').verbose()
path           = require 'path'
nunjucks       = require 'nunjucks'
app            = express()
db             = new sqlite3.Database 'db.sqlite3'
socketIO       = require 'socket.io'
http           = require 'http'
server         = http.Server app
io             = socketIO server
nunjucks.configure 'views', { autoescape: true, express: app }
app.set 'view engine', 'html'
app.set 'views', path.join(__dirname, 'views')
app.use cookieParser()
app.use bodyParser()
app.use session { store: new MemoryStore(), secret: 'secretkey' }
app.use flash()
app.use passport.initialize()
app.use passport.session()
app.use compression { filter: shouldCompress }
app.use lowercasePaths()
app.disable 'x-powered-by'
shouldCompress = (req, res) ->
  if req.headers['x-no-compression']
    return false
  compression.filter req, res
app.use '/static', express.static(__dirname + '/public', { index: false })
require('./lib/routes') app, passport, db
require('./lib/passport') passport, db
module.exports = app
