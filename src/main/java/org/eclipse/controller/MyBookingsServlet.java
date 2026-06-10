package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import org.eclipse.dao.BookingDao;
import org.eclipse.model.Booking;
import org.eclipse.model.User;

@WebServlet("/mybookings")
public class MyBookingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDao bookingDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingDao = new BookingDao();
        System.out.println("[MyBookingsServlet] ✅ Initialisé avec succès");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("[MyBookingsServlet] ===== GET REQUEST RECEIVED =====");
        System.out.println("[MyBookingsServlet] URI: " + request.getRequestURI());
        System.out.println("[MyBookingsServlet] URL: " + request.getRequestURL());
        System.out.println("[MyBookingsServlet] Context Path: " + request.getContextPath());
        System.out.println("[MyBookingsServlet] Accès à la liste des réservations");
        
        HttpSession session = request.getSession(false);
        
        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("[MyBookingsServlet] Utilisateur non connecté - redirection vers login");
            
            // Stocker l'URL demandée pour redirection après login
            session = request.getSession(true);
            session.setAttribute("redirectAfterLogin", "/mybookings");
            
            // Rediriger vers la page de login
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        System.out.println("[MyBookingsServlet] Utilisateur connecté: " + user.getEmail());
        System.out.println("[MyBookingsServlet] User ID: " + user.getId());
        
        try {
            // Récupérer les réservations de l'utilisateur
            Long userId = (long) user.getId();
            System.out.println("[MyBookingsServlet] Recherche réservations pour userId (Long): " + userId);
            List<Booking> bookings = bookingDao.getBookingsByUserId(userId);
            
            System.out.println("[MyBookingsServlet] " + bookings.size() + " réservations trouvées");
            for (Booking booking : bookings) {
                System.out.println("[MyBookingsServlet] Réservation ID: " + booking.getId() + 
                                 ", Statut: " + booking.getStatus() + 
                                 ", User ID: " + booking.getUser().getId());
            }
            
            // Passer les données à la JSP
            request.setAttribute("bookings", bookings);
            request.setAttribute("user", user);
            request.setAttribute("pageTitle", "Mes Réservations");
            
            // Forward vers la page JSP
            request.getRequestDispatcher("/mybookings.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("[MyBookingsServlet] Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération de vos réservations.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[MyBookingsServlet] Erreur inattendue: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur inattendue s'est produite.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}