<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Confirmation de Réservation - VoyageConnect</title>
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
    padding-top: 80px;
}

.container {
    max-width: 900px;
    margin: 0 auto;
    padding: 20px;
}

.success-container {
    background: white;
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    text-align: center;
    margin-bottom: 30px;
}

.success-icon {
    font-size: 5rem;
    color: var(--secondary);
    margin-bottom: 20px;
    animation: scaleIn 0.5s ease-out;
}

@keyframes scaleIn {
    from {
        transform: scale(0);
        opacity: 0;
    }
    to {
        transform: scale(1);
        opacity: 1;
    }
}

.success-title {
    font-size: 2rem;
    color: var(--dark);
    font-weight: 700;
    margin-bottom: 10px;
}

.success-message {
    color: #6b7280;
    font-size: 1.1rem;
    margin-bottom: 30px;
}

.booking-details {
    background: var(--light);
    border-radius: 15px;
    padding: 30px;
    margin-bottom: 30px;
    text-align: left;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    padding: 15px 0;
    border-bottom: 1px solid #e5e7eb;
}

.detail-row:last-child {
    border-bottom: none;
}

.detail-label {
    font-weight: 600;
    color: var(--dark);
}

.detail-value {
    color: #6b7280;
}

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

.action-buttons {
    display: flex;
    gap: 15px;
    justify-content: center;
    flex-wrap: wrap;
}

.btn-action {
    padding: 12px 24px;
    border-radius: 10px;
    font-weight: 600;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    transition: all 0.3s;
}

.btn-primary-action {
    background: var(--primary);
    color: white;
    border: none;
}

.btn-primary-action:hover {
    background: #3b82f6;
    transform: translateY(-2px);
    color: white;
    text-decoration: none;
}

.btn-secondary-action {
    background: white;
    color: var(--primary);
    border: 2px solid var(--primary);
}

.btn-secondary-action:hover {
    background: var(--primary);
    color: white;
    text-decoration: none;
}

@media (max-width: 768px) {
    .success-container {
        padding: 30px 20px;
    }
    
    .success-title {
        font-size: 1.5rem;
    }
    
    .action-buttons {
        flex-direction: column;
    }
    
    .btn-action {
        width: 100%;
        justify-content: center;
    }
}
</style>
</head>
<body>
<%@include file="Header.jsp" %>

<div class="container">
    <div class="success-container">
        <div class="success-icon">
            <i class="fas fa-check-circle"></i>
        </div>
        <h1 class="success-title">Réservation Confirmée !</h1>
        <p class="success-message">
            Votre réservation a été enregistrée avec succès. Vous recevrez un email de confirmation sous peu.
        </p>
        
        <div class="booking-details">
            <h3 style="margin-bottom: 20px; color: var(--dark);">
                <i class="fas fa-info-circle"></i> Détails de votre réservation
            </h3>
            
            <div class="detail-row">
                <span class="detail-label">N° de Réservation:</span>
                <span class="detail-value"><strong>#${booking.id}</strong></span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Destination:</span>
                <span class="detail-value">
                    <c:choose>
                        <c:when test="${not empty booking.offer and not empty booking.offer.destination}">
                            ${booking.offer.destination.city}, ${booking.offer.destination.country}
                        </c:when>
                        <c:otherwise>
                            ${booking.offer.title}
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Offre:</span>
                <span class="detail-value">${booking.offer.title}</span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Dates:</span>
                <span class="detail-value">
                    Du <fmt:formatDate value="${booking.startDate}" pattern="dd/MM/yyyy" /> 
                    au <fmt:formatDate value="${booking.endDate}" pattern="dd/MM/yyyy" />
                </span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Nombre de personnes:</span>
                <span class="detail-value">${booking.quantity}</span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Montant total:</span>
                <span class="detail-value" style="font-weight: 700; color: var(--primary); font-size: 1.1rem;">
                    <fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00 DH" />
                </span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Statut:</span>
                <span class="detail-value">
                    <c:set var="statusStr" value="${booking.status.toString()}" />
                    <c:choose>
                        <c:when test="${statusStr == 'PENDING'}">
                            <span class="status-badge status-pending">En attente</span>
                        </c:when>
                        <c:when test="${statusStr == 'CONFIRMED'}">
                            <span class="status-badge status-confirmed">Confirmée</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge">${statusStr}</span>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
            
            <div class="detail-row">
                <span class="detail-label">Date de réservation:</span>
                <span class="detail-value">
                    <fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy à HH:mm" />
                </span>
            </div>
        </div>
        
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/mybookings" class="btn-action btn-primary-action">
                <i class="fas fa-calendar-check"></i> Voir mes réservations
            </a>
            <a href="${pageContext.request.contextPath}/destinations" class="btn-action btn-secondary-action">
                <i class="fas fa-globe-americas"></i> Explorer d'autres destinations
            </a>
        </div>
    </div>
</div>

<%@include file="Footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>