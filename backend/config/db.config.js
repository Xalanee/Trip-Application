const mySQL = require('mysql');

const connectionString = {
    connectionLimit : 100,
    host : "localhost",
    user : "root",
    password : "",
    database : "xalane",
    debug : false,
    port : 3306
}
const db = mySQL.createPool(connectionString)

module.exports = {
    db,
}