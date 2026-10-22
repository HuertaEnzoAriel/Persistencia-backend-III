/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sesiones;

import com.mycompany.alumnos.Alumno;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/**
 *
 * @author enzo
 */
@Stateless
public class AlumnoFacade extends AbstractFacade<Alumno> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AlumnoFacade() {
        super(Alumno.class);
    }

    /** Alumnos que no rindieron ninguna materia durante el año indicado. */
    public java.util.List<Alumno> findSinExamenesEnAnio(int anio) {
        return em.createQuery("SELECT a FROM Alumno a WHERE NOT EXISTS ("
                + "SELECT e FROM Examen e WHERE e.alumno = a AND FUNCTION('YEAR', e.examenPK.fecha) = :anio) "
                + "ORDER BY a.nombre", Alumno.class)
                .setParameter("anio", anio)
                .getResultList();
    }
}
