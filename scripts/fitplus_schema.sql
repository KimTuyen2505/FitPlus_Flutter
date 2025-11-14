-- FitPlus Health Management System - PostgreSQL Schema

-- Bảng người dùng
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  date_of_birth DATE,
  gender VARCHAR(20),
  height FLOAT,
  weight FLOAT,
  blood_type VARCHAR(10),
  emergency_contact VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng hồ sơ sức khỏe (cân nặng, chiều cao, nhịp tim)
CREATE TABLE health_records (
  record_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  record_type VARCHAR(50),
  weight FLOAT,
  height FLOAT,
  heart_rate INTEGER,
  blood_pressure VARCHAR(20),
  record_date DATE NOT NULL,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng nhắc nhở
CREATE TABLE reminders (
  reminder_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  reminder_title VARCHAR(255) NOT NULL,
  reminder_description TEXT,
  reminder_time TIME NOT NULL,
  reminder_date DATE NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng bác sĩ
CREATE TABLE doctors (
  doctor_id SERIAL PRIMARY KEY,
  full_name VARCHAR(255) NOT NULL,
  specialty VARCHAR(255),
  phone_number VARCHAR(20),
  email VARCHAR(255),
  clinic_address TEXT,
  experience_years INTEGER,
  rating FLOAT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng lịch khám
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  doctor_id INTEGER NOT NULL REFERENCES doctors(doctor_id),
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  reason_for_visit TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng chu kì kinh nguyệt
CREATE TABLE menstrual_cycles (
  cycle_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  cycle_start_date DATE NOT NULL,
  cycle_end_date DATE,
  cycle_length INTEGER,
  symptoms VARCHAR(500),
  mood VARCHAR(100),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng hồ sơ y tế
CREATE TABLE medical_records (
  medical_record_id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  record_type VARCHAR(100),
  diagnosis VARCHAR(255),
  treatment VARCHAR(500),
  doctor_name VARCHAR(255),
  visit_date DATE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng lời khuyên sức khỏe
CREATE TABLE health_advices (
  advice_id SERIAL PRIMARY KEY,
  body_part VARCHAR(100),
  advice_title VARCHAR(255) NOT NULL,
  advice_description TEXT NOT NULL,
advice_category VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes cho tìm kiếm nhanh
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_health_records_user ON health_records(user_id);
CREATE INDEX idx_reminders_user ON reminders(user_id);
CREATE INDEX idx_appointments_user ON appointments(user_id);
CREATE INDEX idx_menstrual_user ON menstrual_cycles(user_id);
CREATE INDEX idx_medical_records_user ON medical_records(user_id);

-- Insert demo data
INSERT INTO users (full_name, email, password_hash, phone_number, date_of_birth, gender, height, weight, blood_type)
VALUES 
  ('Người Dùng Demo', 'demo@fitplus.com', '$2b$10$demo.hash', '0123456789', '1990-01-01', 'male', 175, 70, 'O+'),
  ('Người Dùng Test', 'user@example.com', '$2b$10$test.hash', '0987654321', '1995-05-15', 'female', 165, 60, 'A+');

INSERT INTO doctors (full_name, specialty, phone_number, email, clinic_address, experience_years, rating)
VALUES
  ('Dr. Nguyễn Văn A', 'Tim mạch', '0901234567', 'dr.a@clinic.com', 'Hà Nội', 10, 4.8),
  ('Dr. Trần Thị B', 'Phụ khoa', '0912345678', 'dr.b@clinic.com', 'TP HCM', 8, 4.9),
  ('Dr. Lê Văn C', 'Tổng quát', '0923456789', 'dr.c@clinic.com', 'Đà Nẵng', 12, 4.7);

INSERT INTO health_advices (body_part, advice_title, advice_description, advice_category)
VALUES
  ('Tim', 'Bảo vệ tim khỏe', 'Tập thể dục 30 phút mỗi ngày để tăng cường sức khỏe tim', 'Exercise'),
  ('Phổi', 'Hít thở sâu', 'Thực hiện bài tập hít thở sâu hàng ngày để cải thiện sức khỏe phổi', 'Breathing'),
  ('Cơ', 'Tập luyện cơ bắp', 'Tập gym 3-4 lần mỗi tuần để duy trì sức mạnh cơ bắp', 'Strength');