CREATE DATABASE LumoraDB;
GO
USE LumoraDB;
GO

CREATE TABLE Users (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(200) NOT NULL UNIQUE,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(200) NOT NULL,
    Bio NVARCHAR(500) NULL,
    Role NVARCHAR(20) DEFAULT 'Member',
    IsActive BIT DEFAULT 1,
    Points INT DEFAULT 0,
    Level NVARCHAR(20) DEFAULT 'Bronze',
    DateJoined DATETIME DEFAULT GETDATE()
);

CREATE TABLE Categories (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    IconClass NVARCHAR(100) NULL
);

CREATE TABLE Courses (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Description NVARCHAR(2000) NULL,
    ThumbnailUrl NVARCHAR(500) NULL,
    CategoryId INT REFERENCES Categories(Id),
    InstructorId INT REFERENCES Users(Id),
    Price DECIMAL(18,2) DEFAULT 0,
    IsPublished BIT DEFAULT 1,
    EnrollmentCount INT DEFAULT 0,
    Level NVARCHAR(20) DEFAULT 'Beginner',
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE Lessons (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    Content NVARCHAR(MAX) NULL,
    CourseId INT REFERENCES Courses(Id),
    [Order] INT DEFAULT 1,
    VideoUrl NVARCHAR(500) NULL,
    DurationMinutes INT DEFAULT 30,
    IsPreview BIT DEFAULT 0
);

CREATE TABLE Enrollments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT REFERENCES Users(Id),
    CourseId INT REFERENCES Courses(Id),
    EnrollmentDate DATETIME DEFAULT GETDATE(),
    Progress INT DEFAULT 0,
    IsCompleted BIT DEFAULT 0,
    CompletedDate DATETIME NULL,
    UNIQUE(UserId, CourseId)
);

CREATE TABLE Quizzes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(200) NOT NULL,
    LessonId INT REFERENCES Lessons(Id),
    TimeLimitMinutes INT DEFAULT 30,
    PassingScore INT DEFAULT 70
);

CREATE TABLE QuizQuestions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    QuestionText NVARCHAR(1000) NOT NULL,
    QuizId INT REFERENCES Quizzes(Id),
    Option1 NVARCHAR(500) NULL,
    Option2 NVARCHAR(500) NULL,
    Option3 NVARCHAR(500) NULL,
    Option4 NVARCHAR(500) NULL,
    CorrectOption INT DEFAULT 1
);

CREATE TABLE QuizResults (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT REFERENCES Users(Id),
    QuizId INT REFERENCES Quizzes(Id),
    Score INT DEFAULT 0,
    TotalQuestions INT DEFAULT 0,
    CorrectAnswers INT DEFAULT 0,
    Passed BIT DEFAULT 0,
    DateTaken DATETIME DEFAULT GETDATE()
);

CREATE TABLE Discussions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Message NVARCHAR(MAX) NOT NULL,
    LessonId INT REFERENCES Lessons(Id),
    UserId INT REFERENCES Users(Id),
    ParentId INT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    IsEdited BIT DEFAULT 0
);

CREATE TABLE Badges (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    IconUrl NVARCHAR(200) NULL,
    Condition NVARCHAR(50) NULL,
    PointsRequired INT DEFAULT 0
);

CREATE TABLE UserBadges (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT REFERENCES Users(Id),
    BadgeId INT REFERENCES Badges(Id),
    EarnedDate DATETIME DEFAULT GETDATE(),
    UNIQUE(UserId, BadgeId)
);

CREATE TABLE ContactMessages (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(200) NOT NULL,
    Subject NVARCHAR(200) NULL,
    Message NVARCHAR(MAX) NOT NULL,
    DateSent DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0
);

CREATE TABLE Notifications (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT REFERENCES Users(Id),
    Message NVARCHAR(500) NOT NULL,
    Type NVARCHAR(100) NULL,
    IsRead BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    Link NVARCHAR(200) NULL
);

-- Seed Categories
INSERT INTO Categories (Name, Description, IconClass) VALUES
('Web Development', 'HTML, CSS, JavaScript, ASP.NET', 'bi-code-slash'),
('Database', 'SQL, Entity Framework, Data Modeling', 'bi-database'),
('Software Engineering', 'Design Patterns, OOP, SDLC', 'bi-gear'),
('Data Science', 'Python, Machine Learning, Analytics', 'bi-graph-up'),
('Networking', 'TCP/IP, Security, Cloud', 'bi-wifi'),
('Cyber Security', 'Ethical Hacking, Penetration Testing', 'bi-shield-lock');

-- Seed Badges
INSERT INTO Badges (Name, Description, IconUrl, Condition, PointsRequired) VALUES
('First Steps', 'Complete your first lesson', 'bi-star-fill', 'FirstLesson', 10),
('Quiz Master', 'Pass your first quiz', 'bi-trophy-fill', 'FirstQuizPass', 25),
('Bookworm', 'Enroll in 5 courses', 'bi-book-fill', '5Courses', 50),
('High Scorer', 'Score 90%+ on any quiz', 'bi-award-fill', 'HighScore', 30),
('Committed Learner', 'Complete 3 courses', 'bi-award-fill', '3CoursesComplete', 100),
('Discussion Starter', 'Post your first discussion', 'bi-chat-fill', 'FirstPost', 15);

-- Seed Admin User (password: Admin@123)
INSERT INTO Users (FullName, Email, Username, PasswordHash, Role, IsActive) VALUES
('Administrator', 'admin@edulearn.com', 'admin', '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', 'Admin', 1);

-- Seed Instructor Users
INSERT INTO Users (FullName, Email, Username, PasswordHash, Role, IsActive) VALUES
('Dr. Sarah Johnson', 'instructor@edulearn.com', 'instructor', '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', 'Member', 1),
('Dr. Ahmed Hassan', 'ahmed@edulearn.com', 'dr.ahmed', '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', 'Member', 1),
('Prof. Emily Chen', 'emily@edulearn.com', 'prof.emily', '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', 'Member', 1);

-- Seed Student User (password: Student@123)
INSERT INTO Users (FullName, Email, Username, PasswordHash, Role, IsActive) VALUES
('John Smith', 'student@edulearn.com', 'student', 'sqH0/QpGBgazTIkT4pgdrI0uKD13irpYbEFu4mKb+lQ=', 'Member', 1);

-- Seed Courses
INSERT INTO Courses (Title, Description, CategoryId, InstructorId, Price, IsPublished, EnrollmentCount, Level) VALUES
('Introduction to HTML5 & CSS3', 'Learn the fundamentals of web development with HTML5 and CSS3.', 1, 2, 0, 1, 125, 'Beginner'),
('JavaScript Fundamentals', 'Master JavaScript from basics to advanced concepts.', 1, 2, 0, 1, 98, 'Beginner'),
('Database Design with SQL', 'Learn relational database design, SQL queries, normalization.', 2, 4, 0, 1, 76, 'Intermediate'),
('Object-Oriented Programming in C#', 'Comprehensive guide to OOP principles in C#.', 3, 5, 0, 1, 64, 'Intermediate'),
('Ethical Hacking & Penetration Testing', 'Learn ethical hacking techniques and vulnerability assessment.', 6, 3, 0, 1, 142, 'Intermediate'),
('Python for Data Science', 'Master Python programming for data analysis and ML.', 4, 4, 0, 1, 203, 'Beginner'),
('ASP.NET Core MVC Masterclass', 'Build modern web applications with ASP.NET Core MVC.', 1, 2, 0, 1, 156, 'Intermediate'),
('Advanced SQL & Database Optimization', 'Master advanced SQL queries and performance tuning.', 2, 4, 0, 1, 45, 'Advanced');
