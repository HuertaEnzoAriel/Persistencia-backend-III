<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Carreras de la facultad</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>${facultad.nombre}</h1>
    <p class="sub">Carreras que se dictan en esta facultad</p>
    <table>
        <tr><th>#</th><th>Carrera</th></tr>
        <c:forEach var="carr" items="${carreras}">
            <tr><td>${carr.idcarrera}</td><td>${carr.nombre}</td></tr>
        </c:forEach>
        <c:if test="${empty carreras}"><tr><td colspan="2" class="vacio-msg">Esta facultad no tiene carreras cargadas.</td></tr></c:if>
    </table>
    <p><a class="btn gris" href="${pageContext.request.contextPath}/index.jsp">Volver</a></p>
</main></body></html>
