<%@ Page Title="Course Detail" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CourseDetail.aspx.cs" Inherits="LumoraWebForms.Pages.CourseDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="Courses.aspx">Courses</a></li>
                <li class="breadcrumb-item active"><asp:Literal ID="breadcrumbTitle" runat="server" /></li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-lg-8">
                <div class="glass-card p-4 mb-4">
                    <div class="rounded-lg d-flex align-items-center justify-content-center mb-4" style="height:300px;background:var(--gradient-primary);">
                        <i class="bi bi-book display-1 text-white"></i>
                    </div>
                    <h1 class="mb-3"><asp:Literal ID="courseTitle" runat="server" /></h1>
                    <div class="d-flex flex-wrap gap-3 mb-4">
                        <span class="badge" style="background:rgba(108,92,231,0.1);color:var(--primary);"><i class="bi bi-tag me-1"></i><asp:Literal ID="courseCategory" runat="server" /></span>
                        <span class="text-muted"><i class="bi bi-person me-1"></i><asp:Literal ID="courseInstructor" runat="server" /></span>
                        <span class="text-muted"><i class="bi bi-people me-1"></i><asp:Literal ID="courseEnrollments" runat="server" /> students</span>
                    </div>
                    <h5 class="mb-3">Description</h5>
                    <p><asp:Literal ID="courseDescription" runat="server" /></p>
                </div>

                <asp:Panel ID="pnlLessons" runat="server" CssClass="glass-card p-4">
                    <h5 class="mb-3"><i class="bi bi-list-ol me-2 text-primary"></i>Course Content</h5>
                    <asp:Repeater ID="rptLessons" runat="server">
                        <ItemTemplate>
                            <div class="d-flex justify-content-between align-items-center p-3 rounded-lg mb-2" style="background:var(--bg-primary);">
                                <div>
                                    <span class="badge me-2" style="background:var(--primary);color:white;"><%# Eval("Order") %></span>
                                    <strong><%# Eval("Title") %></strong>
                                </div>
                                <small class="text-muted"><i class="bi bi-clock me-1"></i><%# Eval("DurationMinutes") %> min</small>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
                <asp:Panel ID="pnlNoLessons" runat="server" Visible="false" CssClass="glass-card p-4 text-center">
                    <i class="bi bi-journal-x display-4 text-muted"></i>
                    <h5 class="mt-3 text-muted">No lessons available yet</h5>
                    <p class="text-muted mb-0">Course content is being prepared. Please check back later.</p>
                </asp:Panel>
            </div>

            <div class="col-lg-4">
                <div class="glass-card p-4 sticky-top" style="top:80px;">
                    <div class="text-center mb-4">
                        <h3 class="text-gradient" id="coursePrice" runat="server">Free</h3>
                    </div>
                    <asp:Panel ID="pnlEnroll" runat="server">
                        <asp:Button ID="btnEnroll" runat="server" CssClass="btn-lumora-primary w-100 mb-2" Text="Enroll Now" OnClick="btnEnroll_Click" />
                    </asp:Panel>
                    <asp:Panel ID="pnlManage" runat="server" Visible="false">
                        <a id="btnManageCourse" runat="server" class="btn-lumora-secondary w-100 mb-2 text-center d-block">
                            <i class="bi bi-gear me-2"></i>Manage Course
                        </a>
                    </asp:Panel>
                    <asp:Panel ID="pnlProgress" runat="server" Visible="false">
                        <div class="mb-3">
                            <label class="form-label small text-muted">Your Progress</label>
                            <div class="progress">
                                <asp:Literal ID="progressBar" runat="server" />
                            </div>
                            <small class="text-muted"><asp:Literal ID="progressText" runat="server" /></small>
                        </div>
                        <a id="btnContinue" runat="server" class="btn-lumora-primary w-100 mb-2 text-center"><i class="bi bi-play-circle me-2"></i>Continue Learning</a>
                    </asp:Panel>
                    <hr/>
                    <h6>Details</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><i class="bi bi-file-earmark-play me-2 text-primary"></i><asp:Literal ID="lessonCount" runat="server" /> lessons</li>
                        <li class="mb-2"><i class="bi bi-people me-2 text-primary"></i><asp:Literal ID="enrollmentCount2" runat="server" /> students</li>
                        <li class="mb-2"><i class="bi bi-tag me-2 text-primary"></i><asp:Literal ID="categoryName2" runat="server" /></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
