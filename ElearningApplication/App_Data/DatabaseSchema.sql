

CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    Email NVARCHAR(256) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(500) NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Admin', 'Instructor', 'Student')),
    ProfilePicture NVARCHAR(500) NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    LastLoginAt DATETIME NULL
);

CREATE TABLE UserSessions (
    SessionId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Token NVARCHAR(500) NOT NULL,
    IPAddress NVARCHAR(50) NULL,
    UserAgent NVARCHAR(500) NULL,
    LoginTime DATETIME DEFAULT GETDATE(),
    LogoutTime DATETIME NULL,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    InstructorId INT NOT NULL,
    Category NVARCHAR(100) NULL,
    Level NVARCHAR(50) CHECK (Level IN ('Beginner', 'Intermediate', 'Advanced')),
    Thumbnail NVARCHAR(500) NULL,
    Price DECIMAL(10,2) DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Draft' CHECK (Status IN ('Draft', 'Published', 'Archived')),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (InstructorId) REFERENCES Users(UserId)
);

CREATE TABLE Enrollments (
    EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    EnrolledAt DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'Active' CHECK (Status IN ('Active', 'Completed', 'Dropped')),
    ExpiresAt DATETIME NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    CONSTRAINT UQ_Enrollment UNIQUE (UserId, CourseId)
);

CREATE TABLE Modules (
    ModuleId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    OrderNumber INT NOT NULL,
    IsLocked BIT DEFAULT 0,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE Lessons (
    LessonId INT IDENTITY(1,1) PRIMARY KEY,
    ModuleId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NULL,
    VideoUrl NVARCHAR(500) NULL,
    Duration INT DEFAULT 0,
    OrderNumber INT NOT NULL,
    FOREIGN KEY (ModuleId) REFERENCES Modules(ModuleId)
);

CREATE TABLE Messages (
    MessageId INT IDENTITY(1,1) PRIMARY KEY,
    SenderId INT NOT NULL,
    CourseId INT NOT NULL,
    Content NVARCHAR(500) NOT NULL,
    Timestamp DATETIME DEFAULT GETDATE(),
    IsPinned BIT DEFAULT 0,
    IsRead BIT DEFAULT 0,
    ReplyToMessageId INT NULL,
    FOREIGN KEY (SenderId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    FOREIGN KEY (ReplyToMessageId) REFERENCES Messages(MessageId)
);

CREATE TABLE Notifications (
    NotificationId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Message NVARCHAR(500) NOT NULL,
    Type NVARCHAR(50) CHECK (Type IN ('Info', 'Warning', 'Urgent', 'Success')),
    RelatedUrl NVARCHAR(500) NULL,
    IsRead BIT DEFAULT 0,
    IsDeleted BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE Questions (
    QuestionId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NOT NULL,
    Answer NVARCHAR(MAX) NULL,
    AnsweredBy INT NULL,
    IsAnswered BIT DEFAULT 0,
    IsPinned BIT DEFAULT 0,
    Upvotes INT DEFAULT 0,
    Tags NVARCHAR(200) NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    AnsweredAt DATETIME NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    FOREIGN KEY (AnsweredBy) REFERENCES Users(UserId)
);

CREATE TABLE OnlineUsers (
    OnlineUserId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    ConnectionId NVARCHAR(100) NOT NULL,
    LastActivity DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE Feedbacks (
    FeedbackId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(MAX) NULL,
    IsAnonymous BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    InstructorReply NVARCHAR(MAX) NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    CONSTRAINT UQ_Feedback UNIQUE (UserId, CourseId)
);

CREATE TABLE Progress (
    ProgressId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    CompletionPercentage INT DEFAULT 0 CHECK (CompletionPercentage BETWEEN 0 AND 100),
    ModulesCompleted INT DEFAULT 0,
    TotalModules INT DEFAULT 0,
    LastActivity DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'NotStarted' CHECK (Status IN ('NotStarted', 'InProgress', 'Completed')),
    StartedAt DATETIME NULL,
    CompletedAt DATETIME NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    CONSTRAINT UQ_Progress UNIQUE (UserId, CourseId)
);

CREATE TABLE LessonProgress (
    LessonProgressId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    LessonId INT NOT NULL,
    IsCompleted BIT DEFAULT 0,
    CompletedAt DATETIME NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (LessonId) REFERENCES Lessons(LessonId),
    CONSTRAINT UQ_LessonProgress UNIQUE (UserId, LessonId)
);

CREATE TABLE Attendances (
    AttendanceId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    SessionTitle NVARCHAR(200) NOT NULL,
    JoinTime DATETIME DEFAULT GETDATE(),
    LeaveTime DATETIME NULL,
    DurationMinutes INT DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Present' CHECK (Status IN ('Present', 'Absent', 'Late', 'Excused')),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE EngagementScores (
    EngagementId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL,
    CourseId INT NOT NULL,
    Score INT DEFAULT 0 CHECK (Score BETWEEN 0 AND 100),
    MessagesSent INT DEFAULT 0,
    QuestionsAsked INT DEFAULT 0,
    FeedbacksGiven INT DEFAULT 0,
    LessonsCompleted INT DEFAULT 0,
    SessionsAttended INT DEFAULT 0,
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    CONSTRAINT UQ_Engagement UNIQUE (UserId, CourseId)
);

CREATE TABLE Materials (
    MaterialId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    FileName NVARCHAR(500) NOT NULL,
    FilePath NVARCHAR(1000) NOT NULL,
    FileSize BIGINT NOT NULL,
    FileType NVARCHAR(50) NOT NULL,
    UploadedBy INT NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    DownloadCount INT DEFAULT 0,
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
    FOREIGN KEY (UploadedBy) REFERENCES Users(UserId)
);
