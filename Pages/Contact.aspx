<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="LumoraWebForms.Pages.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-5">
        <div class="text-center mb-5">
            <h1 class="section-title">Contact <span class="text-gradient">Us</span></h1>
            <p class="section-subtitle">Have a question? We'd love to hear from you.</p>
        </div>
        <div class="row justify-content-center">
            <div class="col-lg-7">
                <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>
                <div class="glass-card p-5">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Your Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Asem"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Name is required" CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Email Address</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="asem@example.com" TextMode="Email"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="col-12">
                            <label class="form-label">Subject</label>
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="How can we help?"></asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Message</label>
                            <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="5" placeholder="Write your message here..."></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" ErrorMessage="Message is required" CssClass="text-danger small" Display="Dynamic" />
                        </div>
                        <div class="col-12">
                            <asp:Button ID="btnSend" runat="server" CssClass="btn-lumora-primary w-100" Text="Send Message" OnClick="btnSend_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
