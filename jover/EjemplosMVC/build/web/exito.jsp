<%-- 
    Document   : exito
    Created on : 11/09/2021, 11:31:46 p. m.
    Author     : IngKristianVel
--%>

<%@page import="Modelo.Persona" %>
<%
Persona p1 = (Persona)request.getSession().getAttribute("persona1");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Datos recibidos correctamente</h1>
        <p>Nombre: <%= p1.getNombre()%> </p>
        <p>Edad: <%= p1.getEdad()%> </p>
        <a href="index.jsp">Volver al indice </a>
    </body>
</html>
