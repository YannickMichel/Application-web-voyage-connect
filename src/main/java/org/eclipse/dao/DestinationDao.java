package org.eclipse.dao;

import org.eclipse.model.Destination;
import metier.SingletonConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DestinationDao {
    
    /**
     * Récupère toutes les destinations
     */
    public List<Destination> getAllDestinations() {
        List<Destination> destinations = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM destinations ORDER BY created_at DESC";
        
        try {
            conn = SingletonConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Destination destination = mapResultSetToDestination(rs);
                destinations.add(destination);
            }
            
            System.out.println("✅ " + destinations.size() + " destinations récupérées");
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la récupération des destinations: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, null);
        }
        
        return destinations;
    }
    
    /**
     * Récupère une destination par son ID
     */
    public Destination getDestinationById(Long id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM destinations WHERE id = ?";
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                System.out.println("✅ Destination trouvée avec ID: " + id);
                return mapResultSetToDestination(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la recherche de destination: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return null;
    }
    
    /**
     * Recherche des destinations par mot-clé
     */
    public List<Destination> searchDestinations(String keyword) {
        List<Destination> destinations = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM destinations WHERE " +
                    "country LIKE ? OR city LIKE ? OR description LIKE ? OR category LIKE ? " +
                    "ORDER BY created_at DESC";
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Destination destination = mapResultSetToDestination(rs);
                destinations.add(destination);
            }
            
            System.out.println("✅ " + destinations.size() + " destinations trouvées pour: " + keyword);
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la recherche: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return destinations;
    }
    
    /**
     * Récupère les destinations par catégorie
     */
    public List<Destination> getDestinationsByCategory(String category) {
        List<Destination> destinations = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM destinations WHERE category = ? ORDER BY created_at DESC";
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Destination destination = mapResultSetToDestination(rs);
                destinations.add(destination);
            }
            
            System.out.println("✅ " + destinations.size() + " destinations trouvées pour catégorie: " + category);
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors du filtrage par catégorie: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return destinations;
    }
    
    /**
     * Récupère les catégories uniques
     */
    public List<String> getAllCategories() {
        List<String> categories = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT DISTINCT category FROM destinations WHERE category IS NOT NULL ORDER BY category";
        
        try {
            conn = SingletonConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                categories.add(rs.getString("category"));
            }
            
            System.out.println("✅ " + categories.size() + " catégories récupérées");
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la récupération des catégories: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, null);
        }
        
        return categories;
    }
    
    /**
     * Convertit un ResultSet en objet Destination
     */
    private Destination mapResultSetToDestination(ResultSet rs) throws SQLException {
        Destination destination = new Destination();
        destination.setId(rs.getLong("id"));
        destination.setCountry(rs.getString("country"));
        destination.setCity(rs.getString("city"));
        destination.setDescription(rs.getString("description"));
        destination.setImageUrl(rs.getString("image_url"));
        destination.setPrice(rs.getDouble("price"));
        destination.setDuration(rs.getInt("duration"));
        destination.setCategory(rs.getString("category"));
        destination.setCreatedAt(rs.getTimestamp("created_at"));
        
        return destination;
    }
    
    /**
     * Récupère le nombre total de destinations
     */
    public int getTotalDestinationsCount() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT COUNT(*) as total FROM destinations";
        
        try {
            conn = SingletonConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors du comptage des destinations: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, null);
        }
        
        return 0;
    }
    
    /**
     * Ferme les ressources JDBC
     */
    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            // Ne pas fermer la connexion singleton
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la fermeture des ressources: " + e.getMessage());
        }
    }
}