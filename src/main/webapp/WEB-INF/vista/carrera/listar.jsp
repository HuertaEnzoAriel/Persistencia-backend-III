<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Carreras</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <div class="barra">
        <div><h1>Carreras</h1><p class="sub">${empty lista ? 0 : lista.size()} registro(s)</p></div>
        <a class="btn verde" href="${pageContext.request.contextPath}/carrera/nuevo">+ Nueva carrera</a>
    </div>
    <table>
        <tr><th>ID</th><th>Nombre</th><th>Facultad</th><th></th></tr>
        <c:forEach items="${lista}" var="x">
            <tr>
                <td>${x.idcarrera}</td>
                <td>${x.nombre}</td><td><span class="chip">${x.facultadIdfacultad.nombre}</span></td>
                <td class="acciones">
                    <a class="btn chico" href="${pageContext.request.contextPath}/carrera/editar?id=${x.idcarrera}">Editar</a>
                    <form action="${pageContext.request.contextPath}/carrera/eliminar" method="post"
                          onsubmit="return confirm('¿Eliminar carrera?')">
                        <input type="hidden" name="id" value="${x.idcarrera}">
                        <button class="btn chico rojo" type="submit">Eliminar</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty lista}"><tr><td colspan="4" class="vacio-msg">No hay registros todavía.</td></tr></c:if>
    </table>
</main></body></html>
