<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="LumoraWebForms.Pages.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-7 col-lg-5">
                <div class="glass-card p-5 auth-card fade-in" style="padding: 3rem !important;">
                    <div class="text-center mb-4">
                        <div class="feature-icon purple mx-auto mb-3" style="width:80px;height:80px;font-size:2rem;"><i class="bi bi-box-arrow-in-right"></i></div>
                        <h2 class="mb-1">Welcome Back</h2>
                        <p class="text-muted">Sign in to continue learning</p>
                    </div>

                    <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger" Visible="false"></asp:Label>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="you@example.com" TextMode="Email"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Enter your password" TextMode="Password" ClientIDMode="Static"></asp:TextBox>
                            <span class="input-group-text password-toggle" onclick="togglePassword('txtPassword', this)"><i class="bi bi-eye"></i></span>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="form-check">
                            <asp:CheckBox ID="chkRemember" runat="server" CssClass="form-check-input" />
                            <label class="form-check-label small">Remember me</label>
                        </div>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" CssClass="btn-lumora-primary w-100 mb-3" Text="Sign In" OnClick="btnLogin_Click" />
                    
                    <div class="text-center">
                        <p class="text-muted mb-0">Don't have an account? <a href="Register.aspx" class="text-primary fw-semibold">Start Free</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
