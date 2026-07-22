<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="LumoraWebForms.Pages.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="glass-card p-5 auth-card fade-in">
                    <div class="text-center mb-4">
                        <div class="feature-icon purple mx-auto mb-3"><i class="bi bi-person-plus"></i></div>
                        <h3>Join the LUMORA Community</h3>
                        <p class="text-muted">Start your learning journey today</p>
                    </div>

                    <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger" Visible="false"></asp:Label>
                    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>

                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName" ErrorMessage="Full name is required" CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-at"></i></span>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Choose a username"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ControlToValidate="txtUsername" ErrorMessage="Username is required" CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Email</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="you@example.com" TextMode="Email"></asp:TextBox>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger small" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$" ErrorMessage="Invalid email" CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Min 8 chars" TextMode="Password" ClientIDMode="Static"></asp:TextBox>
                            <span class="input-group-text password-toggle" onclick="togglePassword('txtPassword', this)"><i class="bi bi-eye"></i></span>
                        </div>
                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="Password is required" CssClass="text-danger small" Display="Dynamic" />
                        <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword" ValidationExpression="^.{8,}$" ErrorMessage="Password must be at least 8 characters" CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Confirm Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" placeholder="Confirm your password" TextMode="Password"></asp:TextBox>
                        </div>
                        <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" ErrorMessage="Passwords do not match" CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <div class="mb-4 form-check">
                        <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" />
                        <label class="form-check-label small">I agree to the <a href="#" class="text-primary">Terms &amp; Conditions</a></label>
                        <asp:CustomValidator ID="cvTerms" runat="server" ClientValidationFunction="validateTerms" ErrorMessage="You must agree to the Terms & Conditions" CssClass="text-danger small d-block" Display="Dynamic" ValidateEmptyText="true" />
                    </div>

                    <asp:Button ID="btnRegister" runat="server" CssClass="btn-lumora-primary w-100 mb-3" Text="Create My Account" OnClick="btnRegister_Click" OnClientClick="return validateTerms();" />

                    <div class="text-center">
                        <p class="text-muted mb-0">Already have an account? <a href="Login.aspx" class="text-primary fw-semibold">Log In</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
