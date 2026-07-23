<%@ Page Title="Instructor Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LumoraWebForms.Pages.Instructor.InstructorDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="dashboard-welcome slide-up mb-4">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-1">Welcome, <asp:Literal ID="litName" runat="server" /> &#x1F44B;</h2>
                    <p class="mb-0" style="color:rgba(255,255,255,0.85);">Manage your courses and track student progress.</p>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon purple mx-auto mb-2"><i class="bi bi-collection-play"></i></div>
                    <h4 class="mb-0 text-gradient"><asp:Literal ID="litMyCourses" runat="server" /></h4>
                    <small class="text-muted">My Courses</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon teal mx-auto mb-2"><i class="bi bi-people"></i></div>
                    <h4 class="mb-0" style="color:var(--secondary);"><asp:Literal ID="litTotalStudents" runat="server" /></h4>
                    <small class="text-muted">Total Students</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon gold mx-auto mb-2"><i class="bi bi-patch-question"></i></div>
                    <h4 class="mb-0" style="color:var(--accent-dark);"><asp:Literal ID="litTotalQuizzes" runat="server" /></h4>
                    <small class="text-muted">Quizzes</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon green mx-auto mb-2"><i class="bi bi-check-circle"></i></div>
                    <h4 class="mb-0" style="color:var(--success);"><asp:Literal ID="litCompletions" runat="server" /></h4>
                    <small class="text-muted">Completions</small>
                </div>
            </div>
        </div>

        <div class="glass-card p-0">
            <div class="p-3 border-bottom" style="border-color:var(--border-color)!important;">
                <h5 class="mb-0"><i class="bi bi-collection-play me-2 text-primary"></i>My Courses</h5>
            </div>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>Course</th><th>Category</th><th>Level</th><th>Students</th><th>Status</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptCourses" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><strong><%# Eval("Title") %></strong></td>
                                    <td><small class="text-muted"><%# Eval("CategoryName") %></small></td>
                                    <td><span class="badge" style="background:rgba(108,92,231,0.15);color:var(--primary);"><%# Eval("Level") %></span></td>
                                    <td><%# Eval("EnrollmentCount") %></td>
                                    <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("IsPublished")) ? "var(--success)" : "var(--warning)" %>;color:white;"><%# Convert.ToBoolean(Eval("IsPublished")) ? "Published" : "Draft" %></span></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
