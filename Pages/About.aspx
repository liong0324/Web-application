<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="LumoraWebForms.Pages.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .about-feature { transition: transform 0.3s ease; }
        .about-feature:hover { transform: translateY(-5px); }
        .about-list li { padding: 0.5rem 0; border-bottom: 1px solid rgba(108,92,231,0.1); }
    </style>
    <div class="container py-5">
        <div class="text-center mb-5">
            <h1 class="section-title">About <span class="text-gradient">LUMORA</span></h1>
            <p class="section-subtitle">Illuminate your learning journey</p>
        </div>
        <div class="row g-4 mb-5">
            <div class="col-lg-6">
                <article class="glass-card p-4">
                    <h3><i class="bi bi-lightbulb me-2 text-primary"></i>Our Mission</h3>
                    <p class="text-muted">LUMORA is dedicated to providing accessible, interactive, and engaging digital learning resources. We believe education should be available to everyone, combining professional content with gamified experiences that make learning enjoyable and effective.</p>
                </article>
            </div>
            <div class="col-lg-6">
                <article class="glass-card p-4">
                    <h3><i class="bi bi-eye me-2 text-primary"></i>Our Vision</h3>
                    <p class="text-muted">To become the leading interactive learning platform where students can learn at their own pace, track their progress, earn achievements, and join a supportive community of learners worldwide.</p>
                </article>
            </div>
        </div>
        <article class="glass-card p-5 mb-5">
            <h3 class="text-center mb-4">Technology Stack</h3>
            <div class="row text-center">
                <div class="col-md-3 col-6 mb-4">
                    <div class="feature-icon purple mx-auto"><i class="bi bi-code-slash"></i></div>
                    <h6 class="mt-2">ASP.NET WebForms</h6>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="feature-icon teal mx-auto"><i class="bi bi-database"></i></div>
                    <h6 class="mt-2">ADO.NET / SQL Server</h6>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="feature-icon gold mx-auto"><i class="bi bi-bootstrap"></i></div>
                    <h6 class="mt-2">Bootstrap 5</h6>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="feature-icon green mx-auto"><i class="bi bi-shield-lock"></i></div>
                    <h6 class="mt-2">Forms Authentication</h6>
                </div>
            </div>
        </article>
        <article class="glass-card p-5">
            <h3 class="text-center mb-4">What We Offer</h3>
            <div class="row">
                <div class="col-md-6">
                    <ul class="list-unstyled about-list">
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Interactive courses with hands-on projects</li>
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Gamified learning with points and badges</li>
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Real-time progress tracking</li>
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Self-paced learning with flexible schedules</li>
                    </ul>
                </div>
                <div class="col-md-6">
                    <ul class="list-unstyled about-list">
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Quizzes and assessments</li>
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Community discussions and peer support</li>
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Leaderboard and achievement system</li>
                        <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Dark/Light mode for comfortable studying</li>
                    </ul>
                </div>
            </div>
        </article>
    </div>
</asp:Content>
