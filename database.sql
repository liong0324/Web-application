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
('Dr. Sarah Johnson', 'instructor@edulearn.com', 'instructor', '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', 'Instructor', 1),
('Dr. Ahmed Hassan', 'ahmed@edulearn.com', 'dr.ahmed', '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', 'Instructor', 1),
('Prof. Emily Chen', 'emily@edulearn.com', 'prof.emily', '6G94qKPK8LYNjnTllCqm2G3BUM08AzOK7yW30tfjrMc=', 'Instructor', 1);

-- Seed Student User (password: Student@123)
INSERT INTO Users (FullName, Email, Username, PasswordHash, Role, IsActive) VALUES
('John Smith', 'student@edulearn.com', 'student', 'sqH0/QpGBgazTIkT4pgdrI0uKD13irpYbEFu4mKb+lQ=', 'Member', 1);

-- Seed Courses
INSERT INTO Courses (Title, Description, CategoryId, InstructorId, Price, IsPublished, Level) VALUES
('Introduction to HTML5 & CSS3', 'Learn the fundamentals of web development with HTML5 and CSS3.', 1, 2, 0, 1, 'Beginner'),
('JavaScript Fundamentals', 'Master JavaScript from basics to advanced concepts.', 1, 2, 0, 1, 'Beginner'),
('Database Design with SQL', 'Learn relational database design, SQL queries, normalization.', 2, 4, 0, 1, 'Intermediate'),
('Object-Oriented Programming in C#', 'Comprehensive guide to OOP principles in C#.', 3, 3, 0, 1, 'Intermediate'),
('Ethical Hacking & Penetration Testing', 'Learn ethical hacking techniques and vulnerability assessment.', 6, 3, 0, 1, 'Intermediate'),
('Python for Data Science', 'Master Python programming for data analysis and ML.', 4, 4, 0, 1, 'Beginner'),
('ASP.NET Core MVC Masterclass', 'Build modern web applications with ASP.NET Core MVC.', 1, 2, 0, 1, 'Intermediate'),
('Advanced SQL & Database Optimization', 'Master advanced SQL queries and performance tuning.', 2, 4, 0, 1, 'Advanced');

-- Seed Lessons
INSERT INTO Lessons (Title, Content, CourseId, [Order], DurationMinutes, IsPreview) VALUES
-- Course 1: Introduction to HTML5 & CSS3
(N'Getting Started with HTML5', N'<h3>What is HTML?</h3><p>HTML (HyperText Markup Language) is the standard markup language for creating web pages. It describes the structure of a web page using elements and tags.</p><h4>Basic Document Structure</h4><pre>&lt;!DOCTYPE html&gt;\n&lt;html&gt;\n  &lt;head&gt;&lt;title&gt;My Page&lt;/title&gt;&lt;/head&gt;\n  &lt;body&gt;&lt;h1&gt;Hello World&lt;/h1&gt;&lt;/body&gt;\n&lt;/html&gt;</pre><p>Every HTML document needs a <strong>DOCTYPE</strong>, <strong>html</strong>, <strong>head</strong>, and <strong>body</strong> element.</p>', 1, 1, 25, 1),
(N'Semantic HTML Elements', N'<h3>Semantic HTML</h3><p>Semantic elements clearly describe their meaning to both browser and developer. Examples include <code>&lt;header&gt;</code>, <code>&lt;nav&gt;</code>, <code>&lt;main&gt;</code>, <code>&lt;article&gt;</code>, <code>&lt;section&gt;</code>, and <code>&lt;footer&gt;</code>.</p><p>Using semantic HTML improves accessibility and SEO.</p><ul><li><strong>&lt;header&gt;</strong> - introductory content</li><li><strong>&lt;nav&gt;</strong> - navigation links</li><li><strong>&lt;main&gt;</strong> - main content area</li></ul>', 1, 2, 30, 0),
(N'CSS3 Styling Fundamentals', N'<h3>Introduction to CSS</h3><p>CSS (Cascading Style Sheets) controls the presentation of HTML elements. You can link external stylesheets, use internal styles, or apply inline styles.</p><pre>body { font-family: Arial, sans-serif; }\n.highlight { color: #6C5CE7; font-weight: bold; }</pre><p>CSS selectors target elements by tag, class, or ID to apply visual styling consistently across your website.</p>', 1, 3, 35, 0),
-- Course 2: JavaScript Fundamentals
(N'JavaScript Basics', N'<h3>Variables and Data Types</h3><p>JavaScript uses <code>let</code>, <code>const</code>, and <code>var</code> to declare variables. Common data types include strings, numbers, booleans, arrays, and objects.</p><pre>let name = "LUMORA";\nconst year = 2026;\nlet isActive = true;</pre>', 2, 1, 30, 1),
(N'Functions and Control Flow', N'<h3>Functions</h3><p>Functions are reusable blocks of code. Use <code>if/else</code>, <code>for</code>, and <code>while</code> loops to control program flow.</p><pre>function greet(name) {\n  return "Hello, " + name;\n}</pre>', 2, 2, 35, 0),
(N'DOM Manipulation', N'<h3>The Document Object Model</h3><p>The DOM represents the HTML document as a tree of objects. JavaScript can select and modify elements using methods like <code>getElementById</code> and <code>querySelector</code>.</p><pre>document.getElementById("title").textContent = "Updated!";</pre>', 2, 3, 40, 0),
-- Course 3: Database Design with SQL
(N'Introduction to Relational Databases', N'<h3>What is a Database?</h3><p>A relational database stores data in tables with rows and columns. SQL is the language used to query and manage relational databases like SQL Server and MySQL.</p><p>Key concepts: tables, primary keys, foreign keys, and relationships.</p>', 3, 1, 30, 1),
(N'Writing SQL Queries', N'<h3>SELECT Statements</h3><p>The SELECT statement retrieves data from one or more tables.</p><pre>SELECT FullName, Email FROM Users WHERE IsActive = 1;</pre><p>Use JOIN to combine data from related tables.</p>', 3, 2, 35, 0),
(N'Database Normalization', N'<h3>Normalization</h3><p>Normalization reduces data redundancy by organizing fields and tables. First Normal Form (1NF), Second Normal Form (2NF), and Third Normal Form (3NF) are the most commonly applied rules.</p>', 3, 3, 40, 0),
-- Course 4: Object-Oriented Programming in C#
(N'Classes and Objects', N'<h3>OOP in C#</h3><p>Object-Oriented Programming organizes code into classes (blueprints) and objects (instances). C# supports encapsulation, inheritance, and polymorphism.</p><pre>public class Student {\n  public string Name { get; set; }\n}</pre>', 4, 1, 30, 1),
(N'Inheritance and Polymorphism', N'<h3>Inheritance</h3><p>A class can inherit properties and methods from a base class using the <code>:</code> syntax. Polymorphism allows objects of different types to be treated through a common interface.</p>', 4, 2, 35, 0),
(N'Interfaces and Abstract Classes', N'<h3>Interfaces</h3><p>Interfaces define a contract that implementing classes must follow. Abstract classes can provide partial implementation while requiring subclasses to complete it.</p>', 4, 3, 40, 0),
-- Course 5: Ethical Hacking & Penetration Testing
(N'Introduction to Cyber Security', N'<h3>Security Fundamentals</h3><p>Cyber security protects systems, networks, and data from digital attacks. Ethical hackers use the same techniques as malicious hackers but with permission to find vulnerabilities.</p>', 5, 1, 30, 1),
(N'Reconnaissance and Scanning', N'<h3>Information Gathering</h3><p>Reconnaissance is the first phase of penetration testing. Tools like Nmap scan networks to discover hosts, open ports, and running services.</p>', 5, 2, 35, 0),
(N'Vulnerability Assessment', N'<h3>Finding Weaknesses</h3><p>Vulnerability assessment identifies security flaws in systems. Common vulnerabilities include SQL injection, cross-site scripting (XSS), and misconfigured servers.</p>', 5, 3, 40, 0),
-- Course 6: Python for Data Science
(N'Python Basics for Data Science', N'<h3>Why Python?</h3><p>Python is widely used in data science due to libraries like NumPy, Pandas, and Matplotlib. It has simple syntax and a large ecosystem of data tools.</p><pre>import pandas as pd\ndf = pd.read_csv("data.csv")</pre>', 6, 1, 30, 1),
(N'Data Analysis with Pandas', N'<h3>Pandas DataFrames</h3><p>Pandas provides DataFrame structures for tabular data. You can filter, group, aggregate, and merge datasets efficiently.</p><pre>df.groupby("category").mean()</pre>', 6, 2, 35, 0),
(N'Data Visualization', N'<h3>Visualizing Data</h3><p>Matplotlib and Seaborn create charts and graphs to communicate insights. Visualizations help identify trends, outliers, and patterns in data.</p>', 6, 3, 40, 0),
-- Course 7: ASP.NET Core MVC Masterclass
(N'Introduction to ASP.NET MVC', N'<h3>MVC Pattern</h3><p>Model-View-Controller separates application logic into Models (data), Views (UI), and Controllers (request handling). ASP.NET MVC follows this pattern for building web applications.</p>', 7, 1, 30, 1),
(N'Routing and Controllers', N'<h3>Routing</h3><p>Routing maps URLs to controller actions. Convention-based routing uses patterns like <code>{controller}/{action}/{id}</code>.</p>', 7, 2, 35, 0),
(N'Views and Razor Syntax', N'<h3>Razor Views</h3><p>Razor is a markup syntax for embedding C# in HTML. Views render the UI and receive data from controllers via ViewModels.</p><pre>@model MyViewModel\n&lt;h1&gt;@Model.Title&lt;/h1&gt;</pre>', 7, 3, 40, 0),
-- Course 8: Advanced SQL & Database Optimization
(N'Advanced JOIN Techniques', N'<h3>Complex Joins</h3><p>Beyond INNER JOIN, SQL supports LEFT, RIGHT, FULL OUTER, and CROSS joins. Self-joins allow a table to join with itself for hierarchical data.</p>', 8, 1, 30, 1),
(N'Indexes and Query Performance', N'<h3>Database Indexes</h3><p>Indexes speed up data retrieval but add overhead to writes. Clustered and non-clustered indexes serve different purposes in query optimization.</p>', 8, 2, 35, 0),
(N'Stored Procedures and Optimization', N'<h3>Stored Procedures</h3><p>Stored procedures are precompiled SQL stored in the database. They improve performance, security, and maintainability for complex operations.</p>', 8, 3, 40, 0);

-- Seed Quizzes (one quiz per course, attached to the last lesson of each course)
INSERT INTO Quizzes (Title, LessonId, TimeLimitMinutes, PassingScore) VALUES
('HTML & CSS Quiz', 3, 15, 70),
('JavaScript Quiz', 6, 15, 70),
('SQL Fundamentals Quiz', 9, 15, 70),
('C# OOP Quiz', 12, 15, 70),
('Cyber Security Quiz', 15, 15, 70),
('Python Data Science Quiz', 18, 15, 70),
('ASP.NET MVC Quiz', 21, 15, 70),
('Advanced SQL Quiz', 24, 15, 70);

-- Seed Quiz Questions
INSERT INTO QuizQuestions (QuestionText, QuizId, Option1, Option2, Option3, Option4, CorrectOption) VALUES
-- Quiz 1: HTML & CSS
('What does HTML stand for?', 1, 'HyperText Markup Language', 'High Tech Modern Language', 'Home Tool Markup Language', 'Hyperlink Text Management Language', 1),
('Which tag is used for the largest heading?', 1, '<h6>', '<heading>', '<h1>', '<head>', 3),
('Which CSS property changes text color?', 1, 'font-size', 'color', 'background', 'margin', 2),
-- Quiz 2: JavaScript
('Which keyword declares a constant in JavaScript?', 2, 'var', 'let', 'const', 'static', 3),
('What does DOM stand for?', 2, 'Document Object Model', 'Data Object Management', 'Digital Output Method', 'Dynamic Object Module', 1),
('Which method selects an element by ID?', 2, 'querySelectorAll', 'getElementById', 'getElementsByClass', 'findElement', 2),
-- Quiz 3: SQL
('Which SQL statement retrieves data?', 3, 'INSERT', 'UPDATE', 'SELECT', 'DELETE', 3),
('What is a primary key?', 3, 'A duplicate column', 'A unique identifier for each row', 'A foreign reference', 'An optional field', 2),
('Which clause filters rows in SQL?', 3, 'ORDER BY', 'GROUP BY', 'WHERE', 'HAVING', 3),
-- Quiz 4: C# OOP
('What is encapsulation?', 4, 'Hiding data and exposing methods', 'Copying a class', 'Multiple inheritance', 'Deleting objects', 1),
('Which keyword defines a class in C#?', 4, 'struct', 'class', 'object', 'define', 2),
('What is polymorphism?', 4, 'One interface, many forms', 'Single inheritance only', 'Static typing', 'Memory management', 1),
-- Quiz 5: Cyber Security
('What is ethical hacking?', 5, 'Hacking without permission', 'Authorized security testing', 'Spreading malware', 'Password guessing only', 2),
('What is SQL injection?', 5, 'A database backup method', 'Inserting malicious SQL via input', 'A type of encryption', 'A network protocol', 2),
('What does XSS stand for?', 5, 'Cross-Site Scripting', 'Extended Security System', 'XML Style Sheets', 'Cross Server Sync', 1),
-- Quiz 6: Python Data Science
('Which library is used for data frames?', 6, 'Matplotlib', 'Pandas', 'Flask', 'Django', 2),
('What function reads a CSV file in Pandas?', 6, 'read_csv', 'load_csv', 'open_csv', 'import_csv', 1),
('Which library is commonly used for plotting?', 6, 'NumPy', 'Matplotlib', 'Requests', 'BeautifulSoup', 2),
-- Quiz 7: ASP.NET MVC
('What does MVC stand for?', 7, 'Model View Controller', 'Main Virtual Component', 'Managed View Code', 'Module View Class', 1),
('Which file defines routes in ASP.NET MVC?', 7, 'Web.config', 'RouteConfig.cs', 'Global.asax only', 'App.config', 2),
('What is Razor?', 7, 'A database engine', 'A markup syntax for C# in HTML', 'A CSS framework', 'A JavaScript library', 2),
-- Quiz 8: Advanced SQL
('Which JOIN returns all rows from both tables?', 8, 'INNER JOIN', 'LEFT JOIN', 'FULL OUTER JOIN', 'CROSS JOIN', 3),
('What improves SELECT query speed?', 8, 'Deleting tables', 'Adding indexes', 'Removing columns', 'Disabling constraints', 2),
('What is a stored procedure?', 8, 'A precompiled SQL routine in the database', 'A temporary table', 'An export file', 'A backup script', 1);
