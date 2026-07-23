<%@ Page Title="Achievements" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Achievements.aspx.cs" Inherits="LumoraWebForms.Pages.Achievements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="text-center mb-4">
            <h2 class="section-title">My <span class="text-gradient">Achievements</span></h2>
            <p class="text-muted">Collect badges and earn points as you learn</p>
            <div class="d-inline-block glass-card-sm px-4 py-2">
                <i class="bi bi-star-fill text-warning me-2"></i>
                <strong style="font-family:var(--font-mono);font-size:1.2rem;"><asp:Literal ID="litPoints" runat="server" /></strong> points earned
            </div>
        </div>

        <div class="row g-4">
            <asp:Repeater ID="rptBadges" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 col-lg-3">
                        <div class="glass-card-sm text-center badge-card" style="opacity:<%# Convert.ToBoolean(Eval("Earned")) ? "1" : "0.5" %>;">
                            <div class="badge-icon <%# Convert.ToBoolean(Eval("Earned")) ? "earned" : "locked" %>">
                                <i class="bi <%# Eval("IconUrl") %>"></i>
                            </div>
                            <h6 class="mb-1"><%# Eval("Name") %></h6>
                            <small class="text-muted d-block mb-2"><%# Eval("Description") %></small>
                            <%# Convert.ToBoolean(Eval("Earned"))
                                ? "<span class=\"badge\" style=\"background:var(--success);color:white;\"><i class=\"bi bi-check-circle me-1\"></i>Earned</span>"
                                : "<span class=\"badge\" style=\"background:var(--text-muted);color:white;\"><i class=\"bi bi-lock me-1\"></i>" + Eval("PointsRequired") + " pts</span>" %>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
