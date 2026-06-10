package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet implementation class AcceuilServlet
 * Cette servlet gère l'affichage de la page d'acceuil
 */
@WebServlet("/AcceuilServlet")
public class AcceuilServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public AcceuilServlet() {
        super();
        System.out.println("✅ AcceuilServlet initialisée");
    }

    /**
     * Gère les requêtes GET pour afficher la page d'acceuil
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n=== ACCEUIL SERVLET - DOGET ===");
        
        // Vérifier si l'utilisateur est connecté
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            System.err.println("❌ Pas de session, redirection vers login");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // Vérifier si l'utilisateur existe dans la session
        Object user = session.getAttribute("user");
        if (user == null) {
            System.err.println("❌ Pas d'utilisateur dans la session");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // Log pour débogage
        System.out.println("✅ Utilisateur connecté détecté:");
        System.out.println("- ID: " + session.getAttribute("userId"));
        System.out.println("- Prénom: " + session.getAttribute("firstName"));
        System.out.println("- Email: " + session.getAttribute("email"));
        System.out.println("- Rôle: " + session.getAttribute("role"));
        System.out.println("- Phone: " + session.getAttribute("phone"));
        
        // Transférer les attributs de session à la requête pour la JSP
        request.setAttribute("userId", session.getAttribute("userId"));
        request.setAttribute("firstName", session.getAttribute("firstName"));
        request.setAttribute("lastName", session.getAttribute("lastName"));
        request.setAttribute("email", session.getAttribute("email"));
        request.setAttribute("phone", session.getAttribute("phone"));
        request.setAttribute("role", session.getAttribute("role"));
        request.setAttribute("user", session.getAttribute("user"));
        
        // Récupérer le message de succès de la session
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            System.out.println("📩 Message de succès trouvé: " + successMessage);
            request.setAttribute("successMessage", successMessage);
            // Supprimer le message de la session pour qu'il n'apparaisse qu'une fois
            session.removeAttribute("successMessage");
        }
        
        // Transférer à la JSP d'acceuil
        System.out.println("🔄 Transfert vers Acceuil.jsp");
        request.getRequestDispatcher("Acceuil.jsp").forward(request, response);
    }

    /**
     * Gère les requêtes POST (normalement non utilisées pour l'acceuil)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("🔄 AcceuilServlet - doPost appelé, redirection vers doGet");
        doGet(request, response);
    }
    
    @Override
    public void init() throws ServletException {
        super.init();
        System.out.println("🚀 AcceuilServlet prête à recevoir des requêtes");
    }
}