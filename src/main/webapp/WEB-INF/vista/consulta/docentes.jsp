<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Docentes</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>Docentes que dictan más de 2 materias</h1>
    <p class="sub">${lista.size()} docente(s)</p>
    <table>
        <tr><th>Docente</th><th>Cargo</th><th>Materias</th></tr>
        <c:forEach items="${lista}" var="d">
            <tr>
                <td>${d.nombre}</td>
                <td><span class="chip">${d.cargo}</span></td>
                <td><c:forEach items="${d.materiaCollection}" var="m" varStatus="st">${m.nombre}${st.last ? "" : ", "}</c:forEach>
                    (${d.materiaCollection.size()})</td>
            </tr>
        </c:forEach>
        <c:if test="${empty lista}"><tr><td colspan="3" class="vacio-msg">Ningún docente dicta más de 2 materias.</td></tr></c:if>
    </table>
</main></body></html>
