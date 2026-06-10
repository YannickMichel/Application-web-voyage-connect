package org.eclipse.dao;

import org.eclipse.model.User;

public class TestConnection {

    public static void main(String[] args) {

        System.out.println("TEST DE CONNEXION À LA BASE");
      
        UserDao userDao = new UserDao();

        
        //TEST CONNEXION
       
        System.out.println("\n[1] Test de connexion à la base...");
        if (!userDao.testConnection()) {
            System.err.println("Impossible de se connecter à la base de données");
            return;
        }
        System.out.println("Connexion à la base OK");

       
        // CRÉATION UTILISATEUR TEST
       
        System.out.println("\n[2] Test INSERT utilisateur...");

        String testEmail = "test_" + System.currentTimeMillis() + "@gmail.com";

        User testUser = new User(
                "Test",
                "User",
                testEmail,
                "0612345678",
                "Test1234"
        );

        int userId = userDao.saveUser(testUser);

        if (userId <= 0) {
            System.err.println("Insertion utilisateur");
            return;
        }

        System.out.println("Utilisateur inséré avec ID = " + userId);

        
        //RECHERCHE PAR EMAIL
       
        System.out.println("\n[3] Test SELECT par email...");

        User foundUser = userDao.findByEmail(testEmail);

        if (foundUser == null) {
            System.err.println(" Utilisateur introuvable après insertion");
            return;
        }

        System.out.println("Utilisateur trouvé : "
                + foundUser.getFirstName() + " "
                + foundUser.getLastName());

        
        //AUTHENTIFICATION
        
        System.out.println("\n[4] Test AUTHENTIFICATION...");

        User authUser = userDao.authenticate(testEmail, "Test1234");

        if (authUser == null) {
            System.err.println(" Authentification impossible");
            return;
        }

        System.out.println(" Authentification réussie pour : "
                + authUser.getEmail());

        
        //RÉSUMÉ FINAL
        
        
        System.out.println("🎉 TOUS LES TESTS ONT RÉUSSI !");
       
    }
}
