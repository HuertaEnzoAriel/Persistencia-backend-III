/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package sesiones;

import com.mycompany.alumnos.Docente;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

/**
 *
 * @author enzo
 */
@Stateless
public class DocenteFacade extends AbstractFacade<Docente> {

    @PersistenceContext(unitName = "my_persistence_unit")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public DocenteFacade() {
        super(Docente.class);
    }

    /** Docentes que dictan más de n materias. */
    public java.util.List<Docente> findConMasDeMaterias(int n) {
        return em.createQuery("SELECT DISTINCT d FROM Docente d LEFT JOIN FETCH d.materiaCollection "
                + "WHERE SIZE(d.materiaCollection) > :n ORDER BY d.nombre", Docente.class)
                .setParameter("n", n)
                .getResultList();
    }
}
