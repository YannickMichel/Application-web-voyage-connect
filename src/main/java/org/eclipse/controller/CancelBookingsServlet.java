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

@WebServlet("/cancelbooking")
public class CancelBookingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDao bookingDao;
    
    @Override
    public void init() throws ServletException {
        super.init();
        bookingDao = new BookingDao();
        System.out.println("[CancelBookingServlet] ✅ Initialisé avec succès");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("[CancelBookingServlet] ===== POST REQUEST RECEIVED =====");
        
        HttpSession session = request.getSession(false);
        
        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("[CancelBookingServlet] Utilisateur non connecté - redirection vers login");
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        System.out.println("[CancelBookingServlet] Utilisateur connecté: " + user.getEmail());
        System.out.println("[CancelBookingServlet] User ID: " + user.getId());
        
        // Récupérer l'ID de la réservation à annuler
        String bookingIdParam = request.getParameter("bookingId");
        
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            System.err.println("[CancelBookingServlet] Erreur: bookingId manquant");
            session.setAttribute("errorMessage", "ID de réservation manquant.");
            response.sendRedirect(request.getContextPath() + "/mybookings");
            return;
        }
        
        try {
            Long bookingId = Long.parseLong(bookingIdParam);
            System.out.println("[CancelBookingServlet] Tentative d'annulation de la réservation ID: " + bookingId);
            
            // Vérifier que la réservation existe et appartient à l'utilisateur
            Booking booking = bookingDao.getBookingById(bookingId);
            
            if (booking == null) {
                System.err.println("[CancelBookingServlet] Réservation non trouvée: " + bookingId);
                session.setAttribute("errorMessage", "Réservation non trouvée.");
                response.sendRedirect(request.getContextPath() + "/mybookings");
                return;
            }
            
            // Vérifier que la réservation appartient à l'utilisateur connecté
            if (booking.getUser().getId() != user.getId()) {
                System.err.println("[CancelBookingServlet] Tentative d'annulation d'une réservation qui n'appartient pas à l'utilisateur");
                System.err.println("[CancelBookingServlet] Réservation user ID: " + booking.getUser().getId() + ", Session user ID: " + user.getId());
                session.setAttribute("errorMessage", "Vous n'êtes pas autorisé à annuler cette réservation.");
                response.sendRedirect(request.getContextPath() + "/mybookings");
                return;
            }
            
            // Vérifier que la réservation n'est pas déjà annulée
            if (booking.getStatus().toString().equals("CANCELLED")) {
                System.out.println("[CancelBookingServlet] Réservation déjà annulée");
                session.setAttribute("errorMessage", "Cette réservation est déjà annulée.");
                response.sendRedirect(request.getContextPath() + "/mybookings");
                return;
            }
            
            // Annuler la réservation
            boolean success = bookingDao.cancelBooking(bookingId);
            
            if (success) {
                System.out.println("[CancelBookingServlet] ✅ Réservation annulée avec succès: " + bookingId);
                session.setAttribute("successMessage", "Réservation #" + bookingId + " annulée avec succès.");
            } else {
                System.err.println("[CancelBookingServlet] ❌ Échec de l'annulation de la réservation: " + bookingId);
                session.setAttribute("errorMessage", "Erreur lors de l'annulation de la réservation.");
            }
            
            // Rediriger vers la page "Mes Réservations"
            response.sendRedirect(request.getContextPath() + "/mybookings");
            
        } catch (NumberFormatException e) {
            System.err.println("[CancelBookingServlet] Erreur: bookingId invalide: " + bookingIdParam);
            e.printStackTrace();
            session.setAttribute("errorMessage", "ID de réservation invalide.");
            response.sendRedirect(request.getContextPath() + "/mybookings");
        } catch (SQLException e) {
            System.err.println("[CancelBookingServlet] Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Erreur lors de l'annulation de la réservation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/mybookings");
        } catch (Exception e) {
            System.err.println("[CancelBookingServlet] Erreur inattendue: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Une erreur inattendue s'est produite.");
            response.sendRedirect(request.getContextPath() + "/mybookings");
        }
    }
}