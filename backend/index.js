const express = require("express");
const app = express();
const auth = require("./middlewares/auth.js");
const errors = require("./middlewares/errors.js");
const unless = require("express-unless");


// middleware for authenticating token submitted with requests
/**
 * Conditionally skip a middleware when a condition is met.
 */
// auth.authenticateToken.unless = unless;
// app.use(
//   auth.authenticateToken.unless({
//     path: [
//       { url: "/users/login", methods: ["POST"] },
//       { url: "/users/register", methods: ["POST"] },
//       { url: "/users/otpLogin", methods: ["POST"] },
//       { url: "/users/verifyOTP", methods: ["POST"] },
//     ],
//   })
// );

app.use(express.json());
app.use(function (req, res, next) {

  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  res.setHeader('Access-Control-Allow-Credentials', true);

  next();
});
// initialize routes
app.use("/users", require("./routes/users.routes"));

// middleware for error responses
app.use(errors.errorHandler);

// listen for requests
app.listen(process.env.port || 5000, function () {
  console.log("Ready to Go!");
});
