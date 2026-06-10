<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="org.eclipse.model.Offer" %>
<%@ page import="org.eclipse.model.Destination" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    Offer offer = (Offer) request.getAttribute("offer");
    Destination destination = (Destination) request.getAttribute("destination");
    Integer availableSeats = (Integer) request.getAttribute("availableSeats");
    Boolean isAvailable = (Boolean) request.getAttribute("isAvailable");
    String warningMessage = (String) request.getAttribute("warningMessage");
    String contextPath = request.getContextPath();
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    NumberFormat nf = NumberFormat.getInstance(Locale.FRENCH);
    nf.setMaximumFractionDigits(2);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Offre - <%= offer != null ? offer.getTitle() : "VoyageConnect" %></title>
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
        --flight: #3b82f6;
        --hotel: #10b981;
        --tour: #8b5cf6;
    }
    
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
        max-width: 1200px;
        margin: 0 auto;
        padding: 0 20px;
    }
    
    /* Section Principale */
    .offer-section {
        padding: 40px 0;
    }
    
    /* Header de l'offre */
    .offer-header {
        background: white;
        border-radius: 20px;
        padding: 40px;
        margin-bottom: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
        position: relative;
        overflow: hidden;
    }
    
    .offer-header::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        height: 5px;
        <c:choose>
            <c:when test="${offer.type == 'FLIGHT'}">
                background: var(--flight);
            </c:when>
            <c:when test="${offer.type == 'HOTEL'}">
                background: var(--hotel);
            </c:when>
            <c:otherwise>
                background: var(--tour);
            </c:otherwise>
        </c:choose>
    }
    
    .offer-badge {
        <c:choose>
            <c:when test="${offer.type == 'FLIGHT'}">
                background: var(--flight);
            </c:when>
            <c:when test="${offer.type == 'HOTEL'}">
                background: var(--hotel);
            </c:when>
            <c:otherwise>
                background: var(--tour);
            </c:otherwise>
        </c:choose>
        color: white;
        padding: 8px 20px;
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.9rem;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 20px;
    }
    
    .offer-title {
        font-size: 2.5rem;
        font-weight: 800;
        color: var(--dark);
        margin-bottom: 10px;
    }
    
    .offer-location {
        font-size: 1.2rem;
        color: var(--primary);
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 30px;
    }
    
    /* Informations principales */
    .offer-info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    
    .info-card {
        background: var(--light);
        padding: 20px;
        border-radius: 15px;
        border: 1px solid var(--light-gray);
    }
    
    .info-label {
        font-size: 0.9rem;
        color: var(--gray);
        margin-bottom: 5px;
        display: flex;
        align-items: center;
        gap: 8px;
    }
    
    .info-value {
        font-size: 1.3rem;
        font-weight: 700;
        color: var(--dark);
    }
    
    /* Prix */
    .offer-price {
        background: linear-gradient(135deg, var(--primary), var(--primary-light));
        color: white;
        padding: 30px;
        border-radius: 20px;
        text-align: center;
        margin-bottom: 30px;
    }
    
    .price-label {
        font-size: 1rem;
        opacity: 0.9;
        margin-bottom: 10px;
    }
    
    .price-amount {
        font-size: 3rem;
        font-weight: 800;
        margin-bottom: 20px;
    }
    
    /* Description */
    .offer-description {
        background: white;
        padding: 30px;
        border-radius: 20px;
        margin-bottom: 30px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    }
    
    .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: var(--dark);
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid var(--light-gray);
    }
    
    .description-content {
        color: var(--gray);
        line-height: 1.8;
        font-size: 1.1rem;
    }
    
    .description-content p {
        margin-bottom: 15px;
    }
    
    /* Caractéristiques */
    .offer-features {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-bottom: 30px;
    }
    
    .feature-item {
        background: white;
        padding: 20px;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        display: flex;
        align-items: center;
        gap: 15px;
    }
    
    .feature-icon {
        width: 50px;
        height: 50px;
        background: var(--light);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        color: var(--primary);
    }
    
    /* Actions */
    .offer-actions {
        display: flex;
        gap: 20px;
        margin-top: 40px;
        padding-top: 30px;
        border-top: 1px solid var(--light-gray);
    }
    
    .action-btn {
        flex: 1;
        padding: 18px 30px;
        border-radius: 15px;
        font-weight: 600;
        font-size: 1.1rem;
        text-decoration: none;
        text-align: center;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
    }
    
    .reserve-btn {
        background: var(--secondary);
        color: white;
        border: none;
        cursor: pointer;
    }
    
    .reserve-btn:hover:not(:disabled) {
        background: #0da271;
        transform: translateY(-3px);
        box-shadow: 0 10px 25px rgba(16, 185, 129, 0.3);
    }
    
    .back-btn {
        background: var(--light);
        color: var(--dark);
        border: 2px solid var(--light-gray);
    }
    
    .back-btn:hover {
        background: white;
        border-color: var(--primary);
        transform: translateY(-3px);
    }
    
    /* Disponibilité */
    .availability-badge {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 16px;
        border-radius: 20px;
        font-weight: 600;
        margin-bottom: 20px;
    }
    
    .available {
        background: rgba(16, 185, 129, 0.1);
        color: var(--secondary);
        border: 1px solid var(--secondary);
    }
    
    .unavailable {
        background: rgba(239, 68, 68, 0.1);
        color: #dc2626;
        border: 1px solid #dc2626;
    }
    
    /* Warning Message */
    .warning-message {
        background: rgba(245, 158, 11, 0.1);
        color: #d97706;
        padding: 15px 20px;
        border-radius: 10px;
        border-left: 4px solid #f59e0b;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    /* Icones selon le type d'offre */
    .flight-icon { color: var(--flight); }
    .hotel-icon { color: var(--hotel); }
    .tour-icon { color: var(--tour); }
    
    /* Type d'offre spécifique */
    .offer-type-badge {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        border-radius: 12px;
        font-size: 0.8rem;
        font-weight: 600;
        margin-right: 10px;
    }
    
    .flight-badge { background: rgba(59, 130, 246, 0.1); color: var(--flight); }
    .hotel-badge { background: rgba(16, 185, 129, 0.1); color: var(--hotel); }
    .tour-badge { background: rgba(139, 92, 246, 0.1); color: var(--tour); }
    
    /* Responsive */
    @media (max-width: 768px) {
        .offer-title {
            font-size: 1.8rem;
        }
        
        .offer-actions {
            flex-direction: column;
        }
        
        .action-btn {
            width: 100%;
        }
        
        .price-amount {
            font-size: 2.5rem;
        }
        
        .offer-header {
            padding: 25px;
        }
        
        .offer-info-grid {
            grid-template-columns: 1fr;
        }
    }
</style>
</head>
<body>
<%@include file="Header.jsp" %>

<div class="main-container">
    <section class="offer-section">
        <% if (offer == null) { %>
            <div class="error-message" style="text-align: center; padding: 60px 20px;">
                <i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #dc2626; margin-bottom: 20px;"></i>
                <h2 style="font-size: 1.8rem; color: var(--dark); margin-bottom: 10px;">Offre non trouvée</h2>
                <p style="color: var(--gray); margin-bottom: 30px;">L'offre que vous recherchez n'existe pas ou n'est plus disponible.</p>
                <a href="<%= contextPath %>/destinations" class="action-btn back-btn" style="width: auto; display: inline-flex;">
                    <i class="fas fa-arrow-left"></i> Retour aux destinations
                </a>
            </div>
        <% } else { %>
            <!-- Message d'avertissement -->
            <% if (warningMessage != null) { %>
            <div class="warning-message">
                <i class="fas fa-exclamation-triangle"></i>
                <span><%= warningMessage %></span>
            </div>
            <% } %>
            
            <!-- Badge de disponibilité -->
            <div class="availability-badge <%= isAvailable ? "available" : "unavailable" %>">
                <i class="fas fa-<%= isAvailable ? "check-circle" : "times-circle" %>"></i>
                <span><%= isAvailable ? "Disponible" : "Non disponible" %></span>
            </div>
            
            <!-- Header de l'offre -->
            <div class="offer-header">
                <!-- Badge type d'offre -->
                <div class="offer-badge">
                    <% 
                        String iconClass = "";
                        String typeName = "";
                        if (offer.getType() != null) {
                            switch(offer.getType().toString()) {
                                case "FLIGHT":
                                    iconClass = "fas fa-plane";
                                    typeName = "Vol";
                                    break;
                                case "HOTEL":
                                    iconClass = "fas fa-hotel";
                                    typeName = "Hôtel";
                                    break;
                                case "TOUR":
                                    iconClass = "fas fa-map-marked-alt";
                                    typeName = "Circuit";
                                    break;
                                default:
                                    iconClass = "fas fa-tag";
                                    typeName = offer.getType().toString();
                            }
                        }
                    %>
                    <i class="<%= iconClass %>"></i> <%= typeName %>
                </div>
                
                <h1 class="offer-title"><%= offer.getTitle() %></h1>
                
                <div class="offer-location">
                    <i class="fas fa-map-marker-alt"></i>
                    <span><%= destination != null ? destination.getCity() + ", " + destination.getCountry() : "Destination non spécifiée" %></span>
                </div>
                
                <!-- Informations principales -->
                <div class="offer-info-grid">
                    <div class="info-card">
                        <div class="info-label">
                            <i class="fas fa-calendar-alt"></i> Période
                        </div>
                        <div class="info-value">
                            <% if (offer.getAvailableFrom() != null && offer.getAvailableTo() != null) { %>
                                <%= dateFormat.format(offer.getAvailableFrom()) %> - <%= dateFormat.format(offer.getAvailableTo()) %>
                            <% } else { %>
                                Flexible
                            <% } %>
                        </div>
                    </div>
                    
                    <div class="info-card">
                        <div class="info-label">
                            <i class="fas fa-user-friends"></i> Capacité
                        </div>
                        <div class="info-value">
                            <%= offer.getSeats() > 0 ? offer.getSeats() + " personnes" : "Sur mesure" %>
                        </div>
                    </div>
                    
                    <div class="info-card">
                        <div class="info-label">
                            <i class="fas fa-bed"></i> Chambres
                        </div>
                        <div class="info-value">
                            <%= offer.getRooms() > 0 ? offer.getRooms() + " chambres" : "Non spécifié" %>
                        </div>
                    </div>
                    
                    <% if (availableSeats != null && availableSeats > 0) { %>
                    <div class="info-card">
                        <div class="info-label">
                            <i class="fas fa-chair"></i> Places disponibles
                        </div>
                        <div class="info-value" style="color: var(--secondary);">
                            <%= availableSeats %> places
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Prix -->
            <div class="offer-price">
                <div class="price-label">À partir de</div>
                <div class="price-amount">
                    <% if (offer.getPrice() != null) { %>
                        <%= nf.format(offer.getPrice()) %> DH
                    <% } else { %>
                        Sur demande
                    <% } %>
                </div>
                <div class="price-label">par personne</div>
            </div>
            
            <!-- Description -->
            <% if (offer.getDescription() != null && !offer.getDescription().isEmpty()) { %>
            <div class="offer-description">
                <h2 class="section-title">
                    <i class="fas fa-info-circle"></i> Description de l'offre
                </h2>
                <div class="description-content">
                    <%= offer.getDescription().replace("\n", "<br>") %>
                </div>
            </div>
            <% } %>
            
            <!-- Description de la destination -->
            <% if (destination != null && destination.getDescription() != null && !destination.getDescription().isEmpty()) { %>
            <div class="offer-description">
                <h2 class="section-title">
                    <i class="fas fa-globe-americas"></i> À propos de <%= destination.getCity() %>
                </h2>
                <div class="description-content">
                    <%= destination.getDescription().replace("\n", "<br>") %>
                </div>
            </div>
            <% } %>
            
            <!-- Caractéristiques -->
            <div class="offer-features">
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div>
                        <div style="font-weight: 600; color: var(--dark);">Durée</div>
                        <div style="color: var(--gray);">
                            <% if (destination != null && destination.getDuration() != null) { %>
                                <%= destination.getDuration() + " jours" %>
                            <% } else { %>
                                Flexible
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <% if (destination != null && destination.getCategory() != null && !destination.getCategory().isEmpty()) { %>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-tag"></i>
                    </div>
                    <div>
                        <div style="font-weight: 600; color: var(--dark);">Catégorie</div>
                        <div style="color: var(--gray);">
                            <%= destination.getCategory() %>
                        </div>
                    </div>
                </div>
                <% } %>
                
                <% if (offer.getSeats() > 0) { %>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-users"></i>
                    </div>
                    <div>
                        <div style="font-weight: 600; color: var(--dark);">Groupe</div>
                        <div style="color: var(--gray);">Jusqu'à <%= offer.getSeats() %> personnes</div>
                    </div>
                </div>
                <% } %>
                
                <% if (offer.getRooms() > 0) { %>
                <div class="feature-item">
                    <div class="feature-icon">
                        <i class="fas fa-hotel"></i>
                    </div>
                    <div>
                        <div style="font-weight: 600; color: var(--dark);">Hébergement</div>
                        <div style="color: var(--gray);"><%= offer.getRooms() %> chambres incluses</div>
                    </div>
                </div>
                <% } %>
                
                <% if (offer.getType() != null) { %>
                <div class="feature-item">
                    <div class="feature-icon">
                        <% 
                            String typeIcon = "";
                            switch(offer.getType().toString()) {
                                case "FLIGHT":
                                    typeIcon = "fas fa-plane";
                                    break;
                                case "HOTEL":
                                    typeIcon = "fas fa-hotel";
                                    break;
                                case "TOUR":
                                    typeIcon = "fas fa-map-marked-alt";
                                    break;
                                default:
                                    typeIcon = "fas fa-tag";
                            }
                        %>
                        <i class="<%= typeIcon %>"></i>
                    </div>
                    <div>
                        <div style="font-weight: 600; color: var(--dark);">Type d'offre</div>
                        <div style="color: var(--gray);">
                            <% 
                                String typeDisplay = "";
                                switch(offer.getType().toString()) {
                                    case "FLIGHT":
                                        typeDisplay = "Vol";
                                        break;
                                    case "HOTEL":
                                        typeDisplay = "Hôtel";
                                        break;
                                    case "TOUR":
                                        typeDisplay = "Circuit touristique";
                                        break;
                                    default:
                                        typeDisplay = offer.getType().toString();
                                }
                            %>
                            <%= typeDisplay %>
                        </div>
                    </div>
                </div>
                <% } %>
                
                
            </div>
            
            <!-- Actions -->
            <div class="offer-actions">
                <a href="<%= contextPath %>/destinations" class="action-btn back-btn">
                    <i class="fas fa-arrow-left"></i> Retour aux destinations
                </a>
                
                <% if (isAvailable && offer.isActive()) { %>
                <a href="<%= contextPath %>/reservation?offerId=<%= offer.getId() %>" class="action-btn reserve-btn">
                    <i class="fas fa-calendar-check"></i> Réserver maintenant
                </a>
                <% } else { %>
                <button class="action-btn reserve-btn" style="opacity: 0.6; cursor: not-allowed;" disabled>
                    <i class="fas fa-calendar-times"></i> Indisponible
                </button>
                <% } %>
            </div>
        <% } %>
    </section>
</div>

<%@include file="Footer.jsp" %>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Animation d'entrée
        const elements = document.querySelectorAll('.offer-header, .offer-price, .offer-description, .feature-item');
        elements.forEach((el, index) => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                el.style.opacity = '1';
                el.style.transform = 'translateY(0)';
            }, index * 100);
        });
        
        // Confirmation de réservation
        const reserveBtn = document.querySelector('.reserve-btn:not([disabled])');
        if (reserveBtn) {
            reserveBtn.addEventListener('click', function(e) {
                <% if (availableSeats != null && availableSeats < 5 && availableSeats > 0) { %>
                if (!confirm('Attention: Il ne reste que <%= availableSeats %> place(s) disponible(s). Voulez-vous continuer la réservation ?')) {
                    e.preventDefault();
                }
                <% } %>
            });
        }
        
        // Gestion des sauts de ligne dans la description
        const descriptionContent = document.querySelector('.description-content');
        if (descriptionContent) {
            const text = descriptionContent.innerHTML;
            descriptionContent.innerHTML = text.replace(/\n/g, '<br>');
        }
    });
</script>
</body>
</html>