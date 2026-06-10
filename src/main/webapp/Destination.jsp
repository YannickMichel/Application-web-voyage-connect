<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="org.eclipse.model.Destination" %>
<%@ page import="org.eclipse.model.Offer" %>
<%@ page import="org.eclipse.dao.OfferDao" %>
<%@ page import="metier.SingletonConnection" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.SQLException" %>
<%
    // Debug info
    System.out.println("[JSP] Destination.jsp chargé");
    
    // Récupérer les attributs de la requête
    List<Destination> destinations = (List<Destination>) request.getAttribute("destinations");
    List<String> categories = (List<String>) request.getAttribute("categories");
    String searchTerm = (String) request.getAttribute("searchTerm");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String message = (String) request.getAttribute("message");
    
    // Toujours utiliser request.getContextPath() directement
    String contextPath = request.getContextPath();
    System.out.println("[JSP] Context Path: " + contextPath);
    
    // Vérifier si l'utilisateur est connecté
    HttpSession userSession = request.getSession(false);
    boolean isLoggedIn = (userSession != null && userSession.getAttribute("user") != null);
    System.out.println("[JSP] Utilisateur connecté: " + isLoggedIn);
    
    System.out.println("[JSP] Destinations: " + (destinations != null ? destinations.size() : "null"));
    
    // Initialiser OfferDao pour récupérer les offres
    OfferDao offerDao = null;
    try {
        Connection conn = SingletonConnection.getConnection();
        offerDao = new OfferDao(conn);
        System.out.println("[JSP] OfferDao initialisé avec succès");
    } catch (Exception e) {
        System.err.println("[JSP] Erreur d'initialisation OfferDao: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Destinations - VoyageConnect</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    /* Variables de couleurs */
    :root {
        --primary: #1a56db;
        --primary-light: #3b82f6;
        --secondary: #10b981;
        --dark: #1f2937;
        --light: #f8fafc;
        --gray: #6b7280;
        --light-gray: #e5e7eb;
    }
    
    /* Reset et base */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: var(--light);
        color: var(--dark);
        line-height: 1.6;
    }
    
    .main-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 0 20px;
    }
    
    /* Hero Section */
    .hero-section {
        background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
        color: white;
        padding: 80px 0 60px;
        text-align: center;
        margin-bottom: 40px;
        border-radius: 0 0 30px 30px;
    }
    
    .hero-title {
        font-size: 3rem;
        font-weight: 800;
        margin-bottom: 15px;
        animation: fadeInDown 0.8s ease;
    }
    
    .hero-subtitle {
        font-size: 1.2rem;
        opacity: 0.9;
        max-width: 600px;
        margin: 0 auto 30px;
        animation: fadeInUp 0.8s ease 0.2s both;
    }
    
    /* Filtres et recherche */
    .filters-section {
        background: white;
        padding: 30px;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        margin-bottom: 40px;
    }
    
    .search-container {
        display: flex;
        gap: 15px;
        margin-bottom: 25px;
    }
    
    .search-input {
        flex: 1;
        padding: 16px 24px;
        border: 2px solid var(--light-gray);
        border-radius: 50px;
        font-size: 1.1rem;
        transition: all 0.3s;
    }
    
    .search-input:focus {
        outline: none;
        border-color: var(--primary);
        box-shadow: 0 0 0 3px rgba(26, 86, 219, 0.1);
    }
    
    .search-btn {
        background: var(--primary);
        color: white;
        border: none;
        padding: 0 30px;
        border-radius: 50px;
        font-weight: 600;
        font-size: 1.1rem;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .search-btn:hover {
        background: var(--primary-light);
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(26, 86, 219, 0.3);
    }
    
    /* Catégories */
    .categories-container {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        justify-content: center;
    }
    
    .category-btn {
        background: var(--light);
        color: var(--dark);
        border: 2px solid var(--light-gray);
        padding: 10px 20px;
        border-radius: 25px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
    }
    
    .category-btn:hover,
    .category-btn.active {
        background: var(--primary);
        color: white;
        border-color: var(--primary);
        transform: translateY(-3px);
    }
    
    .category-btn.all-btn {
        background: var(--secondary);
        color: white;
        border-color: var(--secondary);
    }
    
    /* Grid des destinations */
    .destinations-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
        gap: 30px;
        margin-bottom: 50px;
    }
    
    /* Carte de destination */
    .destination-card {
        background: white;
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        transition: all 0.4s ease;
        position: relative;
    }
    
    .destination-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 20px 40px rgba(0,0,0,0.15);
    }
    
    .card-image {
        width: 100%;
        height: 250px;
        object-fit: cover;
        transition: transform 0.5s ease;
    }
    
    .destination-card:hover .card-image {
        transform: scale(1.05);
    }
    
    .card-badge {
        position: absolute;
        top: 20px;
        right: 20px;
        background: rgba(255, 255, 255, 0.95);
        color: var(--dark);
        padding: 8px 16px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.9rem;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        display: flex;
        align-items: center;
        gap: 6px;
    }
    
    .card-content {
        padding: 25px;
    }
    
    .card-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 15px;
    }
    
    .destination-title {
        font-size: 1.4rem;
        font-weight: 700;
        color: var(--dark);
        margin-bottom: 5px;
    }
    
    .destination-location {
        color: var(--primary);
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 0.95rem;
    }
    
    .destination-price {
        background: var(--primary);
        color: white;
        padding: 8px 16px;
        border-radius: 15px;
        font-weight: 700;
        font-size: 1.2rem;
    }
    
    .destination-description {
        color: var(--gray);
        margin-bottom: 20px;
        line-height: 1.7;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .card-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding-top: 20px;
        border-top: 1px solid var(--light-gray);
    }
    
    .destination-duration {
        display: flex;
        align-items: center;
        gap: 8px;
        color: var(--gray);
        font-weight: 500;
    }
    
    /* Bouton Consulter l'offre */
    .details-btn {
        background: var(--secondary);
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
        font-size: 0.9rem;
        min-width: 140px;
        justify-content: center;
    }
    
    .details-btn:hover {
        background: #0da271;
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
    }
    
    .details-btn:disabled {
        background: #9ca3af;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
        opacity: 0.6;
    }
    
    /* Bouton Réserver */
    .reserve-btn {
        background: var(--primary);
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
        font-size: 0.9rem;
        min-width: 120px;
        justify-content: center;
    }
    
    .reserve-btn:hover {
        background: var(--primary-light);
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(26, 86, 219, 0.3);
    }
    
    .reserve-btn:disabled {
        background: #9ca3af;
        cursor: not-allowed;
        transform: none;
        box-shadow: none;
        opacity: 0.6;
    }
    
    /* Conteneur pour les boutons */
    .card-actions {
        display: flex;
        gap: 10px;
        align-items: center;
    }
    
    /* Message vide */
    .empty-message {
        text-align: center;
        padding: 60px 20px;
        background: white;
        border-radius: 20px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        margin: 40px 0;
    }
    
    .empty-icon {
        font-size: 4rem;
        color: var(--light-gray);
        margin-bottom: 20px;
    }
    
    .empty-title {
        font-size: 1.8rem;
        color: var(--dark);
        margin-bottom: 10px;
    }
    
    .empty-text {
        color: var(--gray);
        max-width: 500px;
        margin: 0 auto 30px;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .hero-title {
            font-size: 2.2rem;
        }
        
        .destinations-grid {
            grid-template-columns: 1fr;
            gap: 20px;
        }
        
        .search-container {
            flex-direction: column;
        }
        
        .search-btn {
            width: 100%;
            justify-content: center;
            padding: 16px;
        }
        
        .categories-container {
            justify-content: flex-start;
            overflow-x: auto;
            padding-bottom: 10px;
        }
        
        .category-btn {
            white-space: nowrap;
        }
        
        /* Adaptation responsive pour les boutons */
        .card-footer {
            flex-direction: column;
            gap: 15px;
            align-items: flex-start;
        }
        
        .card-actions {
            flex-direction: column;
            width: 100%;
        }
        
        .details-btn, .reserve-btn {
            width: 100%;
            min-width: auto;
        }
    }
    
    /* Animations */
    @keyframes fadeInDown {
        from {
            opacity: 0;
            transform: translateY(-30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .destination-card {
        animation: fadeInUp 0.6s ease;
        animation-fill-mode: both;
    }
    
    .destination-card:nth-child(1) { animation-delay: 0.1s; }
    .destination-card:nth-child(2) { animation-delay: 0.2s; }
    .destination-card:nth-child(3) { animation-delay: 0.3s; }
    .destination-card:nth-child(4) { animation-delay: 0.4s; }
    .destination-card:nth-child(5) { animation-delay: 0.5s; }
    .destination-card:nth-child(6) { animation-delay: 0.6s; }
</style>
</head>
<body>
<%@include file="Header.jsp" %>

<!-- Hero Section -->
<section class="hero-section">
    <div class="main-container">
        <h1 class="hero-title">
            <i class="fas fa-globe-americas"></i> Explorez le Monde
        </h1>
        <p class="hero-subtitle">
            Découvrez nos destinations exclusives à travers le globe. Des plages paradisiaques aux montagnes majestueuses, 
            trouvez votre prochaine aventure.
        </p>
    </div>
</section>

<div class="main-container">
    <!-- Section Filtres -->
    <section class="filters-section">
        <!-- Barre de recherche -->
        <form action="<%= contextPath %>/destinations" method="get" class="search-container">
            <input type="hidden" name="action" value="search">
            <input type="text" 
                   name="search" 
                   class="search-input" 
                   placeholder="Rechercher une destination, un pays, une ville..."
                   value="<%= searchTerm != null ? searchTerm : "" %>">
            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> Rechercher
            </button>
        </form>
        
        <!-- Filtres par catégorie -->
        <div class="categories-container">
            <a href="<%= contextPath %>/destinations" 
               class="category-btn all-btn <%= (selectedCategory == null || selectedCategory.isEmpty()) ? "active" : "" %>">
                <i class="fas fa-th-large"></i> Toutes
            </a>
            
            <% if (categories != null) { 
                for (String category : categories) { 
            %>
                <a href="<%= contextPath %>/destinations?category=<%= java.net.URLEncoder.encode(category, "UTF-8") %>" 
                   class="category-btn <%= category.equals(selectedCategory) ? "active" : "" %>">
                    <i class="fas fa-tag"></i> <%= category %>
                </a>
            <%   } 
               } %>
        </div>
    </section>
    
    <!-- Section Destinations -->
    <%
        if (destinations != null && !destinations.isEmpty()) {
    %>
        <!-- Grid des destinations -->
        <div class="destinations-grid">
            <% 
                NumberFormat nf = NumberFormat.getInstance(Locale.FRENCH);
                nf.setMaximumFractionDigits(0);
                
                for (Destination destination : destinations) { 
                    String imageUrl = destination.getImageUrl();
                    if (imageUrl == null || imageUrl.isEmpty()) {
                        imageUrl = "https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&auto=format&fit=crop";
                    }
                    
                    String priceText = destination.getPrice() != null ? 
                        nf.format(destination.getPrice()) + " DH" : "Sur demande";
                    
                    // Récupérer la première offre active pour cette destination
                    Offer offer = null;
                    Long offerId = null;
                    String offerTitle = "";
                    boolean offerActive = false;
                    
                    if (offerDao != null) {
                        try {
                            offer = offerDao.getFirstActiveOfferByDestinationId(destination.getId());
                            if (offer != null) {
                                offerId = offer.getId();
                                offerTitle = offer.getTitle();
                                offerActive = offer.isActive();
                                System.out.println("[JSP] Offre trouvée pour destination " + destination.getId() + 
                                                 ": ID=" + offerId + ", Titre=" + offerTitle + ", Active=" + offerActive);
                            } else {
                                System.out.println("[JSP] Aucune offre active pour destination " + destination.getId());
                            }
                        } catch (SQLException e) {
                            System.err.println("[JSP] Erreur récupération offre pour destination " + 
                                               destination.getId() + ": " + e.getMessage());
                        }
                    }
                    
                    // Construire l'URL de réservation
                    String reservationUrl = "";
                    if (offerId != null && offerActive) {
                        reservationUrl = contextPath + "/reservation?offerId=" + offerId;
                    }
            %>
                <div class="destination-card">
                    <!-- Image -->
                    <img src="<%= imageUrl %>" 
                         alt="<%= destination.getCity() %>, <%= destination.getCountry() %>" 
                         class="card-image">
                    
                    <!-- Badge catégorie -->
                    <% if (destination.getCategory() != null && !destination.getCategory().isEmpty()) { %>
                    <div class="card-badge">
                        <i class="fas fa-tag"></i> <%= destination.getCategory() %>
                    </div>
                    <% } %>
                    
                    <!-- Contenu -->
                    <div class="card-content">
                        <div class="card-header">
                            <div>
                                <h3 class="destination-title"><%= destination.getCity() %></h3>
                                <div class="destination-location">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span><%= destination.getCountry() %></span>
                                </div>
                            </div>
                            <div class="destination-price">
                                <%= priceText %>
                            </div>
                        </div>
                        
                        <p class="destination-description">
                            <%= destination.getDescription() != null ? 
                                (destination.getDescription().length() > 150 ? 
                                 destination.getDescription().substring(0, 150) + "..." : 
                                 destination.getDescription()) : 
                                "Aucune description disponible." %>
                        </p>
                        
                        <div class="card-footer">
                            <% if (destination.getDuration() != null) { %>
                            <div class="destination-duration">
                                <i class="fas fa-calendar-alt"></i>
                                <span><%= destination.getDuration() %> jours</span>
                            </div>
                            <% } %>
                            
                            <!-- Conteneur pour les boutons -->
                            <div class="card-actions">
                                <!-- Bouton Consulter l'offre -->
                                <% if (offerId != null) { %>
                                <a href="<%= contextPath %>/OfferServlet?id=<%= offerId %>" 
                                   class="details-btn"
                                   title="<%= offerTitle %>">
                                    <i class="fas fa-file-alt"></i> Consulter l'offre
                                </a>
                                <% } else { %>
                                <button class="details-btn" disabled
                                        title="Aucune offre disponible">
                                    <i class="fas fa-file-alt"></i> Aucune offre
                                </button>
                                <% } %>
                                
                                <!-- Bouton Réserver -->
                                <% if (offerId != null && offerActive) { %>
                                <a href="<%= reservationUrl %>" 
                                   class="reserve-btn"
                                   onclick="return handleReservationClick('<%= contextPath %>', <%= offerId %>, event)"
                                   title="Réserver cette offre">
                                    <i class="fas fa-calendar-check"></i> Réserver
                                </a>
                                <% } else { %>
                                <button class="reserve-btn" disabled
                                        title="<%= offerId == null ? "Aucune offre disponible" : "Offre non active" %>">
                                    <i class="fas fa-calendar-check"></i> Réserver
                                </button>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <%
        } else if (message != null) {
    %>
        <!-- Message quand aucune destination trouvée -->
        <div class="empty-message">
            <div class="empty-icon">
                <i class="fas fa-map-marker-alt"></i>
            </div>
            <h2 class="empty-title">Aucune destination trouvée</h2>
            <p class="empty-text"><%= message %></p>
            <a href="<%= contextPath %>/destinations" class="details-btn">
                <i class="fas fa-undo"></i> Voir toutes les destinations
            </a>
        </div>
    <%
        } else {
    %>
        <!-- Message par défaut -->
        <div class="empty-message">
            <div class="empty-icon">
                <i class="fas fa-compass"></i>
            </div>
            <h2 class="empty-title">Chargement des destinations...</h2>
            <p class="empty-text">Nos merveilleuses destinations seront bientôt affichées.</p>
        </div>
    <%
        }
    %>
</div>

<%@include file="Footer.jsp" %>

<script>
console.log('Destination.jsp chargé');
console.log('Context Path:', '<%= contextPath %>');
console.log('Utilisateur connecté:', <%= isLoggedIn %>);

// Animation au chargement
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM chargé - initialisation des animations');
    
    const cards = document.querySelectorAll('.destination-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
    
    // Gestion des boutons désactivés
    document.querySelectorAll('.details-btn:disabled, .reserve-btn:disabled').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const title = this.getAttribute('title') || "Cette destination n'a pas d'offre disponible pour le moment.";
            alert(title);
        });
    });
    
    // Log des liens pour débogage
    document.querySelectorAll('.reserve-btn:not(:disabled)').forEach(link => {
        console.log('Lien Réserver trouvé:', link.href);
        link.addEventListener('click', function(e) {
            console.log('Clic sur Réserver:', this.href);
        });
    });
    
    // Log des liens consulter l'offre
    document.querySelectorAll('.details-btn:not(:disabled)').forEach(link => {
        console.log('Lien Consulter trouvé:', link.href);
    });
});

// Fonction pour gérer le clic sur Réserver
function handleReservationClick(contextPath, offerId, event) {
    console.log('Tentative de réservation pour offre ID:', offerId);
    console.log('Utilisateur connecté côté serveur:', <%= isLoggedIn %>);
    
    // Si non connecté
    if (<%= !isLoggedIn %>) {
        event.preventDefault(); // Empêcher le comportement par défaut
        
        // Construire l'URL de redirection
        const redirectUrl = contextPath + '/reservation?offerId=' + offerId;
        console.log('URL de redirection:', redirectUrl);
        
        // Afficher une boîte de dialogue personnalisée
        const confirmed = confirm(
            '🔐 Connexion requise\n\n' +
            'Vous devez être connecté pour effectuer une réservation.\n\n' +
            'Voulez-vous vous connecter maintenant ?'
        );
        
        if (confirmed) {
            // Rediriger vers la page de login avec paramètre de redirection
            const loginUrl = contextPath + '/Login.jsp?redirect=' + encodeURIComponent(redirectUrl);
            console.log('Redirection vers:', loginUrl);
            window.location.href = loginUrl;
        } else {
            console.log('Utilisateur a annulé la connexion');
        }
        return false;
    }
    
    // Si connecté, autoriser la navigation normalement
    console.log('Utilisateur connecté, navigation vers le formulaire de réservation');
    return true;
}

// Fonction de test pour vérifier les URLs
function testReservationLinks() {
    console.log('=== Test des liens de réservation ===');
    const reserveLinks = document.querySelectorAll('.reserve-btn:not(:disabled)');
    console.log('Nombre de liens Réserver actifs:', reserveLinks.length);
    
    reserveLinks.forEach((link, index) => {
        console.log(`Lien ${index + 1}:`, link.href);
        
        // Vérifier si le lien est valide
        fetch(link.href, { method: 'HEAD' })
            .then(response => {
                console.log(`Lien ${index + 1} - Status: ${response.status} ${response.statusText}`);
            })
            .catch(error => {
                console.error(`Lien ${index + 1} - Erreur:`, error);
            });
    });
}

// Exécuter le test au chargement (optionnel, pour débogage)
// setTimeout(testReservationLinks, 1000);
</script>
</body>
</html>