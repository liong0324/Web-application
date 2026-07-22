<%@ Page Title="Leaderboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Leaderboard.aspx.cs" Inherits="LumoraWebForms.Pages.Leaderboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="text-center mb-4">
            <h2 class="section-title"><span class="text-gradient">Leaderboard</span></h2>
            <p class="text-muted">Top learners ranked by points</p>
        </div>

        <div class="glass-card p-4 mb-4 text-center" id="pnlMyRank" runat="server">
            <p class="text-muted mb-2">Your Ranking</p>
            <h3 class="text-gradient">#<asp:Literal ID="litMyRank" runat="server" /></h3>
            <p class="mb-0"><i class="bi bi-star-fill text-warning me-1"></i><asp:Literal ID="litMyPoints" runat="server" /> points</p>
        </div>

        <div class="glass-card p-3">
            <asp:Repeater ID="rptLeaderboard" runat="server">
                <ItemTemplate>
                    <div class="leaderboard-item">
                        <div class="leaderboard-rank">
                            <%# Container.ItemIndex + 1 == 1 ? "<i class='bi bi-trophy-fill' style='color:var(--accent);'></i>" : 
                                 Container.ItemIndex + 1 == 2 ? "<i class='bi bi-trophy-fill' style='color:#C0C0C0;'></i>" :
                                 Container.ItemIndex + 1 == 3 ? "<i class='bi bi-trophy-fill' style='color:#CD7F32;'></i>" :
                                 (Container.ItemIndex + 1).ToString() %>
                        </div>
                        <div class="leaderboard-avatar"><%# Eval("FullName").ToString()[0] %></div>
                        <div>
                            <div class="leaderboard-name"><%# Eval("FullName") %></div>
                            <small class="text-muted">Level: <%# Eval("Level") %></small>
                        </div>
                        <div class="leaderboard-points"><i class="bi bi-star-fill text-warning me-1"></i><%# Eval("Points") %> pts</div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
