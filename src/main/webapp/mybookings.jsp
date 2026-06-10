<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Mes Réservations - VoyageConnect</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
:root {
    --primary: #1a56db;
    --secondary: #10b981;
    --warning: #f59e0b;
    --danger: #dc2626;
    --dark: #1f2937;
    --light: #f8fafc;
}

body {
    background-color: #f5f7fa;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    /* Ajout d'un padding-top pour compenser le header fixe */
    padding-top: 80px;
}

/* Si vous avez un header fixe dans votre Header.jsp, ajoutez ces styles */
header.fixed-top {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1030;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    /* Plus de marge en haut car body a déjà un padding-top */
}

.page-header {
    margin-bottom: 40px;
    text-align: center;
    /* Assurance supplémentaire pour que le titre soit bien visible */
    padding-top: 20px;
}

.page-title {
    font-size: 2.5rem;
    color: var(--dark);
    font-weight: 700;
    margin-bottom: 10px;
}

.page-subtitle {
    color: #6b7280;
    font-size: 1.1rem;
}

/* État vide */
.empty-state {
    text-align: center;
    padding: 60px 20px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    margin-bottom: 40px;
}

.empty-icon {
    font-size: 5rem;
    color: #d1d5db;
    margin-bottom: 20px;
    opacity: 0.5;
}

/* Tableau des réservations */
.bookings-table-container {
    background: white;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    margin-bottom: 40px;
}

.bookings-table {
    width: 100%;
    border-collapse: collapse;
}

.bookings-table thead {
    background: var(--light);
}

.bookings-table th {
    padding: 20px;
    text-align: left;
    font-weight: 600;
    color: var(--dark);
    border-bottom: 2px solid #e5e7eb;
}

.bookings-table td {
    padding: 20px;
    border-bottom: 1px solid #e5e7eb;
    vertical-align: middle;
}

.bookings-table tbody tr:hover {
    background: #f8fafc;
}

/* Badge de statut */
.status-badge {
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.9rem;
    font-weight: 600;
    display: inline-block;
}

.status-pending {
    background: rgba(245, 158, 11, 0.1);
    color: var(--warning);
}

.status-confirmed {
    background: rgba(16, 185, 129, 0.1);
    color: var(--secondary);
}

.status-cancelled {
    background: rgba(220, 38, 38, 0.1);
    color: var(--danger);
}

/* Actions */
.booking-actions {
    display: flex;
    gap: 10px;
}

.btn-action {
    padding: 8px 16px;
    border-radius: 8px;
    font-weight: 600;
    font-size: 0.9rem;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    transition: all 0.3s;
}

.btn-view {
    background: var(--primary);
    color: white;
    border: none;
}

.btn-view:hover {
    background: #3b82f6;
    transform: translateY(-2px);
}

.btn-cancel {
    background: white;
    color: var(--danger);
    border: 2px solid var(--danger);
}

.btn-cancel:hover {
    background: var(--danger);
    color: white;
}

.btn-disabled {
    background: #e5e7eb;
    color: #9ca3af;
    cursor: not-allowed;
    border: none;
}

/* Statistiques */
.stats-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
    margin-bottom: 40px;
}

.stat-card {
    background: white;
    padding: 25px;
    border-radius: 15px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    text-align: center;
}

.stat-icon {
    font-size: 2.5rem;
    margin-bottom: 15px;
}

.stat-icon.total {
    color: var(--primary);
}

.stat-icon.pending {
    color: var(--warning);
}

.stat-icon.confirmed {
    color: var(--secondary);
}

.stat-number {
    font-size: 2rem;
    font-weight: 700;
    color: var(--dark);
    margin-bottom: 5px;
}

.stat-label {
    color: #6b7280;
    font-size: 0.9rem;
}

/* Bouton retour */
.back-to-destinations {
    text-align: center;
    margin-top: 30px;
}

.back-link {
    color: var(--primary);
    text-decoration: none;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 24px;
    border: 2px solid var(--primary);
    border-radius: 10px;
    transition: all 0.3s;
}

.back-link:hover {
    background: var(--primary);
    color: white;
    text-decoration: none;
}

/* Responsive */
@media (max-width: 768px) {
    body {
        padding-top: 70px; /* Moins de padding sur mobile si le header est plus petit */
    }
    
    .container {
        padding: 15px;
    }
    
    .page-title {
        font-size: 2rem;
    }
    
    .bookings-table-container {
        overflow-x: auto;
    }
    
    .bookings-table {
        min-width: 800px;
    }
    
    .booking-actions {
        flex-direction: column;
    }
    
    .stats-container {
        grid-template-columns: 1fr;
    }
    
    .btn-action {
        width: 100%;
        justify-content: center;
    }
}

/* Correction supplémentaire pour s'assurer que le contenu ne soit pas caché */
.main-content {
    position: relative;
    z-index: 1;
}
</style>
</head>
<body>
<%@include file="Header.jsp" %>

<div class="container main-content">
    <!-- En-tête de page -->
    <div class="page-header">
        <h1 class="page-title">
            <i class="fas fa-calendar-check"></i> Mes Réservations
        </h1>
        <p class="page-subtitle">
            Consultez l'historique et le statut de toutes vos réservations
        </p>
    </div>
    
    <!-- Statistiques -->
    <div class="stats-container">
        <div class="stat-card">
            <div class="stat-icon total">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <div class="stat-number">${bookings.size()}</div>
            <div class="stat-label">Réservations totales</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon pending">
                <i class="fas fa-clock"></i>
            </div>
            <div class="stat-number">
                <c:set var="pendingCount" value="0" />
                <c:forEach var="booking" items="${bookings}">
                    <c:set var="statusStr" value="${booking.status.toString()}" />
                    <c:if test="${statusStr == 'PENDING'}">
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:if>
                </c:forEach>
                ${pendingCount}
            </div>
            <div class="stat-label">En attente</div>
        </div>
        
        <div class="stat-card">
            <div class="stat-icon confirmed">
                <i class="fas fa-check-circle"></i>
            </div>
            <div class="stat-number">
                <c:set var="confirmedCount" value="0" />
                <c:forEach var="booking" items="${bookings}">
                    <c:set var="statusStr" value="${booking.status.toString()}" />
                    <c:if test="${statusStr == 'CONFIRMED'}">
                        <c:set var="confirmedCount" value="${confirmedCount + 1}" />
                    </c:if>
                </c:forEach>
                ${confirmedCount}
            </div>
            <div class="stat-label">Confirmées</div>
        </div>
    </div>
    
    <c:choose>
        <c:when test="${empty bookings}">
            <!-- État vide - aucune réservation -->
            <div class="empty-state">
                <div class="empty-icon">
                    <i class="fas fa-calendar-times"></i>
                </div>
                <h2 style="color: var(--dark); margin-bottom: 15px;">Aucune réservation</h2>
                <p style="color: #6b7280; margin-bottom: 25px; max-width: 500px; margin-left: auto; margin-right: auto;">
                    Vous n'avez pas encore effectué de réservation. 
                    Parcourez nos destinations et réservez votre prochain voyage !
                </p>
                <a href="${pageContext.request.contextPath}/destinations" class="btn-action btn-view">
                    <i class="fas fa-globe-americas"></i> Explorer les destinations
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <!-- Tableau des réservations -->
            <div class="bookings-table-container">
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th>N° Réservation</th>
                            <th>Destination</th>
                            <th>Dates</th>
                            <th>Personnes</th>
                            <th>Montant</th>
                            <th>Statut</th>
                            <th>Date réservation</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>
                                    <strong>#${booking.id}</strong>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty booking.offer and not empty booking.offer.destination}">
                                            ${booking.offer.destination.city}, ${booking.offer.destination.country}
                                            <div style="font-size: 0.9rem; color: #6b7280; margin-top: 5px;">
                                                ${booking.offer.title}
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            ${booking.offer.title}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${booking.startDate}" pattern="dd/MM/yyyy" /> 
                                    <br>au 
                                    <fmt:formatDate value="${booking.endDate}" pattern="dd/MM/yyyy" />
                                    <c:set var="start" value="${booking.startDate.time}" />
                                    <c:set var="end" value="${booking.endDate.time}" />
                                    <c:set var="days" value="${(end - start) / (1000 * 60 * 60 * 24) + 1}" />
                                    <div style="font-size: 0.9rem; color: #6b7280; margin-top: 5px;">
                                        <fmt:formatNumber value="${days}" maxFractionDigits="0" /> jour(s)
                                    </div>
                                </td>
                                <td>
                                    ${booking.quantity} pers.
                                </td>
                                <td>
                                    <strong style="color: var(--primary);">
                                        <fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00 DH" />
                                    </strong>
                                </td>
                                <td>
                                    <c:set var="statusStr" value="${booking.status.toString()}" />
                                    <c:choose>
                                        <c:when test="${statusStr == 'PENDING'}">
                                            <span class="status-badge status-pending">En attente</span>
                                        </c:when>
                                        <c:when test="${statusStr == 'CONFIRMED'}">
                                            <span class="status-badge status-confirmed">Confirmée</span>
                                        </c:when>
                                        <c:when test="${statusStr == 'CANCELLED'}">
                                            <span class="status-badge status-cancelled">Annulée</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge">${statusStr}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy" />
                                </td>
                                <td>
                                    <div class="booking-actions">
                                        <a href="${pageContext.request.contextPath}/bookingconfirmation?id=${booking.id}" 
                                           class="btn-action btn-view"
                                           title="Voir les détails">
                                            <i class="fas fa-eye"></i> Détails
                                        </a>
                                        
                                        <c:if test="${booking.status != 'CANCELLED'}">
                                            <form action="${pageContext.request.contextPath}/cancelbooking" 
                                                  method="post"
                                                  style="display: inline;"
                                                  onsubmit="return confirm('Êtes-vous sûr de vouloir annuler la réservation #${booking.id} ?');">
                                                <input type="hidden" name="bookingId" value="${booking.id}">
                                                <button type="submit" class="btn-action btn-cancel">
                                                    <i class="fas fa-times"></i> Annuler
                                                </button>
                                            </form>
                                        </c:if>
                                        
                                        <c:if test="${booking.status == 'CANCELLED'}">
                                            <button class="btn-action btn-disabled" disabled>
                                                <i class="fas fa-ban"></i> Annulée
                                            </button>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
    
    <!-- Bouton retour -->
    <div class="back-to-destinations">
        <a href="${pageContext.request.contextPath}/destinations" class="back-link">
            <i class="fas fa-arrow-left"></i> Retour aux destinations
        </a>
    </div>
</div>

<%@include file="Footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Confirmation pour l'annulation
    document.querySelectorAll('form[onsubmit]').forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!confirm(this.getAttribute('onsubmit').replace("return confirm('", "").replace("');", ""))) {
                e.preventDefault();
            }
        });
    });
    
    // Si le header est fixe, ajuster le padding si nécessaire
    const header = document.querySelector('header');
    if (header && window.getComputedStyle(header).position === 'fixed') {
        const headerHeight = header.offsetHeight;
        document.body.style.paddingTop = headerHeight + 'px';
    }
    
    // Debug: Vérifier les données reçues
    <c:if test="${not empty bookings}">
        console.log("[MyBookings] Debug - Nombre de réservations reçues:", ${fn:length(bookings)});
        <c:forEach var="booking" items="${bookings}" varStatus="status">
            console.log("[MyBookings] Réservation ${status.index + 1}: ID=${booking.id}, Statut=${booking.status}, User ID=${booking.user.id}");
        </c:forEach>
    </c:if>
    <c:if test="${empty bookings}">
        console.log("[MyBookings] Debug - Aucune réservation reçue");
    </c:if>
});
</script>
</body>
</html>