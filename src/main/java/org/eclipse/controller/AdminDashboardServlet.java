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
import java.util.List;
import org.eclipse.dao.BookingDao;
import org.eclipse.dao.DestinationDao;
import org.eclipse.dao.UserDao;
import org.eclipse.model.Booking;
import org.eclipse.model.BookingStatus;
import org.eclipse.model.Destination;
import org.eclipse.model.User;

@WebServlet("/admindashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDao userDao;
    private DestinationDao destinationDao;
    private BookingDao bookingDao;
    
    @Override
    public void init() throws ServletException {
        try {
            userDao = new UserDao();
            destinationDao = new DestinationDao();
            bookingDao = new BookingDao();
            System.out.println("[AdminDashboardServlet] Initialisé");
        } catch (Exception e) {
            System.err.println("[AdminDashboardServlet] Erreur d'initialisation: " + e.getMessage());
            throw new ServletException("Erreur d'initialisation du AdminDashboardServlet", e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("[AdminDashboardServlet] GET - Chargement du dashboard admin");
        
        HttpSession session = request.getSession(false);
        
        // Vérifier si l'utilisateur est connecté et est admin
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("[AdminDashboardServlet] Utilisateur non connecté - redirection vers login");
            response.sendRedirect(request.getContextPath() + "/adminlogin.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!user.isAdmin()) {
            System.err.println("[AdminDashboardServlet] Accès refusé - utilisateur non admin");
            response.sendRedirect(request.getContextPath() + "/AcceuilServlet");
            return;
        }
        
        System.out.println("[AdminDashboardServlet] Admin connecté: " + user.getEmail());
        
        try {
            // Charger les statistiques
            int totalUsers = userDao.getTotalUsersCount();
            int totalDestinations = destinationDao.getTotalDestinationsCount();
            int totalBookings = bookingDao.getTotalBookingsCount();
            int pendingBookings = bookingDao.getBookingsCountByStatus(BookingStatus.PENDING);
            int confirmedBookings = bookingDao.getBookingsCountByStatus(BookingStatus.CONFIRMED);
            BigDecimal totalRevenue = bookingDao.getTotalRevenue();
            
            // Charger les listes complètes
            List<User> allUsers = userDao.getAllUsers();
            List<Destination> allDestinations = destinationDao.getAllDestinations();
            List<Booking> allBookings = bookingDao.getAllBookings();
            List<Booking> recentBookings = bookingDao.getRecentBookings(10);
            
            System.out.println("[AdminDashboardServlet] Statistiques chargées:");
            System.out.println("  - Utilisateurs: " + totalUsers + " (liste: " + allUsers.size() + ")");
            System.out.println("  - Destinations: " + totalDestinations + " (liste: " + allDestinations.size() + ")");
            System.out.println("  - Réservations: " + totalBookings + " (liste: " + allBookings.size() + ")");
            System.out.println("  - En attente: " + pendingBookings);
            System.out.println("  - Confirmées: " + confirmedBookings);
            System.out.println("  - Revenu total: " + totalRevenue);
            System.out.println("  - Réservations récentes: " + recentBookings.size());
            
            // Vérifier que les listes ne sont pas null
            if (allUsers == null) {
                System.err.println("[AdminDashboardServlet] ERREUR: allUsers est null!");
            }
            if (allDestinations == null) {
                System.err.println("[AdminDashboardServlet] ERREUR: allDestinations est null!");
            }
            if (allBookings == null) {
                System.err.println("[AdminDashboardServlet] ERREUR: allBookings est null!");
            }
            
            // Passer les données à la JSP
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalDestinations", totalDestinations);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("pendingBookings", pendingBookings);
            request.setAttribute("confirmedBookings", confirmedBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            
            request.setAttribute("allUsers", allUsers != null ? allUsers : new java.util.ArrayList<User>());
            request.setAttribute("allDestinations", allDestinations != null ? allDestinations : new java.util.ArrayList<Destination>());
            request.setAttribute("allBookings", allBookings != null ? allBookings : new java.util.ArrayList<Booking>());
            request.setAttribute("recentBookings", recentBookings != null ? recentBookings : new java.util.ArrayList<Booking>());
            
            System.out.println("[AdminDashboardServlet] Données passées à la JSP avec succès");
            
            // Forward vers la page JSP
            request.getRequestDispatcher("/admindashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            System.err.println("[AdminDashboardServlet] Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du chargement des données: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[AdminDashboardServlet] Erreur inattendue: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Une erreur inattendue s'est produite.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}

