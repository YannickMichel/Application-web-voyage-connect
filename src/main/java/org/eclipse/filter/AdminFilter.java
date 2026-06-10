package org.eclipse.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

import org.eclipse.model.User;

/**
 * Filtre pour restreindre l'accès aux pages admin
 * Seuls les utilisateurs avec le rôle ADMIN peuvent accéder
 */
@WebFilter("/admin/*")
public class AdminFilter extends HttpFilter implements Filter {
       
    public AdminFilter() {
        super();
    }

    public void destroy() {
        // Nettoyage si nécessaire
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        // Récupérer la session
        HttpSession session = req.getSession(false);
        
        // Vérifier si l'utilisateur est connecté et est un admin
        if (session == null) {
            // Pas de session, rediriger vers la page de login
            System.out.println("⏰ AdminFilter: Aucune session active");
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=no_session");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            // Utilisateur non connecté
            System.out.println("⏰ AdminFilter: Utilisateur non connecté");
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=not_logged_in");
            return;
        }
        
        // Vérifier le rôle
        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            // L'utilisateur n'est pas admin
            System.out.println("⏰ AdminFilter: Accès refusé pour " + user.getEmail() 
                             + " (Rôle: " + user.getRole() + ")");
            
            // Stocker un message d'erreur
            session.setAttribute("errorMessage", "Accès réservé aux administrateurs");
            
            // Rediriger vers la page d'accueil ou dashboard client
            res.sendRedirect(req.getContextPath() + "/dashboard-client.jsp");
            return;
        }
        
        // L'utilisateur est admin, continuer
        System.out.println("✅ AdminFilter: Accès autorisé pour " + user.getEmail());
        
        // Ajouter des attributs pour les vues si nécessaire
        req.setAttribute("isAdmin", true);
        
        // Passer au filtre suivant ou à la servlet
        chain.doFilter(request, response);
    }

    public void init(FilterConfig fConfig) throws ServletException {
        System.out.println("✅ AdminFilter initialisé");
    }
}