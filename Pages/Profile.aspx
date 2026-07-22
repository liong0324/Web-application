<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="LumoraWebForms.Pages.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row">
            <div class="col-lg-4">
                <div class="glass-card p-4 text-center mb-4">
                    <div class="feature-icon purple mx-auto mb-3" style="width:80px;height:80px;font-size:2rem;">
                        <i class="bi bi-person"></i>
                    </div>
                    <h4><asp:Literal ID="litFullName" runat="server" /></h4>
                    <p class="text-muted small">@<asp:Literal ID="litUsername" runat="server" /></p>
                    <span class="level-badge-lg level-<%= (Session["Level"] ?? "Bronze").ToString().ToLower() %>"><%= Session["Level"] ?? "Bronze" %> Learner</span>
                    <hr/>
                    <div class="row text-center">
                        <div class="col-4"><h5 class="text-gradient mb-0"><asp:Literal ID="litEnrolled" runat="server" /></h5><small class="text-muted">Enrolled</small></div>
                        <div class="col-4"><h5 style="color:var(--success);" class="mb-0"><asp:Literal ID="litCompleted" runat="server" /></h5><small class="text-muted">Completed</small></div>
                        <div class="col-4"><h5 style="color:var(--accent-dark);" class="mb-0"><asp:Literal ID="litPoints" runat="server" /></h5><small class="text-muted">Points</small></div>
                    </div>
                    <hr/>
                    <p class="small text-muted"><i class="bi bi-calendar me-1"></i>Member since <asp:Literal ID="litDateJoined" runat="server" /></p>
                    <div class="d-grid gap-2">
                        <a href="ChangePassword.aspx" class="btn btn-lumora-secondary btn-sm"><i class="bi bi-key me-2"></i>Change Password</a>
                    </div>
                </div>
            </div>
            <div class="col-lg-8">
                <div class="glass-card p-4">
                    <h5 class="mb-4"><i class="bi bi-pencil-square me-2 text-primary"></i>Edit Profile</h5>
                    <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>
                    <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger" Visible="false"></asp:Label>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Full Name</label>
                            <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Bio</label>
                            <asp:TextBox ID="txtBio" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Tell us about yourself..."></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <asp:Button ID="btnSave" runat="server" CssClass="btn-lumora-primary" Text="Save Changes" OnClick="btnSave_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
