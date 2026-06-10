package org.eclipse.util;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class DatabaseUtil {
	 
	 private static EntityManagerFactory emf;
	    
	    static {
	        try {
	            emf = Persistence.createEntityManagerFactory("voyageconnect-pu");
	        } catch (Exception e) {
	            e.printStackTrace();
	            throw new RuntimeException("Erreur lors de l'initialisation de la base de données");
	        }
	    }
	    
	    public static EntityManager getEntityManager() {
	        return emf.createEntityManager();
	    }
	    
	    public static void close() {
	        if (emf != null && emf.isOpen()) {
	            emf.close();
	        }
	    }

}
