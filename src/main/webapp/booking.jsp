<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Formulaire de Réservation - VoyageConnect</title>
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
    --gray: #6b7280;
}

body {
    background-color: #f5f7fa;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.container {
    max-width: 900px;
    margin: 40px auto;
    padding: 0 20px;
}

.booking-card {
    background: white;
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    margin-bottom: 40px;
}

.page-title {
    font-size: 2.5rem;
    color: var(--dark);
    margin-bottom: 30px;
    text-align: center;
    font-weight: 700;
}

.offer-summary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    padding: 25px;
    border-radius: 15px;
    margin-bottom: 30px;
    color: white;
}

.offer-title {
    font-size: 1.8rem;
    font-weight: 700;
    margin-bottom: 15px;
}

.offer-details {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
    margin-bottom: 15px;
}

.detail-item {
    display: flex;
    align-items: center;
    gap: 10px;
}

.detail-item i {
    font-size: 1.2rem;
}

.form-section {
    margin-bottom: 35px;
}

.section-title {
    font-size: 1.5rem;
    color: var(--dark);
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 2px solid var(--light);
    font-weight: 600;
}

.form-label {
    font-weight: 600;
    color: var(--dark);
    margin-bottom: 8px;
    display: block;
}

.form-control, .form-select {
    padding: 12px 16px;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 1rem;
    transition: all 0.3s;
}

.form-control:focus, .form-select:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(26, 86, 219, 0.1);
}

.dates-container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
}

.price-summary {
    background: var(--light);
    padding: 25px;
    border-radius: 15px;
    margin-bottom: 30px;
}

.price-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 12px;
    padding-bottom: 12px;
    border-bottom: 1px solid #e5e7eb;
}

.price-total {
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--primary);
}

.form-actions {
    display: flex;
    gap: 15px;
    justify-content: flex-end;
    margin-top: 30px;
}

.btn {
    padding: 14px 28px;
    border-radius: 10px;
    font-weight: 600;
    font-size: 1.1rem;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    transition: all 0.3s;
}

.btn-primary {
    background: var(--secondary);
    border: none;
}

.btn-primary:hover {
    background: #0da271;
    transform: translateY(-2px);
}

.btn-secondary {
    background: var(--light);
    color: var(--dark);
    border: 2px solid #e5e7eb;
}

.btn-secondary:hover {
    background: white;
    border-color: var(--primary);
}

.btn:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

.alert {
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 25px;
    border: none;
}

.alert-danger {
    background: rgba(239, 68, 68, 0.1);
    color: #dc2626;
    border-left: 4px solid #dc2626;
}

.alert-warning {
    background: rgba(245, 158, 11, 0.1);
    color: #d97706;
    border-left: 4px solid #f59e0b;
}

.login-required {
    text-align: center;
    padding: 50px 20px;
}

.login-icon {
    font-size: 5rem;
    color: var(--gray);
    margin-bottom: 20px;
    opacity: 0.6;
}

@media (max-width: 768px) {
    .dates-container {
        grid-template-columns: 1fr;
    }
    
    .form-actions {
        flex-direction: column;
    }
    
    .btn {
        width: 100%;
        justify-content: center;
    }
    
    .container {
        padding: 0 15px;
    }
    
    .booking-card {
        padding: 25px;
    }
    
    .page-title {
        font-size: 2rem;
    }
}
</style>
</head>
<body>
<%@include file="Header.jsp" %>

<div class="container">
    <div class="booking-card">
        <h1 class="page-title">
            <i class="fas fa-calendar-check"></i> Formulaire de Réservation
        </h1>
        
        <%-- Messages d'erreur --%>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i> ${errorMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty warningMessage}">
            <div class="alert alert-warning">
                <i class="fas fa-exclamation-triangle"></i> ${warningMessage}
            </div>
        </c:if>
        
        <%-- Vérifier si l'offre existe --%>
        <c:choose>
            <c:when test="${empty offer}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i> Offre non trouvée
                </div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/destinations" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour aux destinations
                    </a>
                </div>
            </c:when>
            
            <c:otherwise>
                <%-- Vérifier si connecté --%>
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <div class="login-required">
                            <div class="login-icon">
                                <i class="fas fa-user-lock"></i>
                            </div>
                            <h2 style="color: var(--dark); margin-bottom: 15px;">Connexion requise</h2>
                            <p style="color: var(--gray); margin-bottom: 25px; font-size: 1.1rem;">
                                Vous devez être connecté pour effectuer une réservation.
                            </p>
                            <a href="${pageContext.request.contextPath}/Login.jsp?redirect=${pageContext.request.requestURI}?offerId=${offer.id}" 
                               class="btn btn-primary">
                                <i class="fas fa-sign-in-alt"></i> Se connecter
                            </a>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <!-- Résumé de l'offre -->
                        <div class="offer-summary">
                            <h2 class="offer-title">${offer.title}</h2>
                            <div class="offer-details">
                                <c:if test="${not empty offer.destination}">
                                    <div class="detail-item">
                                        <i class="fas fa-map-marker-alt"></i>
                                        <span>${offer.destination.city}, ${offer.destination.country}</span>
                                    </div>
                                    <c:if test="${not empty offer.destination.category}">
                                    <div class="detail-item">
                                        <i class="fas fa-tag"></i>
                                        <span>${offer.destination.category}</span>
                                    </div>
                                    </c:if>
                                </c:if>
                                <div class="detail-item">
                                    <i class="fas fa-users"></i>
                                    <span>Places disponibles: ${offer.seats}</span>
                                </div>
                            </div>
                            <div class="detail-item">
                                <i class="fas fa-money-bill-wave"></i>
                                <span>Prix par personne: <fmt:formatNumber value="${offer.price}" pattern="#,##0.00 DH" /></span>
                            </div>
                        </div>
                        
                        <!-- Formulaire de réservation -->
<form action="${pageContext.request.contextPath}/reservation" method="post" id="bookingForm">
    <input type="hidden" name="offerId" value="${offer.id}">
    
    <!-- Section : Dates -->
    <div class="form-section">
        <h3 class="section-title">
            <i class="fas fa-calendar-alt"></i> Sélection des dates
        </h3>
        <div class="dates-container">
            <div class="mb-3">
                <label class="form-label">
                    <i class="fas fa-calendar-day"></i> Date de début
                </label>
                <input type="date" 
                       name="startDate" 
                       class="form-control"
                       id="startDate"
                       value="${defaultStartDateStr}"
                       min="${minStartDateStr}"
                       <c:if test="${not empty maxEndDateStr}">
                       max="${maxEndDateStr}"
                       </c:if>
                       required>
                <div class="form-text">
                    Sélectionnez la date de début de votre séjour
                    <c:if test="${not empty maxEndDateStr}">
                    (jusqu'au <fmt:formatDate value="${maxEndDate}" pattern="dd/MM/yyyy" />)
                    </c:if>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">
                    <i class="fas fa-calendar-check"></i> Date de fin
                </label>
                <input type="date" 
                       name="endDate" 
                       class="form-control"
                       id="endDate"
                       value="${defaultEndDateStr}"
                       min="${minStartDateStr}"
                       <c:if test="${not empty maxEndDateStr}">
                       max="${maxEndDateStr}"
                       </c:if>
                       required>
                <div class="form-text">
                    Sélectionnez la date de fin de votre séjour
                    <c:if test="${not empty maxEndDateStr}">
                    (jusqu'au <fmt:formatDate value="${maxEndDate}" pattern="dd/MM/yyyy" />)
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Section : Participants -->
    <div class="form-section">
        <h3 class="section-title">
            <i class="fas fa-users"></i> Participants
        </h3>
        <div class="mb-3" style="max-width: 300px;">
            <label class="form-label">
                <i class="fas fa-user-friends"></i> Nombre de personnes
            </label>
            <select name="quantity" class="form-select" id="quantitySelect" required>
                <c:forEach var="i" begin="1" end="${offer.seats > 10 ? 10 : offer.seats}">
                    <option value="${i}" ${i == 1 ? 'selected' : ''}>
                        ${i} personne${i > 1 ? 's' : ''}
                    </option>
                </c:forEach>
            </select>
            <div class="form-text">Maximum ${offer.seats > 10 ? 10 : offer.seats} personnes par réservation</div>
        </div>
    </div>
    
    <!-- Section : Récapitulatif du prix -->
    <div class="form-section">
        <h3 class="section-title">
            <i class="fas fa-calculator"></i> Récapitulatif du prix
        </h3>
        <div class="price-summary">
            <div class="price-row">
                <span>Prix par personne:</span>
                <span id="pricePerPerson"><fmt:formatNumber value="${offer.price}" pattern="#,##0.00 DH" /></span>
            </div>
            <div class="price-row">
                <span>Nombre de personnes:</span>
                <span id="quantityDisplay">1</span>
            </div>
            <div class="price-row">
                <span>Nombre de jours:</span>
                <span id="daysDisplay">1</span>
            </div>
            <div class="price-row" style="border-bottom: none; padding-bottom: 0;">
                <span style="font-weight: 700; font-size: 1.2rem;">Total:</span>
                <span id="totalAmount" class="price-total"><fmt:formatNumber value="${offer.price}" pattern="#,##0.00 DH" /></span>
            </div>
        </div>
    </div>
    
    <!-- Section : Informations du client -->
    <div class="form-section">
        <h3 class="section-title">
            <i class="fas fa-user-circle"></i> Vos informations
        </h3>
        <div class="row">
            <div class="col-md-6 mb-3">
                <label class="form-label">Nom complet</label>
                <input type="text" class="form-control" 
                       value="${sessionScope.user.firstName} ${sessionScope.user.lastName}" 
                       readonly>
            </div>
            <div class="col-md-6 mb-3">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" 
                       value="${sessionScope.user.email}" 
                       readonly>
            </div>
        </div>
        <div class="alert alert-info">
            <i class="fas fa-info-circle"></i> 
            Ces informations sont basées sur votre profil. Pour les modifier, veuillez mettre à jour votre profil.
        </div>
    </div>
    
    <!-- Actions -->
    <div class="form-actions">
        <a href="${pageContext.request.contextPath}/OfferServlet?id=${offer.id}" 
           class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Retour à l'offre
        </a>
        <button type="submit" class="btn btn-primary" 
                id="submitBtn"
                ${hasBooked ? 'disabled' : ''}>
            <i class="fas fa-check-circle"></i> 
            ${hasBooked ? 'Déjà réservé' : 'Confirmer la réservation'}
        </button>
    </div>
</form>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@include file="Footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Récupérer les données depuis les attributs
    const pricePerPerson = ${offer.price};
    const maxSeats = ${offer.seats};
    
    const quantitySelect = document.getElementById('quantitySelect');
    const startDateInput = document.getElementById('startDate');
    const endDateInput = document.getElementById('endDate');
    const quantityDisplay = document.getElementById('quantityDisplay');
    const daysDisplay = document.getElementById('daysDisplay');
    const totalAmount = document.getElementById('totalAmount');
    const submitBtn = document.getElementById('submitBtn');
    
    // Formater un nombre avec séparateurs
    function formatNumber(num) {
        return num.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');
    }
    
    // Calculer le prix
    function calculatePrice() {
        if (!quantitySelect || !startDateInput || !endDateInput) return;
        
        const quantity = parseInt(quantitySelect.value);
        const startDate = new Date(startDateInput.value);
        const endDate = new Date(endDateInput.value);
        
        // Vérifier si les dates sont valides
        if (!startDateInput.value || !endDateInput.value) {
            daysDisplay.textContent = '1';
            const total = pricePerPerson * quantity;
            totalAmount.textContent = formatNumber(total) + ' DH';
            return;
        }
        
        // Calculer le nombre de jours
        const timeDiff = endDate.getTime() - startDate.getTime();
        const days = Math.max(1, Math.ceil(timeDiff / (1000 * 3600 * 24)) + 1);
        
        // Calculer le total
        const total = pricePerPerson * quantity * days;
        
        // Mettre à jour l'affichage
        quantityDisplay.textContent = quantity;
        daysDisplay.textContent = days;
        totalAmount.textContent = formatNumber(total) + ' DH';
    }
    
    // Valider les dates
    function validateDates() {
        if (!startDateInput.value || !endDateInput.value) return true;
        
        const startDate = new Date(startDateInput.value);
        const endDate = new Date(endDateInput.value);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        startDate.setHours(0, 0, 0, 0);
        
        if (startDate < today) {
            alert('La date de début ne peut pas être dans le passé.');
            return false;
        }
        
        if (endDate <= startDate) {
            alert('La date de fin doit être après la date de début.');
            return false;
        }
        
        return true;
    }
    
    // Valider le nombre de personnes
    function validateQuantity() {
        const quantity = parseInt(quantitySelect.value);
        
        if (quantity > maxSeats) {
            alert('Le nombre de personnes ne peut pas dépasser ' + maxSeats + ' places disponibles.');
            return false;
        }
        
        if (quantity < 1) {
            alert('Le nombre de personnes doit être d\'au moins 1.');
            return false;
        }
        
        return true;
    }
    
    // Écouter les changements
    if (quantitySelect && startDateInput && endDateInput) {
        quantitySelect.addEventListener('change', function() {
            calculatePrice();
        });
        
        startDateInput.addEventListener('change', function() {
            if (startDateInput.value && endDateInput.value) {
                const start = new Date(startDateInput.value);
                const end = new Date(endDateInput.value);
                if (end < start) {
                    endDateInput.value = startDateInput.value;
                }
            }
            calculatePrice();
        });
        
        endDateInput.addEventListener('change', function() {
            if (startDateInput.value && endDateInput.value) {
                const start = new Date(startDateInput.value);
                const end = new Date(endDateInput.value);
                if (end < start) {
                    alert('La date de fin doit être après la date de début.');
                    endDateInput.value = startDateInput.value;
                }
            }
            calculatePrice();
        });
        
        // Calcul initial
        calculatePrice();
    }
    
    // Validation du formulaire
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        bookingForm.addEventListener('submit', function(e) {
            if (submitBtn.disabled) {
                e.preventDefault();
                return;
            }
            
            if (!validateDates() || !validateQuantity()) {
                e.preventDefault();
                return;
            }
            
            // Afficher un message de confirmation
            if (!confirm('Confirmez-vous cette réservation ?')) {
                e.preventDefault();
                return;
            }
            
            // Désactiver le bouton pour éviter les doubles clics
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Traitement en cours...';
        });
    }
    
    // Définir la date minimale pour aujourd'hui
    const today = new Date();
    const todayFormatted = today.toISOString().split('T')[0];
    if (startDateInput) {
        startDateInput.min = todayFormatted;
        if (startDateInput.value < todayFormatted) {
            startDateInput.value = todayFormatted;
        }
    }
    
    if (endDateInput) {
        endDateInput.min = todayFormatted;
        if (endDateInput.value < todayFormatted) {
            endDateInput.value = todayFormatted;
        }
    }
});
</script>
</body>
</html>