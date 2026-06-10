package org.eclipse.util;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordHasher {
	
	private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Hash un mot de passe avec un salt aléatoire
     */
    public static String hashPassword(String password) {
        try {
            // Générer un salt aléatoire
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Hasher le mot de passe avec le salt
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Combiner salt et mot de passe hashé
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            
            // Encoder en Base64 pour stockage
            return Base64.getEncoder().encodeToString(combined);
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur de hashage du mot de passe", e);
        }
    }
    
    /**
     * Vérifie si un mot de passe correspond au hash stocké
     */
    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Décoder le hash stocké
            byte[] combined = Base64.getDecoder().decode(storedHash);
            
            // Extraire le salt (premiers SALT_LENGTH bytes)
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);
            
            // Hasher le mot de passe fourni avec le salt extrait
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(password.getBytes());
            
            // Comparer avec le hash stocké (après le salt)
            for (int i = 0; i < hashedPassword.length; i++) {
                if (hashedPassword[i] != combined[i + SALT_LENGTH]) {
                    return false;
                }
            }
            return true;
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Erreur de vérification du mot de passe", e);
        }
    }

}
