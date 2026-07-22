<%@ Page Title="Manage Categories" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageCategories.aspx.cs" Inherits="LumoraWebForms.Pages.Admin.ManageCategories" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <h2 class="mb-4"><i class="bi bi-tags me-2 text-primary"></i>Manage Categories</h2>
        <div class="row">
            <div class="col-lg-8">
                <div class="glass-card p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead><tr><th>Name</th><th>Description</th><th>Actions</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptCategories" runat="server" OnItemCommand="rptCategories_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong><%# Eval("Name") %></strong></td>
                                            <td class="text-muted"><%# Eval("Description") %></td>
                                            <td>
                                                <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-sm btn-outline-primary me-1" CommandName="Edit" CommandArgument='<%# Eval("Id") + "|" + Eval("Name") + "|" + Eval("Description") %>'><i class="bi bi-pencil"></i></asp:LinkButton>
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
            <div class="col-lg-4">
                <div class="glass-card p-4">
                    <h5 class="mb-3" id="formTitle" runat="server">Add Category</h5>
                    <asp:HiddenField ID="hdnEditId" runat="server" />
                    <div class="mb-3">
                        <label class="form-label">Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required" CssClass="text-danger" Display="Dynamic" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnSave" runat="server" CssClass="btn-lumora-primary w-100" Text="Add Category" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
