<%@ Page Title="Learn" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Learn.aspx.cs" Inherits="LumoraWebForms.Pages.Learn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid py-4">
        <div class="row">
            <div class="col-lg-3 d-none d-lg-block">
                <aside class="glass-card p-3 sticky-top" style="top:80px;max-height:80vh;overflow-y:auto;">
                    <h6 class="mb-3"><i class="bi bi-list-ul me-2 text-primary"></i><asp:Literal ID="litCourseTitle" runat="server" /></h6>
                    <asp:Repeater ID="rptSidebar" runat="server">
                        <ItemTemplate>
                            <a href='Learn.aspx?courseId=<%# Eval("CourseId") %>&lessonId=<%# Eval("Id") %>'
                               class="d-block p-2 rounded-lg mb-1 text-decoration-none"
                               style="background:<%# Convert.ToInt32(Eval("Id")) == currentLessonId ? "var(--primary)" : "transparent" %>;color:<%# Convert.ToInt32(Eval("Id")) == currentLessonId ? "white" : "var(--text-primary)" %>;">
                                <small><i class="bi bi-circle me-2" style="font-size:0.6rem;"></i><%# Eval("Title") %></small>
                            </a>
                        </ItemTemplate>
                    </asp:Repeater>
                </aside>
            </div>

            <div class="col-lg-9">
                <div class="glass-card p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0"><i class="bi bi-play-circle me-2 text-primary"></i>Lesson <asp:Literal ID="litOrder" runat="server" />: <asp:Literal ID="litTitle" runat="server" /></h5>
                        <small class="text-muted"><i class="bi bi-clock me-1"></i><asp:Literal ID="litDuration" runat="server" /> min</small>
                    </div>
                    <div class="lesson-content">
                        <asp:Literal ID="litContent" runat="server" />
                    </div>
                </div>

                <asp:Panel ID="pnlQuizzes" runat="server" CssClass="glass-card p-4 mb-4" Visible="false">
                    <h5 class="mb-3"><i class="bi bi-clipboard-check me-2 text-primary"></i>Quizzes</h5>
                    <div class="row g-3">
                        <asp:Repeater ID="rptQuizzes" runat="server">
                            <ItemTemplate>
                                <div class="col-md-6">
                                    <div class="glass-card-sm text-center p-3">
                                        <i class="bi bi-question-circle display-6 text-primary"></i>
                                        <h6 class="mt-2"><%# Eval("Title") %></h6>
                                        <p class="small text-muted mb-2"><%# Eval("TimeLimitMinutes") %> min | <%# Eval("PassingScore") %>% to pass</p>
                                        <% if (Session["Role"] != null && Session["Role"].ToString() == "Instructor") { %>
                                            <a href='<%= ResolveUrl("~/Pages/Instructor/ManageCourse.aspx?id=" + courseId) %>' class="btn btn-sm btn-outline-warning"><i class="bi bi-patch-question me-1"></i>Manage Quiz</a>
                                        <% } else if (Session["Role"] != null && Session["Role"].ToString() == "Admin") { %>
                                            <a href='<%= ResolveUrl("~/Pages/Admin/ManageCourse.aspx?id=" + courseId) %>' class="btn btn-sm btn-outline-warning"><i class="bi bi-patch-question me-1"></i>Manage Quiz</a>
                                        <% } else { %>
                                            <a href='TakeQuiz.aspx?quizId=<%# Eval("Id") %>&courseId=<%= courseId %>&lessonId=<%# Eval("LessonId") %>' class="btn btn-sm btn-lumora-primary">Take Quiz</a>
                                        <% } %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <div class="glass-card p-4 mb-4">
                    <h5 class="mb-3"><i class="bi bi-chat-dots me-2 text-primary"></i>Discussion</h5>
                    <% if (Session["Role"] == null || Session["Role"].ToString() == "Member") { %>
                    <div class="mb-4">
                        <asp:TextBox ID="txtDiscussion" runat="server" CssClass="form-control mb-2" TextMode="MultiLine" Rows="3" placeholder="Share your thoughts..."></asp:TextBox>
                        <asp:Button ID="btnPost" runat="server" CssClass="btn-lumora-primary btn-sm" Text="Post" OnClick="btnPost_Click" />
                    </div>
                    <% } %>
                    <asp:Repeater ID="rptDiscussions" runat="server">
                        <ItemTemplate>
                            <div class="p-3 rounded-lg mb-2" style="background:var(--bg-primary);">
                                <div class="d-flex justify-content-between">
                                    <strong><i class="bi bi-person-circle me-1"></i><%# Eval("FullName") %></strong>
                                    <small class="text-muted"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("dd MMM HH:mm") %></small>
                                </div>
                                <p class="mt-2 mb-0"><%# Eval("Message") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

        <!-- Lesson progress warning on leave (Members only) -->
        <% if (Session["Role"] != null && Session["Role"].ToString() == "Member") { %>
        <script>
            (function () {
                var navigatingAway = false;
                window.addEventListener('beforeunload', function (e) {
                    if (navigatingAway) return;
                    var msg = 'Your progress will be saved. You can continue from where you left off when you log back in.';
                    e.preventDefault();
                    e.returnValue = msg;
                    return msg;
                });
                // Suppress warning when clicking any intentional navigation
                document.addEventListener('click', function (e) {
                    var el = e.target.closest('a, button, input[type="submit"]');
                    if (el) navigatingAway = true;
                });
            })();
        </script>
        <% } %>

                <div class="d-flex justify-content-between">
                    <a href='CourseDetail.aspx?id=<%= courseId %>' class="btn btn-lumora-secondary"><i class="bi bi-arrow-left me-2"></i>Back</a>
                    <% if (Session["Role"] == null || Session["Role"].ToString() == "Member") { %>
                    <asp:Button ID="btnComplete" runat="server" CssClass="btn-lumora-primary" Text="Mark Complete" OnClick="btnComplete_Click" />
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
