<%@ Page Title="My Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyCourses.aspx.cs" Inherits="LumoraWebForms.Pages.Instructor.MyCourses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0"><i class="bi bi-collection-play me-2 text-primary"></i>My Courses</h3>
        </div>
        <div class="glass-card p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>Course</th><th>Category</th><th>Level</th><th>Students</th><th>Completions</th><th>Status</th><th></th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptCourses" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <strong><%# Eval("Title") %></strong>
                                        <div><small class="text-muted"><%# Eval("Description") %></small></div>
                                    </td>
                                    <td><small><%# Eval("CategoryName") %></small></td>
                                    <td><span class="badge" style="background:rgba(108,92,231,0.15);color:var(--primary);"><%# Eval("Level") %></span></td>
                                    <td><%# Eval("EnrollmentCount") %></td>
                                    <td><%# Eval("Completions") %></td>
                                    <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("IsPublished")) ? "var(--success)" : "var(--warning)" %>;color:white;"><%# Convert.ToBoolean(Eval("IsPublished")) ? "Published" : "Draft" %></span></td>
                                    <td><a href='<%# "ManageCourse.aspx?id=" + Eval("Id") %>' class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil-square me-1"></i>Manage Lessons</a></td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
