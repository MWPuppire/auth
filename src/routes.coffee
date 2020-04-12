module.exports = (app, passport, db) ->
  app.get '/', (req, res) ->
    res.render 'index', { user: req.user, message: req.flash 'errorMessage' }
  app.get '/login', isNotLoggedIn, (req, res) ->
    res.render 'login', { user: req.user, message: req.flash 'loginMessage' }
  app.get '/signup', isNotLoggedIn, (req, res) ->
    res.render 'signup', { user: req.user, message: req.flash 'signupMessage' }
  app.get '/profile', isLoggedIn, (req, res) ->
    res.render 'profile', { user: req.user }
  app.get '/profile/:Username', (req, res) ->
    res.render 'profile', { user: req.params }
  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'
  app.post '/signup', passport.authenticate('local-signup', {
    successRedirect : '/profile',
    failureRedirect : '/signup',
    failureFlash    : true
  })
  app.post '/login', passport.authenticate('local-login', {
    successRedirect : '/profile',
    failureRedirect : '/login',
    failureFlash    : true
  })
  app.use (req, res, next) ->
    res.status(404).render '404'

isLoggedIn = (req, res, next) ->
  if req.isAuthenticated() then return next()
  req.flash 'errorMessage', 'Must be logged in to visit that page.'
  res.redirect '/'

isNotLoggedIn = (req, res, next) ->
  if not req.isAuthenticated() then return next()
  req.flash 'errorMessage', 'Must sign out to visit that page.'
  res.redirect '/profile'
