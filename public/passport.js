var LocalStrategy, crypto, hash;

LocalStrategy = require('passport-local').Strategy;

crypto = require('crypto');

hash = function(str) {
  return crypto.createHash('sha256').update(str).digest('hex');
};

module.exports = function(passport, db) {
  passport.serializeUser(function(user, done) {
    return done(null, user);
  });
  passport.deserializeUser(function(user, done) {
    return done(null, user);
  });
  passport.use('local-signup', new LocalStrategy({
    passReqToCallback: true
  }, function(req, username, password, done) {
    return process.nextTick(function() {
      return db.get("SELECT 1 FROM Users WHERE Username=? LIMIT 1;", [username], function(err, exists) {
        if (err) {
          return done(err);
        }
        if (exists) {
          return done(null, false, req.flash('signupMessage', 'That username is already taken.'));
        } else {
          password = hash(password);
          db.run("INSERT INTO Users (Username, Password) VALUES (?, ?);", [username, password]);
          return done(null, {
            Username: username,
            Password: password
          });
        }
      });
    });
  }));
  return passport.use('local-login', new LocalStrategy({
    passReqToCallback: true
  }, function(req, username, password, done) {
    return db.get("SELECT * FROM Users WHERE Username=? LIMIT 1;", [username], function(err, user) {
      if (err) {
        return done(err);
      }
      if (!user) {
        return done(null, false, req.flash('loginMessage', 'No user found.'));
      }
      if (user.Password !== hash(password)) {
        return done(null, false, req.flash('loginMessage', 'Wrong password.'));
      }
      return done(null, user);
    });
  }));
};
