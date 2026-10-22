/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sesiones;

import com.mycompany.alumnos.Examen;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/**
 *
 * @author enzo
 */
@Stateless
public class ExamenFacade extends AbstractFacade<Examen> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public ExamenFacade() {
        super(Examen.class);
    }

    /** Mesas de examen del turno de julio (mes 7), con alumno y materia. anio null = todos los años. */
    public java.util.List<Examen> findMesasJulio(Integer anio) {
        String jpql = "SELECT e FROM Examen e JOIN FETCH e.alumno JOIN FETCH e.materia "
                + "WHERE FUNCTION('MONTH', e.examenPK.fecha) = 7 "
                + (anio != null ? "AND FUNCTION('YEAR', e.examenPK.fecha) = :anio " : "")
                + "ORDER BY e.examenPK.fecha, e.materia.nombre, e.alumno.nombre";
        jakarta.persistence.TypedQuery<Examen> q = em.createQuery(jpql, Examen.class);
        if (anio != null) {
            q.setParameter("anio", anio);
        }
        return q.getResultList();
    }
}
