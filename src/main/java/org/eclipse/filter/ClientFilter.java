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
 * Filtre pour les pages réservées aux clients connectés
 */
@WebFilter({"/reservation/*", "/profile/*", "/mes-reservations", "/avis/*"})
public class ClientFilter extends HttpFilter implements Filter {
       
    public ClientFilter() {
        super();
    }

    public void destroy() {
        // Nettoyage
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        
        // Récupérer la session
        HttpSession session = req.getSession(false);
        
        // Vérifier si l'utilisateur est connecté
        if (session == null) {
            System.out.println("⏰ ClientFilter: Aucune session active");
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=session_expired");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            System.out.println("⏰ ClientFilter: Utilisateur non connecté");
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=please_login");
            return;
        }
        
        // Vérifier que l'utilisateur n'est pas admin essayant d'accéder aux pages client spécifiques
        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Si c'est une page spécifique client et que l'utilisateur est admin, rediriger
        if (path.startsWith("/reservation/") && "ADMIN".equalsIgnoreCase(user.getRole())) {
            System.out.println("ℹ️ Admin tentant d'accéder aux pages réservation client");
            // Un admin peut vouloir gérer les réservations, donc on autorise
            // Mais on peut ajouter un attribut pour différencier l'affichage
            req.setAttribute("isAdminViewing", true);
        }
        
        System.out.println("✅ ClientFilter: Accès autorisé pour " + user.getEmail());
        
        // Ajouter l'utilisateur à la requête pour faciliter l'accès dans les JSP
        req.setAttribute("currentUser", user);
        
        chain.doFilter(request, response);
    }

    public void init(FilterConfig fConfig) throws ServletException {
        System.out.println("✅ ClientFilter initialisé");
    }
}