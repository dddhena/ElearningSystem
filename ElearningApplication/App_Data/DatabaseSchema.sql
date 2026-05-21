

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

-- Assignments and Submissions
CREATE TABLE Assignments (
    AssignmentId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    DueDate DATETIME NOT NULL,
    MaxScore INT DEFAULT 100,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE AssignmentSubmissions (
    SubmissionId INT IDENTITY(1,1) PRIMARY KEY,
    AssignmentId INT NOT NULL,
    UserId INT NOT NULL,
    SubmissionDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT 'Submitted' CHECK (Status IN ('Submitted', 'Graded', 'Late')),
    Grade INT NULL,
    Feedback NVARCHAR(MAX) NULL,
    FOREIGN KEY (AssignmentId) REFERENCES Assignments(AssignmentId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT UQ_AssignmentSubmission UNIQUE (AssignmentId, UserId)
);

CREATE TABLE AssignmentSubmissionFiles (
    FileId INT IDENTITY(1,1) PRIMARY KEY,
    SubmissionId INT NOT NULL,
    FileName NVARCHAR(500) NOT NULL,
    FilePath NVARCHAR(1000) NOT NULL,
    UploadedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubmissionId) REFERENCES AssignmentSubmissions(SubmissionId)
);

-- Assessments (Quizzes) and Questions
CREATE TABLE Assessments (
    AssessmentId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    DurationMinutes INT DEFAULT 60,
    TotalMarks INT DEFAULT 100,
    PassingMarks INT DEFAULT 50,
    CreatedAt DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT 'Draft' CHECK (Status IN ('Draft', 'Published', 'Closed')),
    FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE AssessmentQuestions (
    QuestionId INT IDENTITY(1,1) PRIMARY KEY,
    AssessmentId INT NOT NULL,
    QuestionText NVARCHAR(MAX) NOT NULL,
    QuestionType NVARCHAR(50) NOT NULL CHECK (QuestionType IN ('MultipleChoice', 'TrueFalse', 'ShortAnswer')),
    OptionA NVARCHAR(500) NULL,
    OptionB NVARCHAR(500) NULL,
    OptionC NVARCHAR(500) NULL,
    OptionD NVARCHAR(500) NULL,
    CorrectAnswer NVARCHAR(500) NOT NULL, -- Stores 'A', 'B', 'C', 'D' or 'True'/'False' or the short answer text
    Marks INT DEFAULT 1,
    FOREIGN KEY (AssessmentId) REFERENCES Assessments(AssessmentId)
);

CREATE TABLE AssessmentSubmissions (
    SubmissionId INT IDENTITY(1,1) PRIMARY KEY,
    AssessmentId INT NOT NULL,
    UserId INT NOT NULL,
    StartTime DATETIME DEFAULT GETDATE(),
    EndTime DATETIME NULL,
    Score INT DEFAULT 0,
    Status NVARCHAR(50) DEFAULT 'InProgress' CHECK (Status IN ('InProgress', 'Submitted', 'Graded')),
    FOREIGN KEY (AssessmentId) REFERENCES Assessments(AssessmentId),
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    CONSTRAINT UQ_AssessmentSubmission UNIQUE (AssessmentId, UserId)
);

CREATE TABLE StudentAnswers (
    AnswerId INT IDENTITY(1,1) PRIMARY KEY,
    SubmissionId INT NOT NULL,
    QuestionId INT NOT NULL,
    GivenAnswer NVARCHAR(MAX) NULL, -- Can be 'A', 'B', text, etc.
    MarksObtained INT DEFAULT 0,
    FOREIGN KEY (SubmissionId) REFERENCES AssessmentSubmissions(SubmissionId),
    FOREIGN KEY (QuestionId) REFERENCES AssessmentQuestions(QuestionId)
);
