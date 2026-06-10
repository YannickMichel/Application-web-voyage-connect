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

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDao userDao;
    
    @Override
    public void init() throws ServletException {
        userDao = new UserDao();
        System.out.println("✅ AdminLoginServlet initialisé");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== ADMIN LOGIN SERVLET - DOGET ===");
        
        // Vérifier si déjà connecté en tant qu'admin
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser != null && "ADMIN".equals(currentUser.getRole())) {
                System.out.println("✅ Admin déjà connecté: " + currentUser.getEmail());
                System.out.println("Redirection vers dashboard admin...");
                response.sendRedirect(request.getContextPath() + "/admindashboard.jsp");
                return;
            }
        }
        
        // Transmettre à la JSP
        System.out.println("Affichage de la page adminlogin.jsp");
        request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
    }
    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        System.out.println("\n=== ADMIN LOGIN SERVLET - ACTION: " + action + " ===");
        
        if ("create".equals(action)) {
            processCreateAdmin(request, response);
        } else {
            processLogin(request, response);
        }
    }
    
    private void processLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== TRAITEMENT CONNEXION ADMIN ===");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        System.out.println("🔑 Tentative de connexion ADMIN avec email: " + email);
        
        // Validation
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            
            System.err.println("❌ Champs email/mot de passe manquants");
            request.setAttribute("error", "Veuillez saisir l'email et le mot de passe");
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
            return;
        }
        
        email = email.trim().toLowerCase();
        
        // VÉRIFICATION SPÉCIFIQUE: Seuls les emails @voyageconnect.com sont autorisés
        if (!email.endsWith("@voyageconnect.com")) {
            System.err.println("❌ Tentative de connexion admin avec email non autorisé: " + email);
            request.setAttribute("error", "Accès réservé aux administrateurs avec email @voyageconnect.com");
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
            return;
        }
        
        try {
            // Authentifier l'administrateur
            System.out.println("🔍 Authentification ADMIN en cours...");
            User user = userDao.authenticate(email, password);
            
            System.out.println("🔍 Résultat authenticate(): " + (user != null ? "USER TROUVÉ" : "NULL"));
            
            if (user != null) {
                System.out.println("🔍 Rôle de l'utilisateur: " + user.getRole());
                System.out.println("🔍 Est-ce ADMIN? " + "ADMIN".equals(user.getRole()));
            }
            
            if (user != null && "ADMIN".equals(user.getRole())) {
                System.out.println("✅ Connexion ADMIN réussie pour: " + email);
                
                // Créer la session
                System.out.println("🔐 Création de la session admin...");
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("firstName", user.getFirstName());
                session.setAttribute("lastName", user.getLastName());
                session.setAttribute("email", user.getEmail());
                session.setAttribute("phone", user.getPhone());
                session.setAttribute("role", user.getRole());
                session.setAttribute("isAdmin", true);
                
                // Message de bienvenue spécial admin
                session.setAttribute("successMessage", "✅ Bienvenue dans l'espace administrateur, " + user.getFirstName() + " !");
                
                // Rediriger vers le dashboard admin
                System.out.println("🔄 Redirection vers admindashboard.jsp...");
                response.sendRedirect(request.getContextPath() + "/admindashboard.jsp");
                
            } else if (user != null && !"ADMIN".equals(user.getRole())) {
                // L'utilisateur existe mais n'est pas admin
                System.err.println("❌ Accès refusé: l'utilisateur n'est pas admin, rôle=" + user.getRole());
                request.setAttribute("error", "Accès refusé. Vous n'avez pas les droits d'administrateur. Rôle: " + user.getRole());
                request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
                
            } else {
                // Échec d'authentification (user est null)
                System.err.println("❌ Échec d'authentification - user est NULL");
                
                // Debug supplémentaire: vérifier si l'email existe
                boolean emailExists = userDao.emailExists(email);
                System.out.println("🔍 L'email existe en base? " + emailExists);
                
                request.setAttribute("error", "Email ou mot de passe administrateur incorrect");
                request.setAttribute("email", email);
                request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Exception lors de la connexion ADMIN:");
            e.printStackTrace();
            
            request.setAttribute("error", "Erreur technique: " + e.getMessage());
            request.getRequestDispatcher("adminlogin.jsp").forward(request, response);
        }
    }
    
    private void processCreateAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== CRÉATION D'UN NOUVEL ADMINISTRATEUR ===");
        
        // Récupérer les paramètres
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        
        System.out.println("📝 Données du nouvel admin:");
        System.out.println("- Prénom: " + firstName);
        System.out.println("- Nom: " + lastName);
        System.out.println("- Email: " + email);
        System.out.println("- Téléphone: " + phone);
        System.out.println("- Rôle: " + role);
        
        // Validation des champs
        if (firstName == null || firstName.trim().isEmpty() ||
            lastName == null || lastName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {
            
            System.err.println("❌ Champs obligatoires manquants");
            request.setAttribute("error", "Tous les champs obligatoires (*) doivent être remplis");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
            return;
        }
        
        // Nettoyer les données
        firstName = firstName.trim();
        lastName = lastName.trim();
        email = email.trim().toLowerCase();
        phone = phone != null ? phone.trim() : "";
        
        // Validation de l'email
        if (!email.endsWith("@voyageconnect.com")) {
            System.err.println("❌ Email non autorisé: " + email);
            request.setAttribute("error", "L'email doit se terminer par @voyageconnect.com");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
            return;
        }
        
        // Validation du mot de passe
        if (!password.equals(confirmPassword)) {
            System.err.println("❌ Les mots de passe ne correspondent pas");
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
            return;
        }
        
        if (password.length() < 8) {
            System.err.println("❌ Mot de passe trop court");
            request.setAttribute("error", "Le mot de passe doit contenir au moins 8 caractères");
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
            return;
        }
        
        try {
            // Vérifier si l'email existe déjà
            if (userDao.emailExists(email)) {
                System.err.println("❌ Email déjà utilisé: " + email);
                request.setAttribute("error", "Cet email est déjà utilisé. Veuillez en choisir un autre.");
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
                return;
            }
            
            // Créer l'objet User
            User newAdmin = new User();
            newAdmin.setFirstName(firstName);
            newAdmin.setLastName(lastName);
            newAdmin.setEmail(email);
            newAdmin.setPhone(phone);
            newAdmin.setPassword(password);
            newAdmin.setRole(role != null ? role : "ADMIN");
            
            // Sauvegarder l'admin
            System.out.println("💾 Sauvegarde du nouvel admin...");
            int adminId = userDao.saveUser(newAdmin);
            
            if (adminId > 0) {
                System.out.println("✅ Nouvel admin créé avec ID: " + adminId);
                
                // Mettre à jour le rôle en ADMIN si ce n'est pas déjà fait
                if (!"ADMIN".equals(newAdmin.getRole())) {
                    userDao.updateUserRole(adminId, "ADMIN");
                }
                
                request.setAttribute("success", "✅ Administrateur créé avec succès: " + email);
                request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
            } else {
                System.err.println("❌ Échec de la création de l'admin");
                request.setAttribute("error", "Erreur lors de la création de l'administrateur");
                request.setAttribute("firstName", firstName);
                request.setAttribute("lastName", lastName);
                request.setAttribute("email", email);
                request.setAttribute("phone", phone);
                request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Exception lors de la création de l'admin:");
            e.printStackTrace();
            
            request.setAttribute("error", "Erreur technique: " + e.getMessage());
            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("adminlogin.jsp?action=create").forward(request, response);
        }
    }
}