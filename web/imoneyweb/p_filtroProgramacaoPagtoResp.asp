<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="recursos/p_funcoesasp.asp" -->
<%
	session("gS_nmCriterio")=""
	session("gS_CriterioProgramacao")=""
	session("dDtIni")="":session("dDtFim")=""
	
	if request.QueryString("acao")="limpar" then response.Redirect("pg_consultaProgramacaoPagto.asp")
	
	if request.Form("txtDtIni") <> "" then session("dDtIni")=request.Form("txtDtIni")
	if request.Form("txtDtFim") <> "" then session("dDtFim")=request.Form("txtDtFim")
	
	if (session("dDtIni") <> "" or session("dDtFim") <> "") then 
		if not isdate(session("dDtIni")) then Mensagem "Data","Data Inicial informada e invalida!"
		if not isdate(session("dDtFim")) then Mensagem "Data","Data Final informada e invalida!"
		sCrit = "pg.pgt_data >= '" & FormataData(session("dDtIni"),"yyyy/mm/dd") & "'"
		sCrit = sCrit  & " and pg.pgt_data <= '" & FormataData(session("dDtFim"),"yyyy/mm/dd") & "'"
		
		session("gS_nmCriterio") = "Data Pesquisada: " & FormataData(session("dDtIni"),"dd/mm/yyyy") & " a " & FormataData(session("dDtFim"),"dd/mm/yyyy")
	end if
	
	if (request.Form("chkPendente") = "1") then 
		if (sCrit <> "") then session("gS_nmCriterio") = session("gS_nmCriterio") & "<br>"
		
		if (Trim(sCrit) = "") then 
		  sCrit = "pg.pgt_status = 0" 
		else 
		  sCrit = sCrit  & " and pg.pgt_status = 0"
		end if  
		session("gS_nmCriterio") = session("gS_nmCriterio") & "Programa��es pendentes"		
	end if	
	
	session("gS_CriterioProgramacao")=sCrit
	response.Redirect("pg_consultaProgramacaoPagto.asp")

%>