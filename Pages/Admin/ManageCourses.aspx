<%@ Page Title="Manage Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageCourses.aspx.cs" Inherits="LumoraWebForms.Pages.Admin.ManageCourses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-collection-play me-2 text-primary"></i>Manage Courses</h2>
        </div>

        <asp:Panel ID="pnlAdd" runat="server" CssClass="glass-card p-4 mb-4" Visible="false">
            <h5 class="mb-3"><asp:Literal ID="litFormTitle" Text="Add Course" runat="server" /></h5>
            <div class="row g-3">
                <div class="col-md-6"><label class="form-label">Title</label><asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"></asp:TextBox><asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" ErrorMessage="Title is required" CssClass="text-danger" Display="Dynamic" /></div>
                <div class="col-md-6">
                    <label class="form-label">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"></asp:DropDownList>
                </div>
                <div class="col-12"><label class="form-label">Description</label><asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox></div>
                <div class="col-md-4"><label class="form-label">Price ($)</label><asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" Text="0"></asp:TextBox></div>
                <div class="col-md-4"><label class="form-label">Level</label>
                    <asp:DropDownList ID="ddlLevel" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Beginner" Value="Beginner" />
                        <asp:ListItem Text="Intermediate" Value="Intermediate" />
                        <asp:ListItem Text="Advanced" Value="Advanced" />
                    </asp:DropDownList>
                </div>
                <div class="col-12">
                    <asp:HiddenField ID="hdnEditId" runat="server" />
                    <asp:Button ID="btnSave" runat="server" CssClass="btn-lumora-primary" Text="Save" OnClick="btnSave_Click" />
                    <asp:Button ID="btnCancel" runat="server" CssClass="btn btn-lumora-secondary ms-2" Text="Cancel" OnClick="btnCancel_Click" />
                </div>
            </div>
        </asp:Panel>

        <asp:Button ID="btnAddNew" runat="server" CssClass="btn-lumora-primary mb-3" Text="Add New Course" OnClick="btnAddNew_Click" />

        <div class="glass-card p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>Title</th><th>Category</th><th>Students</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td><strong><%# Eval("Title") %></strong></td>
                                    <td><span class="badge" style="background:rgba(108,92,231,0.1);color:var(--primary);"><%# Eval("CategoryName") %></span></td>
                                    <td><%# Eval("EnrollmentCount") %></td>
                                    <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("IsPublished")) ? "var(--success)" : "var(--text-muted)" %>;color:white;"><%# Convert.ToBoolean(Eval("IsPublished")) ? "Published" : "Draft" %></span></td>
                                    <td>
                                        <a href='ManageCourse.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil"></i></a>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Delete this course?');"><i class="bi bi-trash"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnToggle" runat="server" CssClass="btn btn-sm btn-outline-warning" CommandName="Toggle" CommandArgument='<%# Eval("Id") %>'><i class="bi bi-eye"></i></asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</asp:Content>
