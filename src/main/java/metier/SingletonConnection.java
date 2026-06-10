package metier;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SingletonConnection {
    private static Connection connection;
    
    // URL de connexion
    private static final String URL;
private static final String USER;
private static final String PASSWORD;

static {
    String host     = System.getenv("MYSQLHOST");
    String port     = System.getenv("MYSQLPORT");
    String database = System.getenv("MYSQLDATABASE");
    USER            = System.getenv("MYSQLUSER");
    PASSWORD        = System.getenv("MYSQLPASSWORD");

    URL = "jdbc:mysql://" + host + ":" + port + "/" + database
        + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
}
    
    // Constructeur privé pour empêcher l'instanciation
    private SingletonConnection() {}
    
    /**
     * Récupère l'instance unique de connexion
     */
    public static Connection getConnection() {
        if (connection == null) {
            try {
                // Charger le driver
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                // Créer la connexion
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
                
                System.out.println("✅ Connexion MySQL établie (Singleton)");
                
            } catch (ClassNotFoundException e) {
                System.err.println("❌ Driver MySQL non trouvé");
                e.printStackTrace();
                throw new RuntimeException("Driver MySQL manquant", e);
            } catch (SQLException e) {
                System.err.println("❌ Erreur de connexion à la base");
                e.printStackTrace();
                throw new RuntimeException("Échec de connexion à la base", e);
            }
        }
        return connection;
    }
    
    /**
     * Ferme la connexion
     */
    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
                System.out.println("✅ Connexion fermée");
            } catch (SQLException e) {
                System.err.println("❌ Erreur lors de la fermeture de la connexion");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Teste la connexion
     */
    public static boolean testConnection() {
        try {
            Connection conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ Test de connexion réussi");
                return true;
            }
        } catch (SQLException e) {
            System.err.println("❌ Test de connexion échoué: " + e.getMessage());
        }
        return false;
    }
}
