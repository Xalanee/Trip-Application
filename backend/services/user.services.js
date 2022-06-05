const bcrypt = require("bcryptjs");
const auth = require("../middlewares/auth.js");

const otpGenerator = require("otp-generator");
const crypto = require("crypto");
const key = "verysecretkey"; // Key for cryptograpy. Keep it secret
var msg91 = require("msg91")("1", "1", "1");
const mySQL = require('mysql');
const { db } = require('../config/db.config');
const { title } = require("process");

async function login({ email, password }, callback) {
  // const user = await user.findOne({ email });
  let selectQuery = 'SELECT COUNT(*) as "total", ?? FROM ?? WHERE ?? = ? LIMIT 1';
  let query = mySQL.format(selectQuery, ["password", "user_register", "email", email])

  db.query(query, (err, data) => {
    if (err) {
      return callback(err);
    }
    if (data[0].total == 0) {
      return callback({
        message: "Invalid Username/Password!",
      });
    }
    else {
      if (bcrypt.compareSync(password, data[0].password)) {
        const token = auth.generateAccessToken(email);
        return callback(null, { token });
      }
      else {
        return callback({
          message: "Invalid Username/Password!",
        });
      }
    }

  });

}

async function userProfile({ email}, callback) {
  // const user = await user.findOne({ email });
  let selectQuery = 'SELECT id,username,email,phone FROM user_register WHERE email = ? LIMIT 1';
  let query = mySQL.format(selectQuery, [email])

  db.query(query, (err, data) => {
    if (err) {
      return callback(err);
    }
    if (data[0].total == 0) {
      return callback({
        message: "Invalid Username/Password!",
      });
    }
    else {
      return callback(null, { data:data[0] });
      
    }

  });

}
async function GetTrip(email,callback) {
  let selectQuery = 'select t.*,u.email from trips t,user_register u where t.userId=u.id and u.email=?';
  let query = mySQL.format(selectQuery)

  db.query(query,[email], (err, data) => {
    if (err) {
      return callback(err);
    } 
    // if (data[0].total == 0) {
    //   return callback({
    //     message: "Invalid Trip!",
    //   });
    // }
    // console.log(data);
      return callback(null, { data });
  });
}

async function Delete(id, callback) {  
  let selectQuery = 'DELETE FROM trips WHERE id = ?';
  let query = mySQL.format(selectQuery)
  db.query(query,[id], (err, data) => {
    if(err) {
      return callback(err);
    }
    console.log("Number of records deleted: " + data.affectedRows);
  })
}
async function register(params, callback) {

  if (params.username === undefined) {
    return callback({
        message: "Username Required",
      });
  }
  if (params.email === undefined) {
    return callback({
        message: "Email Required",
      });
  }
  if (params.phone === undefined) {
    return callback({
        message: "Phone Required",
      });
  }
  let selectQuery = 'SELECT count(*) as "total"  FROM ?? WHERE ?? = ? LIMIT 1';
  let query = mySQL.format(selectQuery, ["user_register", "email", params.email])

  db.query(query, (err, data) => {
    if (err) {
      return callback(err);
    }
    if (data[0].total > 0) {
      return callback({
        message: "Email already exist",
      });
    }
    else {
      db.query(`INSERT INTO user_register (username, email , password, phone) values (?,?,?,?)`,
      [params.username,params.email,params.password,params.phone], (error, result, fields) => {
        if(error){
        return callback(error)
        }
        return callback(null , "User register Succesfully");
      }
      );
      }
    })
}
async function trips(params, callback) {

  let selectQuery = 'SELECT count(*) as "total"  FROM ?? WHERE ?? = ? and  (select email FROM user_register where id= userId)=? LIMIT 1';
  let query = mySQL.format(selectQuery, ["trips", "title", params.title,params.email]) 
  db.query(query, (err, data) => {
    if (err) {
      return callback(err);
      console.log("ERROR REGISTRATION",err);
    }
    if (data[0].total > 0) {
      console.log("Trip already exist",data[0]);
      return callback({
        message: "Trip already exist",
      });
     
    }
    else {
      console.log("Registarion trip",params);
      let send_data={lastId:1,userId:1}
 db.query(`select (ifnull(max(id),0)+1) as lastId , (select id from user_register where user_register.email=?) as userId from trips`, [params.email],(err, data) => {
    console.log("bal itus",data[0]); 
    if(data[0]){
send_data.lastId=data[0].lastId;
send_data.userId=data[0].userId;
    } 
    db.query(`INSERT INTO trips (id,title, body , payload,userId) values (?,?,?,?,?)`,
    [send_data.lastId,params.title,params.body,params.payload,send_data.userId], (error, result, fields) => {
      if(error){
      return callback(error)
      }
      return callback(null , "Trip register Succesfully");
    }
    ); 
  });  

      }
    })
}




async function createNewOTP(params, callback) {
  // Generate a 4 digit numeric OTP
  const otp = otpGenerator.generate(4, {
    alphabets: false,
    upperCase: false,
    specialChars: false,
  });
  const ttl = 5 * 60 * 1000; //5 Minutes in miliseconds
  const expires = Date.now() + ttl; //timestamp to 5 minutes in the future
  const data = `${params.phone}.${otp}.${expires}`; // phone.otp.expiry_timestamp
  const hash = crypto.createHmac("sha256", key).update(data).digest("hex"); // creating SHA256 hash of the data
  const fullHash = `${hash}.${expires}`; // Hash.expires, format to send to the user
  // you have to implement the function to send SMS yourself. For demo purpose. let's assume it's called sendSMS
  //sendSMS(phone, `Your OTP is ${otp}. it will expire in 5 minutes`);

  console.log(`Your OTP is ${otp}. it will expire in 5 minutes`);

  var otpMessage = `Dear Customer, ${otp} is the One Time Password ( OTP ) for your login.`;

  msg91.send(`+91${params.phone}`, otpMessage, function (err, response) {
    console.log(response);
  });

  return callback(null, fullHash);
}

async function verifyOTP(params, callback) {
  // Separate Hash value and expires from the hash returned from the user
  let [hashValue, expires] = params.hash.split(".");
  // Check if expiry time has passed
  let now = Date.now();
  if (now > parseInt(expires)) return callback("OTP Expired");
  // Calculate new hash with the same key and the same algorithm
  let data = `${params.phone}.${params.otp}.${expires}`;
  let newCalculatedHash = crypto
    .createHmac("sha256", key)
    .update(data)
    .digest("hex");
  // Match the hashes
  if (newCalculatedHash === hashValue) {
    return callback(null, "Success");
  }
  return callback("Invalid OTP");
}

module.exports = {
  login,
  register,
  createNewOTP,
  trips,
  verifyOTP,
  userProfile,
  GetTrip,
  Delete
};
