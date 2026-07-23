<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="LumoraWebForms.Pages.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="dashboard-welcome slide-up">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-1" style="font-size:2.4rem;font-weight:800;">Welcome back, <asp:Literal ID="litUserName" runat="server" /> &#x1F44B;</h1>
                    <div class="d-flex align-items-center gap-3 mt-2">
                        <% string role = Session["Role"] != null ? Session["Role"].ToString() : ""; %>
                        <% if (role == "Member") { %>
                            <span class="level-badge-lg level-<%= (Session["Level"] ?? "Bronze").ToString().ToLower() %>"><%= Session["Level"] ?? "Bronze" %> Learner</span>
                        <% } else if (role == "Instructor") { %>
                            <span class="level-badge-lg" style="background:rgba(0,206,201,0.2);color:var(--secondary);border:1px solid rgba(0,206,201,0.4);"><i class="bi bi-person-video3 me-1"></i>Instructor</span>
                        <% } else if (role == "Admin") { %>
                            <span class="level-badge-lg" style="background:rgba(108,92,231,0.2);color:var(--primary-light);border:1px solid rgba(108,92,231,0.4);"><i class="bi bi-shield-lock me-1"></i>Administrator</span>
                        <% } %>
                        <span class="text-white-50"><i class="bi bi-star-fill text-warning me-1"></i><asp:Literal ID="litPoints" runat="server" /> points</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon purple mx-auto mb-2"><i class="bi bi-collection-play"></i></div>
                    <h4 class="mb-0 text-gradient"><asp:Literal ID="litEnrolled" runat="server" /></h4>
                    <small class="text-muted">Enrolled</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon green mx-auto mb-2"><i class="bi bi-check-circle"></i></div>
                    <h4 class="mb-0" style="color:var(--success);"><asp:Literal ID="litCompleted" runat="server" /></h4>
                    <small class="text-muted">Completed</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon teal mx-auto mb-2"><i class="bi bi-clipboard-data"></i></div>
                    <h4 class="mb-0" style="color:var(--secondary);"><asp:Literal ID="litAvgScore" runat="server" />%</h4>
                    <small class="text-muted">Avg Score</small>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="glass-card-sm text-center">
                    <div class="feature-icon gold mx-auto mb-2"><i class="bi bi-star"></i></div>
                    <h4 class="mb-0" style="color:var(--accent-dark);"><asp:Literal ID="litTotalPoints" runat="server" /></h4>
                    <small class="text-muted">Points</small>
                </div>
            </div>
        </div>

        <asp:Panel ID="pnlCourses" runat="server" CssClass="mb-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="mb-0"><i class="bi bi-collection-play me-2 text-primary"></i>My Courses</h5>
                <a href="Courses.aspx" class="text-primary small fw-semibold">Browse New Courses +</a>
            </div>
            <div class="glass-card p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead><tr><th>Course</th><th>Progress</th><th>Status</th><th></th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptMyCourses" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong><%# Eval("Title") %></strong><br/><small class="text-muted"><%# Eval("CategoryName") %></small></td>
                                        <td style="width:200px;">
                                            <div class="progress mb-1"><div class="progress-bar" style="width:<%# Eval("Progress") %>%"></div></div>
                                            <small class="text-muted"><%# Eval("Progress") %>%</small>
                                        </td>
                                        <td><span class="badge" style="background:var(--success);color:white;"><%# Convert.ToInt32(Eval("Progress")) >= 100 ? "Completed" : "In Progress" %></span></td>
                                        <td>
                                            <a href='<%# "Learn.aspx?courseId=" + Eval("Id") %>' class='<%# Convert.ToInt32(Eval("Progress")) >= 100 ? "btn btn-sm btn-success" : "btn btn-sm btn-lumora-primary" %>'><%# Convert.ToInt32(Eval("Progress")) >= 100 ? "Retake" : "Continue" %></a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlResults" runat="server" CssClass="mb-4">
            <h5 class="mb-3"><i class="bi bi-clipboard-data me-2 text-primary"></i>Recent Quiz Results</h5>
            <div class="glass-card p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0">
                        <thead><tr><th>Quiz</th><th>Score</th><th>Status</th><th>Date</th></tr></thead>
                        <tbody>
                            <asp:Repeater ID="rptResults" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><%# Eval("QuizTitle") %></td>
                                        <td><span class="fw-bold" style="font-family:var(--font-mono);color:var(--primary);"><%# Eval("Score") %>%</span></td>
                                        <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("Passed")) ? "var(--success)" : "var(--danger)" %>;color:white;"><%# Convert.ToBoolean(Eval("Passed")) ? "Passed" : "Failed" %></span></td>
                                        <td class="text-muted small"><%# Convert.ToDateTime(Eval("DateTaken")).ToString("dd MMM yyyy") %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
