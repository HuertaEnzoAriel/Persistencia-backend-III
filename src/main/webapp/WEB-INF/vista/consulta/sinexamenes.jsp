<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Alumnos sin exámenes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>Alumnos sin exámenes en ${anio}</h1>
    <p class="sub">Alumnos que no rindieron ninguna materia durante ese año</p>
    <form class="barra" action="${pageContext.request.contextPath}/consulta/sinexamenes" method="get">
        <div><label for="anio">Año</label>
            <input type="text" id="anio" name="anio" value="${anio}" placeholder="año actual" style="width:120px"></div>
        <button class="btn" type="submit">Filtrar</button>
    </form>
    <table>
        <tr><th>ID</th><th>Nombre</th><th>Registro</th><th>Carrera</th></tr>
        <c:forEach items="${lista}" var="a">
            <tr><td>${a.idalumno}</td><td>${a.nombre}</td><td>${a.registro}</td>
                <td><span class="chip">${a.carreraIdcarrera.nombre}</span></td></tr>
        </c:forEach>
        <c:if test="${empty lista}"><tr><td colspan="4" class="vacio-msg">Todos los alumnos rindieron al menos una materia en ${anio}.</td></tr></c:if>
    </table>
</main></body></html>
