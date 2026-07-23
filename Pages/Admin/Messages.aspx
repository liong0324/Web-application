<%@ Page Title="Messages" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="LumoraWebForms.Pages.Admin.Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <h2 class="mb-4"><i class="bi bi-envelope me-2 text-primary"></i>Contact Messages</h2>

        <!-- Message Detail Panel -->
        <asp:Panel ID="pnlDetail" runat="server" Visible="false" CssClass="glass-card p-4 mb-4">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                    <h5 class="mb-1"><asp:Literal ID="litDetailSubject" runat="server" /></h5>
                    <small class="text-muted">
                        From: <strong><asp:Literal ID="litDetailName" runat="server" /></strong>
                        &mdash; <asp:Literal ID="litDetailDate" runat="server" />
                    </small>
                </div>
                <asp:Button ID="btnCloseDetail" runat="server" CssClass="btn btn-sm btn-lumora-secondary" Text="Close" OnClick="btnCloseDetail_Click" CausesValidation="false" />
            </div>
            <div class="p-3 rounded mb-3" style="background:var(--bg-primary);white-space:pre-wrap;line-height:1.7;">
                <asp:Literal ID="litDetailMessage" runat="server" />
            </div>
            <div class="alert alert-info d-flex align-items-center gap-2 mb-0">
                <i class="bi bi-info-circle-fill fs-5"></i>
                <span>To reply, send an email directly to: <strong><asp:Literal ID="litDetailEmail" runat="server" /></strong></span>
            </div>
        </asp:Panel>

        <!-- Messages Table -->
        <div class="glass-card p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>From</th><th>Email</th><th>Subject</th><th>Date</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptMessages" runat="server" OnItemCommand="rptMessages_ItemCommand">
                            <ItemTemplate>
                                <tr style="opacity:<%# Convert.ToBoolean(Eval("IsRead")) ? "0.65" : "1" %>;" class="<%# !Convert.ToBoolean(Eval("IsRead")) ? "fw-semibold" : "" %>">
                                    <td><strong><%# Eval("Name") %></strong></td>
                                    <td class="small text-muted"><%# Eval("Email") %></td>
                                    <td>
                                        <asp:LinkButton runat="server" CssClass="text-decoration-none text-body" CommandName="View" CommandArgument='<%# Eval("Id") %>'>
                                            <%# Eval("Subject") %>
                                        </asp:LinkButton>
                                    </td>
                                    <td class="small text-muted"><%# Convert.ToDateTime(Eval("DateSent")).ToString("dd MMM yyyy") %></td>
                                    <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("IsRead")) ? "var(--text-muted)" : "var(--primary)" %>;color:white;"><%# Convert.ToBoolean(Eval("IsRead")) ? "Read" : "New" %></span></td>
                                    <td>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-primary me-1" CommandName="View" CommandArgument='<%# Eval("Id") %>' title="View & Reply"><i class="bi bi-eye"></i></asp:LinkButton>
                                        <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Delete this message?');" title="Delete"><i class="bi bi-trash"></i></asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
            <asp:Panel ID="pnlNoMessages" runat="server" Visible="false">
                <div class="p-5 text-center">
                    <i class="bi bi-envelope-open display-4 text-muted"></i>
                    <p class="text-muted mt-2">No messages yet.</p>
                </div>
            </asp:Panel>
        </div>
    </div>
</asp:Content>
