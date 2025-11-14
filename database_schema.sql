-- Complete PostgreSQL schema for FitPlus app

-- Bảng người dùng
CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  gender VARCHAR(50),
  height_cm DECIMAL(5, 2),
  weight_kg DECIMAL(5, 2),
  blood_group VARCHAR(10),
  heart_rate INT,
  address TEXT,
  phone_number VARCHAR(20),
  doctor_phone_number VARCHAR(20),
  medical_history TEXT,
  current_medications TEXT,
  profile_image_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng hồ sơ sức khỏe
CREATE TABLE health_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  record_date TIMESTAMP NOT NULL,
  weight_kg DECIMAL(5, 2),
  height_cm DECIMAL(5, 2),
  heart_rate INT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng bác sĩ
CREATE TABLE doctors (
  doctor_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name VARCHAR(255) NOT NULL,
  specialty VARCHAR(100) NOT NULL,
  phone_number VARCHAR(20),
  qualification TEXT,
  rating DECIMAL(3, 1),
  profile_image_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng lịch khám
CREATE TABLE appointments (
  appointment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  doctor_id UUID NOT NULL REFERENCES doctors(doctor_id) ON DELETE CASCADE,
  appointment_date TIMESTAMP NOT NULL,
  status VARCHAR(50) DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng nhắc nhở
CREATE TABLE reminders (
  reminder_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  reminder_date_time TIMESTAMP NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng chu kì kinh nguyệt
CREATE TABLE menstrual_cycles (
  cycle_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  start_date DATE NOT NULL,
  cycle_length_days INT DEFAULT 28,
  period_length_days INT DEFAULT 5,
  flow_intensity VARCHAR(50),
  pain_level INT,
  symptoms TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng theo dõi thai kì
CREATE TABLE pregnancy_trackers (
  pregnancy_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  last_menstrual_date DATE NOT NULL,
  baby_name VARCHAR(255),
  expected_delivery_date DATE,
  week_of_pregnancy INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng hồ sơ y tế
CREATE TABLE medical_records (
  record_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
  diagnosis VARCHAR(255),
  date_created TIMESTAMP NOT NULL,
  doctor_name VARCHAR(255),
  notes TEXT,
  medications TEXT[],
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng lời khuyên sức khỏe
CREATE TABLE health_advices (
  advice_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  body_part VARCHAR(100),
  category VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes để tối ưu hóa tìm kiếm
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_health_records_user_id ON health_records(user_id);
CREATE INDEX idx_health_records_date ON health_records(record_date);
CREATE INDEX idx_appointments_user_id ON appointments(user_id);
CREATE INDEX idx_reminders_user_id ON reminders(user_id);
CREATE INDEX idx_menstrual_cycles_user_id ON menstrual_cycles(user_id);
CREATE INDEX idx_medical_records_user_id ON medical_records(user_id);
