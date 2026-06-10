package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Date;

import org.eclipse.dao.OfferDao;
import org.eclipse.model.Offer;

@WebServlet("/OfferServlet")
public class OfferServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OfferDao offerDao;

    @Override
    public void init() throws ServletException {
        try {
            // Utilisation directe de votre SingletonConnection
            offerDao = new OfferDao();
        } catch (Exception e) {
            throw new ServletException("Erreur d'initialisation de la connexion à la base de données", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/destinations");
            return;
        }
        
        try {
            Long offerId = Long.parseLong(idParam);
            Offer offer = offerDao.getOfferById(offerId);
            
            if (offer == null) {
                request.setAttribute("errorMessage", "L'offre demandée n'existe pas ou n'est plus disponible.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
                return;
            }
            
            // Vérifier si l'offre est disponible
            boolean isAvailable = isOfferAvailable(offer);
            request.setAttribute("isAvailable", isAvailable);
            
            if (!isAvailable) {
                request.setAttribute("warningMessage", "Cette offre n'est plus disponible pour le moment.");
            }
            
            // Calculer les places restantes
            int availableSeats = offerDao.getAvailableSeats(offerId);
            request.setAttribute("availableSeats", availableSeats);
            
            request.setAttribute("offer", offer);
            request.setAttribute("destination", offer.getDestination());
            request.setAttribute("page", "offer");
            
            request.getRequestDispatcher("/Offer.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID d'offre invalide.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération de l'offre: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    // Méthode pour vérifier la disponibilité de l'offre
    private boolean isOfferAvailable(Offer offer) {
        if (!offer.isActive()) {
            return false;
        }
        
        Date now = new Date();
        Date availableFrom = offer.getAvailableFrom();
        Date availableTo = offer.getAvailableTo();
        
        if (availableFrom == null || availableTo == null) {
            return false;
        }
        
        return !now.before(availableFrom) && !now.after(availableTo);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}