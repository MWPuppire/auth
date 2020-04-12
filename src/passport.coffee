LocalStrategy  = require('passport-local').Strategy
crypto         = require 'crypto'
hash           = (str) ->
  crypto.createHash('sha256').update(str).digest 'hex'
module.exports = (passport, db) ->
  passport.serializeUser (user, done) ->
    done null, user
  passport.deserializeUser (user, done) ->
    done null, user
  passport.use 'local-signup', new LocalStrategy({
    passReqToCallback: true
  }, (req, username, password, done) ->
    process.nextTick () ->
      db.get "SELECT 1 FROM Users WHERE Username=? LIMIT 1;", [ username ], (err, exists) ->
        if err
          return done err
        if exists
          return done null, false, req.flash('signupMessage', 'That username is already taken.')
        else
          password = hash password
          db.run "INSERT INTO Users (Username, Password) VALUES (?, ?);", [ username, password ]
          return done null, { Username: username, Password: password }
  )
  passport.use 'local-login', new LocalStrategy({
    passReqToCallback: true
  }, (req, username, password, done) ->
    db.get "SELECT * FROM Users WHERE Username=? LIMIT 1;", [ username ], (err, user) ->
      if err
        return done err
      if not user
        return done null, false, req.flash('loginMessage', 'Username not found.')
      if hash(password) != user.Password
        return done null, false, req.flash('loginMessage', 'Wrong password.')
      return done null, user
  )
