const bcrypt = require("bcryptjs");
const userServices = require("../services/user.services");

/**
 * 1. To secure the password, we are using the bcryptjs, It stores the hashed password in the database.
 * 2. In the SignIn API, we are checking whether the assigned and retrieved passwords are the same or not using the bcrypt.compare() method.
 * 3. In the SignIn API, we set the JWT token expiration time. Token will be expired within the defined duration.
 */
var storeLoginUser=0;
exports.register = (req, res, next) => {
  // return console.log(req.body);
  const { password } = req.body;

  const salt = bcrypt.genSaltSync(10);

  req.body.password = bcrypt.hashSync(password, salt);

  userServices.register(req.body, (error, results) => {
    if (error) {
      return next(error);
    }
    console.log(results);
    // storeLoginUser=email
    return res.status(200).send({
      message: "Success",
      data: results,
    });
  });
};

exports.login = (req, res, next) => {
  // console.log('jjjjjjjjjjjjjj');
  const { email, password } = req.body;

  userServices.login({ email, password }, (error, results) => {
    if (error) {
      console.log("login error",err);
      return next(error);
      
    }
    storeLoginUser=email
    return res.status(200).send({
      message: "Success",
      data: results,
    });
  });
};

exports.userProfile = (req, res, next) => {
  req.params.email=storeLoginUser
  // console.log("userLogin isthe",storeLoginUser);
  userServices.userProfile({email:req.params.email},(error,results)=>{
    if (error) {
      return next(error);
    }
    return res.status(200).send(results);
  })
};
exports.GetTrips = (req, res, next) => {   
  userServices.GetTrip(storeLoginUser,(error, results) => { 
    if (error) {
      console.log("there are error",error);
      return next(error);
    }
    // console.log(results);
    return res.status(200).send({
      message: "Success",
      data: results,
    });
  });
};
exports.trips = (req, res, next) => {
  req.body.email=storeLoginUser 
  userServices.trips(req.body, (error, results) => {
    if (error) {
      return next(error);
    }
    // console.log(results);
    return res.status(200).send(results);
  });
};


exports.deletetrip = (req, res, next) => {  
  userServices.Delete(req.params.id, (error, results) => {
    if (error) {
      return next(error);
    }
    console.log(results);
    return res.status(200).send({
      message: "Success",
      data: results,
    });
  });
};

exports.verifyOTP = (req, res, next) => {
  userServices.verifyOTP(req.body, (error, results) => {
    if (error) {
      return next(error);
    }
    return res.status(200).send({
      message: "Success",
      data: results,
    });
  });
};
