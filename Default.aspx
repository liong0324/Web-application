<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LumoraWebForms.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-7 hero-content">
                    <h1 class="hero-title">Learn Without Limits — Start Your Journey Today</h1>
                    <p class="hero-subtitle">An interactive learning platform combining professional content with engaging challenges, gamified experiences, and a supportive community.</p>
                    <div class="d-flex gap-3 flex-wrap">
                        <a href="<%= ResolveUrl("~/Pages/Courses.aspx") %>" class="btn-hero-primary">
                            <i class="bi bi-rocket-takeoff me-2"></i>Explore Courses
                        </a>
                        <a href="<%= ResolveUrl("~/Pages/About.aspx") %>" class="btn-hero-secondary">
                            <i class="bi bi-play-circle me-2"></i>See How It Works
                        </a>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block text-center">
                    <div style="font-size:8rem;opacity:0.3;color:white;">
                        <i class="bi bi-lightbulb"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <div class="container">
        <div class="stats-bar glass-card">
            <div class="row">
                <div class="col-6 col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" id="statStudents">0</div>
                        <div class="stat-label">Registered Students</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" id="statCourses">0</div>
                        <div class="stat-label">Courses</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-item">
                        <div class="stat-number" id="statQuizzes">0</div>
                        <div class="stat-label">Interactive Quizzes</div>
                    </div>
                </div>
                <div class="col-6 col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">98%</div>
                        <div class="stat-label">Satisfaction Rate</div>
                    </div>
                </div>
            </div>
        </div>

        <section class="py-5 mt-4">
            <h2 class="section-title">Why <span class="text-gradient">LUMORA</span>?</h2>
            <p class="section-subtitle">Everything you need for an effective and engaging learning experience</p>
            <div class="row g-4">
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon purple"><i class="bi bi-bullseye"></i></div>
                        <h5>Learn at Your Own Pace</h5>
                        <p class="text-muted small">Content broken into small, trackable steps that fit your schedule.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon gold"><i class="bi bi-trophy"></i></div>
                        <h5>Achievement System</h5>
                        <p class="text-muted small">Earn points and badges as you complete lessons and quizzes.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon teal"><i class="bi bi-graph-up"></i></div>
                        <h5>Track Your Progress</h5>
                        <p class="text-muted small">Visual charts showing your performance in real time.</p>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="feature-card">
                        <div class="feature-icon green"><i class="bi bi-people"></i></div>
                        <h5>Interactive Community</h5>
                        <p class="text-muted small">Discussions, peer support, and collaborative learning.</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-5">
            <h2 class="section-title">Featured <span class="text-gradient">Courses</span></h2>
            <p class="section-subtitle">Explore our most popular courses handpicked for you</p>
            <div class="row g-4">
            <asp:Repeater ID="rptCourses" runat="server">
                <ItemTemplate>
                    <div class="col-md-6 col-lg-4">
                        <div class="course-card">
                            <div class="course-card-img">
                                <i class="bi bi-book"></i>
                                <span class="level-badge beginner"><%# Eval("Level") %></span>
                            </div>
                            <div class="course-card-body">
                                <span class="badge" style="background:rgba(108,92,231,0.1);color:var(--primary);margin-bottom:0.5rem;"><%# Eval("CategoryName") %></span>
                                <h5 class="course-card-title"><%# Eval("Title") %></h5>
                                <p class="course-card-desc"><%# Eval("Description") %></p>
                                <div class="course-card-meta mb-3">
                                    <span><i class="bi bi-file-earmark-play me-1"></i><%# Eval("LessonCount") %> lessons</span>
                                    <span><i class="bi bi-people me-1"></i><%# Eval("EnrollmentCount") %> students</span>
                                </div>
                                <a href='CourseDetail.aspx?id=<%# Eval("Id") %>' class="btn-lumora-primary w-100 text-center">
                                    View Details <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            </div>
            <div class="text-center mt-4">
                <a href="<%= ResolveUrl("~/Pages/Courses.aspx") %>" class="btn-lumora-secondary">View All Courses <i class="bi bi-arrow-right ms-1"></i></a>
            </div>
        </section>

        <section class="py-5">
            <h2 class="section-title">Multimedia <span class="text-gradient">Showcase</span></h2>
            <p class="section-subtitle">Experience interactive learning with rich multimedia content</p>
            <div class="row g-4">
                <div class="col-lg-6">
                    <div class="multimedia-card">
                        <div class="p-3">
                            <h6 class="mb-3"><i class="bi bi-camera-video me-2 text-primary"></i>Video Lesson Preview</h6>
                            <video controls style="width:100%;border-radius:12px;background:#1a1a2e;">
                                <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4">
                            </video>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="multimedia-card">
                        <div class="p-3">
                            <h6 class="mb-3"><i class="bi bi-headphones me-2 text-primary"></i>Audio Lesson Sample</h6>
                            <audio controls style="width:100%;border-radius:12px;">
                                <source src="https://www.w3schools.com/html/horse.mp3" type="audio/mpeg">
                            </audio>
                            <div class="mt-3">
                                <div class="d-flex align-items-center p-3 rounded-lg" style="background:var(--bg-primary);">
                                    <i class="bi bi-music-note-beamed text-primary me-3" style="font-size:1.5rem;"></i>
                                    <div>
                                        <small class="text-muted">Now Playing</small>
                                        <div class="fw-semibold">Introduction to Web Development</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-5">
            <h2 class="section-title">What Students <span class="text-gradient">Say</span></h2>
            <p class="section-subtitle">Join thousands of satisfied learners</p>
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="testimonial-avatar">A</div>
                        <div class="testimonial-stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="mb-3">"LUMORA transformed my learning experience. The gamification makes studying fun and I can track my progress easily!"</p>
                        <strong>Ahmed K.</strong>
                        <div class="small text-muted">Computer Science Student</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="testimonial-avatar">S</div>
                        <div class="testimonial-stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="mb-3">"The interactive quizzes and badges keep me motivated. I've completed 5 courses in just 2 months!"</p>
                        <strong>Sara M.</strong>
                        <div class="small text-muted">Software Engineering Student</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="testimonial-card">
                        <div class="testimonial-avatar">J</div>
                        <div class="testimonial-stars"><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i></div>
                        <p class="mb-3">"Best learning platform I've used. The dark mode and clean design make it a pleasure to use every day."</p>
                        <strong>John L.</strong>
                        <div class="small text-muted">Data Science Student</div>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-5 mb-5">
            <div class="cta-section">
                <h2 class="cta-title">Ready to Start Learning?</h2>
                <p class="cta-subtitle">Join thousands of learners and begin your journey today.</p>
                <a href="<%= ResolveUrl("~/Pages/Register.aspx") %>" class="btn-cta">
                    <i class="bi bi-rocket-takeoff me-2"></i>Create Your Free Account
                </a>
            </div>
        </section>
    </div>
</asp:Content>
