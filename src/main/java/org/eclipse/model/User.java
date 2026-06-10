package org.eclipse.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_user")
    private int id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(name = "first_name", nullable = false)
    private String firstName;

    @Column(name = "last_name", nullable = false)
    private String lastName;

    private String phone;

    private String role = "CLIENT";

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    public User() {
        this.createdAt = new Date();
    }

    public User(String firstName, String lastName, String email, String phone, String password) {
        this();
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        
        if (email != null && email.endsWith("@voyageconnect.com")) {
            this.role = "ADMIN";
        } else {
            this.role = "CLIENT";
        }
    }

    


    // Getters et Setters (nécessaires à Hibernate)
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    //public String getUsername() { return username; }
    //public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; 
    
    // Mettre à jour le rôle si l'email change
    if (email != null && email.endsWith("@voyageconnect.com")) {
        this.role = "ADMIN";
    } else {
        this.role = "CLIENT";
    }
    
    }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    // Méthode utilitaire pour obtenir le nom complet
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    // Méthodes  pour vérifier si l'utilisateur est admin
 
    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role);
    }
    
    public boolean isClient() {
        return "CLIENT".equalsIgnoreCase(role);
    }
    
    @Override
    public String toString() {
        return "User [id=" + id + ", nom=" + firstName + ", prenom=" + lastName + 
               ", email=" + email + ", role=" + role + "]";
    }
}