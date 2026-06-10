package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import org.eclipse.model.User;

@WebServlet("/admin/*")
public class AdminAccesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        
        // Vérifier si l'utilisateur est admin
        if (user == null || !user.isAdmin()) {
            // Stocker l'URL demandée pour redirection après login
            if (session != null) {
                session.setAttribute("redirectAfterLogin", request.getRequestURI());
                session.setAttribute("errorMessage", 
                    "Accès réservé aux administrateurs. Veuillez vous connecter avec un compte administrateur.");
            }
            
            // Rediriger vers la page de login admin
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }
        
        // L'utilisateur est admin, continuer vers la page demandée
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            // Rediriger vers le servlet AdminDashboardServlet pour charger les données
            response.sendRedirect(request.getContextPath() + "/admindashboard");
        } else {
            // Autres pages admin
            String jspPage = "/admin" + pathInfo + ".jsp";
            try {
                request.getRequestDispatcher(jspPage).forward(request, response);
            } catch (Exception e) {
                // Page non trouvée, rediriger vers le dashboard
                response.sendRedirect(request.getContextPath() + "/admindashboard");
            }
        }
    }
}