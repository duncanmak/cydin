<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="Cydin.Views.UserViewPage" %>
<%@ Import Namespace="Cydin.Builder" %>
<%@ Import Namespace="Cydin.Properties" %>
<%@ Import Namespace="Cydin.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Site Administration
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
	<script type="text/javascript" src="/Scripts/jquery.cookie.js"></script> 
	<script type="text/javascript">
		$(function() {
			$("#tabs").tabs( {cookie: { expires: 1 } });
		});
	</script>
    <h2>Administration</h2>

	<div id="tabs">
	<ul>
		<li><a href="#tabs-1">Build Service</a></li>
		<li><a href="#tabs-2">Applications</a></li>
		<li><a href="/SiteAdmin/UsersList">Users</a></li>
		<li><a href="/SiteAdmin/EditSettings">Settings</a></li>
		<li><a href="/SiteAdmin/Log">Server Log</a></li>
	</ul>
	
	<div id="tabs-1">
	<b>Cydin version:</b> <%=CurrentServiceModel.Version%><br>
    <b>Service Address:</b> <%=BuildService.AuthorisedBuildBotConnection %><br>
    <b>Status:</b> <%=BuildService.Status %><br><br>
    
    <% if (!BuildService.AllowChangingService) { %>
   	    <%=Html.ActionLink ("Change Service", "EnableServiceChange") %>
    <% } else if (string.IsNullOrEmpty (BuildService.BuildBotConnectionRequest)) { %>
   	    <p>There no build service connection requests</p>
   	    <%=Html.ActionLink ("Cancel Service Change", "DisableServiceChange") %>
    <% } else { %>
    	<p>There is a build service connection request from: <b><%=BuildService.BuildBotConnectionRequest%></b></p>
   	    <%=Html.ActionLink ("Authorize Connection", "AuthorizeServiceChange") %>
   	    <%=Html.ActionLink ("Cancel Service Change", "DisableServiceChange") %>
    <% } %>
    </div>
    <div id="tabs-2">
    <%
			var apps = CurrentServiceModel.GetApplications ();
			if (!apps.Any ())
				Response.Write ("There are no applications defined.");
			else { %>
    <table>
    <tr><th>Name</th><th>Subdomain</th><th>Platforms</th><th></th></tr>
	<%
		foreach (Application app in CurrentServiceModel.GetApplications ()) { %>
    <tr>
    <td> <%=Html.ActionLink (app.Name, "EditApplication", "SiteAdmin", new { id = app.Id }, null) %> </td>
	<td> <%=app.Subdomain%> </td>
	<td> <%=app.Platforms%> </td>
    <td> <%=Html.ActionLink ("Delete", "DeleteApplication", "SiteAdmin", new { id = app.Id }, null) %> </td>
    </tr>
    <% } } %>
    </table>

	<% if (Settings.Default.SupportsMultiApps || apps.Count() == 0) { %>
  	<p><%=Html.ActionLink ("Add new application", "NewApplication") %></p>
	<% } %>
	</div>

	</div>
    
</asp:Content>
