// Node.js + Express Backend cho FitPlus (ví dụ đơn giản)
// Cài đặt: npm install express pg bcryptjs cors dotenv
// Chạy: node server.js

const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const cors = require('cors');
require('dotenv').config();

const app = express();
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://user:password@localhost:5432/fitplus'
});

app.use(cors());
app.use(express.json());

// Login endpoint
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
    
    if (result.rows.length === 0) {
      return res.json({ success: false, message: 'Email không tồn tại' });
    }

    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password_hash);

    if (!validPassword) {
      return res.json({ success: false, message: 'Mật khẩu không đúng' });
    }

    res.json({
      success: true,
      token: `token_${Date.now()}`,
      user: {
        userId: user.user_id,
        fullName: user.full_name,
        email: user.email,
        phoneNumber: user.phone_number,
        height: user.height,
        weight: user.weight,
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get health records
app.get('/api/health-records/:userId', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM health_records WHERE user_id = $1 ORDER BY record_date DESC',
      [req.params.userId]
    );
    res.json({ data: result.rows });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Add health record
app.post('/api/health-records', async (req, res) => {
  try {
    const { userId, weight, height, heartRate, recordDate } = req.body;
    const result = await pool.query(
      'INSERT INTO health_records (user_id, weight, height, heart_rate, record_date) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [userId, weight, height, heartRate, recordDate]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get doctors
app.get('/api/doctors', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM doctors');
    res.json({ data: result.rows });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Backend chạy tại http://localhost:${PORT}`));