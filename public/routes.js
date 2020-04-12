var isLoggedIn, isNotLoggedIn;

module.exports = function(app, passport, db) {
  app.get('/', function(req, res) {
    return res.render('pages/index', {
      user: req.user
    });
  });
  app.get('/login', isNotLoggedIn, function(req, res) {
    return res.render('pages/login', {
      user: req.user,
      message: req.flash('loginMessage')
    });
  });
  app.get('/signup', isNotLoggedIn, function(req, res) {
    return res.render('pages/signup', {
      user: req.user,
      message: req.flash('signupMessage')
    });
  });
  app.get('/profile', isLoggedIn, function(req, res) {
    return res.render('pages/profile', {
      user: req.user
    });
  });
  app.get('/profile/:Username', function(req, res) {
    return res.render('pages/profile', {
      user: req.params
    });
  });
  app.get('/logout', function(req, res) {
    req.logout();
    return res.redirect('/');
  });
  app.post('/signup', passport.authenticate('local-signup', {
    successRedirect: '/profile',
    failureRedirect: '/signup',
    failureFlash: true
  }));
  return app.post('/login', passport.authenticate('local-login', {
    successRedirect: '/profile',
    failureRedirect: '/login',
    failureFlash: true
  }));
};

isLoggedIn = function(req, res, next) {
  if (req.isAuthenticated()) {
    return next();
  }
  return res.redirect('/signup');
};

isNotLoggedIn = function(req, res, next) {
  if (req.isAuthenticated()) {
    return res.redirect('/profile');
  }
  return next();
};
