<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Header - VoyageConnect</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Navigation principale */
        .voyage-nav {
            background: linear-gradient(135deg, #1a56db 0%, #0ea5e9 100%);
            padding: 1rem 0;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            transition: all 0.3s ease;
        }
        
        .voyage-nav.scrolled {
            padding: 0.7rem 0;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
        }
        
        /* Logo */
        .nav-logo {
            color: white;
            font-size: 1.8rem;
            font-weight: 800;
            text-decoration: none;
            display: flex;
            align-items: center;
        }
        
        .nav-logo i {
            color: #fbbf24;
            margin-right: 10px;
            font-size: 2rem;
        }
        
        .voyage-nav.scrolled .nav-logo {
            color: #1e293b;
        }
        
        /* Container principal */
        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        /* Menu */
        .nav-menu {
            display: flex;
            list-style: none;
            margin: 0;
            padding: 0;
            gap: 1rem;
            align-items: center;
        }
        
        .nav-link {
            color: white;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            padding: 0.5rem 0.8rem;
            border-radius: 20px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }
        
        .voyage-nav.scrolled .nav-link {
            color: #1e293b;
        }
        
        .nav-link:hover, .nav-link.active {
            background: rgba(255, 255, 255, 0.15);
            transform: translateY(-2px);
        }
        
        .voyage-nav.scrolled .nav-link:hover, 
        .voyage-nav.scrolled .nav-link.active {
            background: rgba(26, 86, 219, 0.1);
            color: #1a56db;
        }
        
        /* Section utilisateur */
        .user-section {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-left: 10px;
        }
        
        .user-greeting {
            color: white;
            font-weight: 500;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
        }
        
        .voyage-nav.scrolled .user-greeting {
            color: #1e293b;
        }
      .logout-btn {
        background: rgba(239, 68, 68, 0.9);
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 20px;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        text-decoration: none;
        flex-shrink: 0;
        font-weight: 600;
        font-size: 0.85rem;
        gap: 6px;
        height: 40px;
    }

    /* Supprimé la tooltip et ajusté pour texte visible */
    .logout-btn .btn-text {
        display: inline;
    }

    .logout-btn:hover {
        background: #dc2626;
        transform: translateY(-2px);
        box-shadow: 0 4px 10px rgba(220, 38, 38, 0.3);
    }

    .logout-btn i {
        font-size: 1rem;
    }

    /* Style pour le mode scrolled */
    .voyage-nav.scrolled .logout-btn {
        background: rgba(220, 38, 38, 0.9);
    }

    .voyage-nav.scrolled .logout-btn:hover {
        background: #dc2626;
    }

    /* Pour mobile: rendre plus visible */
    @media (max-width: 900px) {
        .logout-btn {
            width: auto;
            justify-content: center;
            padding: 10px 20px;
            margin: 5px 0;
            color: white;
            background: #dc2626;
        }
        
        .voyage-nav.scrolled .logout-btn {
            background: #dc2626;
        }
    }

    @media (max-width: 480px) {
        .logout-btn {
            padding: 8px 15px;
            font-size: 0.8rem;
        }
        
        .logout-btn i {
            font-size: 0.9rem;
        }
    }
        .user-avatar {
            width: 32px;
            height: 32px;
            background: #fbbf24;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1e293b;
            font-weight: bold;
            font-size: 0.85rem;
            flex-shrink: 0;
        }
        
        /* Menu mobile */
        .mobile-toggle {
            display: none;
            background: none;
            border: none;
            color: white;
            font-size: 1.5rem;
            cursor: pointer;
            padding: 5px;
        }
        
        .voyage-nav.scrolled .mobile-toggle {
            color: #1e293b;
        }
        
        /* Boutons Dashboard - NOUVEAU */
        .dashboard-btns {
            display: flex;
            gap: 8px;
            margin-right: 10px;
            flex-shrink: 0;
        }
        
        .dashboard-btn {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            white-space: nowrap;
            flex-shrink: 0;
        }
        
        .voyage-nav.scrolled .dashboard-btn {
            background: rgba(26, 86, 219, 0.1);
            color: #1a56db;
        }
        
        .dashboard-btn:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
        }
        
        .voyage-nav.scrolled .dashboard-btn:hover {
            background: rgba(26, 86, 219, 0.2);
        }
        
        
        
        
        

        
        .dashboard-btn.client {
            background: rgba(16, 185, 129, 0.2);
            color: #a7f3d0;
        }
        
        .voyage-nav.scrolled .dashboard-btn.client {
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
        }
        
        .dashboard-btn.client:hover {
            background: rgba(16, 185, 129, 0.3);
        }
        
        /* Badge Admin - NOUVEAU */
        .admin-badge {
            background: rgba(220, 38, 38, 0.9);
            color: white;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 0.7rem;
            font-weight: 700;
            margin-left: 4px;
            letter-spacing: 0.5px;
        }
        
        .voyage-nav.scrolled .admin-badge {
            background: #dc2626;
        }
        
        /* Menu déroulant Dashboard - NOUVEAU */
        .dashboard-dropdown {
            position: relative;
            display: inline-block;
        }
        
        .dashboard-dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            min-width: 220px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            z-index: 1001;
            padding: 10px 0;
            margin-top: 5px;
        }
        
        .dashboard-dropdown-content.show {
            display: block;
        }
        
        .dashboard-dropdown-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            text-decoration: none;
            color: #1e293b;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .dashboard-dropdown-item:hover {
            background: #f1f5f9;
            color: #1a56db;
        }
        
        .dashboard-dropdown-item i {
            width: 20px;
            text-align: center;
            color: #64748b;
        }
        
        .dashboard-dropdown-item:hover i {
            color: #1a56db;
        }
        
        .dashboard-dropdown-divider {
            height: 1px;
            background: #e5e7eb;
            margin: 8px 0;
        }
        
        /* Styles pour le menu déroulant de connexion */
        .login-dropdown {
            position: relative;
            display: inline-block;
        }
        
        .login-dropdown-content {
            display: none;
            position: absolute;
            top: 100%;
            right: 0;
            background: white;
            min-width: 200px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            border-radius: 12px;
            z-index: 1001;
            padding: 10px 0;
            margin-top: 5px;
        }
        
        .login-dropdown-content.show {
            display: block;
        }
        
        .login-dropdown-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            text-decoration: none;
            color: #1e293b;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .login-dropdown-item:hover {
            background: #f1f5f9;
            color: #1a56db;
        }
        
        .login-dropdown-item i {
            width: 20px;
            text-align: center;
            color: #64748b;
        }
        
        .login-dropdown-item:hover i {
            color: #1a56db;
        }
        
        .login-dropdown-divider {
            height: 1px;
            background: #e5e7eb;
            margin: 8px 0;
        }
        
        /* Bouton de connexion principal */
        .login-main-btn {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            white-space: nowrap;
        }
        
        .login-main-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateY(-2px);
        }
        
        .voyage-nav.scrolled .login-main-btn {
            background: rgba(26, 86, 219, 0.1);
            color: #1a56db;
        }
        
        .voyage-nav.scrolled .login-main-btn:hover {
            background: rgba(26, 86, 219, 0.2);
        }
        
        /* Responsive */
        @media (max-width: 1024px) {
            .nav-container {
                padding: 0 15px;
            }
            
            .nav-menu {
                gap: 0.8rem;
            }
            
            .nav-link {
                font-size: 0.95rem;
                padding: 0.4rem 0.7rem;
            }
            
            .user-greeting {
                font-size: 0.85rem;
            }
            
            .logout-btn {
                padding: 5px 10px;
                font-size: 0.8rem;
            }
            
            .dashboard-btn {
                padding: 5px 10px;
                font-size: 0.8rem;
            }
            
            .login-main-btn {
                padding: 0.4rem 0.8rem;
                font-size: 0.9rem;
            }
        }
        
        @media (max-width: 900px) {
            .nav-menu {
                display: none;
                position: absolute;
                top: 100%;
                left: 0;
                right: 0;
                background: white;
                flex-direction: column;
                padding: 1.5rem;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                border-radius: 0 0 15px 15px;
                gap: 1rem;
                align-items: stretch;
            }
            
            .nav-menu.show {
                display: flex;
            }
            
            .nav-link {
                color: #1e293b;
                padding: 0.8rem 1rem;
                justify-content: flex-start;
                font-size: 1rem;
            }
            
            .user-section {
                flex-direction: column;
                width: 100%;
                margin: 15px 0 0 0;
                padding-top: 15px;
                border-top: 1px solid #e5e7eb;
                align-items: stretch;
                gap: 10px;
            }
            
            .user-greeting {
                color: #1e293b;
                justify-content: center;
            }
            
            .logout-btn {
                width: 100%;
                justify-content: center;
                padding: 10px;
            }
            
            .dashboard-btns {
                flex-direction: column;
                width: 100%;
                margin: 10px 0;
                gap: 10px;
            }
            
            .dashboard-btn {
                width: 100%;
                justify-content: center;
                padding: 10px;
                color: #1e293b;
                background: #f1f5f9;
            }
            
            .dashboard-dropdown-content,
            .login-dropdown-content {
                position: static;
                box-shadow: none;
                background: #f8fafc;
                border-radius: 8px;
                margin-top: 5px;
                display: none;
            }
            
            .dashboard-dropdown-content.show,
            .login-dropdown-content.show {
                display: block;
            }
            
            .login-main-btn {
                width: 100%;
                justify-content: center;
                padding: 10px;
                color: #1e293b;
                background: #f1f5f9;
            }
            
            .mobile-toggle {
                display: block;
            }
            
            .nav-logo span {
                font-size: 1.5rem;
            }
        }
        
        @media (max-width: 480px) {
            .nav-container {
                padding: 0 10px;
            }
            
            .nav-logo span {
                font-size: 1.3rem;
            }
            
            .nav-logo i {
                font-size: 1.5rem;
            }
            
            .logout-btn span {
                display: none;
            }
            
            .logout-btn i {
                margin: 0;
            }
            
            .user-greeting span:first-child {
                display: none;
            }
            
            .dashboard-btn span {
                font-size: 0.8rem;
            }
            
            .dashboard-btn i {
                font-size: 0.9rem;
            }
            
            .login-main-btn span {
                font-size: 0.9rem;
            }
        }
        
        /* Espace pour navbar fixe */
        .nav-space {
            height: 70px;
        }
        
        @media (max-width: 900px) {
            .nav-space {
                height: 65px;
            }
        }
        
        /* Notification de succès */
        .success-notification {
            position: fixed;
            top: 70px;
            left: 0;
            right: 0;
            z-index: 9999;
            animation: slideDown 0.5s ease-out;
        }
        
        @keyframes slideDown {
            from {
                transform: translateY(-100%);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        
        .success-content {
            max-width: 500px;
            margin: 0 auto;
            background: #10b981;
            color: white;
            padding: 12px 16px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(16, 185, 129, 0.3);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .success-content button {
            background: none;
            border: none;
            color: white;
            cursor: pointer;
            font-size: 1rem;
            padding: 0;
            margin-left: 10px;
        }
        
        /* Optimisation pour petits écrans */
        @media (max-width: 600px) {
            .success-content {
                margin: 0 10px;
                padding: 10px 12px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>
    <!-- Notification de succès -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="success-notification">
            <div class="success-content">
                <div style="display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-check-circle"></i>
                    <span>${sessionScope.successMessage}</span>
                </div>
                <button onclick="this.parentElement.parentElement.style.display='none'">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
        <% session.removeAttribute("successMessage"); %>
    </c:if>
    
    <!-- Navigation -->
    <nav class="voyage-nav">
        <div style="max-width: 1200px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center;">
            <!-- Logo -->
            <a href="${pageContext.request.contextPath}/Acceuil.jsp" class="nav-logo">
                <i class="fas fa-plane-departure"></i>
                <span>VoyageConnect</span>
            </a>
            
            <!-- Menu Desktop -->
            <ul class="nav-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/Acceuil.jsp" class="nav-link ${page == 'home' ? 'active' : ''}">
                        <i class="fas fa-home"></i> Acceuil
                    </a>
                </li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/destinations" class="nav-link ${page == 'destinations' ? 'active' : ''}">
                        <i class="fas fa-globe-americas"></i> Destinations
                    </a>
                </li>
                
                <li class="nav-item">
    <a class="nav-link" href="${pageContext.request.contextPath}/mybookings">
        <i class="fas fa-calendar-check"></i> Réservations
    </a>
</li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/paiement" class="nav-link ${page == 'paiement' ? 'active' : ''}">
                        <i class="fas fa-credit-card"></i> Paiement
                    </a>
                </li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/avis" class="nav-link ${page == 'avis' ? 'active' : ''}">
                        <i class="fas fa-star"></i> Avis
                    </a>
                </li>
                
                <!-- Section utilisateur connecté/déconnecté -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- Section utilisateur existante -->
                        <li class="user-info-container">
                            <!-- Bouton Dashboard seulement pour Admin -->
                            
                            
                            <!-- Bouton "Mon Espace" pour tous les utilisateurs connectés -->
                            <a href="${pageContext.request.contextPath}/userdashboard.jsp" class="dashboard-btn client">
                                <i class="fas fa-user-circle"></i>
                                <span>Mon Espace</span>
                            </a>
                            
                            <!-- Avatar utilisateur -->
                            <div class="user-greeting">
                                <div class="user-avatar" title="${sessionScope.firstName} ${sessionScope.lastName}">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.firstName}">
                                            ${sessionScope.firstName.charAt(0)}
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-user"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <span>Bonjour, ${sessionScope.firstName}</span>
                            </div>
                            
                            <!-- Bouton de déconnexion -->
                            <a href="${pageContext.request.contextPath}/LoginServlet?action=logout" 
                               class="logout-btn" 
                               onclick="return confirm('Êtes-vous sûr de vouloir vous déconnecter ?')">
                                <i class="fas fa-sign-out-alt"></i>
                                Déconnexion
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- MODIFICATION: Un seul bouton "Connexion" avec menu déroulant -->
                        <li class="login-dropdown">
                            <a href="#" class="login-main-btn" id="loginDropdownBtn">
                                <i class="fas fa-sign-in-alt"></i>
                                <span>Connexion/Inscription</span>
                                <i class="fas fa-chevron-down" style="font-size: 0.8rem;"></i>
                            </a>
                            <div class="login-dropdown-content" id="loginDropdownContent">
                                <!-- Option 1: Connexion Utilisateur -->
                                <a href="${pageContext.request.contextPath}/LoginServlet" class="login-dropdown-item">
                                    <i class="fas fa-user-circle"></i>
                                    <span>Profil Utilisateur</span>
                                </a>
                                
                                <!-- Séparateur -->
                                <div class="login-dropdown-divider"></div>
                                
                                <!-- Option 2: Connexion Admin -->
                                <a href="${pageContext.request.contextPath}/AdminLoginServlet" class="login-dropdown-item">
                                    <i class="fas fa-user-shield"></i>
                                    <span>Profil Administrateur</span>
                                </a>
                            </div>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
            
            <!-- Menu Mobile Toggle -->
            <button class="mobile-toggle" id="mobileToggle">
                <i class="fas fa-bars"></i>
            </button>
        </div>
    </nav>
    
    <!-- Espace pour navbar fixe -->
    <div class="nav-space"></div>
    
    <script>
        // Toggle menu mobile
        document.getElementById('mobileToggle').addEventListener('click', function() {
            document.querySelector('.nav-menu').classList.toggle('show');
        });
        
        // Effet au scroll
        window.addEventListener('scroll', function() {
            const nav = document.querySelector('.voyage-nav');
            if (window.scrollY > 50) {
                nav.classList.add('scrolled');
            } else {
                nav.classList.remove('scrolled');
            }
        });
        
        // Fermer menu mobile au clic sur un lien
        document.querySelectorAll('.nav-link, .logout-btn, .dashboard-btn').forEach(link => {
            link.addEventListener('click', function() {
                document.querySelector('.nav-menu').classList.remove('show');
            });
        });
        
        // GESTION DU DROPDOWN DE CONNEXION - CORRIGÉ
        const loginDropdownBtn = document.getElementById('loginDropdownBtn');
        const loginDropdownContent = document.getElementById('loginDropdownContent');
        
        if (loginDropdownBtn && loginDropdownContent) {
            // Ouvrir/fermer le dropdown au clic
            loginDropdownBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                loginDropdownContent.classList.toggle('show');
                
                // Fermer les autres dropdowns
                closeAllOtherDropdowns(loginDropdownContent);
            });
            
            // Garder le dropdown ouvert quand on survole
            loginDropdownContent.addEventListener('mouseenter', function() {
                this.classList.add('show');
            });
            
            loginDropdownContent.addEventListener('mouseleave', function() {
                this.classList.remove('show');
            });
            
            // Fermer le dropdown quand on clique sur un lien
            loginDropdownContent.querySelectorAll('.login-dropdown-item').forEach(item => {
                item.addEventListener('click', function() {
                    loginDropdownContent.classList.remove('show');
                    document.querySelector('.nav-menu').classList.remove('show');
                });
            });
        }
        
        // Gestion des dropdowns dashboard
        document.querySelectorAll('.dashboard-dropdown .dashboard-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const dropdown = this.nextElementSibling;
                dropdown.classList.toggle('show');
                
                // Fermer les autres dropdowns
                closeAllOtherDropdowns(dropdown);
            });
        });
        
        // Fonction pour fermer tous les autres dropdowns
        function closeAllOtherDropdowns(currentDropdown) {
            document.querySelectorAll('.dashboard-dropdown-content, .login-dropdown-content').forEach(dropdown => {
                if (dropdown !== currentDropdown) {
                    dropdown.classList.remove('show');
                }
            });
        }
        
        // Fermer tous les dropdowns quand on clique ailleurs sur la page
        document.addEventListener('click', function(event) {
            // Si le clic n'est pas à l'intérieur d'un dropdown ou sur son bouton
            if (!event.target.closest('.login-dropdown') && 
                !event.target.closest('.dashboard-dropdown')) {
                closeAllDropdowns();
            }
        });
        
        function closeAllDropdowns() {
            document.querySelectorAll('.dashboard-dropdown-content, .login-dropdown-content').forEach(dropdown => {
                dropdown.classList.remove('show');
            });
        }
        
        // Surligner la page active
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const links = document.querySelectorAll('.nav-link');
            
            links.forEach(link => {
                if (link.getAttribute('href') === currentPath) {
                    link.classList.add('active');
                }
            });
            
            // Auto-hide notification after 5 seconds
            const notification = document.querySelector('.success-notification');
            if (notification) {
                setTimeout(() => {
                    notification.style.opacity = '0';
                    notification.style.transition = 'opacity 0.5s ease';
                    setTimeout(() => {
                        notification.style.display = 'none';
                    }, 500);
                }, 5000);
            }
        });
        
        // Confirmation avant déconnexion
        document.querySelectorAll('.logout-btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                if (!confirm('Êtes-vous sûr de vouloir vous déconnecter ?')) {
                    e.preventDefault();
                }
            });
        });
        
        // Pour mobile: toggle dropdown au clic
        if (window.innerWidth <= 900) {
            document.querySelectorAll('.login-main-btn, .dashboard-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    if (this.closest('.login-dropdown')) {
                        const dropdown = document.getElementById('loginDropdownContent');
                        if (dropdown) dropdown.classList.toggle('show');
                    } else if (this.closest('.dashboard-dropdown')) {
                        const dropdown = this.nextElementSibling;
                        if (dropdown) dropdown.classList.toggle('show');
                    }
                });
            });
        }
    </script>
</body>
</html>