package org.eclipse.model;

import javax.persistence.*;

import org.eclipse.model.Offer;
import org.eclipse.model.User;

import java.util.Date;

@Entity
@Table(name = "reviews")
public class Review {
	
	 @Id
	    @GeneratedValue(strategy = GenerationType.IDENTITY)
	    private Long id;

	    // Relation ManyToOne avec User
	    @ManyToOne
	    @JoinColumn(name = "user_id", nullable = false)
	    private User user;

	    // Relation ManyToOne avec Offer
	    @ManyToOne
	    @JoinColumn(name = "offer_id", nullable = false)
	    private Offer offer;

	    @Column(nullable = false)
	    private int rating;

	    @Column(columnDefinition = "TEXT")
	    private String comment;

	    @Temporal(TemporalType.TIMESTAMP)
	    @Column(name = "created_at")
	    private Date createdAt;

	    public Review() {}

	    // Getters & Setters
	    public Long getId() { return id; }
	    public void setId(Long id) { this.id = id; }

	    public User getUser() { return user; }
	    public void setUser(User user) { this.user = user; }

	    public Offer getOffer() { return offer; }
	    public void setOffer(Offer offer) { this.offer = offer; }

	    public int getRating() { return rating; }
	    public void setRating(int rating) { this.rating = rating; }

	    public String getComment() { return comment; }
	    public void setComment(String comment) { this.comment = comment; }

	    public Date getCreatedAt() { return createdAt; }
	    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }


}
