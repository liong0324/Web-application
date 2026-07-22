<%@ Page Title="Change Password" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ChangePassword.aspx.cs" Inherits="LumoraWebForms.Pages.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="glass-card p-5 auth-card fade-in">
                    <div class="text-center mb-4">
                        <div class="feature-icon purple mx-auto mb-3"><i class="bi bi-key"></i></div>
                        <h3>Change Password</h3>
                    </div>
                    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>
                    <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger" Visible="false"></asp:Label>
                    <div class="mb-3">
                        <label class="form-label">Current Password</label>
                        <asp:TextBox ID="txtOldPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvOld" runat="server" ControlToValidate="txtOldPassword" ErrorMessage="Required" CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="mb-3">
                        <label class="form-label">New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNew" runat="server" ControlToValidate="txtNewPassword" ErrorMessage="Required" CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Confirm New Password</label>
                        <asp:TextBox ID="txtConfirm" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        <asp:CompareValidator ID="cvPwd" runat="server" ControlToValidate="txtConfirm" ControlToCompare="txtNewPassword" ErrorMessage="Passwords do not match" CssClass="text-danger small" Display="Dynamic" />
                    </div>
                    <asp:Button ID="btnChange" runat="server" CssClass="btn-lumora-primary w-100 mb-3" Text="Update Password" OnClick="btnChange_Click" />
                    <div class="text-center"><a href="Profile.aspx" class="text-primary"><i class="bi bi-arrow-left me-1"></i>Back to Profile</a></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
