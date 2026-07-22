<%@ Page Title="Messages" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Messages.aspx.cs" Inherits="LumoraWebForms.Pages.Admin.Messages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <h2 class="mb-4"><i class="bi bi-envelope me-2 text-primary"></i>Contact Messages</h2>
        <div class="glass-card p-0">
            <asp:Panel ID="pnlNoMessages" runat="server" Visible="false">
                <div class="p-5 text-center">
                    <i class="bi bi-envelope-open display-4 text-muted"></i>
                    <p class="text-muted mt-2">No messages yet.</p>
                </div>
            </asp:Panel>
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>From</th><th>Email</th><th>Subject</th><th>Date</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptMessages" runat="server" OnItemCommand="rptMessages_ItemCommand">
                            <ItemTemplate>
                                <tr style="opacity:<%# Convert.ToBoolean(Eval("IsRead")) ? "0.6" : "1" %>;">
                                    <td><strong><%# Eval("Name") %></strong></td>
                                    <td class="small"><%# Eval("Email") %></td>
                                    <td><%# Eval("Subject") %></td>
                                    <td class="small text-muted"><%# Convert.ToDateTime(Eval("DateSent")).ToString("dd MMM yyyy") %></td>
                                    <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("IsRead")) ? "var(--text-muted)" : "var(--primary)" %>;color:white;"><%# Convert.ToBoolean(Eval("IsRead")) ? "Read" : "New" %></span></td>
                                    <td>
                                        <asp:LinkButton ID="btnRead" runat="server" CssClass="btn btn-sm btn-outline-info" CommandName="MarkRead" CommandArgument='<%# Eval("Id") %>'><i class="bi bi-check-lg"></i></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Delete?');"><i class="bi bi-trash"></i></asp:LinkButton>
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
