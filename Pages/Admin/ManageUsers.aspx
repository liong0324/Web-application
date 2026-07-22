<%@ Page Title="Manage Users" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="LumoraWebForms.Pages.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="bi bi-people me-2 text-primary"></i>Manage Users</h2>
            <span class="badge" style="background:rgba(108,92,231,0.1);color:var(--primary);font-size:1rem;"><asp:Literal ID="litCount" runat="server" /> users</span>
        </div>
        <div class="glass-card p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead><tr><th>User</th><th>Email</th><th>Joined</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                            <ItemTemplate>
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="leaderboard-avatar" style="width:35px;height:35px;font-size:0.8rem;"><%# Eval("FullName").ToString()[0] %></div>
                                            <div class="ms-2"><strong><%# Eval("FullName") %></strong><br/><small class="text-muted">@<%# Eval("Username") %></small></div>
                                        </div>
                                    </td>
                                    <td class="small"><%# Eval("Email") %></td>
                                    <td class="small"><%# Convert.ToDateTime(Eval("DateJoined")).ToString("dd MMM yyyy") %></td>
                                    <td><span class="badge" style="background:<%# Convert.ToBoolean(Eval("IsActive")) ? "var(--success)" : "var(--danger)" %>;color:white;"><%# Convert.ToBoolean(Eval("IsActive")) ? "Active" : "Inactive" %></span></td>
                                    <td>
                                        <asp:LinkButton ID="btnToggle" runat="server" CssClass="btn btn-sm btn-outline-warning" CommandName="Toggle" CommandArgument='<%# Eval("Id") %>'><%# Convert.ToBoolean(Eval("IsActive")) ? "Suspend" : "Activate" %></asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="btn btn-sm btn-outline-danger" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Delete this user?');"><i class="bi bi-trash"></i></asp:LinkButton>
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
