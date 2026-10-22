package com.mycompany.alumnos.controlador;

import com.mycompany.alumnos.Alumno;
import com.mycompany.alumnos.Carrera;
import com.mycompany.alumnos.Facultad;
import com.mycompany.alumnos.Materia;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import sesiones.AlumnoFacade;
import sesiones.CarreraFacade;
import sesiones.DocenteFacade;
import sesiones.ExamenFacade;
import sesiones.FacultadFacade;
import sesiones.MateriaFacade;

@WebServlet(name = "Manejador", loadOnStartup = 1, urlPatterns = {
    "/alumno/listar", "/alumno/nuevo", "/alumno/editar", "/alumno/guardar", "/alumno/eliminar",
    "/materia/listar", "/materia/nuevo", "/materia/editar", "/materia/guardar", "/materia/eliminar",
    "/carrera/listar", "/carrera/nuevo", "/carrera/editar", "/carrera/guardar", "/carrera/eliminar",
    "/Facultad",
    "/consulta/julio", "/consulta/sinexamenes", "/consulta/docentes"
})
public class Manejador extends HttpServlet {

    @EJB
    private FacultadFacade facu;
    @EJB
    private CarreraFacade carreraFacade;
    @EJB
    private AlumnoFacade alumnoFacade;
    @EJB
    private MateriaFacade materiaFacade;
    @EJB
    private ExamenFacade examenFacade;
    @EJB
    private DocenteFacade docenteFacade;

    @Override
    public void init() throws ServletException {
        // Almacena la lista de facultades en el contexto del servlet (menú principal)
        getServletContext().setAttribute("facultades", facu.findAll());
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String path = request.getServletPath();
        String ctx = request.getContextPath();
        String url = "/index.jsp";

        try {
            switch (path) {
                // ---------- FACULTAD (menú dinámico) ----------
                case "/Facultad":
                    Facultad miFacu = facu.find(idParam(request, "codigoFacu"));
                    if (miFacu == null) {
                        throw new IllegalArgumentException("La facultad solicitada no existe.");
                    }
                    request.setAttribute("facultad", miFacu);
                    request.setAttribute("carreras", carreraFacade.findByFacultad(miFacu.getIdfacultad()));
                    url = "/WEB-INF/vista/facultad/carreras.jsp";
                    break;

                // ---------- CONSULTAS (Ejercicio 6) ----------
                case "/consulta/julio":
                    Integer anioJulio = anioParam(request);
                    request.setAttribute("anio", anioJulio);
                    request.setAttribute("lista", examenFacade.findMesasJulio(anioJulio));
                    url = "/WEB-INF/vista/consulta/julio.jsp";
                    break;

                case "/consulta/sinexamenes":
                    Integer anioSin = anioParam(request);
                    if (anioSin == null) {
                        anioSin = java.time.Year.now().getValue();
                    }
                    request.setAttribute("anio", anioSin);
                    request.setAttribute("lista", alumnoFacade.findSinExamenesEnAnio(anioSin));
                    url = "/WEB-INF/vista/consulta/sinexamenes.jsp";
                    break;

                case "/consulta/docentes":
                    request.setAttribute("lista", docenteFacade.findConMasDeMaterias(2));
                    url = "/WEB-INF/vista/consulta/docentes.jsp";
                    break;

                // ---------- ALUMNO ----------
                case "/alumno/listar":
                    request.setAttribute("lista", alumnoFacade.findAll());
                    url = "/WEB-INF/vista/alumno/listar.jsp";
                    break;

                case "/alumno/nuevo":
                    request.setAttribute("alumno", new Alumno());
                    request.setAttribute("carreras", carreraFacade.findAll());
                    url = "/WEB-INF/vista/alumno/form.jsp";
                    break;

                case "/alumno/editar":
                    request.setAttribute("alumno", alumnoFacade.find(idParam(request, "id")));
                    request.setAttribute("carreras", carreraFacade.findAll());
                    url = "/WEB-INF/vista/alumno/form.jsp";
                    break;

                case "/alumno/guardar":
                    String idAlumno = request.getParameter("idalumno");
                    Carrera carrera = carreraFacade.find(idParam(request, "carrera"));
                    Alumno a = (idAlumno == null || idAlumno.isEmpty())
                            ? new Alumno() : alumnoFacade.find(Integer.valueOf(idAlumno));
                    a.setNombre(request.getParameter("nombre"));
                    a.setRegistro(request.getParameter("registro"));
                    a.setCarreraIdcarrera(carrera);
                    if (a.getIdalumno() == null) {
                        alumnoFacade.create(a);
                    } else {
                        alumnoFacade.edit(a);
                    }
                    response.sendRedirect(ctx + "/alumno/listar");
                    return;

                case "/alumno/eliminar":
                    alumnoFacade.remove(alumnoFacade.find(idParam(request, "id")));
                    response.sendRedirect(ctx + "/alumno/listar");
                    return;

                // ---------- MATERIA ----------
                case "/materia/listar":
                    request.setAttribute("lista", materiaFacade.findAll());
                    url = "/WEB-INF/vista/materia/listar.jsp";
                    break;

                case "/materia/nuevo":
                    request.setAttribute("materia", new Materia());
                    url = "/WEB-INF/vista/materia/form.jsp";
                    break;

                case "/materia/editar":
                    request.setAttribute("materia", materiaFacade.find(idParam(request, "id")));
                    url = "/WEB-INF/vista/materia/form.jsp";
                    break;

                case "/materia/guardar":
                    String idMateria = request.getParameter("idmateria");
                    Materia m = (idMateria == null || idMateria.isEmpty())
                            ? new Materia() : materiaFacade.find(Integer.valueOf(idMateria));
                    m.setNombre(request.getParameter("nombre"));
                    if (m.getIdmateria() == null) {
                        materiaFacade.create(m);
                    } else {
                        materiaFacade.edit(m);
                    }
                    response.sendRedirect(ctx + "/materia/listar");
                    return;

                case "/materia/eliminar":
                    materiaFacade.remove(materiaFacade.find(idParam(request, "id")));
                    response.sendRedirect(ctx + "/materia/listar");
                    return;

                // ---------- CARRERA ----------
                case "/carrera/listar":
                    request.setAttribute("lista", carreraFacade.findAll());
                    url = "/WEB-INF/vista/carrera/listar.jsp";
                    break;

                case "/carrera/nuevo":
                    request.setAttribute("carrera", new Carrera());
                    request.setAttribute("listaFacultades", facu.findAll());
                    url = "/WEB-INF/vista/carrera/form.jsp";
                    break;

                case "/carrera/editar":
                    request.setAttribute("carrera", carreraFacade.find(idParam(request, "id")));
                    request.setAttribute("listaFacultades", facu.findAll());
                    url = "/WEB-INF/vista/carrera/form.jsp";
                    break;

                case "/carrera/guardar":
                    String idCarrera = request.getParameter("idcarrera");
                    Facultad facultad = facu.find(idParam(request, "facultad"));
                    Carrera c = (idCarrera == null || idCarrera.isEmpty())
                            ? new Carrera() : carreraFacade.find(Integer.valueOf(idCarrera));
                    c.setNombre(request.getParameter("nombre"));
                    c.setFacultadIdfacultad(facultad);
                    if (c.getIdcarrera() == null) {
                        carreraFacade.create(c);
                    } else {
                        carreraFacade.edit(c);
                    }
                    response.sendRedirect(ctx + "/carrera/listar");
                    return;

                case "/carrera/eliminar":
                    carreraFacade.remove(carreraFacade.find(idParam(request, "id")));
                    response.sendRedirect(ctx + "/carrera/listar");
                    return;
            }
        } catch (IllegalArgumentException ex) {
            request.setAttribute("error", ex.getMessage() != null ? ex.getMessage() : "Parámetro inválido.");
            url = "/WEB-INF/vista/error.jsp";
        } catch (Exception ex) {
            request.setAttribute("error", "No se pudo completar la operación: " + ex.getMessage());
            url = "/WEB-INF/vista/error.jsp";
        }

        request.getRequestDispatcher(url).forward(request, response);
    }

    /** Lee un parámetro numérico obligatorio. NumberFormatException es una IllegalArgumentException. */
    private Integer idParam(HttpServletRequest request, String nombre) {
        String valor = request.getParameter(nombre);
        if (valor == null || valor.isBlank()) {
            throw new IllegalArgumentException("Falta el parámetro '" + nombre + "'.");
        }
        return Integer.valueOf(valor.trim());
    }

    /** Año opcional (?anio=2025); null si no viene. */
    private Integer anioParam(HttpServletRequest request) {
        String valor = request.getParameter("anio");
        return (valor == null || valor.isBlank()) ? null : Integer.valueOf(valor.trim());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
