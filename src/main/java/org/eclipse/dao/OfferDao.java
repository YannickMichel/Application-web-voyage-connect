package org.eclipse.dao;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.model.Offer;
import org.eclipse.model.Destination;
import org.eclipse.model.OfferType;
import metier.SingletonConnection;

public class OfferDao {
    private Connection connection;
    
    public OfferDao() {
        this.connection = SingletonConnection.getConnection();
    }
    
    public OfferDao(Connection connection) {
        this.connection = connection;
    }

    // Récupérer une offre par son ID avec la destination associée
    public Offer getOfferById(Long id) throws SQLException {
        String sql = "SELECT o.*, d.id as dest_id, d.country, d.city, d.description as dest_description, " +
                    "d.image_url, d.duration, d.category " +
                    "FROM offer o " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE o.id_offer = ? AND o.activate = 1";  // CHANGÉ: id -> id_offer
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOffer(rs);
            }
        }
        return null;
    }

    // Récupérer les offres pour une destination spécifique
    public List<Offer> getOffersByDestinationId(Long destinationId) throws SQLException {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT o.*, d.id as dest_id, d.country, d.city, d.description as dest_description, " +
                    "d.image_url, d.duration, d.category " +
                    "FROM offer o " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE o.destination_id = ? AND o.activate = 1 " +
                    "ORDER BY o.available_from";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, destinationId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                offers.add(mapResultSetToOffer(rs));
            }
        }
        return offers;
    }

    // Récupérer la première offre active pour une destination
    public Offer getFirstActiveOfferByDestinationId(Long destinationId) throws SQLException {
        String sql = "SELECT o.*, d.id as dest_id, d.country, d.city, d.description as dest_description, " +
                    "d.image_url, d.duration, d.category " +
                    "FROM offer o " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE o.destination_id = ? AND o.activate = 1 " +
                    "LIMIT 1";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, destinationId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOffer(rs);
            }
        }
        return null;
    }

    // Récupérer toutes les offres disponibles
    public List<Offer> getAllActiveOffers() throws SQLException {
        List<Offer> offers = new ArrayList<>();
        String sql = "SELECT o.*, d.id as dest_id, d.country, d.city, d.description as dest_description, " +
                    "d.image_url, d.duration, d.category " +
                    "FROM offer o " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE o.activate = 1 AND o.available_to >= CURDATE() " +
                    "ORDER BY o.available_from";
        
        try (Statement stmt = connection.createStatement()) {
            ResultSet rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                offers.add(mapResultSetToOffer(rs));
            }
        }
        return offers;
    }

    // Mapper le ResultSet vers un objet Offer
    private Offer mapResultSetToOffer(ResultSet rs) throws SQLException {
        Offer offer = new Offer();
        
        // ID de l'offre (colonne id_offer dans la BDD)
        offer.setId(rs.getLong("id_offer"));  // CHANGÉ: id -> id_offer
        
        // Gestion du type d'offre
        String typeStr = rs.getString("type");
        if (typeStr != null && !typeStr.isEmpty()) {
            try {
                offer.setType(OfferType.valueOf(typeStr.toUpperCase()));
            } catch (IllegalArgumentException e) {
                offer.setType(OfferType.TOUR);
            }
        }
        
        offer.setTitle(rs.getString("title"));
        offer.setDescription(rs.getString("description"));
        offer.setPrice(rs.getBigDecimal("price"));
        
        // Gérer seats (peut être NULL)
        int seats = rs.getInt("seats");
        if (rs.wasNull()) {
            offer.setSeats(0);  // Valeur par défaut
        } else {
            offer.setSeats(seats);
        }
        
        // Gérer rooms (peut être NULL)
        int rooms = rs.getInt("rooms");
        if (rs.wasNull()) {
            offer.setRooms(0);  // Valeur par défaut
        } else {
            offer.setRooms(rooms);
        }
        
        offer.setAvailableFrom(rs.getDate("available_from"));
        offer.setAvailableTo(rs.getDate("available_to"));
        
        // Gérer activate (tinyint)
        boolean activate = rs.getBoolean("activate");
        if (rs.wasNull()) {
            activate = true; // valeur par défaut
        }
        offer.setActive(activate);
        
        // Pas de created_at dans la table, donc on met null
        offer.setCreatedAt(null);
        
        // Créer l'objet Destination associé
        if (rs.getLong("dest_id") > 0) {
            Destination destination = new Destination();
            destination.setId(rs.getLong("dest_id"));
            destination.setCountry(rs.getString("country"));
            destination.setCity(rs.getString("city"));
            destination.setDescription(rs.getString("dest_description"));
            destination.setImageUrl(rs.getString("image_url"));
            
            // Gérer duration (peut être NULL)
            int duration = rs.getInt("duration");
            if (rs.wasNull()) {
                destination.setDuration(null);
            } else {
                destination.setDuration(duration);
            }
            
            destination.setCategory(rs.getString("category"));
            destination.setCreatedAt(null); // Pas de created_at dans le mapping
            
            offer.setDestination(destination);
        }
        
        return offer;
    }

    // Vérifier la disponibilité des places
    public int getAvailableSeats(Long offerId) throws SQLException {
        String sql = "SELECT seats FROM offer WHERE id_offer = ? AND activate = 1";  // CHANGÉ: id -> id_offer
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, offerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("seats");
            }
        }
        return 0;
    }

    // Mettre à jour les places disponibles après réservation
    public boolean updateAvailableSeats(Long offerId, int seatsBooked) throws SQLException {
        String sql = "UPDATE offer SET seats = seats - ? WHERE id_offer = ? AND seats >= ?";  // CHANGÉ: id -> id_offer
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, seatsBooked);
            stmt.setLong(2, offerId);
            stmt.setInt(3, seatsBooked);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Vérifier si une offre existe et est active
    public boolean isOfferActive(Long offerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM offer WHERE id_offer = ? AND activate = 1";  // CHANGÉ: id -> id_offer
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, offerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Récupérer le prix d'une offre
    public BigDecimal getOfferPrice(Long offerId) throws SQLException {
        String sql = "SELECT price FROM offer WHERE id_offer = ? AND activate = 1";  // CHANGÉ: id -> id_offer
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, offerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("price");
            }
        }
        return null;
    }
}