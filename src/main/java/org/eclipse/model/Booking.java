package org.eclipse.model;

import javax.persistence.*;

import java.util.Date;
import java.math.BigDecimal; // IMPORTANT: pour total_amount

@Entity
@Table(name = "booking") 
public class Booking {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_booking") 
    private Long id;

    // Relation avec User
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Relation avec Offer
    @ManyToOne
    @JoinColumn(name = "offer_id", nullable = false)
    private Offer offer;

    @Column(name = "start_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date startDate;

    @Column(name = "end_date", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date endDate;

    @Column(nullable = false)
    private int quantity;

    @Column(name = "booking_date", nullable = false) // Non null dans la table
    @Temporal(TemporalType.DATE) // CHANGÉ: DATE pas TIMESTAMP
    private Date bookingDate;

    // ENUM BookingStatus
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30) // Correspond à varchar(30)
    private BookingStatus status;

    @Column(name = "total_amount", nullable = false, precision = 10, scale = 2) // decimal(10,2)
    private BigDecimal totalAmount; // CHANGÉ: double -> BigDecimal

    // Constructeur vide (obligatoire pour JPA)
    public Booking() {}

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Offer getOffer() { return offer; }
    public void setOffer(Offer offer) { this.offer = offer; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public BookingStatus getStatus() { return status; }
    public void setStatus(BookingStatus status) { this.status = status; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
}