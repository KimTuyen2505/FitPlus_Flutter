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
  connectionString: process.env.DATABASE_URL,
  connectionTimeoutMillis: 5000,
  idleTimeoutMillis: 30000,
  max: 20,
});

pool.on('error', (err) => {
  console.error('[ERROR] Lỗi kết nối pool:', err);
});

app.use(cors());
app.use(express.json());

app.get('/api/health', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json({ status: 'OK', time: result.rows[0] });
  } catch (error) {
    res.status(500).json({ status: 'ERROR', message: error.message });
  }
});

// Signup endpoint
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { fullName, email, password, phoneNumber, dateOfBirth, height, weight } = req.body;

    // Validation
    if (!fullName || !email || !password || !dateOfBirth) {
      return res.status(400).json({ 
        success: false, 
        message: 'Họ tên, email, mật khẩu và ngày sinh là bắt buộc' 
      });
    }

    // Kiểm tra email đã tồn tại chưa
    const emailCheck = await pool.query(
      'SELECT user_id FROM public.users WHERE email = $1',
      [email]
    );
    
    if (emailCheck.rows.length > 0) {
      return res.json({ 
        success: false, 
        message: 'Email đã tồn tại' 
      });
    }

    // Hash mật khẩu
    const hashedPassword = await bcrypt.hash(password, 10);

    const result = await pool.query(
      `INSERT INTO public.users (full_name, email, password_hash, date_of_birth, height_cm, weight_kg) 
       VALUES ($1, $2, $3, $4, $5, $6) 
       RETURNING user_id, full_name, email, date_of_birth, height_cm, weight_kg`,
      [fullName, email, hashedPassword, dateOfBirth, height || 0, weight || 0]
    );

    const user = result.rows[0];
    return res.status(201).json({
      success: true,
      message: 'Đăng kí thành công',
      user: {
        userId: user.user_id,
        fullName: user.full_name,
        email: user.email,
        dateOfBirth: user.date_of_birth,
        height: user.height_cm,
        weight: user.weight_kg,
      }
    });
  } catch (error) {
    console.error('[ERROR] Signup error:', error);
    return res.status(500).json({ 
      success: false, 
      message: 'Lỗi máy chủ: ' + error.message 
    });
  }
});

// Login endpoint
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const result = await pool.query(
      'SELECT * FROM public.users WHERE email = $1',
      [email]
    );
    
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
        height: user.height_cm,
        weight: user.weight_kg,
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
      'SELECT * FROM public.health_records WHERE user_id = $1 ORDER BY record_date DESC',
      [req.params.userId]
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[ERROR] Get health records:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Add health record
app.post('/api/health-records', async (req, res) => {
  try {
    const { userId, weight, height, heartRate, recordDate } = req.body;
    const result = await pool.query(
      'INSERT INTO public.health_records (user_id, weight_kg, height_cm, heart_rate, record_date) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [userId, weight, height, heartRate, recordDate || new Date()]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('[ERROR] Add health record:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get reminders
app.get('/api/reminders/:userId', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM public.reminders WHERE user_id = $1 ORDER BY reminder_time DESC',
      [req.params.userId]
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[ERROR] Get reminders:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Add reminder
app.post('/api/reminders', async (req, res) => {
  try {
    const { userId, title, description, reminderTime } = req.body;
    const reminderId = 'reminder_' + Date.now();
    const result = await pool.query(
      'INSERT INTO public.reminders (reminder_id, user_id, title, description, reminder_time) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [reminderId, userId, title, description, reminderTime]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('[ERROR] Add reminder:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Delete reminder
app.delete('/api/reminders/:reminderId', async (req, res) => {
  try {
    await pool.query(
      'DELETE FROM public.reminders WHERE reminder_id = $1',
      [req.params.reminderId]
    );
    res.json({ success: true });
  } catch (error) {
    console.error('[ERROR] Delete reminder:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get doctors
app.get('/api/doctors', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM public.doctors');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[ERROR] Get doctors:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get appointments
app.get('/api/appointments/:userId', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM public.appointments WHERE user_id = $1 ORDER BY appointment_date DESC',
      [req.params.userId]
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[ERROR] Get appointments:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Book appointment
app.post('/api/appointments', async (req, res) => {
  try {
    const { userId, doctorId, appointmentDate, reason } = req.body;
    const appointmentId = 'appointment_' + Date.now();
    const result = await pool.query(
      'INSERT INTO public.appointments (appointment_id, user_id, doctor_id, appointment_date, reason) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [appointmentId, userId, doctorId, appointmentDate, reason]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('[ERROR] Book appointment:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get medical records
app.get('/api/medical-records/:userId', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM public.medical_records WHERE user_id = $1 ORDER BY record_date DESC',
      [req.params.userId]
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[ERROR] Get medical records:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get menstrual cycles
app.get('/api/menstrual-cycles/:userId', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM public.menstrual_cycles WHERE user_id = $1 ORDER BY cycle_start_date DESC',
      [req.params.userId]
    );
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[ERROR] Get menstrual cycles:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Add menstrual cycle
app.post('/api/menstrual-cycles', async (req, res) => {
  try {
    const { userId, cycleStartDate, cycleDays } = req.body;
    const cycleId = 'cycle_' + Date.now();
    const result = await pool.query(
      'INSERT INTO public.menstrual_cycles (cycle_id, user_id, cycle_start_date, cycle_days) VALUES ($1, $2, $3, $4) RETURNING *',
      [cycleId, userId, cycleStartDate, cycleDays || 28]
    );
    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('[ERROR] Add menstrual cycle:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Get health advices
app.get('/api/health-advices', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM public.health_advices');
    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[ERROR] Get health advices:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Backend chạy tại http://localhost:${PORT}`));
