<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    org.eclipse.model.User user = (org.eclipse.model.User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Espace Client - VoyageConnect</title>
    
    <jsp:include page="/Header.jsp">
        <jsp:param name="pageTitle" value="Mon Espace"/>
    </jsp:include>
    
    <style>
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        .profile-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .reservation-card {
            border-left: 4px solid #3498db;
            transition: all 0.3s;
        }
        .reservation-card:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .nav-pills .nav-link {
            border-radius: 10px;
            margin-bottom: 10px;
        }
        .nav-pills .nav-link.active {
            background: linear-gradient(45deg, #3498db, #2c3e50);
        }
    </style>
</head>
<body>
    <jsp:include page="/Header.jsp"/>
    
    <div class="container py-5">
        <!-- En-tête -->
        <div class="welcome-card">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-5 fw-bold">
                        Bonjour, <%= user.getFirstName() %> !
                    </h1>
                    <p class="lead">Bienvenue dans votre espace personnel VoyageConnect</p>
                    <p class="mb-0">
                        <i class="fas fa-envelope me-2"></i><%= user.getEmail() %> 
                        <span class="mx-3">|</span>
                        <i class="fas fa-phone me-2"></i><%= user.getPhone() != null ? user.getPhone() : "Non renseigné" %>
                    </p>
                </div>
                <div class="col-md-4 text-center">
                    <div class="bg-white rounded-circle d-inline-flex align-items-center justify-content-center" 
                         style="width: 120px; height: 120px;">
                        <i class="fas fa-user-circle fa-5x text-primary"></i>
                    </div>
                    <div class="mt-3">
                        <span class="badge bg-info fs-6">CLIENT</span>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-4">
            <!-- Sidebar -->
            <div class="col-md-3">
                <div class="card profile-card mb-4">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <div class="mb-3">
                                <i class="fas fa-user-circle fa-5x text-secondary"></i>
                            </div>
                            <h5><%= user.getFullName() %></h5>
                            <p class="text-muted">Membre depuis <%= user.getCreatedAt() %></p>
                        </div>
                        
                        <ul class="nav nav-pills flex-column">
                            <li class="nav-item">
                                <a class="nav-link active" href="${pageContext.request.contextPath}/userdashboard.jsp">
                                    <i class="fas fa-tachometer-alt me-2"></i> Tableau de bord
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/reservations.jsp">
                                    <i class="fas fa-calendar-alt me-2"></i> Mes réservations
                                    <span class="badge bg-primary float-end">3</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/client/profile.jsp">
                                    <i class="fas fa-user-edit me-2"></i> Mon profil
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/client/favorites.jsp">
                                    <i class="fas fa-heart me-2"></i> Favoris
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/client/avis.jsp">
                                    <i class="fas fa-star me-2"></i> Mes avis
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/client/settings.jsp">
                                    <i class="fas fa-cog me-2"></i> Paramètres
                                </a>
                            </li>
                            <li class="nav-item mt-4">
                                <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                                    <i class="fas fa-sign-out-alt me-2"></i> Déconnexion
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
   
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/reservations/nouvelle" 
                                   class="btn btn-primary w-100 h-100 py-3">
                                    <i class="fas fa-plus-circle fa-2x mb-2"></i>
                                    <br>
                                    Nouvelle réservation
                                </a>
                            </div>
                            
                            </div>
                            
                            <div class="col-md-3 mb-3">
                                <a href="${pageContext.request.contextPath}/client/avis.jsp" 
                                   class="btn btn-outline-warning w-100 h-100 py-3">
                                    <i class="fas fa-star fa-2x mb-2"></i>
                                    <br>
                                    Donner un avis
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Dernières réservations -->
                <div class="card">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-history text-primary me-2"></i>
                            Mes dernières réservations
                        
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/Header.jsp"/>
    
    <script>
        // Scripts spécifiques au dashboard client
        document.addEventListener('DOMContentLoaded', function() {
            // Mettre à jour l'heure locale
            function updateTime() {
                const now = new Date();
                document.getElementById('current-time').textContent = 
                    now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit' });
            }
            setInterval(updateTime, 60000);
            updateTime();
            
            // Animation pour les cartes de réservation
            document.querySelectorAll('.reservation-card').forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.cursor = 'pointer';
                });
            });
        });
    </script>
</body>
</html>