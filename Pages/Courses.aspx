<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="LumoraWebForms.Pages.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="text-center mb-4">
            <h2 class="section-title">Explore <span class="text-gradient">Courses</span></h2>
        </div>

        <div class="glass-card p-3 mb-4">
            <div class="d-flex flex-wrap gap-2 justify-content-center">
                <asp:LinkButton ID="btnAll" runat="server" CssClass="filter-btn btn-lumora-primary" Text="All" OnClick="btnAll_Click" />
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnCategory" runat="server"
                            CssClass='<%# "filter-btn " + (ViewState["ActiveCat"] != null && ViewState["ActiveCat"].ToString() == Eval("Id").ToString() ? "btn-lumora-primary" : "btn-lumora-secondary") %>'
                            CommandArgument='<%# Eval("Id") %>' OnClick="btnCategory_Click"
                            Text='<%# Eval("Name") %>' />
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
        <style>
            .filter-btn {
                padding: 0.45rem 1.2rem;
                border-radius: var(--radius-xl);
                font-size: 0.875rem;
                font-weight: 600;
                cursor: pointer;
                transition: var(--transition);
                display: inline-block;
                text-decoration: none;
            }
        </style>

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
                                    <span><i class="bi bi-person me-1"></i><%# Eval("InstructorName") %></span>
                                    <span><i class="bi bi-people me-1"></i><%# Eval("EnrollmentCount") %></span>
                                </div>
                                <%# GetCourseButton(Eval("Id")) %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlNoResults" runat="server" Visible="false">
            <div class="text-center py-5 glass-card">
                <i class="bi bi-inbox display-4 text-muted"></i>
                <h5 class="mt-3 text-muted">No courses found</h5>
            </div>
        </asp:Panel>
    </div>
</asp:Content>
