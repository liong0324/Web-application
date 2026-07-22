<%@ Page Title="Quiz Result" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="QuizResult.aspx.cs" Inherits="LumoraWebForms.Pages.QuizResultPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="glass-card p-5 text-center fade-in">
                    <% if (passed) { %>
                        <div class="feature-icon green mx-auto mb-3" style="width:100px;height:100px;font-size:3rem;"><i class="bi bi-trophy"></i></div>
                        <h2 style="color:var(--success);">Congratulations!</h2>
                        <p class="text-muted">You passed the quiz!</p>
                    <% } else { %>
                        <div class="feature-icon" style="background:rgba(231,76,60,0.1);color:var(--danger);width:100px;height:100px;font-size:3rem;margin:0 auto;"><i class="bi bi-x-circle"></i></div>
                        <h2 style="color:var(--danger);">Not Quite There</h2>
                        <p class="text-muted">Keep studying and try again!</p>
                    <% } %>
                    <hr/>
                    <div class="row mb-4">
                        <div class="col-4"><h3 class="text-gradient mb-0" style="font-family:var(--font-mono);"><%= score %>%</h3><small class="text-muted">Score</small></div>
                        <div class="col-4"><h3 style="color:var(--success);font-family:var(--font-mono);" class="mb-0"><%= correctAnswers %></h3><small class="text-muted">Correct</small></div>
                        <div class="col-4"><h3 style="color:var(--secondary);font-family:var(--font-mono);" class="mb-0"><%= totalQuestions %></h3><small class="text-muted">Total</small></div>
                    </div>
                    <div class="progress mb-4" style="height:12px;">
                        <div class="progress-bar" style="width:<%= score %>%;background:<%= passed ? "var(--success)" : "var(--danger)" %>;"></div>
                    </div>
                    <div class="d-grid gap-2">
                        <a href="Courses.aspx" class="btn-lumora-primary"><i class="bi bi-collection-play me-2"></i>Browse Courses</a>
                        <a href="Dashboard.aspx" class="btn btn-lumora-secondary"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
