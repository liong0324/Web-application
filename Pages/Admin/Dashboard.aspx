<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LumoraWebForms.Pages.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <h2 class="mb-4"><i class="bi bi-speedometer2 me-2 text-primary"></i>Admin Dashboard</h2>

        <div class="row g-4 mb-4">
            <div class="col-6 col-md-4 col-lg-2">
                <div class="admin-stat-card text-center">
                    <div class="admin-stat-icon mx-auto" style="background:rgba(108,92,231,0.1);color:var(--primary);"><i class="bi bi-people"></i></div>
                    <div class="admin-stat-number text-gradient"><asp:Literal ID="litUsers" runat="server" /></div>
                    <small class="text-muted">Users</small>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="admin-stat-card text-center">
                    <div class="admin-stat-icon mx-auto" style="background:rgba(0,206,201,0.1);color:var(--secondary);"><i class="bi bi-collection-play"></i></div>
                    <div class="admin-stat-number" style="color:var(--secondary);"><asp:Literal ID="litCourses" runat="server" /></div>
                    <small class="text-muted">Courses</small>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="admin-stat-card text-center">
                    <div class="admin-stat-icon mx-auto" style="background:rgba(0,184,148,0.1);color:var(--success);"><i class="bi bi-people-fill"></i></div>
                    <div class="admin-stat-number" style="color:var(--success);"><asp:Literal ID="litEnrollments" runat="server" /></div>
                    <small class="text-muted">Enrollments</small>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="admin-stat-card text-center">
                    <div class="admin-stat-icon mx-auto" style="background:rgba(253,203,110,0.15);color:var(--accent-dark);"><i class="bi bi-file-earmark-play"></i></div>
                    <div class="admin-stat-number" style="color:var(--accent-dark);"><asp:Literal ID="litLessons" runat="server" /></div>
                    <small class="text-muted">Lessons</small>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="admin-stat-card text-center">
                    <div class="admin-stat-icon mx-auto" style="background:rgba(231,76,60,0.1);color:var(--danger);"><i class="bi bi-envelope"></i></div>
                    <div class="admin-stat-number" style="color:var(--danger);"><asp:Literal ID="litMessages" runat="server" /></div>
                    <small class="text-muted">Messages</small>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="glass-card p-4 mb-4">
                    <h5 class="mb-3">Recent Courses</h5>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead><tr><th>Title</th><th>Category</th><th>Status</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptRecentCourses" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong><%# Eval("Title") %></strong></td>
                                            <td><span class="badge" style="background:rgba(108,92,231,0.1);color:var(--primary);"><%# Eval("CategoryName") %></span></td>
                                            <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("IsPublished")) ? "var(--success)" : "var(--text-muted)" %>;color:white;"><%# Convert.ToBoolean(Eval("IsPublished")) ? "Published" : "Draft" %></span></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="glass-card p-4">
                    <h5 class="mb-3">Quick Actions</h5>
                    <div class="d-grid gap-2">
                        <a href="ManageCourses.aspx" class="btn btn-lumora-secondary"><i class="bi bi-collection-play me-2"></i>Manage Courses</a>
                        <a href="ManageUsers.aspx" class="btn btn-lumora-secondary"><i class="bi bi-people me-2"></i>Manage Users</a>
                        <a href="Messages.aspx" class="btn btn-lumora-secondary"><i class="bi bi-envelope me-2"></i>Messages</a>
                        <a href="ManageCategories.aspx" class="btn btn-lumora-secondary"><i class="bi bi-tags me-2"></i>Categories</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
