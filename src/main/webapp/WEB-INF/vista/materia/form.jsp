<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>materia</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilo.css">
</head>
<body>
<%@include file="/WEB-INF/vista/_menu.jspf"%>
<main>
    <h1>${empty materia.idmateria ? 'Nueva' : 'Editar'} materia</h1>
    <p class="sub">Completá los datos y guardá.</p>
    <form class="tarjeta" action="${pageContext.request.contextPath}/materia/guardar" method="post">
        <input type="hidden" name="idmateria" value="${materia.idmateria}">
        <div class="campo"><label for="nombre">Nombre</label>
            <input type="text" id="nombre" name="nombre" maxlength="45" value="${materia.nombre}" required></div>
        <button class="btn verde" type="submit">Guardar</button>
        <a class="btn gris" href="${pageContext.request.contextPath}/materia/listar">Cancelar</a>
    </form>
</main></body></html>
