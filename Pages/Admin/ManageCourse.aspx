<%@ Page Title="Manage Course" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageCourse.aspx.cs" Inherits="LumoraWebForms.Pages.Admin.ManageCourse" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
<script>
    (function () {
        var isDirty = false;

        // Mark dirty when any input/textarea/select changes
        document.addEventListener('change', function (e) {
            if (e.target.matches('input, textarea, select')) isDirty = true;
        });
        document.addEventListener('input', function (e) {
            if (e.target.matches('input, textarea, select')) isDirty = true;
        });

        // Warn before leaving if unsaved
        window.addEventListener('beforeunload', function (e) {
            if (!isDirty) return;
            var msg = 'You have unsaved changes. Are you sure you want to leave? Your changes will be lost.';
            e.preventDefault();
            e.returnValue = msg;
            return msg;
        });

        // Clear dirty flag when any Save button is clicked
        document.addEventListener('click', function (e) {
            var btn = e.target.closest('input[type="submit"], button[type="submit"], a.breadcrumb-item');
            if (btn) {
                var txt = (btn.value || btn.innerText || '').toLowerCase();
                if (txt.indexOf('save') !== -1 || txt.indexOf('cancel') !== -1 || btn.classList.contains('breadcrumb-item')) {
                    isDirty = false;
                }
            }
        });

        // Also clear on any ASP.NET postback that's a save action
        window.__clearDirty = function () { isDirty = false; };
    })();
</script>
<div class="container py-4">

    <nav aria-label="breadcrumb" class="mb-3">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="ManageCourses.aspx">Manage Courses</a></li>
            <li class="breadcrumb-item active"><asp:Literal ID="litBreadcrumb" runat="server" /></li>
        </ol>
    </nav>

    <!-- Course Details Form -->
    <div class="glass-card p-4 mb-4">
        <h5 class="mb-3"><i class="bi bi-pencil-square me-2 text-primary"></i>Course Details</h5>
        <asp:Label ID="lblMsg" runat="server" CssClass="alert alert-success d-block mb-3" Visible="false" />
        <div class="row g-3">
            <div class="col-md-8">
                <label class="form-label">Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtTitle" ErrorMessage="Required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="course" />
            </div>
            <div class="col-md-4">
                <label class="form-label">Level</label>
                <asp:DropDownList ID="ddlLevel" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Beginner" Value="Beginner" />
                    <asp:ListItem Text="Intermediate" Value="Intermediate" />
                    <asp:ListItem Text="Advanced" Value="Advanced" />
                </asp:DropDownList>
            </div>
            <div class="col-md-8">
                <label class="form-label">Category</label>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" />
            </div>
            <div class="col-md-4">
                <label class="form-label">Price ($)</label>
                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" Text="0" />
            </div>
            <div class="col-12">
                <label class="form-label">Description</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
            </div>
            <div class="col-12 d-flex gap-2 align-items-center">
                <asp:Button ID="btnSaveCourse" runat="server" CssClass="btn-lumora-primary" Text="Save Changes" OnClick="btnSaveCourse_Click" ValidationGroup="course" OnClientClick="window.__clearDirty && window.__clearDirty();" />
                <asp:CheckBox ID="chkPublished" runat="server" CssClass="form-check-input ms-3" />
                <label class="form-check-label ms-1">Published</label>
            </div>
        </div>
    </div>

    <!-- Lessons Management -->
    <div class="glass-card p-4 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0"><i class="bi bi-list-ol me-2 text-primary"></i>Lessons</h5>
            <asp:Button ID="btnAddLesson" runat="server" CssClass="btn-lumora-primary btn-sm" Text="+ Add Lesson" OnClick="btnAddLesson_Click" />
        </div>

        <!-- Lesson Form -->
        <asp:Panel ID="pnlLessonForm" runat="server" CssClass="glass-card p-3 mb-3" Visible="false">
            <h6 class="mb-3"><asp:Literal ID="litLessonFormTitle" runat="server" Text="Add Lesson" /></h6>
            <asp:HiddenField ID="hdnLessonId" runat="server" />
            <div class="row g-3">
                <div class="col-md-8">
                    <label class="form-label">Lesson Title</label>
                    <asp:TextBox ID="txtLessonTitle" runat="server" CssClass="form-control" />
                    <asp:RequiredFieldValidator runat="server" ControlToValidate="txtLessonTitle" ErrorMessage="Required" CssClass="text-danger small" Display="Dynamic" ValidationGroup="lesson" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Duration (minutes)</label>
                    <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" Text="30" />
                </div>
                <div class="col-12">
                    <label class="form-label">Content</label>
                    <asp:TextBox ID="txtLessonContent" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" />
                </div>
                <div class="col-12 d-flex gap-2">
                    <asp:Button ID="btnSaveLesson" runat="server" CssClass="btn-lumora-primary" Text="Save Lesson" OnClick="btnSaveLesson_Click" ValidationGroup="lesson" OnClientClick="window.__clearDirty && window.__clearDirty();" />
                    <asp:Button ID="btnCancelLesson" runat="server" CssClass="btn btn-lumora-secondary" Text="Cancel" OnClick="btnCancelLesson_Click" CausesValidation="false" />
                </div>
            </div>
        </asp:Panel>

        <!-- Lessons List -->
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
                                <td>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-primary me-1" CommandName="EditLesson" CommandArgument='<%# Eval("Id") %>'><i class="bi bi-pencil"></i></asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-warning me-1" CommandName="ManageQuiz" CommandArgument='<%# Eval("Id") %>' title="Manage Quiz"><i class="bi bi-patch-question"></i></asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="DeleteLesson" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Delete this lesson and its quizzes?');"><i class="bi bi-trash"></i></asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Quiz Management (shown when a lesson is selected) -->
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

        <!-- Questions List -->
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
