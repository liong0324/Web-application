<%@ Page Title="Manage Course" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageCourse.aspx.cs" Inherits="LumoraWebForms.Pages.Instructor.InstructorManageCourse" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script>
    (function () {
        var isDirty = false;

        document.addEventListener('change', function (e) {
            if (e.target.matches('input, textarea, select')) isDirty = true;
        });
        document.addEventListener('input', function (e) {
            if (e.target.matches('input, textarea, select')) isDirty = true;
        });

        window.addEventListener('beforeunload', function (e) {
            if (!isDirty) return;
            var msg = 'You have unsaved changes. Are you sure you want to leave? Your changes will be lost.';
            e.preventDefault();
            e.returnValue = msg;
            return msg;
        });

        document.addEventListener('click', function (e) {
            var btn = e.target.closest('input[type="submit"], button[type="submit"]');
            if (btn) {
                var txt = (btn.value || btn.innerText || '').toLowerCase();
                if (txt.indexOf('save') !== -1 || txt.indexOf('cancel') !== -1) {
                    isDirty = false;
                }
            }
            // Also clear when navigating via breadcrumb or links
            if (e.target.closest('.breadcrumb a, .breadcrumb-item a')) isDirty = false;
        });

        window.__clearDirty = function () { isDirty = false; };
    })();
</script>
<div class="container py-4">

    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="MyCourses.aspx">My Courses</a></li>
            <li class="breadcrumb-item active"><asp:Literal ID="litBreadcrumb" runat="server" /></li>
        </ol>
    </nav>

    <asp:Label ID="lblMsg" runat="server" CssClass="alert alert-success d-block mb-3" Visible="false" />

    <!-- Lessons List -->
    <div class="glass-card p-4 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0"><i class="bi bi-list-ol me-2 text-primary"></i>Lessons</h5>
        </div>
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead><tr><th>#</th><th>Lesson Title</th><th>Duration</th><th>Actions</th></tr></thead>
                <tbody>
                    <asp:Repeater ID="rptLessons" runat="server" OnItemCommand="rptLessons_ItemCommand">
                        <ItemTemplate>
                            <tr>
                                <td><span class="badge" style="background:var(--primary);color:white;"><%# Eval("Order") %></span></td>
                                <td><strong><%# Eval("Title") %></strong></td>
                                <td><small class="text-muted"><i class="bi bi-clock me-1"></i><%# Eval("DurationMinutes") %> min</small></td>
                                <td class="d-flex gap-1">
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-primary" CommandName="EditLesson" CommandArgument='<%# Eval("Id") %>' title="Edit Lesson Content"><i class="bi bi-pencil me-1"></i>Edit</asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-warning" CommandName="ManageQuiz" CommandArgument='<%# Eval("Id") %>' title="Manage Quiz"><i class="bi bi-patch-question me-1"></i>Quiz</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Lesson Edit Panel -->
    <asp:Panel ID="pnlLessonEdit" runat="server" Visible="false" CssClass="glass-card p-4 mb-4">
        <asp:HiddenField ID="hdnLessonId" runat="server" />
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0"><i class="bi bi-pencil-square me-2 text-primary"></i>Edit Lesson: <asp:Literal ID="litEditLessonName" runat="server" /></h5>
            <asp:Button ID="btnCloseLessonEdit" runat="server" CssClass="btn btn-sm btn-lumora-secondary" Text="Close" OnClick="btnCloseLessonEdit_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblLessonMsg" runat="server" CssClass="alert alert-success d-block mb-3" Visible="false" />
        <div class="row g-3">
            <div class="col-md-8">
                <label class="form-label">Lesson Title</label>
                <asp:TextBox ID="txtLessonTitle" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-4">
                <label class="form-label">Duration (minutes)</label>
                <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" />
            </div>
            <div class="col-12">
                <label class="form-label">Content <small class="text-muted">(HTML supported)</small></label>
                <asp:TextBox ID="txtLessonContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="10" />
            </div>
            <div class="col-12">
                <asp:Button ID="btnSaveLesson" runat="server" CssClass="btn-lumora-primary" Text="Save Lesson" OnClick="btnSaveLesson_Click" CausesValidation="false" OnClientClick="window.__clearDirty && window.__clearDirty();" />
            </div>
        </div>
    </asp:Panel>

    <!-- Quiz Management Panel -->
    <asp:Panel ID="pnlQuizSection" runat="server" Visible="false" CssClass="glass-card p-4 mb-4">
        <asp:HiddenField ID="hdnQuizLessonId" runat="server" />
        <asp:HiddenField ID="hdnQuizId" runat="server" />
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0"><i class="bi bi-patch-question me-2 text-primary"></i>Quiz for: <asp:Literal ID="litQuizLessonName" runat="server" /></h5>
            <asp:Button ID="btnCloseQuiz" runat="server" CssClass="btn btn-sm btn-lumora-secondary" Text="Close" OnClick="btnCloseQuiz_Click" CausesValidation="false" />
        </div>
        <asp:Label ID="lblQuizMsg" runat="server" CssClass="alert alert-success d-block mb-3" Visible="false" />

        <!-- Quiz Settings -->
        <div class="row g-3 mb-4 p-3 rounded" style="background:var(--bg-primary);">
            <div class="col-md-5">
                <label class="form-label">Quiz Title</label>
                <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="form-control" />
            </div>
            <div class="col-md-3">
                <label class="form-label">Time Limit (min)</label>
                <asp:TextBox ID="txtQuizTime" runat="server" CssClass="form-control" Text="15" />
            </div>
            <div class="col-md-2">
                <label class="form-label">Passing Score (%)</label>
                <asp:TextBox ID="txtPassingScore" runat="server" CssClass="form-control" Text="70" />
            </div>
            <div class="col-md-2 d-flex align-items-end">
                <asp:Button ID="btnSaveQuiz" runat="server" CssClass="btn-lumora-primary w-100" Text="Save Quiz" OnClick="btnSaveQuiz_Click" CausesValidation="false" OnClientClick="window.__clearDirty && window.__clearDirty();" />
            </div>
        </div>

        <!-- Questions -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h6 class="mb-0"><i class="bi bi-list-check me-2"></i>Questions</h6>
            <asp:Button ID="btnAddQuestion" runat="server" CssClass="btn btn-sm btn-lumora-primary" Text="+ Add Question" OnClick="btnAddQuestion_Click" CausesValidation="false" />
        </div>

        <asp:Panel ID="pnlQuestionForm" runat="server" CssClass="p-3 rounded mb-3" Visible="false" style="background:var(--bg-primary);">
            <asp:HiddenField ID="hdnQuestionId" runat="server" />
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label">Question</label>
                    <asp:TextBox ID="txtQuestion" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-6"><label class="form-label">Option 1</label><asp:TextBox ID="txtOpt1" runat="server" CssClass="form-control" /></div>
                <div class="col-md-6"><label class="form-label">Option 2</label><asp:TextBox ID="txtOpt2" runat="server" CssClass="form-control" /></div>
                <div class="col-md-6"><label class="form-label">Option 3</label><asp:TextBox ID="txtOpt3" runat="server" CssClass="form-control" /></div>
                <div class="col-md-6"><label class="form-label">Option 4</label><asp:TextBox ID="txtOpt4" runat="server" CssClass="form-control" /></div>
                <div class="col-md-4">
                    <label class="form-label">Correct Answer</label>
                    <asp:DropDownList ID="ddlCorrect" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Option 1" Value="1" />
                        <asp:ListItem Text="Option 2" Value="2" />
                        <asp:ListItem Text="Option 3" Value="3" />
                        <asp:ListItem Text="Option 4" Value="4" />
                    </asp:DropDownList>
                </div>
                <div class="col-12 d-flex gap-2">
                    <asp:Button ID="btnSaveQuestion" runat="server" CssClass="btn-lumora-primary" Text="Save Question" OnClick="btnSaveQuestion_Click" CausesValidation="false" OnClientClick="window.__clearDirty && window.__clearDirty();" />
                    <asp:Button ID="btnCancelQuestion" runat="server" CssClass="btn btn-lumora-secondary" Text="Cancel" OnClick="btnCancelQuestion_Click" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
            <ItemTemplate>
                <div class="p-3 rounded mb-2 d-flex justify-content-between align-items-start" style="background:var(--bg-primary);">
                    <div>
                        <strong><%# Eval("QuestionText") %></strong>
                        <div class="mt-1">
                            <small class="<%# Convert.ToInt32(Eval("CorrectOption")) == 1 ? "text-success fw-bold" : "text-muted" %>">1. <%# Eval("Option1") %></small> &nbsp;
                            <small class="<%# Convert.ToInt32(Eval("CorrectOption")) == 2 ? "text-success fw-bold" : "text-muted" %>">2. <%# Eval("Option2") %></small> &nbsp;
                            <small class="<%# Convert.ToInt32(Eval("CorrectOption")) == 3 ? "text-success fw-bold" : "text-muted" %>">3. <%# Eval("Option3") %></small> &nbsp;
                            <small class="<%# Convert.ToInt32(Eval("CorrectOption")) == 4 ? "text-success fw-bold" : "text-muted" %>">4. <%# Eval("Option4") %></small>
                        </div>
                    </div>
                    <div class="d-flex gap-1">
                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-primary" CommandName="EditQ" CommandArgument='<%# Eval("Id") %>'><i class="bi bi-pencil"></i></asp:LinkButton>
                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="DeleteQ" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Delete?');"><i class="bi bi-trash"></i></asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

</div>
</asp:Content>
