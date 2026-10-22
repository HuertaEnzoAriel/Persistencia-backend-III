package com.mycompany.alumnos;

import jakarta.persistence.Basic;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.NamedQueries;
import jakarta.persistence.NamedQuery;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.io.Serializable;
import java.util.Collection;

/**
 * Docente: integra el equipo de cátedra de una o más materias.
 */
@Entity
@Table(name = "docente", catalog = "universidad", schema = "")
@NamedQueries({
    @NamedQuery(name = "Docente.findAll", query = "SELECT d FROM Docente d")})
public class Docente implements Serializable {

    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "iddocente", nullable = false)
    private Integer iddocente;
    @Size(max = 45)
    @Column(name = "nombre", length = 45, nullable = false)
    private String nombre;
    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "cargo", nullable = false)
    private Cargo cargo;
    @ManyToMany
    @JoinTable(name = "materia_has_docente", catalog = "universidad",
            joinColumns = @JoinColumn(name = "docente_iddocente", referencedColumnName = "iddocente"),
            inverseJoinColumns = @JoinColumn(name = "materia_idmateria", referencedColumnName = "idmateria"))
    private Collection<Materia> materiaCollection;

    public Docente() {
    }

    public Integer getIddocente() {
        return iddocente;
    }

    public void setIddocente(Integer iddocente) {
        this.iddocente = iddocente;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public Cargo getCargo() {
        return cargo;
    }

    public void setCargo(Cargo cargo) {
        this.cargo = cargo;
    }

    public Collection<Materia> getMateriaCollection() {
        return materiaCollection;
    }

    public void setMateriaCollection(Collection<Materia> materiaCollection) {
        this.materiaCollection = materiaCollection;
    }

    @Override
    public int hashCode() {
        return iddocente != null ? iddocente.hashCode() : 0;
    }

    @Override
    public boolean equals(Object object) {
        if (!(object instanceof Docente)) {
            return false;
        }
        Docente other = (Docente) object;
        return !((this.iddocente == null && other.iddocente != null)
                || (this.iddocente != null && !this.iddocente.equals(other.iddocente)));
    }

    @Override
    public String toString() {
        return "com.mycompany.alumnos.Docente[ iddocente=" + iddocente + " ]";
    }

}
