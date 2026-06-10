package org.eclipse.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "destinations") // Note: nom de table au pluriel
public class Destination {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String country;

    @Column(nullable = false, length = 100)
    private String city;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "image_url", length = 500)
    private String imageUrl; // Nouveau champ pour l'URL de l'image

    @Column(name = "price")
    private Double price; // Prix du voyage

    @Column(name = "duration")
    private Integer duration; // Durée en jours

    @Column(name = "category", length = 50)
    private String category; // Catégorie (Plage, Montagne, Ville, etc.)

    @Column(name = "created_at")
    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    // Constructeur vide (obligatoire pour JPA)
    public Destination() {}

    // Constructeur avec paramètres
    public Destination(String country, String city, String description, String imageUrl, Double price, Integer duration, String category) {
        this.country = country;
        this.city = city;
        this.description = description;
        this.imageUrl = imageUrl;
        this.price = price;
        this.duration = duration;
        this.category = category;
        this.createdAt = new Date();
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }

    public Integer getDuration() { return duration; }
    public void setDuration(Integer duration) { this.duration = duration; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    // Méthode utilitaire pour obtenir le nom complet
    public String getFullName() {
        return city + ", " + country;
    }

    // Méthode utilitaire pour obtenir le prix formaté
    public String getFormattedPrice() {
        if (price == null) return "Sur demande";
        return String.format("%,.0f", price) + " DH";
    }
}