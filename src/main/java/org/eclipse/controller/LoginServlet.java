package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.eclipse.dao.UserDao;
import org.eclipse.model.User;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDao userDao;
    
    @Override
    public void init() throws ServletException {
        userDao = new UserDao();
        System.out.println("✅ LoginServlet initialisé, UserDao créé");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== LOGIN SERVLET - DOGET ===");
        
        // Gérer la déconnexion
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            System.out.println("🔴 Déconnexion demandée");
            HttpSession session = request.getSession(false);
            if (session != null) {
                String email = (String) session.getAttribute("email");
                System.out.println("Déconnexion de l'utilisateur: " + email);
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // Vérifier si déjà connecté
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            System.out.println("✅ Utilisateur déjà connecté: " + session.getAttribute("email"));
            System.out.println("Redirection vers l'accueil...");
            response.sendRedirect(request.getContextPath() + "/AcceuilServlet");
            return;
        }
        
        // Sinon, afficher la page de connexion/inscription
        System.out.println("Affichage de la page Login.jsp");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("register".equals(action)) {
            processRegistration(request, response);
        } else if ("login".equals(action)) {
            processLogin(request, response);
        } else {
            // Fallback: traiter comme connexion
            processLogin(request, response);
        }
    }
    
    /**
     * Traite l'inscription d'un nouvel utilisateur
     */
    private void processRegistration(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== TRAITEMENT INSCRIPTION ===");
        
        // Récupérer les données du formulaire
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        
        // Log des données reçues
        System.out.println("📋 Données reçues:");
        System.out.println("- Prénom: " + firstName);
        System.out.println("- Nom: " + lastName);
        System.out.println("- Email: " + email);
        System.out.println("- Téléphone: " + phone);
        System.out.println("- Mot de passe présent: " + (password != null && !password.isEmpty()));
        
        // Validation des champs obligatoires
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            
            System.err.println("❌ Validation échouée: champs obligatoires manquants");
            
            request.setAttribute("error", "Tous les champs obligatoires (*) doivent être remplis");
            request.setAttribute("mode", "register");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }
        
        // Nettoyer les données
        firstName = firstName.trim();
        lastName = lastName.trim();
        email = email.trim().toLowerCase();
        phone = phone != null ? phone.trim() : "";
        
        try {
            // TEST: Vérifier la connexion à la base
            System.out.println("🔗 Test de connexion à la base...");
            if (!userDao.testConnection()) {
                throw new Exception("Impossible de se connecter à la base de données");
            }
            
            // Vérifier si l'email existe déjà
            System.out.println("📧 Vérification de l'email '" + email + "'...");
            if (userDao.emailExists(email)) {
                System.err.println("❌ Email déjà utilisé");
                
                request.setAttribute("error", "Cette adresse email est déjà utilisée");
                request.setAttribute("mode", "register");
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("Login.jsp").forward(request, response);
                return;
            }
            
            // Créer l'objet User
            System.out.println("👤 Création de l'objet User...");
            User user = new User(firstName, lastName, email, phone, password);
            
            // Sauvegarder dans la base
            System.out.println("💾 Sauvegarde de l'utilisateur...");
            int userId = userDao.saveUser(user);
            
            if (userId > 0) {
                System.out.println("✅ Inscription réussie! ID utilisateur: " + userId);
                
                // Récupérer l'utilisateur complet avec ses données
                System.out.println("🔍 Récupération de l'utilisateur par ID...");
                User savedUser = userDao.findById(userId);
                
                if (savedUser != null) {
                    System.out.println("✅ Utilisateur récupéré: " + savedUser.getFirstName() + " " + savedUser.getLastName());
                    
                    // Créer la session
                    System.out.println("🔐 Création de la session...");
                    HttpSession session = request.getSession();
                    session.setAttribute("user", savedUser);
                    session.setAttribute("userId", savedUser.getId());
                    session.setAttribute("firstName", savedUser.getFirstName());
                    session.setAttribute("lastName", savedUser.getLastName()); // AJOUT IMPORTANT
                    session.setAttribute("email", savedUser.getEmail());
                    session.setAttribute("phone", savedUser.getPhone());
                    session.setAttribute("role", savedUser.getRole());
                    
                    // Message de succès
                    session.setAttribute("successMessage", "✅ Inscription réussie! Bienvenue " + firstName + "!");
                    
                    // Log des attributs de session
                    System.out.println("📝 Attributs de session définis:");
                    System.out.println("   - userId: " + savedUser.getId());
                    System.out.println("   - firstName: " + savedUser.getFirstName());
                    System.out.println("   - lastName: " + savedUser.getLastName());
                    System.out.println("   - email: " + savedUser.getEmail());
                    System.out.println("   - phone: " + savedUser.getPhone());
                    System.out.println("   - role: " + savedUser.getRole());
                    
                    // Rediriger vers l'accueil
                    System.out.println("🔄 Redirection vers AccueuilServlet...");
                    response.sendRedirect(request.getContextPath() + "/AcceuilServlet");
                    return;
                } else {
                    System.err.println("❌ Utilisateur créé mais non retrouvé en base");
                    throw new Exception("Utilisateur créé mais non retrouvé en base");
                }
            } else {
                System.err.println("❌ Échec de la sauvegarde (userId = " + userId + ")");
                request.setAttribute("error", "Erreur technique lors de la création du compte. Veuillez réessayer.");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Exception lors de l'inscription:");
            e.printStackTrace();
            
            request.setAttribute("error", "Erreur: " + e.getMessage());
        }
        
        // Si on arrive ici, il y a eu une erreur
        System.err.println("⚠️ Retour au formulaire avec erreur");
        request.setAttribute("mode", "register");
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }
    
    /**
     * Traite la connexion d'un utilisateur existant
     */
    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== TRAITEMENT CONNEXION ===");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("🔑 Tentative de connexion avec email: " + email);
        
        // Validation
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            System.err.println("❌ Champs email/mot de passe manquants");
            request.setAttribute("error", "Veuillez saisir l'email et le mot de passe");
            request.setAttribute("mode", "login");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }
        
        email = email.trim().toLowerCase();
        
        try {
            // Authentifier l'utilisateur
            System.out.println("🔍 Authentification en cours...");
            User user = userDao.authenticate(email, password);
            
            if (user != null) {
                System.out.println("✅ Connexion réussie pour: " + email);
                
                // Créer la session
                System.out.println("🔐 Création de la session...");
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("firstName", user.getFirstName());
                session.setAttribute("lastName", user.getLastName()); // AJOUT IMPORTANT
                session.setAttribute("email", user.getEmail());
                session.setAttribute("phone", user.getPhone());
                session.setAttribute("role", user.getRole());
                
                // Message de bienvenue
                session.setAttribute("successMessage", "✅ Bienvenue " + user.getFirstName() + " !");
                
                // Log des attributs de session
                System.out.println("📝 Attributs de session définis:");
                System.out.println("   - userId: " + user.getId());
                System.out.println("   - firstName: " + user.getFirstName());
                System.out.println("   - lastName: " + user.getLastName());
                System.out.println("   - email: " + user.getEmail());
                System.out.println("   - phone: " + user.getPhone());
                System.out.println("   - role: " + user.getRole());
                
                // Rediriger
                System.out.println("🔄 Redirection vers AcceuilServlet...");
                response.sendRedirect(request.getContextPath() + "/AcceuilServlet");
            } else {
                System.err.println("❌ Échec d'authentification pour: " + email);
                request.setAttribute("error", "Email ou mot de passe incorrect");
                request.setAttribute("mode", "login");
                request.setAttribute("email", email);
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Exception lors de la connexion:");
            e.printStackTrace();
            
            request.setAttribute("error", "Erreur technique: " + e.getMessage());
            request.setAttribute("mode", "login");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
    
    /**
     * Pour la déconnexion via DELETE (optionnel)
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🔴 Déconnexion via DELETE");
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
    }
}