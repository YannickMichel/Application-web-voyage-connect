package org.eclipse.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.eclipse.model.Booking;
import org.eclipse.model.User;
import org.eclipse.model.Offer;
import org.eclipse.model.Destination;
import org.eclipse.model.BookingStatus;
import java.math.BigDecimal;
import metier.SingletonConnection;

public class BookingDao {
    private Connection connection;
    
    public BookingDao() {
        try {
            this.connection = SingletonConnection.getConnection();
            // S'assurer que l'auto-commit est activé
            if (this.connection != null && !this.connection.getAutoCommit()) {
                this.connection.setAutoCommit(true);
                System.out.println("[BookingDao] Auto-commit activé");
            }
            System.out.println("[BookingDao] Connexion établie avec succès, auto-commit: " + 
                             (this.connection != null ? this.connection.getAutoCommit() : "N/A"));
        } catch (Exception e) {
            System.err.println("[BookingDao] Erreur d'initialisation: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Erreur d'initialisation de BookingDao", e);
        }
    }
    
    public BookingDao(Connection connection) {
        this.connection = connection;
    }

    // Créer une nouvelle réservation
    public Long createBooking(Booking booking) throws SQLException {
        int userId = booking.getUser().getId();
        Long offerId = booking.getOffer().getId();
        
        System.out.println("[BookingDao] ===== DÉBUT CRÉATION RÉSERVATION =====");
        System.out.println("[BookingDao] User ID: " + userId);
        System.out.println("[BookingDao] Offer ID: " + offerId);
        
        // Vérifier que la connexion est valide
        if (connection == null || connection.isClosed()) {
            System.err.println("[BookingDao] Connexion invalide ou fermée");
            throw new SQLException("Connexion à la base de données invalide");
        }
        
        // Vérifier l'auto-commit
        boolean autoCommit = connection.getAutoCommit();
        System.out.println("[BookingDao] Auto-commit: " + autoCommit);
        
        // Vérifier que l'utilisateur existe
        if (!userExists(userId)) {
            System.err.println("[BookingDao] ERREUR: L'utilisateur avec ID " + userId + " n'existe pas dans la base de données");
            throw new SQLException("L'utilisateur avec ID " + userId + " n'existe pas");
        }
        
        // Vérifier que l'offre existe
        if (!offerExists(offerId)) {
            System.err.println("[BookingDao] ERREUR: L'offre avec ID " + offerId + " n'existe pas dans la base de données");
            throw new SQLException("L'offre avec ID " + offerId + " n'existe pas");
        }
        
        String sql = "INSERT INTO booking (start_date, end_date, quantity, booking_date, status, total_amount, user_id, offer_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        PreparedStatement stmt = null;
        try {
            stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            java.sql.Date startDate = new java.sql.Date(booking.getStartDate().getTime());
            java.sql.Date endDate = new java.sql.Date(booking.getEndDate().getTime());
            java.sql.Date bookingDate = new java.sql.Date(booking.getBookingDate().getTime());
            String status = booking.getStatus() != null ? booking.getStatus().toString() : "PENDING";
            
            stmt.setDate(1, startDate);
            stmt.setDate(2, endDate);
            stmt.setInt(3, booking.getQuantity());
            stmt.setDate(4, bookingDate);
            stmt.setString(5, status);
            stmt.setBigDecimal(6, booking.getTotalAmount());
            stmt.setLong(7, userId);
            stmt.setLong(8, offerId);
            
            System.out.println("[BookingDao] SQL: " + sql);
            System.out.println("[BookingDao] Paramètres:");
            System.out.println("  - start_date: " + startDate);
            System.out.println("  - end_date: " + endDate);
            System.out.println("  - quantity: " + booking.getQuantity());
            System.out.println("  - booking_date: " + bookingDate);
            System.out.println("  - status: " + status);
            System.out.println("  - total_amount: " + booking.getTotalAmount());
            System.out.println("  - user_id: " + userId + " (type: " + userId + ")");
            System.out.println("  - offer_id: " + offerId + " (type: " + offerId.getClass().getName() + ")");
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("[BookingDao] Lignes affectées par INSERT: " + rowsAffected);
            
            // Si auto-commit est désactivé, commit manuellement
            if (!autoCommit) {
                connection.commit();
                System.out.println("[BookingDao] Transaction commitée manuellement");
            } else {
                System.out.println("[BookingDao] Auto-commit activé, pas besoin de commit manuel");
            }
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys != null && generatedKeys.next()) {
                    Long bookingId = generatedKeys.getLong(1);
                    System.out.println("[BookingDao] ✅ Réservation créée avec succès! ID: " + bookingId);
                    generatedKeys.close();
                    return bookingId;
                } else {
                    System.err.println("[BookingDao] ❌ Aucune clé générée retournée malgré " + rowsAffected + " ligne(s) affectée(s)");
                }
            } else {
                System.err.println("[BookingDao] ❌ Aucune ligne affectée par l'INSERT");
            }
        } catch (SQLException e) {
            System.err.println("[BookingDao] ❌ ERREUR SQL lors de la création:");
            System.err.println("  - Message: " + e.getMessage());
            System.err.println("  - Code d'erreur SQL: " + e.getErrorCode());
            System.err.println("  - État SQL: " + e.getSQLState());
            System.err.println("  - Cause: " + (e.getCause() != null ? e.getCause().getMessage() : "N/A"));
            e.printStackTrace();
            
            // Rollback en cas d'erreur si auto-commit est désactivé
            if (!autoCommit) {
                try {
                    connection.rollback();
                    System.out.println("[BookingDao] Transaction annulée (rollback)");
                } catch (SQLException rollbackEx) {
                    System.err.println("[BookingDao] Erreur lors du rollback: " + rollbackEx.getMessage());
                }
            }
            throw e;
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    System.err.println("[BookingDao] Erreur lors de la fermeture du statement: " + e.getMessage());
                }
            }
            System.out.println("[BookingDao] ===== FIN CRÉATION RÉSERVATION =====");
        }
        
        System.err.println("[BookingDao] ❌ Échec création réservation - aucun ID généré");
        return null;
    }
    
    // Vérifier si un utilisateur existe
    private boolean userExists(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE id_user = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("[BookingDao] Vérification user: " + count + " utilisateur(s) trouvé(s) avec ID " + userId);
                return count > 0;
            }
        }
        return false;
    }
    
    // Vérifier si une offre existe
    private boolean offerExists(Long offerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM offer WHERE id_offer = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, offerId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("[BookingDao] Vérification offer: " + count + " offre(s) trouvée(s) avec ID " + offerId);
                return count > 0;
            }
        }
        return false;
    }

    // Récupérer une réservation par son ID
    public Booking getBookingById(Long bookingId) throws SQLException {
        System.out.println("[BookingDao] Récupération réservation ID: " + bookingId);
        
        String sql = "SELECT b.*, " +
                    "u.id_user as user_id, u.username, u.email, u.first_name, u.last_name, " +
                    "o.id_offer as offer_id, o.title, o.price, o.destination_id, " +
                    "d.id as dest_id, d.city, d.country " +
                    "FROM booking b " +
                    "LEFT JOIN users u ON b.user_id = u.id_user " +
                    "LEFT JOIN offer o ON b.offer_id = o.id_offer " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE b.id_booking = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, bookingId);
            
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            System.out.println("[BookingDao] Paramètre bookingId: " + bookingId);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                System.out.println("[BookingDao] Réservation trouvée pour ID: " + bookingId);
                return mapResultSetToBooking(rs);
            } else {
                System.out.println("[BookingDao] Aucune réservation trouvée pour ID: " + bookingId);
            }
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL lors de la récupération: " + e.getMessage());
            throw e;
        }
        return null;
    }

    // Récupérer les réservations d'un utilisateur
    public List<Booking> getBookingsByUserId(Long userId) throws SQLException {
        System.out.println("[BookingDao] ===== RÉCUPÉRATION RÉSERVATIONS POUR USER ID: " + userId + " =====");
        
        // Vérifier la connexion
        if (connection == null || connection.isClosed()) {
            System.err.println("[BookingDao] Connexion invalide, tentative de récupération...");
            connection = SingletonConnection.getConnection();
        }
        
        // D'abord, vérifier combien de réservations existent pour cet utilisateur (sans jointure)
        String countSql = "SELECT COUNT(*) as total FROM booking WHERE user_id = ?";
        try (PreparedStatement countStmt = connection.prepareStatement(countSql)) {
            countStmt.setLong(1, userId);
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                int totalCount = countRs.getInt("total");
                System.out.println("[BookingDao] Nombre total de réservations dans la table pour user_id=" + userId + ": " + totalCount);
            }
        }
        
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                    "u.id_user as user_id, u.username, u.email, u.first_name, u.last_name, " +
                    "o.id_offer as offer_id, o.title, o.price, o.destination_id, " +
                    "d.id as dest_id, d.city, d.country " +
                    "FROM booking b " +
                    "LEFT JOIN users u ON b.user_id = u.id_user " +
                    "LEFT JOIN offer o ON b.offer_id = o.id_offer " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE b.user_id = ? " +
                    "ORDER BY b.booking_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, userId);
            
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            System.out.println("[BookingDao] Paramètre userId (Long): " + userId + " (type: " + userId.getClass().getName() + ")");
            
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            
            while (rs.next()) {
                System.out.println("[BookingDao] Réservation trouvée - ID: " + rs.getLong("id_booking") + 
                                 ", user_id dans booking: " + rs.getLong("user_id") +
                                 ", user_id dans users: " + rs.getLong("user_id"));
                try {
                    Booking booking = mapResultSetToBooking(rs);
                    bookings.add(booking);
                    count++;
                    System.out.println("[BookingDao] Réservation mappée avec succès - Booking ID: " + booking.getId());
                } catch (Exception e) {
                    System.err.println("[BookingDao] Erreur lors du mapping d'une réservation: " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            System.out.println("[BookingDao] " + count + " réservations trouvées et mappées pour user ID: " + userId);
            System.out.println("[BookingDao] ===== FIN RÉCUPÉRATION =====");
            
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL lors de la récupération par user: " + e.getMessage());
            System.err.println("[BookingDao] Code d'erreur SQL: " + e.getErrorCode());
            System.err.println("[BookingDao] État SQL: " + e.getSQLState());
            e.printStackTrace();
            throw e;
        }
        return bookings;
    }

    // Récupérer les réservations pour une offre
    public List<Booking> getBookingsByOfferId(Long offerId) throws SQLException {
        System.out.println("[BookingDao] Récupération réservations pour offre ID: " + offerId);
        
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                    "u.id_user as user_id, u.username, u.email, u.first_name, u.last_name, " +
                    "o.id_offer as offer_id, o.title, o.price, o.destination_id, " +
                    "d.id as dest_id, d.city, d.country " +
                    "FROM booking b " +
                    "LEFT JOIN users u ON b.user_id = u.id_user " +
                    "LEFT JOIN offer o ON b.offer_id = o.id_offer " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE b.offer_id = ? " +
                    "ORDER BY b.booking_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setLong(1, offerId);
            
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            System.out.println("[BookingDao] Paramètre offerId: " + offerId);
            
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
                count++;
            }
            
            System.out.println("[BookingDao] " + count + " réservations trouvées pour offre ID: " + offerId);
            
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL lors de la récupération par offre: " + e.getMessage());
            throw e;
        }
        return bookings;
    }

    // Récupérer toutes les réservations
    public List<Booking> getAllBookings() throws SQLException {
        System.out.println("[BookingDao] ===== RÉCUPÉRATION DE TOUTES LES RÉSERVATIONS =====");
        
        // Vérifier la connexion
        if (connection == null || connection.isClosed()) {
            System.err.println("[BookingDao] Connexion invalide, tentative de récupération...");
            connection = SingletonConnection.getConnection();
        }
        
        // D'abord, vérifier combien de réservations existent dans la table
        String countSql = "SELECT COUNT(*) as total FROM booking";
        try (PreparedStatement countStmt = connection.prepareStatement(countSql)) {
            ResultSet countRs = countStmt.executeQuery();
            if (countRs.next()) {
                int totalCount = countRs.getInt("total");
                System.out.println("[BookingDao] Nombre total de réservations dans la table: " + totalCount);
            }
        }
        
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                    "u.id_user as user_id, u.username, u.email, u.first_name, u.last_name, " +
                    "o.id_offer as offer_id, o.title, o.price, o.destination_id, " +
                    "d.id as dest_id, d.city, d.country " +
                    "FROM booking b " +
                    "LEFT JOIN users u ON b.user_id = u.id_user " +
                    "LEFT JOIN offer o ON b.offer_id = o.id_offer " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "ORDER BY b.booking_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            
            while (rs.next()) {
                try {
                    System.out.println("[BookingDao] Réservation trouvée - ID: " + rs.getLong("id_booking") + 
                                     ", user_id: " + rs.getLong("user_id") +
                                     ", offer_id: " + rs.getLong("offer_id"));
                    Booking booking = mapResultSetToBooking(rs);
                    bookings.add(booking);
                    count++;
                    System.out.println("[BookingDao] Réservation mappée avec succès - Booking ID: " + booking.getId());
                } catch (Exception e) {
                    System.err.println("[BookingDao] Erreur lors du mapping d'une réservation: " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            System.out.println("[BookingDao] " + count + " réservations trouvées et mappées au total");
            System.out.println("[BookingDao] ===== FIN RÉCUPÉRATION =====");
            
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL lors de la récupération totale: " + e.getMessage());
            System.err.println("[BookingDao] Code d'erreur SQL: " + e.getErrorCode());
            System.err.println("[BookingDao] État SQL: " + e.getSQLState());
            e.printStackTrace();
            throw e;
        }
        return bookings;
    }

    // Mettre à jour le statut d'une réservation
    public boolean updateBookingStatus(Long bookingId, BookingStatus status) throws SQLException {
        System.out.println("[BookingDao] Mise à jour statut réservation ID: " + bookingId + " -> " + status);
        
        String sql = "UPDATE booking SET status = ? WHERE id_booking = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status.toString());
            stmt.setLong(2, bookingId);
            
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            System.out.println("[BookingDao] Paramètres: status=" + status + ", bookingId=" + bookingId);
            
            int rowsAffected = stmt.executeUpdate();
            System.out.println("[BookingDao] Lignes affectées: " + rowsAffected);
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL lors de la mise à jour statut: " + e.getMessage());
            throw e;
        }
    }

    // Annuler une réservation
    public boolean cancelBooking(Long bookingId) throws SQLException {
        System.out.println("[BookingDao] Annulation réservation ID: " + bookingId);
        return updateBookingStatus(bookingId, BookingStatus.CANCELLED);
    }

    // Vérifier la disponibilité des dates
    public boolean isDateAvailable(Long offerId, Date startDate, Date endDate) throws SQLException {
        System.out.println("[BookingDao] Vérification disponibilité dates pour offre ID: " + offerId);
        System.out.println("[BookingDao] Période: " + startDate + " à " + endDate);
        
        // Si les dates sont nulles, considérer comme disponible
        if (startDate == null || endDate == null) {
            return true;
        }
        
        String sql = "SELECT COUNT(*) FROM booking " +
                    "WHERE offer_id = ? AND status NOT IN ('CANCELLED', 'REFUNDED') " +
                    "AND NOT (end_date < ? OR start_date > ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
            java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());
            
            stmt.setLong(1, offerId);
            stmt.setDate(2, sqlStartDate);
            stmt.setDate(3, sqlEndDate);
            
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            System.out.println("[BookingDao] Paramètres: offerId=" + offerId + 
                             ", startDate=" + sqlStartDate + ", endDate=" + sqlEndDate);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                boolean available = count == 0;
                System.out.println("[BookingDao] Nombre de réservations conflictuelles: " + count + 
                                 ", Disponible: " + available);
                return available;
            }
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL vérification disponibilité: " + e.getMessage());
            throw e;
        }
        return false;
    }

    // Vérifier les places disponibles pour une période
    public int getAvailableQuantity(Long offerId, Date startDate, Date endDate) throws SQLException {
        System.out.println("[BookingDao] Calcul places disponibles pour offre ID: " + offerId);
        
        String sql = "SELECT COALESCE(SUM(quantity), 0) as total_reserved " +
                    "FROM booking " +
                    "WHERE offer_id = ? AND status NOT IN ('CANCELLED', 'REFUNDED') " +
                    "AND NOT (end_date < ? OR start_date > ?)";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
            java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());
            
            stmt.setLong(1, offerId);
            stmt.setDate(2, sqlStartDate);
            stmt.setDate(3, sqlEndDate);
            
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int totalReserved = rs.getInt("total_reserved");
                System.out.println("[BookingDao] Places déjà réservées: " + totalReserved);
                return totalReserved;
            }
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL calcul places: " + e.getMessage());
            throw e;
        }
        return 0;
    }

    // Mapper ResultSet vers Booking
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        
        try {
            // Informations de base
            booking.setId(rs.getLong("id_booking"));
            booking.setStartDate(rs.getDate("start_date"));
            booking.setEndDate(rs.getDate("end_date"));
            booking.setQuantity(rs.getInt("quantity"));
            booking.setBookingDate(rs.getDate("booking_date"));
            
            // Statut
            String statusStr = rs.getString("status");
            try {
                booking.setStatus(BookingStatus.valueOf(statusStr.toUpperCase()));
            } catch (IllegalArgumentException e) {
                System.err.println("[BookingDao] Statut invalide: " + statusStr + ", utilisation de PENDING");
                booking.setStatus(BookingStatus.PENDING);
            }
            
            // Total amount
            BigDecimal totalAmount = rs.getBigDecimal("total_amount");
            if (totalAmount == null) {
                totalAmount = BigDecimal.ZERO;
            }
            booking.setTotalAmount(totalAmount);
            
            // User
            User user = new User();
            user.setId(rs.getInt("user_id"));
            
            // Essayer de récupérer le nom d'abord depuis 'first_name' et 'last_name'
            String firstName = rs.getString("first_name");
            String lastName = rs.getString("last_name");
            String username = rs.getString("username");
            
            if (firstName != null && lastName != null) {
                user.setFirstName(firstName);
                user.setLastName(lastName);
            } else if (username != null) {
                user.setFirstName(username);
                user.setLastName("");
            } else {
                user.setFirstName("Utilisateur");
                user.setLastName("");
            }
            
            user.setEmail(rs.getString("email"));
            booking.setUser(user);
            
            // Offer
            Offer offer = new Offer();
            offer.setId(rs.getLong("offer_id"));
            offer.setTitle(rs.getString("title"));
            
            BigDecimal price = rs.getBigDecimal("price");
            if (price == null) {
                price = BigDecimal.ZERO;
            }
            offer.setPrice(price);
            
            // Destination
            Long destId = rs.getLong("dest_id");
            if (!rs.wasNull() && destId > 0) {
                Destination destination = new Destination();
                destination.setId(destId);
                destination.setCity(rs.getString("city"));
                destination.setCountry(rs.getString("country"));
                offer.setDestination(destination);
            }
            
            booking.setOffer(offer);
            
            System.out.println("[BookingDao] Réservation mappée - ID: " + booking.getId() + 
                             ", User: " + user.getFullName() + 
                             ", Offre: " + offer.getTitle());
            
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur lors du mapping ResultSet: " + e.getMessage());
            throw e;
        }
        
        return booking;
    }

    // Calculer le total pour une réservation
    public BigDecimal calculateTotal(BigDecimal pricePerPerson, int quantity, int days) {
        if (pricePerPerson == null || quantity <= 0 || days <= 0) {
            return BigDecimal.ZERO;
        }
        
        BigDecimal total = pricePerPerson.multiply(BigDecimal.valueOf(quantity))
                                         .multiply(BigDecimal.valueOf(days));
        
        System.out.println("[BookingDao] Calcul total: " + pricePerPerson + " * " + 
                         quantity + " * " + days + " = " + total);
        
        return total;
    }

    // Vérifier si l'utilisateur a déjà réservé cette offre
    public boolean hasUserBookedOffer(int userId, Long offerId) throws SQLException {
        System.out.println("[BookingDao] Vérification si user " + userId + " a réservé offre " + offerId);
        
        String sql = "SELECT COUNT(*) as count FROM booking " +
                    "WHERE user_id = ? AND offer_id = ? AND status NOT IN ('CANCELLED', 'REFUNDED')";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setLong(2, offerId);
            
            System.out.println("[BookingDao] Exécution SQL: " + sql);
            System.out.println("[BookingDao] Paramètres: userId=" + userId + ", offerId=" + offerId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count");
                boolean hasBooked = count > 0;
                System.out.println("[BookingDao] Réservations trouvées: " + count + 
                                 ", Has booked: " + hasBooked);
                return hasBooked;
            }
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL vérification réservation: " + e.getMessage());
            throw e;
        }
        return false;
    }
    
    // Récupérer le nombre total de réservations
    public int getTotalBookingsCount() throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM booking";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    // Récupérer le nombre de réservations par statut
    public int getBookingsCountByStatus(BookingStatus status) throws SQLException {
        String sql = "SELECT COUNT(*) as total FROM booking WHERE status = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status.toString());
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }
        }
        return 0;
    }
    
    // Récupérer le revenu total (somme des montants des réservations confirmées)
    public BigDecimal getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) as total FROM booking WHERE status = 'CONFIRMED'";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        }
        return BigDecimal.ZERO;
    }
    
    // Récupérer les réservations récentes (limite)
    public List<Booking> getRecentBookings(int limit) throws SQLException {
        System.out.println("[BookingDao] Récupération des " + limit + " réservations récentes");
        
        // Vérifier la connexion
        if (connection == null || connection.isClosed()) {
            System.err.println("[BookingDao] Connexion invalide, tentative de récupération...");
            connection = SingletonConnection.getConnection();
        }
        
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                    "u.id_user as user_id, u.username, u.email, u.first_name, u.last_name, " +
                    "o.id_offer as offer_id, o.title, o.price, o.destination_id, " +
                    "d.id as dest_id, d.city, d.country " +
                    "FROM booking b " +
                    "LEFT JOIN users u ON b.user_id = u.id_user " +
                    "LEFT JOIN offer o ON b.offer_id = o.id_offer " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "ORDER BY b.booking_date DESC LIMIT ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, limit);
            System.out.println("[BookingDao] Exécution SQL: " + sql + " avec limite: " + limit);
            
            ResultSet rs = stmt.executeQuery();
            int count = 0;
            
            while (rs.next()) {
                try {
                    Booking booking = mapResultSetToBooking(rs);
                    bookings.add(booking);
                    count++;
                } catch (Exception e) {
                    System.err.println("[BookingDao] Erreur lors du mapping d'une réservation récente: " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            System.out.println("[BookingDao] " + count + " réservations récentes trouvées");
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur SQL lors de la récupération des réservations récentes: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return bookings;
    }
    
    // Récupérer les réservations par statut
    public List<Booking> getBookingsByStatus(BookingStatus status) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, " +
                    "u.id_user as user_id, u.username, u.email, u.first_name, u.last_name, " +
                    "o.id_offer as offer_id, o.title, o.price, o.destination_id, " +
                    "d.id as dest_id, d.city, d.country " +
                    "FROM booking b " +
                    "LEFT JOIN users u ON b.user_id = u.id_user " +
                    "LEFT JOIN offer o ON b.offer_id = o.id_offer " +
                    "LEFT JOIN destinations d ON o.destination_id = d.id " +
                    "WHERE b.status = ? " +
                    "ORDER BY b.booking_date DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status.toString());
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
        }
        return bookings;
    }
    
    // Vérifier la connexion
    public boolean isConnectionValid() {
        if (connection == null) {
            return false;
        }
        
        try {
            return connection.isValid(5); // Timeout de 5 secondes
        } catch (SQLException e) {
            System.err.println("[BookingDao] Erreur vérification connexion: " + e.getMessage());
            return false;
        }
    }
    
    // Fermer la connexion
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("[BookingDao] Connexion fermée");
            } catch (SQLException e) {
                System.err.println("[BookingDao] Erreur fermeture connexion: " + e.getMessage());
            }
        }
    }
}