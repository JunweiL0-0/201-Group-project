const mysql = require('mysql2/promise');
let pool = null;

exports.createPool = async function () {
    pool = mysql.createPool({
        multipleStatements: true,
        host: process.env.MYSQL_HOST,
        user: process.env.MYSQL_USER,
        password: process.env.MYSQL_PASSWORD,
        database: process.env.MYSQL_DATABASE,
        port: process.env.MYSQL_PORT || 3306
    });
};

exports.getPool = function () {
    return pool;
};

exports.transaction = async function (pool, callback) {

  const connection = await pool.getConnection();
  await connection.beginTransaction();

  try {

    await callback(connection);
    await connection.commit();

  } catch (err) {

    await connection.rollback();
    // Throw the error again so others can catch it.
    throw err;

  } finally {

    connection.release();

  }

};