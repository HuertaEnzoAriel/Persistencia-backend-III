<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mesas de julio</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>Mesas de examen - turno de julio</h1>
    <p class="sub">Exámenes rendidos en julio, con los datos de cada alumno</p>
    <form class="barra" action="${pageContext.request.contextPath}/consulta/julio" method="get">
        <div><label for="anio">Año</label>
            <input type="text" id="anio" name="anio" value="${anio}" placeholder="todos los años" style="width:120px"></div>
        <button class="btn" type="submit">Filtrar</button>
    </form>
    <table>
        <tr><th>Fecha</th><th>Materia</th><th>Alumno</th><th>Nota</th></tr>
        <c:forEach items="${lista}" var="e">
            <tr>
                <td><fmt:formatDate value="${e.examenPK.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td>${e.materia.nombre}</td>
                <td>${e.alumno.nombre}</td>
                <td><span class="chip">${e.nota}</span></td>
            </tr>
        </c:forEach>
        <c:if test="${empty lista}"><tr><td colspan="4" class="vacio-msg">No hay exámenes en julio<c:if test="${not empty anio}"> de ${anio}</c:if>.</td></tr></c:if>
    </table>
</main></body></html>
