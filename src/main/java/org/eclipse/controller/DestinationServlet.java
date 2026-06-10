package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.eclipse.dao.DestinationDao;
import org.eclipse.model.Destination;
import java.io.IOException;
import java.util.List;

@WebServlet("/destinations")
public class DestinationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private DestinationDao destinationDao;
    
    @Override
    public void init() throws ServletException {
        System.out.println("🚀 INIT DestinationServlet - Début");
        System.out.println("📌 Servlet mappée sur: /destinations");
        destinationDao = new DestinationDao();
        System.out.println("✅ DestinationDao initialisé");
        System.out.println("🚀 INIT DestinationServlet - Fin");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("\n🌐 === DESTINATION SERVLET - DOGET ===");
        System.out.println("📥 URL: " + request.getRequestURL());
        System.out.println("🔍 Query: " + request.getQueryString());
        System.out.println("📍 Contexte: " + request.getContextPath());
        
        // Vérifier la session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("⚠️ Session utilisateur non trouvée (accès public autorisé)");
        } else {
            System.out.println("👤 Utilisateur connecté: " + session.getAttribute("user"));
        }
        
        // Récupérer les paramètres
        String action = request.getParameter("action");
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        
        System.out.println("📋 Paramètres reçus:");
        System.out.println("- action: " + action);
        System.out.println("- search: " + search);
        System.out.println("- category: " + category);
        
        List<Destination> destinations;
        
        // Logique de récupération des données
        if ("search".equals(action) && search != null && !search.trim().isEmpty()) {
            System.out.println("🔍 Recherche avec mot-clé: " + search);
            destinations = destinationDao.searchDestinations(search.trim());
            request.setAttribute("searchTerm", search.trim());
            
        } else if (category != null && !category.trim().isEmpty()) {
            System.out.println("🏷️ Filtrage par catégorie: " + category);
            destinations = destinationDao.getDestinationsByCategory(category.trim());
            request.setAttribute("selectedCategory", category.trim());
            
        } else {
            System.out.println("🌍 Récupération de toutes les destinations");
            destinations = destinationDao.getAllDestinations();
        }
        
        // Récupérer les catégories pour le filtre
        List<String> categories = destinationDao.getAllCategories();
        System.out.println("📊 " + categories.size() + " catégories disponibles");
        
        // Définir les attributs de la requête
        request.setAttribute("destinations", destinations);
        request.setAttribute("categories", categories);
        request.setAttribute("page", "destinations");
        request.setAttribute("contextPath", request.getContextPath());
        
        // Vérifier si des destinations ont été trouvées
        if (destinations == null || destinations.isEmpty()) {
            System.out.println("ℹ️ Aucune destination trouvée");
            request.setAttribute("message", "Aucune destination ne correspond à votre recherche.");
        } else {
            System.out.println("✅ " + destinations.size() + " destinations à afficher");
        }
        
        // Transférer à la JSP - CORRECTION ICI
        System.out.println("🔄 Transfert vers /Destination.jsp");
        request.getRequestDispatcher("/Destination.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("📨 DestinationServlet - doPost() appelé, redirection vers doGet");
        doGet(request, response);
    }
    
    @Override
    public void destroy() {
        System.out.println("🔚 DestinationServlet détruite");
    }
}