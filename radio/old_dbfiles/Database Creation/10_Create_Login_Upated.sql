-- ایجاد کاربر rdbu با پسورد و تنظیمات مربوطه
CREATE LOGIN rdbu WITH
    PASSWORD = 'HadiTabasiAslAvval',
    DEFAULT_DATABASE = RCMS,
    CHECK_POLICY = OFF;
GO

-- ایجاد کاربر django با پسورد و تنظیمات مربوطه
CREATE LOGIN django WITH
    PASSWORD = 'Login_Pass_2024',
    DEFAULT_DATABASE = RCMS,
    CHECK_POLICY = OFF;
GO

-- ایجاد کاربران دیتابیس برای rdbu و django
USE RCMS;
CREATE USER rdbu FOR LOGIN rdbu
    WITH DEFAULT_SCHEMA = Event;
CREATE USER django FOR LOGIN django
    WITH DEFAULT_SCHEMA = Django;
GO

-- تنظیم مالکیت اسکیماها برای کاربر django
ALTER AUTHORIZATION ON SCHEMA::[Application] TO [django];
ALTER AUTHORIZATION ON SCHEMA::[Command] TO [django];
ALTER AUTHORIZATION ON SCHEMA::[Common] TO [django];
ALTER AUTHORIZATION ON SCHEMA::[Django] TO [django];
ALTER AUTHORIZATION ON SCHEMA::[Radio] TO [django];
ALTER AUTHORIZATION ON SCHEMA::[Setting] TO [django];
GO

-- تنظیم مالکیت اسکیمای Event برای کاربر rdbu
ALTER AUTHORIZATION ON SCHEMA::[Event] TO [rdbu];
GO

-- اضافه کردن کاربر django به نقش‌های دیتابیس مورد نیاز
ALTER ROLE [db_datareader] ADD MEMBER [django];
ALTER ROLE [db_datawriter] ADD MEMBER [django];
ALTER ROLE [db_ddladmin] ADD MEMBER [django]; -- فقط اگر نیاز به ایجاد یا تغییر ساختار جدول‌ها دارد
GO

-- اضافه کردن کاربر rdbu به نقش‌های دیتابیس مورد نیاز
ALTER ROLE [db_datareader] ADD MEMBER [rdbu];
ALTER ROLE [db_datawriter] ADD MEMBER [rdbu];
GO

-- حذف دسترسی‌های سطح سرور برای کاربر rdbu
-- این دستورات فقط باید برای کاربرانی که وظایف مدیریتی دارند اجرا شوند
-- ALTER SERVER ROLE [dbcreator] DROP MEMBER [rdbu];
-- ALTER SERVER ROLE [diskadmin] DROP MEMBER [rdbu];
-- ALTER SERVER ROLE [serveradmin] DROP MEMBER [rdbu];
-- و غیره...
