const express = require("express");
const { Pool } = require("pg");

const app = express();
const port = 5000;

// DB connection pool
const pool = new Pool({
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  port: 5432,
});

app.get("/", (req, res) => {
  res.send("Hello from Node.js + ECS + RDS!");
});

app.get("/items", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW();");
    res.json({ db_time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get("/health", (req, res) => {
  res.send("OK");
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
