<%@ Page Title="Take Quiz" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TakeQuiz.aspx.cs" Inherits="LumoraWebForms.Pages.TakeQuiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="glass-card p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="mb-0"><i class="bi bi-clipboard-check me-2 text-primary"></i><asp:Literal ID="litQuizTitle" runat="server" /></h4>
                        <span class="badge" style="background:rgba(108,92,231,0.1);color:var(--primary);"><i class="bi bi-clock me-1"></i><asp:Literal ID="litTimeLimit" runat="server" /> min</span>
                    </div>

                    <asp:Repeater ID="rptQuestions" runat="server">
                        <ItemTemplate>
                            <div class="glass-card-sm mb-4">
                                <h6 class="text-primary">Question <%# Container.ItemIndex + 1 %></h6>
                                <p class="fw-semibold mb-3"><%# Eval("QuestionText") %></p>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="q<%# Eval("Id") %>" value="1" id="q<%# Eval("Id") %>_o1" required />
                                    <label class="form-check-label" for="q<%# Eval("Id") %>_o1"><%# Eval("Option1") %></label>
                                </div>
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="q<%# Eval("Id") %>" value="2" id="q<%# Eval("Id") %>_o2" />
                                    <label class="form-check-label" for="q<%# Eval("Id") %>_o2"><%# Eval("Option2") %></label>
                                </div>
                                <%# !string.IsNullOrEmpty(Eval("Option3")?.ToString()) ? "<div class='form-check mb-2'><input class='form-check-input' type='radio' name='q" + Eval("Id") + "' value='3' id='q" + Eval("Id") + "_o3' /><label class='form-check-label' for='q" + Eval("Id") + "_o3'>" + Eval("Option3") + "</label></div>" : "" %>
                                <%# !string.IsNullOrEmpty(Eval("Option4")?.ToString()) ? "<div class='form-check mb-2'><input class='form-check-input' type='radio' name='q" + Eval("Id") + "' value='4' id='q" + Eval("Id") + "_o4' /><label class='form-check-label' for='q" + Eval("Id") + "_o4'>" + Eval("Option4") + "</label></div>" : "" %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div class="d-flex justify-content-between">
                        <a href='Learn.aspx?courseId=<%= courseId %>&lessonId=<%= lessonId %>' class="btn btn-lumora-secondary"><i class="bi bi-arrow-left me-2"></i>Back</a>
                        <asp:Button ID="btnSubmit" runat="server" CssClass="btn-lumora-primary" Text="Submit Quiz" OnClick="btnSubmit_Click" OnClientClick="return confirm('Submit quiz?');" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
