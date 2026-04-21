<%-- 
    Document   : index
    Created on : 11/09/2021, 9:27:16 p. m.
    Author     : IngKristianVel
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Formulario de Ejemplo MVC</h1>
        <form action="procesar.do" method="post">
            Nombre: <input type="text" name="txtNombre" /><br />
            Edad: <input type="text" name="txtEdad" /><br />
            <input type="submit" value="Enviar Datos a procesar" >
        </form>
    </body>
</html>
