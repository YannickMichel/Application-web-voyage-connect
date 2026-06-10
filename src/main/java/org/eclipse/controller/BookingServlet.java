package org.eclipse.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.eclipse.dao.BookingDao;
import org.eclipse.dao.OfferDao;
import org.eclipse.model.Booking;
import org.eclipse.model.BookingStatus;
import org.eclipse.model.Offer;
import org.eclipse.model.User;

@WebServlet("/reservation")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDao bookingDao;
    private OfferDao offerDao;
    
    @Override
    public void init() throws ServletException {
        try {
            bookingDao = new BookingDao();
            offerDao = new OfferDao();
            System.out.println("[BookingServlet] Initialisé avec succès");
        } catch (Exception e) {
            System.err.println("[BookingServlet] Erreur d'initialisation: " + e.getMessage());
            throw new ServletException("Erreur d'initialisation du BookingServlet", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Rediriger vers login si non connecté
            session.setAttribute("redirectAfterLogin", request.getRequestURI() + 
                (request.getQueryString() != null ? "?" + request.getQueryString() : ""));
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String offerIdParam = request.getParameter("offerId");
        
        if (offerIdParam == null || offerIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Aucune offre spécifiée.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }
        
        try {
            Long offerId = Long.parseLong(offerIdParam);
            Offer offer = offerDao.getOfferById(offerId);
            
            if (offer == null || !offer.isActive()) {
                request.setAttribute("errorMessage", "Cette offre n'est pas disponible.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Vérifier si déjà réservé
            boolean hasBooked = bookingDao.hasUserBookedOffer(user.getId(), offerId);
            if (hasBooked) {
                request.setAttribute("warningMessage", "Vous avez déjà réservé cette offre.");
            }
            
            // CALCUL DES DATES CORRIGÉ
            Date today = new Date();
            
            // Date de début minimum = aujourd'hui
            Date minStartDate = today;
            
            // Date de fin maximum = date de fin de l'offre si elle existe
            Date maxEndDate = null;
            if (offer.getAvailableTo() != null) {
                maxEndDate = offer.getAvailableTo();
            }
            
            // Date de fin par défaut = aujourd'hui + durée par défaut (3 jours)
            Date defaultEndDate = new Date(today.getTime() + (3 * 24 * 60 * 60 * 1000));
            
            // Si l'offre a une date de fin max, vérifier que defaultEndDate ne dépasse pas
            if (maxEndDate != null && defaultEndDate.after(maxEndDate)) {
                defaultEndDate = maxEndDate;
            }
            
            // Formater les dates pour HTML
            SimpleDateFormat htmlFormat = new SimpleDateFormat("yyyy-MM-dd");
            
            request.setAttribute("offer", offer);
            request.setAttribute("user", user);
            request.setAttribute("today", today);
            request.setAttribute("minStartDate", minStartDate);
            request.setAttribute("defaultStartDate", today);
            request.setAttribute("defaultEndDate", defaultEndDate);
            request.setAttribute("maxEndDate", maxEndDate);
            request.setAttribute("hasBooked", hasBooked);
            
            // Formatted dates for HTML inputs
            request.setAttribute("minStartDateStr", htmlFormat.format(today));
            request.setAttribute("defaultStartDateStr", htmlFormat.format(today));
            request.setAttribute("defaultEndDateStr", htmlFormat.format(defaultEndDate));
            if (maxEndDate != null) {
                request.setAttribute("maxEndDateStr", htmlFormat.format(maxEndDate));
            }
            
            request.getRequestDispatcher("/booking.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID d'offre invalide.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors de la récupération de l'offre.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("[BookingServlet] POST - Traitement formulaire de réservation");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("[BookingServlet] POST - Utilisateur non connecté");
            response.sendRedirect(request.getContextPath() + "/Login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        try {
            // Récupérer les données du formulaire
            Long offerId = Long.parseLong(request.getParameter("offerId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            Date startDate = dateFormat.parse(request.getParameter("startDate"));
            Date endDate = dateFormat.parse(request.getParameter("endDate"));
            
            System.out.println("[BookingServlet] POST - Données reçues:");
            System.out.println("  - Offer ID: " + offerId);
            System.out.println("  - Quantity: " + quantity);
            System.out.println("  - Start Date: " + startDate);
            System.out.println("  - End Date: " + endDate);
            
            // Valider les dates
            Date today = new Date();
            if (startDate.before(today)) {
                request.setAttribute("errorMessage", "La date de début ne peut pas être dans le passé.");
                doGet(request, response);
                return;
            }
            
            if (endDate.before(startDate)) {
                request.setAttribute("errorMessage", "La date de fin doit être après la date de début.");
                doGet(request, response);
                return;
            }
            
            // Calculer le nombre de jours
            long diff = endDate.getTime() - startDate.getTime();
            int days = (int) (diff / (1000 * 60 * 60 * 24)) + 1;
            
            if (days <= 0) {
                request.setAttribute("errorMessage", "La durée doit être d'au moins 1 jour.");
                doGet(request, response);
                return;
            }
            
            // Récupérer l'offre
            Offer offer = offerDao.getOfferById(offerId);
            if (offer == null || !offer.isActive()) {
                request.setAttribute("errorMessage", "Cette offre n'est plus disponible.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            // Vérifier la disponibilité des places
            int availableSeats = offerDao.getAvailableSeats(offerId);
            if (quantity > availableSeats) {
                request.setAttribute("errorMessage", 
                    "Il ne reste que " + availableSeats + " place(s) disponible(s).");
                doGet(request, response);
                return;
            }
            
            // Vérifier la disponibilité des dates
            java.sql.Date sqlStartDate = new java.sql.Date(startDate.getTime());
            java.sql.Date sqlEndDate = new java.sql.Date(endDate.getTime());
            boolean isAvailable = bookingDao.isDateAvailable(offerId, sqlStartDate, sqlEndDate);
            
            if (!isAvailable) {
                request.setAttribute("errorMessage", 
                    "Ces dates ne sont pas disponibles pour cette offre. Veuillez choisir d'autres dates.");
                doGet(request, response);
                return;
            }
            
            // Calculer le total
            BigDecimal pricePerPerson = offer.getPrice();
            BigDecimal totalAmount = pricePerPerson
                .multiply(BigDecimal.valueOf(quantity))
                .multiply(BigDecimal.valueOf(days));
            
            // Créer la réservation
            Booking booking = new Booking();
            booking.setUser(user);
            booking.setOffer(offer);
            booking.setStartDate(startDate);
            booking.setEndDate(endDate);
            booking.setQuantity(quantity);
            booking.setBookingDate(new Date());
            booking.setStatus(BookingStatus.PENDING);
            booking.setTotalAmount(totalAmount);
            
            System.out.println("[BookingServlet] Création réservation pour user: " + user.getId());
            
            // Enregistrer la réservation
            Long bookingId = bookingDao.createBooking(booking);
            
            if (bookingId != null) {
                System.out.println("[BookingServlet] Réservation créée avec ID: " + bookingId);
                
                // Mettre à jour les places disponibles
                offerDao.updateAvailableSeats(offerId, quantity);
                
                // Rediriger vers la confirmation
                String confirmationUrl = request.getContextPath() + "/bookingconfirmation?id=" + bookingId;
                System.out.println("[BookingServlet] Redirection vers: " + confirmationUrl);
                response.sendRedirect(confirmationUrl);
            } else {
                System.err.println("[BookingServlet] Échec création réservation");
                request.setAttribute("errorMessage", "Erreur lors de la création de la réservation.");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            System.err.println("[BookingServlet] Erreur format données: " + e.getMessage());
            request.setAttribute("errorMessage", "Données invalides. Veuillez vérifier les informations saisies.");
            doGet(request, response);
        } catch (ParseException e) {
            System.err.println("[BookingServlet] Erreur parsing date: " + e.getMessage());
            request.setAttribute("errorMessage", "Format de date invalide.");
            doGet(request, response);
        } catch (SQLException e) {
            System.err.println("[BookingServlet] Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur de base de données: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[BookingServlet] Erreur inattendue: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur inattendue s'est produite.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    public void destroy() {
        System.out.println("[BookingServlet] Destruction du servlet");
        super.destroy();
    }
}