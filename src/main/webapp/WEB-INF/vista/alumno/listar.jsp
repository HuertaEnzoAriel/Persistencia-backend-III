<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Alumnos</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <div class="barra">
        <div><h1>Alumnos</h1><p class="sub">${empty lista ? 0 : lista.size()} registro(s)</p></div>
        <a class="btn verde" href="${pageContext.request.contextPath}/alumno/nuevo">+ Nuevo alumno</a>
    </div>
    <table>
        <tr><th>ID</th><th>Nombre</th><th>Registro</th><th>Carrera</th><th></th></tr>
        <c:forEach items="${lista}" var="x">
            <tr>
                <td>${x.idalumno}</td>
                <td>${x.nombre}</td><td>${x.registro}</td><td><span class="chip">${x.carreraIdcarrera.nombre}</span></td>
                <td class="acciones">
                    <a class="btn chico" href="${pageContext.request.contextPath}/alumno/editar?id=${x.idalumno}">Editar</a>
                    <form action="${pageContext.request.contextPath}/alumno/eliminar" method="post"
                          onsubmit="return confirm('¿Eliminar alumno?')">
                        <input type="hidden" name="id" value="${x.idalumno}">
                        <button class="btn chico rojo" type="submit">Eliminar</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty lista}"><tr><td colspan="5" class="vacio-msg">No hay registros todavía.</td></tr></c:if>
    </table>
</main></body></html>
