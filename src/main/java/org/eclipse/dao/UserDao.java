package org.eclipse.dao;

import org.eclipse.model.User;
import metier.SingletonConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserDao {
    
    /**
     * Sauvegarde un nouvel utilisateur dans la base de données
     * Retourne l'ID généré ou -1 en cas d'erreur
     */
    public int saveUser(User user) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet generatedKeys = null;
        
        System.out.println("\n=== DEBUT saveUser (avec Singleton) ===");
        System.out.println("Données utilisateur:");
        System.out.println("- Prénom: " + user.getFirstName());
        System.out.println("- Nom: " + user.getLastName());
        System.out.println("- Email: " + user.getEmail());
        System.out.println("- Téléphone: " + user.getPhone());
        System.out.println("- Rôle: " + (user.getRole() != null ? user.getRole() : "CLIENT"));
        
        String sql = """
                INSERT INTO users 
                (first_name, last_name, email, phone, password, username, role)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        
        try {
            // UTILISATION DU SINGLETON
            conn = SingletonConnection.getConnection();
            System.out.println("✅ Connexion obtenue via SingletonConnection");
            
            // Préparer la requête avec retour des clés générées
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            // Générer un username unique
            String username = generateUsername(user.getEmail());
            
            // Hacher le mot de passe
            String hashedPassword = hashPassword(user.getPassword());
            
            // Définir le rôle (par défaut CLIENT si non spécifié)
            String role = user.getRole() != null ? user.getRole() : "CLIENT";
            
            // Définir les paramètres
            pstmt.setString(1, user.getFirstName());
            pstmt.setString(2, user.getLastName());
            pstmt.setString(3, user.getEmail());
            pstmt.setString(4, user.getPhone() != null ? user.getPhone() : "");
            pstmt.setString(5, hashedPassword);
            pstmt.setString(6, username);
            pstmt.setString(7, role);
            
            // Exécuter l'insertion
            System.out.println("Exécution de l'insertion...");
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                System.err.println("❌ Aucune ligne insérée!");
                return -1;
            }
            
            // Récupérer l'ID généré
            generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int generatedId = generatedKeys.getInt(1);
                System.out.println("✅ Utilisateur créé avec ID: " + generatedId);
                System.out.println("=== FIN saveUser SUCCÈS ===");
                return generatedId;
            } else {
                System.err.println("❌ Impossible de récupérer l'ID généré");
                return -1;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ ERREUR SQL dans saveUser:");
            System.err.println("- Message: " + e.getMessage());
            System.err.println("- SQLState: " + e.getSQLState());
            System.err.println("- ErrorCode: " + e.getErrorCode());
            
            // Vérifier les violations de contrainte
            if (e.getMessage().contains("Duplicate entry")) {
                if (e.getMessage().contains("email")) {
                    System.err.println("⚠️  Email déjà utilisé!");
                } else if (e.getMessage().contains("username")) {
                    System.err.println("⚠️  Username déjà utilisé!");
                }
            }
            
            e.printStackTrace();
            return -1;
            
        } finally {
            // IMPORTANT: NE PAS FERMER LA CONNEXION SINGLETON ICI
            // Fermer seulement Statement et ResultSet
            closeResources(generatedKeys, pstmt, null); // null pour connection
        }
    }
    
    /**
     * Crée un compte administrateur (méthode spécifique)
     */
    public int createAdmin(User adminUser) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet generatedKeys = null;
        
        System.out.println("\n=== CRÉATION ADMINISTRATEUR ===");
        System.out.println("Données admin:");
        System.out.println("- Prénom: " + adminUser.getFirstName());
        System.out.println("- Nom: " + adminUser.getLastName());
        System.out.println("- Email: " + adminUser.getEmail());
        System.out.println("- Rôle: ADMIN");
        
        String sql = """
                INSERT INTO users 
                (first_name, last_name, email, phone, password, username, role)
                VALUES (?, ?, ?, ?, ?, ?, 'ADMIN')
                """;
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            // Générer un username unique
            String username = generateUsername(adminUser.getEmail());
            
            // Hacher le mot de passe
            String hashedPassword = hashPassword(adminUser.getPassword());
            
            // Définir les paramètres
            pstmt.setString(1, adminUser.getFirstName());
            pstmt.setString(2, adminUser.getLastName());
            pstmt.setString(3, adminUser.getEmail());
            pstmt.setString(4, adminUser.getPhone() != null ? adminUser.getPhone() : "");
            pstmt.setString(5, hashedPassword);
            pstmt.setString(6, username);
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows == 0) {
                System.err.println("❌ Aucune ligne insérée pour l'admin!");
                return -1;
            }
            
            generatedKeys = pstmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int generatedId = generatedKeys.getInt(1);
                System.out.println("✅ Administrateur créé avec ID: " + generatedId);
                return generatedId;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur création admin: " + e.getMessage());
        } finally {
            closeResources(generatedKeys, pstmt, null);
        }
        
        return -1;
    }
    
    /**
     * Vérifie si un email existe déjà
     */
    public boolean emailExists(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try {
            // UTILISATION DU SINGLETON
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Email '" + email + "' existe: " + (count > 0));
                return count > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la vérification de l'email: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * Authentifie un utilisateur
     */
    public User authenticate(String email, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try {
            // UTILISATION DU SINGLETON
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                String inputHash = hashPassword(password);
                
                if (storedHash.equals(inputHash)) {
                    System.out.println("✅ Authentification réussie pour: " + email);
                    User user = mapResultSetToUser(rs);
                    System.out.println("Rôle de l'utilisateur: " + user.getRole());
                    return user;
                } else {
                    System.out.println("❌ Mot de passe incorrect pour: " + email);
                }
            } else {
                System.out.println("❌ Utilisateur non trouvé: " + email);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur d'authentification: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return null;
    }
    
    /**
     * Authentifie un administrateur (avec vérification de rôle)
     */
    public User authenticateAdmin(String email, String password) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users WHERE email = ? AND role = 'ADMIN'";
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String storedHash = rs.getString("password");
                String inputHash = hashPassword(password);
                
                if (storedHash.equals(inputHash)) {
                    System.out.println("✅ Authentification ADMIN réussie pour: " + email);
                    return mapResultSetToUser(rs);
                } else {
                    System.out.println("❌ Mot de passe ADMIN incorrect pour: " + email);
                }
            } else {
                System.out.println("❌ Admin non trouvé ou mauvais rôle: " + email);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur d'authentification admin: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return null;
    }
    
    /**
     * Vérifie si un utilisateur est administrateur
     */
    public boolean isAdmin(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT role FROM users WHERE email = ?";
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String role = rs.getString("role");
                boolean isAdmin = "ADMIN".equals(role);
                System.out.println("Vérification rôle pour " + email + ": " + role + " -> admin=" + isAdmin);
                return isAdmin;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur vérification admin: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return false;
    }
    
    /**
     * Récupère un utilisateur par email
     */
    public User findByEmail(String email) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try {
            // UTILISATION DU SINGLETON
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                System.out.println("✅ Utilisateur trouvé par email: " + email);
                return mapResultSetToUser(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la recherche: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return null;
    }
    
    /**
     * Récupère un utilisateur par ID
     */
    public User findById(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String sql = "SELECT * FROM users WHERE id_user = ?";

        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToUser(rs);
            }

        } catch (SQLException e) {
            System.err.println("❌ Erreur findById: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, null);
        }

        return null;
    }
    
    /**
     * Récupère tous les administrateurs
     */
    public java.util.List<User> getAllAdmins() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        java.util.List<User> admins = new java.util.ArrayList<>();
        
        String sql = "SELECT * FROM users WHERE role = 'ADMIN' ORDER BY last_name, first_name";
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                admins.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ Nombre d'administrateurs trouvés: " + admins.size());
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur récupération admins: " + e.getMessage());
        } finally {
            closeResources(rs, pstmt, null);
        }
        
        return admins;
    }
    
    /**
     * Met à jour le rôle d'un utilisateur
     */
    public boolean updateUserRole(int userId, String newRole) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        String sql = "UPDATE users SET role = ? WHERE id_user = ?";
        
        try {
            conn = SingletonConnection.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newRole);
            pstmt.setInt(2, userId);
            
            int affectedRows = pstmt.executeUpdate();
            System.out.println("✅ Mise à jour rôle pour userId=" + userId + " -> " + newRole + 
                             " (lignes affectées: " + affectedRows + ")");
            
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur mise à jour rôle: " + e.getMessage());
            return false;
        } finally {
            closeResources(null, pstmt, null);
        }
    }
    
    /**
     * Récupère tous les utilisateurs
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try {
            conn = SingletonConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ " + users.size() + " utilisateurs récupérés");
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la récupération des utilisateurs: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, null);
        }
        
        return users;
    }
    
    /**
     * Récupère le nombre total d'utilisateurs
     */
    public int getTotalUsersCount() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT COUNT(*) as total FROM users";
        
        try {
            conn = SingletonConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            if (rs.next()) {
                return rs.getInt("total");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors du comptage des utilisateurs: " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(rs, stmt, null);
        }
        
        return 0;
    }
    
    /**
     * Liste tous les utilisateurs (pour débogage)
     */
    public void listAllUsers() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        
        String sql = "SELECT id_user, first_name, last_name, email, phone, role FROM users ORDER BY id_user";
        
        try {
            // UTILISATION DU SINGLETON
            conn = SingletonConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            System.out.println("\n=== LISTE DES UTILISATEURS ===");
            boolean hasUsers = false;
            
            while (rs.next()) {
                hasUsers = true;
                System.out.println("ID: " + rs.getInt("id_user") + 
                                 " | Nom: " + rs.getString("first_name") + " " + rs.getString("last_name") +
                                 " | Email: " + rs.getString("email") +
                                 " | Téléphone: " + rs.getString("phone") +
                                 " | Rôle: " + rs.getString("role"));
            }
            
            if (!hasUsers) {
                System.out.println("Aucun utilisateur dans la base.");
            }
            
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la liste: " + e.getMessage());
        } finally {
            closeResources(rs, stmt, null);
        }
    }
    
    /**
     * Méthodes utilitaires (inchangées)
     */
    private String generateUsername(String email) {
        String base = email.split("@")[0];
        base = base.replaceAll("[^a-zA-Z0-9]", "");
        String suffix = UUID.randomUUID().toString().substring(0, 8);
        return base + "_" + suffix;
    }
    
    private String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            
            return hexString.toString();
        } catch (Exception e) {
            System.err.println("❌ Erreur de hashage: " + e.getMessage());
            return password;
        }
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id_user"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
    
    /**
     * Ferme les ressources (sauf la connexion singleton)
     */
    private void closeResources(ResultSet rs, Statement stmt, Connection conn) {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            // NE PAS FERMER LA CONNEXION SI C'EST LE SINGLETON
        } catch (SQLException e) {
            System.err.println("❌ Erreur lors de la fermeture des ressources: " + e.getMessage());
        }
    }
    
    /**
     * Test de connexion utilisant le Singleton
     */
    public boolean testConnection() {
        System.out.println("\n=== TEST DE CONNEXION (Singleton) ===");
        return SingletonConnection.testConnection();
    }
}