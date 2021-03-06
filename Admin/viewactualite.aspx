<%@ Page%>
<%@ Import NameSpace="System.Data"%>
<%@ Import NameSpace="System.Data.SqlClient"%>
<%@ Register Tagprefix="Controls" TagName="Top" src="top.ascx"%>
<%@ Register Tagprefix="Controls" TagName="Left" src="left.ascx"%>
<%@ Register Tagprefix="Controls" TagName="User" src="user.ascx"%>
<html>
	<head>
		<title>Air Alg�rie - Voir une actualit�</title>
		<script language="Javascript" src="script/js.js"></script>
		<link type=text/css href="style/style.css" rel=stylesheet>
	</head>
<body onLoad="debuteDate();debuteTemps()" onUnload="clearTimeout(ddate);clearTimeout(ttime)">

	<form runat="server">
    	<Controls:Top id="top" runat="server" />
    	<Controls:User id="User" runat="server" /> 
    	
    	<table align="center" cellspacing="0" width="760" cellpadding="0" >
			<tr>
    			<td width="140" valign=top>
    				<p><Controls:Left id="Left" runat="server" /></p>
				</td>
				<td width="620" valign=top>
    				<table width="100%">
    						<th align="center" colspan="2">Voir une actualit�</th>
						<tr>
							<td width="10"></td>
							<td>
								<br>
								<p>
									<asp:Button ID="btnDelete" CssClass="Button" Text="Supprimer" OnClick="Delete" Runat="server" Width="70" />&nbsp;	
									<asp:Button CssClass="Button" Text="Retour" OnClick="Retour" Runat="server" Width="60" />	
								</p>
								<br>
								<table>
									<tr>
										<td><b>Intituler:</b></td>
										<td><asp:label id="Intituler" runat="server" /></td>
									</tr>
									<tr>
										<td><b>Date:</b></td>
										<td><asp:label id="DateHeure" runat="server" /></td>
									</tr>	
									<tr>
										<td valign="top"><b>Decription:</b></td>
										<td colspan="2"><span class="Details"><asp:Literal ID="Description" Runat=server /></span></td>
									</tr>																	
								</table>														
								</p>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>
<script runat=server>
void Page_Load(Object sender, EventArgs e)
{
	if (!IsPostBack) {
		int Nu_Actualite = int.Parse(Request.Params["Nu_Actualite"]);
		if (CheckNu(Nu_Actualite)) {
			btnDelete.Attributes.Add("OnClick", "javascript:return confirm('A ce que vous etre s�r ?')");		
			SqlConnection connection = new SqlConnection(ConfigurationSettings.AppSettings["ConnectionString"]);
			connection.Open ();	
			SqlCommand cmd = new SqlCommand	("select Intituler, Description, DateHeure from Actualite where Nu_Actualite = " + Nu_Actualite , connection);	
			SqlDataReader readerdata = cmd.ExecuteReader ();
			while (readerdata.Read ()) {
				DateHeure.Text = readerdata.GetDateTime(2).ToString ("d");
				Intituler.Text = readerdata["Intituler"].ToString ();					
				Description.Text = readerdata["Description"].ToString ();						
			}
			connection.Close ();
		}
		else
			Response.Redirect ("Actualites.aspx");
	}
}
void Delete ( Object sender, EventArgs e)
{
	int Nu_Actualite = int.Parse(Request.Params["Nu_Actualite"]);
	SqlConnection connection = new SqlConnection(ConfigurationSettings.AppSettings["ConnectionString"]);
	try {
		connection.Open();
		SqlCommand command = new SqlCommand	("delete from Actualite where Nu_Actualite =" + Nu_Actualite, connection);
		command.ExecuteNonQuery ();
		Response.Redirect("Actualites.aspx");
		}
	finally {
		connection.Close ();
	}
}
bool CheckNu(int Nu_Actualite)
{
	SqlConnection connection = new SqlConnection(ConfigurationSettings.AppSettings["ConnectionString"]);
	connection.Open ();
	SqlCommand cmd = new SqlCommand("select count (*) from Actualite where Nu_Actualite= " + Nu_Actualite, connection);
	int Nu = (int) cmd .ExecuteScalar ();
	return ( Nu > 0 );
	connection.Close ();
}
void Retour ( Object sender, EventArgs e)
{
	Response.Redirect("actualites.aspx");
}
</script>