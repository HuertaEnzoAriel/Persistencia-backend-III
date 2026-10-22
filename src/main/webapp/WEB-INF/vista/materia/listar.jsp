<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Materias</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <div class="barra">
        <div><h1>Materias</h1><p class="sub">${empty lista ? 0 : lista.size()} registro(s)</p></div>
        <a class="btn verde" href="${pageContext.request.contextPath}/materia/nuevo">+ Nueva materia</a>
    </div>
    <table>
        <tr><th>ID</th><th>Nombre</th><th></th></tr>
        <c:forEach items="${lista}" var="x">
            <tr>
                <td>${x.idmateria}</td>
                <td>${x.nombre}</td>
                <td class="acciones">
                    <a class="btn chico" href="${pageContext.request.contextPath}/materia/editar?id=${x.idmateria}">Editar</a>
                    <form action="${pageContext.request.contextPath}/materia/eliminar" method="post"
                          onsubmit="return confirm('¿Eliminar materia?')">
                        <input type="hidden" name="id" value="${x.idmateria}">
                        <button class="btn chico rojo" type="submit">Eliminar</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty lista}"><tr><td colspan="3" class="vacio-msg">No hay registros todavía.</td></tr></c:if>
    </table>
</main></body></html>
