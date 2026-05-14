
IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'admin@example.com')
BEGIN
    INSERT INTO Users (Email, PasswordHash, FirstName, LastName, Role, IsActive)
    VALUES ('admin@example.com', 'adminpassword', 'Sarah', 'Admin', 'Admin', 1);
    PRINT 'Admin user created.';
END
ELSE
BEGIN
    PRINT 'Admin user already exists.';
END

IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = 'instructor@example.com')
BEGIN
    INSERT INTO Users (Email, PasswordHash, FirstName, LastName, Role, IsActive)
    VALUES ('instructor@example.com', 'password123', 'John', 'Instructor', 'Instructor', 1);
    PRINT 'Instructor user created.';
END
ELSE
BEGIN
    PRINT 'Instructor user already exists.';
END
GO
