package org.eclipse.model;

import javax.persistence.*;

import org.eclipse.model.Destination;
import org.eclipse.model.OfferType;

import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "offer")

public class Offer {
	 @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id_offer;  // BIGINT AUTO_INCREMENT

	    @Enumerated(EnumType.STRING)
	    private OfferType type; // ENUM('FLIGHT','HOTEL','TOUR')

	    @Column(nullable = false, length = 255)
	    private String title;

	    @Column(columnDefinition = "TEXT")
	    private String description;

	    // Relation ManyToOne avec Destination (clé étrangère)
	    @ManyToOne
	    @JoinColumn(name = "destination_id")
	    private Destination destination;

	    @Column(nullable = false)
	    private BigDecimal price; // DECIMAL(10,2)

	    @Column(name = "available_from")
	    @Temporal(TemporalType.DATE)
	    private Date availableFrom;

	    @Column(name = "available_to")
	    @Temporal(TemporalType.DATE)
	    private Date availableTo;

	    private int seats;  // int

	    private int rooms;  // int

	    private boolean activate; // tinyint(1)

	    @Column(name = "created_at")
	    @Temporal(TemporalType.TIMESTAMP)
	    private Date createdAt;

	    // Constructeur vide (obligatoire)
	    public Offer() {}

	    // Getters et setters
	    public Long getId() { return id_offer; }
	    public void setId(Long id) { this.id_offer = id; }

	    public OfferType getType() { return type; }
	    public void setType(OfferType type) { this.type = type; }

	    public String getTitle() { return title; }
	    public void setTitle(String title) { this.title = title; }

	    public String getDescription() { return description; }
	    public void setDescription(String description) { this.description = description; }

	    public Destination getDestination() { return destination; }
	    public void setDestination(Destination destination) { this.destination = destination; }

	    public BigDecimal getPrice() { return price; }
	    public void setPrice(BigDecimal price) { this.price = price; }

	    public Date getAvailableFrom() { return availableFrom; }
	    public void setAvailableFrom(Date availableFrom) { this.availableFrom = availableFrom; }

	    public Date getAvailableTo() { return availableTo; }
	    public void setAvailableTo(Date availableTo) { this.availableTo = availableTo; }

	    public int getSeats() { return seats; }
	    public void setSeats(int seats) { this.seats = seats; }

	    public int getRooms() { return rooms; }
	    public void setRooms(int rooms) { this.rooms = rooms; }

	    public boolean isActive() { return activate; }
	    public void setActive(boolean active) { this.activate = active; }

	    public Date getCreatedAt() { return createdAt; }
	    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

}
