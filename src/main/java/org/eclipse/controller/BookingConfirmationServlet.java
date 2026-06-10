package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import org.eclipse.dao.BookingDao;
import org.eclipse.model.Booking;
import org.eclipse.model.User;

@WebServlet("/bookingconfirmation")
public class BookingConfirmationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDao bookingDao;
    
    @Override
    public void init() throws ServletException {
        bookingDao = new BookingDao();
        System.out.println("[BookingConfirmationServlet] Initialisé");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("[BookingConfirmationServlet] GET - Affichage confirmation réservation");
        
        HttpSession session = request.getSession(false);
        
        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("[BookingConfirmationServlet] Utilisateur non connecté - redirection vers login");
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String bookingIdParam = request.getParameter("id");
        
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            System.err.println("[BookingConfirmationServlet] Aucun ID de réservation fourni");
            request.setAttribute("errorMessage", "Aucune réservation spécifiée.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        try {
            Long bookingId = Long.parseLong(bookingIdParam);
            Booking booking = bookingDao.getBookingById(bookingId);
            
            if (booking == null) {
                System.err.println("[BookingConfirmationServlet] Réservation non trouvée pour ID: " + bookingId);
                request.setAttribute("errorMessage", "Réservation non trouvée.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Vérifier que la réservation appartient à l'utilisateur connecté
            if (booking.getUser().getId() != user.getId()) {
                System.err.println("[BookingConfirmationServlet] Tentative d'accès non autorisée - User ID: " + 
                                 user.getId() + ", Booking User ID: " + booking.getUser().getId());
                request.setAttribute("errorMessage", "Vous n'avez pas l'autorisation d'accéder à cette réservation.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            System.out.println("[BookingConfirmationServlet] Réservation trouvée - ID: " + bookingId + 
                             ", User: " + user.getEmail());
            
            // Passer les données à la JSP
            request.setAttribute("booking", booking);
            request.setAttribute("user", user);
            request.setAttribute("pageTitle", "Confirmation de Réservation");
            
            // Forward vers la page JSP
            request.getRequestDispatcher("/bookingconfirmation.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("[BookingConfirmationServlet] Erreur format ID: " + e.getMessage());
            request.setAttribute("errorMessage", "ID de réservation invalide.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("[BookingConfirmationServlet] Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération de la réservation.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[BookingConfirmationServlet] Erreur inattendue: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur inattendue s'est produite.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}