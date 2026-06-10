<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.util.*" %>
<%@ page import="org.eclipse.model.*" %>
<%@ page import="org.eclipse.dao.*" %>

<c:choose>
    <c:when test="${not empty sessionScope.user and sessionScope.user.role == 'ADMIN'}">
        <!-- Your admin content here -->
    </c:when>
    </c:choose>
    
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Dashboard Admin - VoyageConnect</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/chart.js">
            <style>
                /* Variables de couleurs */
                :root {
                    --admin-red: #dc2626;
                    --admin-red-dark: #b91c1c;
                    --admin-red-light: #fef2f2;
                    --primary-blue: #1a56db;
                    --secondary-blue: #0ea5e9;
                    --success-green: #10b981;
                    --warning-yellow: #f59e0b;
                    --info-cyan: #06b6d4;
                    --background-light: #f5f7fa;
                    --card-white: #ffffff;
                    --text-dark: #1e293b;
                    --text-muted: #64748b;
                    --border-light: #e5e7eb;
                    --sidebar-width: 260px;
                    --header-height: 70px;
                    --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
                    --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                    --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
                }
                
                /* Reset et styles de base */
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: var(--background-light);
                    color: var(--text-dark);
                    overflow-x: hidden;
                    min-height: 100vh;
                }
                
                /* Layout principal */
                .admin-dashboard {
                    display: flex;
                    min-height: 100vh;
                }
                
                /* Sidebar */
                .admin-sidebar {
                    width: var(--sidebar-width);
                    background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
                    color: white;
                    position: fixed;
                    height: 100vh;
                    overflow-y: auto;
                    transition: all 0.3s ease;
                    z-index: 100;
                }
                
                .sidebar-header {
                    padding: 25px 20px;
                    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                    text-align: center;
                }
                
                .admin-logo {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 10px;
                    font-size: 1.5rem;
                    font-weight: 700;
                    color: white;
                    text-decoration: none;
                }
                
                .admin-logo i {
                    color: var(--admin-red);
                    font-size: 2rem;
                }
                
                .admin-brand {
                    font-size: 1.2rem;
                    opacity: 0.9;
                    margin-top: 5px;
                    color: rgba(255, 255, 255, 0.7);
                }
                
                /* Menu de navigation */
                .sidebar-menu {
                    padding: 20px 0;
                }
                
                .menu-section {
                    margin-bottom: 25px;
                }
                
                .menu-title {
                    font-size: 0.8rem;
                    text-transform: uppercase;
                    color: rgba(255, 255, 255, 0.5);
                    padding: 0 20px 10px;
                    letter-spacing: 1px;
                }
                
                .menu-list {
                    list-style: none;
                }
                
                .menu-item {
                    margin: 5px 0;
                }
                
                .menu-link {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    padding: 14px 20px;
                    color: rgba(255, 255, 255, 0.8);
                    text-decoration: none;
                    transition: all 0.3s ease;
                    border-left: 3px solid transparent;
                }
                
                .menu-link:hover, .menu-link.active {
                    background: rgba(255, 255, 255, 0.1);
                    color: white;
                    border-left-color: var(--admin-red);
                }
                
                .menu-link i {
                    width: 20px;
                    text-align: center;
                    font-size: 1.2rem;
                }
                
                .menu-badge {
                    margin-left: auto;
                    background: var(--admin-red);
                    color: white;
                    padding: 2px 8px;
                    border-radius: 12px;
                    font-size: 0.75rem;
                    font-weight: 600;
                }
                
                /* Main content */
                .admin-main {
                    flex: 1;
                    margin-left: var(--sidebar-width);
                    min-height: 100vh;
                }
                
                /* Header */
                .admin-header {
                    height: var(--header-height);
                    background: var(--card-white);
                    border-bottom: 1px solid var(--border-light);
                    padding: 0 30px;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    position: sticky;
                    top: 0;
                    z-index: 50;
                    box-shadow: var(--shadow-sm);
                }
                
                .header-left h1 {
                    font-size: 1.5rem;
                    color: var(--text-dark);
                    display: flex;
                    align-items: center;
                    gap: 10px;
                }
                
                .header-left h1 i {
                    color: var(--admin-red);
                }
                
                .header-right {
                    display: flex;
                    align-items: center;
                    gap: 20px;
                }
                
                /* User info */
                .user-info {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }
                
                .user-avatar {
                    width: 40px;
                    height: 40px;
                    background: linear-gradient(135deg, var(--admin-red) 0%, var(--admin-red-dark) 100%);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-weight: bold;
                    font-size: 1.2rem;
                }
                
                .user-details h4 {
                    font-size: 0.95rem;
                    font-weight: 600;
                }
                
                .user-details p {
                    font-size: 0.85rem;
                    color: var(--text-muted);
                }
                
                /* Notifications */
                .notifications {
                    position: relative;
                }
                
                .notification-btn {
                    background: none;
                    border: none;
                    color: var(--text-muted);
                    font-size: 1.3rem;
                    cursor: pointer;
                    position: relative;
                    padding: 5px;
                }
                
                .notification-badge {
                    position: absolute;
                    top: 0;
                    right: 0;
                    background: var(--admin-red);
                    color: white;
                    font-size: 0.7rem;
                    width: 18px;
                    height: 18px;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                
                /* Content area */
                .admin-content {
                    padding: 30px;
                }
                
                /* Welcome banner */
                .welcome-banner {
                    background: linear-gradient(135deg, var(--admin-red) 0%, var(--admin-red-dark) 100%);
                    color: white;
                    padding: 30px;
                    border-radius: 15px;
                    margin-bottom: 30px;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    box-shadow: var(--shadow-lg);
                }
                
                .welcome-text h2 {
                    font-size: 1.8rem;
                    margin-bottom: 10px;
                }
                
                .welcome-text p {
                    opacity: 0.9;
                    max-width: 600px;
                }
                
                .welcome-icon {
                    font-size: 4rem;
                    opacity: 0.8;
                }
                
                /* Stats cards */
                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                    margin-bottom: 30px;
                }
                
                .stat-card {
                    background: var(--card-white);
                    padding: 25px;
                    border-radius: 15px;
                    box-shadow: var(--shadow);
                    transition: all 0.3s ease;
                    border: 1px solid var(--border-light);
                }
                
                .stat-card:hover {
                    transform: translateY(-5px);
                    box-shadow: var(--shadow-lg);
                }
                
                .stat-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 15px;
                }
                
                .stat-icon {
                    width: 50px;
                    height: 50px;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.5rem;
                    color: white;
                }
                
                .stat-icon.users {
                    background: linear-gradient(135deg, var(--primary-blue) 0%, var(--secondary-blue) 100%);
                }
                
                .stat-icon.reservations {
                    background: linear-gradient(135deg, var(--success-green) 0%, #34d399 100%);
                }
                
                .stat-icon.destinations {
                    background: linear-gradient(135deg, var(--warning-yellow) 0%, #fbbf24 100%);
                }
                
                .stat-icon.revenue {
                    background: linear-gradient(135deg, var(--admin-red) 0%, #ef4444 100%);
                }
                
                .stat-trend {
                    display: flex;
                    align-items: center;
                    gap: 5px;
                    font-size: 0.85rem;
                    font-weight: 600;
                }
                
                .trend-up {
                    color: var(--success-green);
                }
                
                .trend-down {
                    color: var(--admin-red);
                }
                
                .stat-value {
                    font-size: 2rem;
                    font-weight: 700;
                    color: var(--text-dark);
                    margin-bottom: 5px;
                }
                
                .stat-label {
                    color: var(--text-muted);
                    font-size: 0.9rem;
                }
                
                /* Charts section */
                .charts-section {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
                    gap: 20px;
                    margin-bottom: 30px;
                }
                
                .chart-card {
                    background: var(--card-white);
                    padding: 25px;
                    border-radius: 15px;
                    box-shadow: var(--shadow);
                }
                
                .chart-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 20px;
                }
                
                .chart-header h3 {
                    font-size: 1.2rem;
                    font-weight: 600;
                }
                
                .chart-container {
                    position: relative;
                    height: 300px;
                    width: 100%;
                }
                
                /* Recent activity */
                .activity-section {
                    background: var(--card-white);
                    padding: 25px;
                    border-radius: 15px;
                    box-shadow: var(--shadow);
                    margin-bottom: 30px;
                }
                
                .section-header {
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    margin-bottom: 20px;
                }
                
                .section-header h3 {
                    font-size: 1.2rem;
                    font-weight: 600;
                }
                
                .section-actions {
                    display: flex;
                    gap: 10px;
                }
                
                .btn {
                    padding: 8px 16px;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    border: none;
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    font-size: 0.9rem;
                }
                
                .btn-primary {
                    background: var(--primary-blue);
                    color: white;
                }
                
                .btn-primary:hover {
                    background: #1e40af;
                    transform: translateY(-2px);
                }
                
                .btn-danger {
                    background: var(--admin-red);
                    color: white;
                }
                
                .btn-danger:hover {
                    background: var(--admin-red-dark);
                    transform: translateY(-2px);
                }
                
                .btn-success {
                    background: var(--success-green);
                    color: white;
                }
                
                .btn-success:hover {
                    background: #059669;
                    transform: translateY(-2px);
                }
                
                /* Tables */
                .table-responsive {
                    overflow-x: auto;
                }
                
                .admin-table {
                    width: 100%;
                    border-collapse: collapse;
                }
                
                .admin-table thead {
                    background: var(--admin-red-light);
                }
                
                .admin-table th {
                    padding: 15px;
                    text-align: left;
                    font-weight: 600;
                    color: var(--text-dark);
                    border-bottom: 2px solid var(--border-light);
                }
                
                .admin-table td {
                    padding: 15px;
                    border-bottom: 1px solid var(--border-light);
                }
                
                .admin-table tbody tr:hover {
                    background: #f8fafc;
                }
                
                .status-badge {
                    padding: 5px 12px;
                    border-radius: 20px;
                    font-size: 0.85rem;
                    font-weight: 600;
                }
                
                .status-active {
                    background: #d1fae5;
                    color: var(--success-green);
                }
                
                .status-pending {
                    background: #fef3c7;
                    color: var(--warning-yellow);
                }
                
                .status-cancelled {
                    background: #fee2e2;
                    color: var(--admin-red);
                }
                
                .action-buttons {
                    display: flex;
                    gap: 8px;
                }
                
                .action-btn {
                    width: 35px;
                    height: 35px;
                    border-radius: 8px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    border: none;
                    color: white;
                }
                
                .action-edit {
                    background: var(--primary-blue);
                }
                
                .action-delete {
                    background: var(--admin-red);
                }
                
                .action-view {
                    background: var(--success-green);
                }
                
                /* Modal */
                .modal {
                    display: none;
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.5);
                    z-index: 1000;
                    align-items: center;
                    justify-content: center;
                }
                
                .modal.active {
                    display: flex;
                }
                
                .modal-content {
                    background: var(--card-white);
                    border-radius: 15px;
                    width: 90%;
                    max-width: 500px;
                    max-height: 90vh;
                    overflow-y: auto;
                    box-shadow: var(--shadow-lg);
                }
                
                .modal-header {
                    padding: 20px;
                    border-bottom: 1px solid var(--border-light);
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                }
                
                .modal-header h3 {
                    font-size: 1.3rem;
                    font-weight: 600;
                }
                
                .modal-close {
                    background: none;
                    border: none;
                    font-size: 1.5rem;
                    cursor: pointer;
                    color: var(--text-muted);
                }
                
                .modal-body {
                    padding: 20px;
                }
                
                .form-group {
                    margin-bottom: 20px;
                }
                
                .form-label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                }
                
                .form-control {
                    width: 100%;
                    padding: 12px;
                    border: 1px solid var(--border-light);
                    border-radius: 8px;
                    font-size: 1rem;
                }
                
                .form-control:focus {
                    outline: none;
                    border-color: var(--primary-blue);
                }
                
                .modal-footer {
                    padding: 20px;
                    border-top: 1px solid var(--border-light);
                    display: flex;
                    justify-content: flex-end;
                    gap: 10px;
                }
                
                /* Quick actions */
                .quick-actions {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 15px;
                    margin-bottom: 30px;
                }
                
                .action-card {
                    background: var(--card-white);
                    padding: 20px;
                    border-radius: 12px;
                    box-shadow: var(--shadow);
                    display: flex;
                    align-items: center;
                    gap: 15px;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    border: 1px solid var(--border-light);
                }
                
                .action-card:hover {
                    transform: translateY(-3px);
                    box-shadow: var(--shadow-lg);
                }
                
                .action-icon {
                    width: 50px;
                    height: 50px;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.5rem;
                    color: white;
                }
                
                .action-info h4 {
                    font-size: 1rem;
                    margin-bottom: 5px;
                }
                
                .action-info p {
                    font-size: 0.85rem;
                    color: var(--text-muted);
                }
                
                /* Responsive */
                @media (max-width: 1024px) {
                    .sidebar {
                        transform: translateX(-100%);
                    }
                    
                    .sidebar.active {
                        transform: translateX(0);
                    }
                    
                    .admin-main {
                        margin-left: 0;
                    }
                    
                    .menu-toggle {
                        display: block;
                    }
                    
                    .charts-section {
                        grid-template-columns: 1fr;
                    }
                }
                
                @media (max-width: 768px) {
                    .admin-content {
                        padding: 20px;
                    }
                    
                    .welcome-banner {
                        flex-direction: column;
                        text-align: center;
                        gap: 20px;
                    }
                    
                    .welcome-icon {
                        font-size: 3rem;
                    }
                    
                    .stats-grid {
                        grid-template-columns: 1fr;
                    }
                    
                    .charts-section {
                        grid-template-columns: 1fr;
                    }
                    
                    .quick-actions {
                        grid-template-columns: 1fr;
                    }
                }
                
                @media (max-width: 480px) {
                    .admin-header {
                        padding: 0 15px;
                    }
                    
                    .header-right {
                        gap: 10px;
                    }
                    
                    .user-details {
                        display: none;
                    }
                }
                
                /* Animations */
                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(10px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
                
                .fade-in {
                    animation: fadeIn 0.5s ease;
                }
                
                /* Sections du dashboard */
                .dashboard-section {
                    display: none;
                }
                
                .dashboard-section.active {
                    display: block;
                    animation: fadeIn 0.3s ease;
                }
            </style>
        </head>
        <body>
            <div class="admin-dashboard">
                <!-- Sidebar -->
                <aside class="admin-sidebar">
                    <div class="sidebar-header">
                        <a href="#" class="admin-logo">
                            <i class="fas fa-user-shield"></i>
                            <div>
                                <div>VoyageConnect</div>
                                <div class="admin-brand">Administration</div>
                            </div>
                        </a>
                    </div>
                    
                    <nav class="sidebar-menu">
                        <div class="menu-section">
                            <h3 class="menu-title">Tableau de bord</h3>
                            <ul class="menu-list">
                                <li class="menu-item">
                                    <a href="#" class="menu-link active" data-section="overview">
                                        <i class="fas fa-tachometer-alt"></i>
                                        <span>Vue d'ensemble</span>
                                    </a>
                                </li>
                                <li class="menu-item">
                                    <a href="#" class="menu-link" data-section="analytics">
                                        <i class="fas fa-chart-bar"></i>
                                        <span>Analytics</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                        
                        <div class="menu-section">
                            <h3 class="menu-title">Gestion</h3>
                            <ul class="menu-list">
                                <li class="menu-item">
                                    <a href="javascript:void(0);" class="menu-link" onclick="showSection('users'); return false;" data-section="users">
                                        <i class="fas fa-users"></i>
                                        <span>Utilisateurs</span>
                                        <span class="menu-badge" id="users-count">${totalUsers}</span>
                                    </a>
                                </li>
                                <li class="menu-item">
                                    <a href="javascript:void(0);" class="menu-link" onclick="showSection('destinations'); return false;" data-section="destinations">
                                        <i class="fas fa-map-marked-alt"></i>
                                        <span>Destinations</span>
                                        <span class="menu-badge" id="destinations-count">${totalDestinations}</span>
                                    </a>
                                </li>
                                <li class="menu-item">
                                    <a href="javascript:void(0);" class="menu-link" onclick="showSection('reservations'); return false;" data-section="reservations">
                                        <i class="fas fa-calendar-check"></i>
                                        <span>Réservations</span>
                                        <span class="menu-badge" id="reservations-count">${totalBookings}</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                        
                        <div class="menu-section">
                            <h3 class="menu-title">Contenu</h3>
                            <ul class="menu-list">
                                <li class="menu-item">
                                    <a href="#" class="menu-link" data-section="avis">
                                        <i class="fas fa-star"></i>
                                        <span>Avis clients</span>
                                    </a>
                                </li>
                                
                            </ul>
                        </div>
                        
                        <div class="menu-section">
                            
                                <li class="menu-item">
                                    <a href="${pageContext.request.contextPath}/AcceuilServlet?action=logout" class="menu-link">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Déconnexion</span>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </nav>
                </aside>
                
                <!-- Main Content -->
                <main class="admin-main">
                    <!-- Header -->
                    <header class="admin-header">
                        <div class="header-left">
                            <h1>
                                <i class="fas fa-tachometer-alt"></i>
                                <span id="page-title">Tableau de bord</span>
                            </h1>
                        </div>
                        
                        <div class="header-right">
                            <div class="notifications">
                                <button class="notification-btn">
                                    <i class="fas fa-bell"></i>
                                    <span class="notification-badge">3</span>
                                </button>
                            </div>
                            
                            <div class="user-info">
                                <div class="user-avatar">
                                    ${sessionScope.user.firstName.charAt(0)}${sessionScope.user.lastName.charAt(0)}
                                </div>
                                <div class="user-details">
                                    <h4>${sessionScope.user.firstName} ${sessionScope.user.lastName}</h4>
                                    <p>Administrateur</p>
                                </div>
                            </div>
                        </div>
                    </header>
                    
                    <!-- Content Area -->
                    <div class="admin-content">
                        <!-- Overview Section (default) -->
                        <section class="dashboard-section active" id="overview-section">
                            <!-- Welcome Banner -->
                            <div class="welcome-banner fade-in">
                                <div class="welcome-text">
                                    <h2>Bonjour, ${sessionScope.user.firstName} ! 👋</h2>
                                    <p>Voici un aperçu des performances de votre plateforme VoyageConnect. Gérez vos utilisateurs, destinations et réservations en toute simplicité.</p>
                                </div>
                                <div class="welcome-icon">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                            </div>
                            
                            <!-- Quick Actions -->
                            <div class="quick-actions">
                                <div class="action-card" data-action="add-user">
                                    <div class="action-icon" style="background: linear-gradient(135deg, #1a56db 0%, #0ea5e9 100%);">
                                        <i class="fas fa-user-plus"></i>
                                    </div>
                                    <div class="action-info">
                                        <h4>Ajouter un utilisateur</h4>
                                        <p>Créer un nouveau compte</p>
                                    </div>
                                </div>
                                
                                <div class="action-card" data-action="add-destination">
                                    <div class="action-icon" style="background: linear-gradient(135deg, #10b981 0%, #34d399 100%);">
                                        <i class="fas fa-map-marked"></i>
                                    </div>
                                    <div class="action-info">
                                        <h4>Ajouter une destination</h4>
                                        <p>Nouvelle offre de voyage</p>
                                    </div>
                                </div>
                                
                                <div class="action-card" data-action="view-reports">
                                    <div class="action-icon" style="background: linear-gradient(135deg, #f59e0b 0%, #fbbf24 100%);">
                                        <i class="fas fa-file-alt"></i>
                                    </div>
                                    <div class="action-info">
                                        <h4>Voir les rapports</h4>
                                        <p>Analyse des performances</p>
                                    </div>
                                </div>
                                
                                <div class="action-card" data-action="settings">
                                    <div class="action-icon" style="background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);">
                                        <i class="fas fa-cog"></i>
                                    </div>
                                    <div class="action-info">
                                        <h4>Paramètres</h4>
                                        <p>Configurer la plateforme</p>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Stats Cards -->
                            <div class="stats-grid">
                                <div class="stat-card fade-in">
                                    <div class="stat-header">
                                        <div class="stat-icon users">
                                            <i class="fas fa-users"></i>
                                        </div>
                                        <div class="stat-trend trend-up">
                                            <i class="fas fa-arrow-up"></i>
                                            <span>12%</span>
                                        </div>
                                    </div>
                                    <div class="stat-value" id="total-users">${totalUsers}</div>
                                    <div class="stat-label">Utilisateurs inscrits</div>
                                </div>
                                
                                <div class="stat-card fade-in">
                                    <div class="stat-header">
                                        <div class="stat-icon reservations">
                                            <i class="fas fa-calendar-check"></i>
                                        </div>
                                        <div class="stat-trend trend-up">
                                            <i class="fas fa-arrow-up"></i>
                                            <span>${confirmedBookings}</span>
                                        </div>
                                    </div>
                                    <div class="stat-value" id="total-reservations">${totalBookings}</div>
                                    <div class="stat-label">Réservations totales</div>
                                </div>
                                
                                <div class="stat-card fade-in">
                                    <div class="stat-header">
                                        <div class="stat-icon destinations">
                                            <i class="fas fa-map-marker-alt"></i>
                                        </div>
                                        <div class="stat-trend trend-up">
                                            <i class="fas fa-arrow-up"></i>
                                            <span>${totalDestinations}</span>
                                        </div>
                                    </div>
                                    <div class="stat-value" id="total-destinations">${totalDestinations}</div>
                                    <div class="stat-label">Destinations disponibles</div>
                                </div>
                                
                                <div class="stat-card fade-in">
                                    <div class="stat-header">
                                        <div class="stat-icon revenue">
                                            <i class="fas fa-dollar-sign"></i>
                                        </div>
                                        <div class="stat-trend trend-up">
                                            <i class="fas fa-arrow-up"></i>
                                            <span>${confirmedBookings}</span>
                                        </div>
                                    </div>
                                    <div class="stat-value">
                                        <fmt:formatNumber value="${totalRevenue}" pattern="#,##0.00" /> DH
                                    </div>
                                    <div class="stat-label">Revenu total</div>
                                </div>
                            </div>
                            
                            <!-- Charts -->
                            <div class="charts-section">
                                <div class="chart-card fade-in">
                                    <div class="chart-header">
                                        <h3>Activité des utilisateurs</h3>
                                        <select class="form-control" style="width: auto;">
                                            <option>7 derniers jours</option>
                                            <option>30 derniers jours</option>
                                            <option>3 derniers mois</option>
                                        </select>
                                    </div>
                                    <div class="chart-container">
                                        <canvas id="userActivityChart"></canvas>
                                    </div>
                                </div>
                                
                                <div class="chart-card fade-in">
                                    <div class="chart-header">
                                        <h3>Répartition des réservations</h3>
                                    </div>
                                    <div class="chart-container">
                                        <canvas id="reservationChart"></canvas>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Recent Activity -->
                            <div class="activity-section fade-in">
                                <div class="section-header">
                                    <h3>Activité récente</h3>
                                    <button class="btn btn-primary">
                                        <i class="fas fa-sync"></i>
                                        Actualiser
                                    </button>
                                </div>
                                <div class="table-responsive">
                                    <table class="admin-table">
                                        <thead>
                                            <tr>
                                                <th>Utilisateur</th>
                                                <th>Action</th>
                                                <th>Date</th>
                                                <th>Statut</th>
                                            </tr>
                                        </thead>
                                        <tbody id="activity-table">
                                            <c:forEach var="booking" items="${recentBookings}" varStatus="status">
                                                <tr>
                                                    <td>${booking.user.firstName} ${booking.user.lastName}</td>
                                                    <td>Nouvelle réservation #${booking.id}</td>
                                                    <td><fmt:formatDate value="${booking.bookingDate}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                    <td>
                                                        <c:set var="statusStr" value="${booking.status.toString()}" />
                                                        <c:choose>
                                                            <c:when test="${statusStr == 'PENDING'}">
                                                                <span class="status-badge status-pending">En attente</span>
                                                            </c:when>
                                                            <c:when test="${statusStr == 'CONFIRMED'}">
                                                                <span class="status-badge status-active">Confirmée</span>
                                                            </c:when>
                                                            <c:when test="${statusStr == 'CANCELLED'}">
                                                                <span class="status-badge status-cancelled">Annulée</span>
                                                            </c:when>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            <c:if test="${empty recentBookings}">
                                                <tr>
                                                    <td colspan="4" style="text-align: center; color: var(--text-muted);">
                                                        Aucune activité récente
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </section>
                        
                        <!-- Users Management Section -->
                        <section class="dashboard-section" id="users-section">
                            <div class="section-header">
                                <h2><i class="fas fa-users"></i> Gestion des Utilisateurs</h2>
                                <div class="section-actions">
                                    <button class="btn btn-primary" onclick="openAddUserModal()">
                                        <i class="fas fa-user-plus"></i>
                                        Ajouter un utilisateur
                                    </button>
                                    <button class="btn btn-success" onclick="exportUsers()">
                                        <i class="fas fa-download"></i>
                                        Exporter
                                    </button>
                                </div>
                            </div>
                            
                            <div class="table-responsive">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Nom</th>
                                            <th>Email</th>
                                            <th>Téléphone</th>
                                            <th>Rôle</th>
                                            <th>Inscription</th>
                                            <th>Statut</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="users-table">
                                        <c:choose>
                                            <c:when test="${not empty allUsers}">
                                                <c:forEach var="user" items="${allUsers}">
                                                    <tr>
                                                        <td>${user.id}</td>
                                                        <td>${user.firstName} ${user.lastName}</td>
                                                        <td>${user.email}</td>
                                                        <td>${user.phone != null ? user.phone : '-'}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${user.role == 'ADMIN'}">
                                                                    <span class="status-badge" style="background: #fee2e2; color: #dc2626;">Admin</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="status-badge status-active">Client</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty user.createdAt}">
                                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                                            </c:if>
                                                            <c:if test="${empty user.createdAt}">
                                                                -
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <span class="status-badge status-active">Actif</span>
                                                        </td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <button class="action-btn action-view" onclick="viewUser(${user.id})" title="Voir">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button class="action-btn action-edit" onclick="editUser(${user.id})" title="Modifier">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <button class="action-btn action-delete" onclick="deleteUser(${user.id})" title="Supprimer">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="8" style="text-align: center; color: var(--text-muted);">
                                                        Aucun utilisateur trouvé (Total: ${totalUsers})
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </section>
                        
                        <!-- Destinations Management Section -->
                        <section class="dashboard-section" id="destinations-section">
                            <div class="section-header">
                                <h2><i class="fas fa-map-marked-alt"></i> Gestion des Destinations</h2>
                                <div class="section-actions">
                                    <button class="btn btn-primary" onclick="openAddDestinationModal()">
                                        <i class="fas fa-plus"></i>
                                        Ajouter une destination
                                    </button>
                                </div>
                            </div>
                            
                            <div class="table-responsive">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Image</th>
                                            <th>Nom</th>
                                            <th>Pays</th>
                                            <th>Prix</th>
                                            <th>Disponibilité</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="destinations-table">
                                        <c:choose>
                                            <c:when test="${not empty allDestinations}">
                                                <c:forEach var="destination" items="${allDestinations}">
                                                    <tr>
                                                        <td>${destination.id}</td>
                                                        <td>
                                                            <c:if test="${not empty destination.imageUrl}">
                                                                <img src="${destination.imageUrl}" alt="${destination.city}" 
                                                                     style="width: 60px; height: 60px; object-fit: cover; border-radius: 8px;">
                                                            </c:if>
                                                            <c:if test="${empty destination.imageUrl}">
                                                                <div style="width: 60px; height: 60px; background: #e5e7eb; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                                    <i class="fas fa-image" style="color: #9ca3af;"></i>
                                                                </div>
                                                            </c:if>
                                                        </td>
                                                        <td><strong>${destination.city}</strong></td>
                                                        <td>${destination.country}</td>
                                                        <td>
                                                            <c:if test="${not empty destination.price}">
                                                                <fmt:formatNumber value="${destination.price}" pattern="#,##0.00" /> DH
                                                            </c:if>
                                                            <c:if test="${empty destination.price}">
                                                                Sur demande
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <span class="status-badge status-active">Disponible</span>
                                                        </td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <button class="action-btn action-view" onclick="viewDestination(${destination.id})" title="Voir">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <button class="action-btn action-edit" onclick="editDestination(${destination.id})" title="Modifier">
                                                                    <i class="fas fa-edit"></i>
                                                                </button>
                                                                <button class="action-btn action-delete" onclick="deleteDestination(${destination.id})" title="Supprimer">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="7" style="text-align: center; color: var(--text-muted);">
                                                        Aucune destination trouvée (Total: ${totalDestinations})
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </section>
                        
                        <!-- Reservations Management Section -->
                        <section class="dashboard-section" id="reservations-section">
                            <div class="section-header">
                                <h2><i class="fas fa-calendar-check"></i> Gestion des Réservations</h2>
                                <div class="section-actions">
                                    <select class="form-control" style="width: auto;" onchange="filterReservations(this.value)">
                                        <option value="all">Toutes les réservations</option>
                                        <option value="pending">En attente</option>
                                        <option value="confirmed">Confirmées</option>
                                        <option value="cancelled">Annulées</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="table-responsive">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Client</th>
                                            <th>Destination</th>
                                            <th>Date</th>
                                            <th>Personnes</th>
                                            <th>Prix total</th>
                                            <th>Statut</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody id="reservations-table">
                                        <c:choose>
                                            <c:when test="${not empty allBookings}">
                                                <c:forEach var="booking" items="${allBookings}">
                                                    <tr data-status="${booking.status.toString().toLowerCase()}">
                                                        <td>#${booking.id}</td>
                                                        <td>
                                                            <c:if test="${not empty booking.user}">
                                                                ${booking.user.firstName} ${booking.user.lastName}<br>
                                                                <small style="color: var(--text-muted);">${booking.user.email}</small>
                                                            </c:if>
                                                            <c:if test="${empty booking.user}">
                                                                Utilisateur inconnu
                                                            </c:if>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty booking.offer and not empty booking.offer.destination}">
                                                                    ${booking.offer.destination.city}, ${booking.offer.destination.country}
                                                                </c:when>
                                                                <c:when test="${not empty booking.offer}">
                                                                    ${booking.offer.title}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Offre inconnue
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:if test="${not empty booking.startDate}">
                                                                <fmt:formatDate value="${booking.startDate}" pattern="dd/MM/yyyy" /><br>
                                                                <small style="color: var(--text-muted);">au <fmt:formatDate value="${booking.endDate}" pattern="dd/MM/yyyy" /></small>
                                                            </c:if>
                                                        </td>
                                                        <td>${booking.quantity}</td>
                                                        <td><strong><fmt:formatNumber value="${booking.totalAmount}" pattern="#,##0.00" /> DH</strong></td>
                                                        <td>
                                                            <c:set var="statusStr" value="${booking.status.toString()}" />
                                                            <c:choose>
                                                                <c:when test="${statusStr == 'PENDING'}">
                                                                    <span class="status-badge status-pending">En attente</span>
                                                                </c:when>
                                                                <c:when test="${statusStr == 'CONFIRMED'}">
                                                                    <span class="status-badge status-active">Confirmée</span>
                                                                </c:when>
                                                                <c:when test="${statusStr == 'CANCELLED'}">
                                                                    <span class="status-badge status-cancelled">Annulée</span>
                                                                </c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <button class="action-btn action-view" onclick="viewBooking(${booking.id})" title="Voir">
                                                                    <i class="fas fa-eye"></i>
                                                                </button>
                                                                <c:if test="${statusStr == 'PENDING'}">
                                                                    <button class="action-btn action-edit" onclick="confirmBooking(${booking.id})" title="Confirmer">
                                                                        <i class="fas fa-check"></i>
                                                                    </button>
                                                                </c:if>
                                                                <c:if test="${statusStr != 'CANCELLED'}">
                                                                    <button class="action-btn action-delete" onclick="cancelBooking(${booking.id})" title="Annuler">
                                                                        <i class="fas fa-times"></i>
                                                                    </button>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="8" style="text-align: center; color: var(--text-muted);">
                                                        Aucune réservation trouvée (Total: ${totalBookings})
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </section>
                        
                        <!-- Add more sections for other management areas -->
                    </div>
                </main>
            </div>
            
            <!-- Modals -->
            <!-- Add User Modal -->
            <div class="modal" id="addUserModal">
                <div class="modal-content">
                    <div class="modal-header">
                        <h3><i class="fas fa-user-plus"></i> Ajouter un utilisateur</h3>
                        <button class="modal-close" onclick="closeModal('addUserModal')">&times;</button>
                    </div>
                    <div class="modal-body">
                        <form id="addUserForm">
                            <div class="form-group">
                                <label class="form-label">Prénom</label>
                                <input type="text" class="form-control" name="firstName" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Nom</label>
                                <input type="text" class="form-control" name="lastName" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Téléphone</label>
                                <input type="tel" class="form-control" name="phone">
                            </div>
                            <div class="form-group">
                                <label class="form-label">Mot de passe</label>
                                <input type="password" class="form-control" name="password" required>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Rôle</label>
                                <select class="form-control" name="role">
                                    <option value="CLIENT">Client</option>
                                    <option value="ADMIN">Administrateur</option>
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" onclick="closeModal('addUserModal')">Annuler</button>
                        <button class="btn btn-primary" onclick="saveUser()">Enregistrer</button>
                    </div>
                </div>
            </div>
        </div>
        
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
        // Fonction globale pour afficher une section
        function showSection(sectionId) {
            console.log('[AdminDashboard] showSection appelé avec:', sectionId);
            
            if (!sectionId) {
                console.error('[AdminDashboard] ERREUR: sectionId est vide ou undefined');
                return;
            }
            
            // Cacher toutes les sections
            const allSections = document.querySelectorAll('.dashboard-section');
            console.log('[AdminDashboard] Nombre de sections trouvées:', allSections.length);
            
            allSections.forEach(section => {
                section.classList.remove('active');
                section.style.display = 'none';
            });
            
            // Afficher la section demandée
            const sectionIdWithSuffix = sectionId + '-section';
            console.log('[AdminDashboard] Recherche de la section avec ID:', sectionIdWithSuffix);
            
            const targetSection = document.getElementById(sectionIdWithSuffix);
            if (targetSection) {
                console.log('[AdminDashboard] Section trouvée, affichage...');
                targetSection.classList.add('active');
                targetSection.style.display = 'block';
            } else {
                console.error('[AdminDashboard] ERREUR: Section non trouvée avec ID:', sectionIdWithSuffix);
                // Afficher toutes les sections disponibles pour déboguer
                allSections.forEach(section => {
                    console.log('[AdminDashboard] Section disponible:', section.id);
                });
            }
            
            // Mettre à jour l'état actif du menu
            document.querySelectorAll('.menu-link').forEach(link => {
                link.classList.remove('active');
                if (link.getAttribute('data-section') === sectionId) {
                    link.classList.add('active');
                }
            });
            
            // Mettre à jour le titre de la page
            updatePageTitle(sectionId);
        }
        
        // Fonction pour mettre à jour le titre de la page
        function updatePageTitle(sectionId) {
            const titles = {
                'overview': 'Tableau de bord',
                'analytics': 'Analytics',
                'users': 'Gestion des Utilisateurs',
                'destinations': 'Gestion des Destinations',
                'reservations': 'Gestion des Réservations',
                'avis': 'Avis Clients'
            };
            
            const titleElement = document.getElementById('page-title');
            if (titleElement) {
                titleElement.textContent = titles[sectionId] || 'Tableau de bord';
            }
        }
        
        // Initialiser avec la section overview au chargement
        document.addEventListener('DOMContentLoaded', function() {
            console.log('[AdminDashboard] DOM chargé, initialisation...');
            showSection('overview');
        });
        
        // Si le DOM est déjà chargé
        if (document.readyState !== 'loading') {
            console.log('[AdminDashboard] DOM déjà chargé, initialisation immédiate...');
            showSection('overview');
        }
        
        // Filtrer les réservations
        function filterReservations(status) {
            const rows = document.querySelectorAll('#reservations-table tr[data-status]');
            rows.forEach(row => {
                if (status === 'all' || row.getAttribute('data-status') === status) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }
        
        // Fonctions modales
        function openAddUserModal() {
            document.getElementById('addUserModal').classList.add('active');
        }
        
        function closeModal(modalId) {
            document.getElementById(modalId).classList.remove('active');
        }
        
        function openAddDestinationModal() {
            alert('Fonctionnalité à implémenter');
        }
        
        // Fonctions d'action
        function viewUser(userId) {
            alert('Voir utilisateur ' + userId);
        }
        
        function editUser(userId) {
            alert('Modifier utilisateur ' + userId);
        }
        
        function deleteUser(userId) {
            if (confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
                alert('Supprimer utilisateur ' + userId);
            }
        }
        
        function viewDestination(destId) {
            alert('Voir destination ' + destId);
        }
        
        function editDestination(destId) {
            alert('Modifier destination ' + destId);
        }
        
        function deleteDestination(destId) {
            if (confirm('Êtes-vous sûr de vouloir supprimer cette destination ?')) {
                alert('Supprimer destination ' + destId);
            }
        }
        
        function viewBooking(bookingId) {
            window.location.href = '${pageContext.request.contextPath}/bookingconfirmation?id=' + bookingId;
        }
        
        function confirmBooking(bookingId) {
            if (confirm('Confirmer cette réservation ?')) {
                // TODO: Appel AJAX pour confirmer la réservation
                alert('Confirmer réservation ' + bookingId);
            }
        }
        
        function cancelBooking(bookingId) {
            if (confirm('Annuler cette réservation ?')) {
                // TODO: Appel AJAX pour annuler la réservation
                alert('Annuler réservation ' + bookingId);
            }
        }
        
        function saveUser() {
            alert('Enregistrer utilisateur');
        }
        
        function exportUsers() {
            alert('Exporter utilisateurs');
        }
        
        // Initialiser les graphiques Chart.js
        document.addEventListener('DOMContentLoaded', function() {
            // Graphique activité utilisateurs
            const userActivityCtx = document.getElementById('userActivityChart');
            if (userActivityCtx) {
                new Chart(userActivityCtx, {
                    type: 'line',
                    data: {
                        labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
                        datasets: [{
                            label: 'Nouveaux utilisateurs',
                            data: [12, 19, 15, 25, 22, 18, 24],
                            borderColor: '#1a56db',
                            backgroundColor: 'rgba(26, 86, 219, 0.1)',
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
            }
            
            // Graphique répartition réservations
            const reservationCtx = document.getElementById('reservationChart');
            if (reservationCtx) {
                new Chart(reservationCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ['Confirmées', 'En attente', 'Annulées'],
                        datasets: [{
                            data: [${confirmedBookings}, ${pendingBookings}, ${totalBookings - confirmedBookings - pendingBookings}],
                            backgroundColor: ['#10b981', '#f59e0b', '#dc2626']
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
            }
            
            // Debug: Vérifier les données reçues
            console.log("[AdminDashboard] Debug - Statistiques:");
            console.log("  - Total Users:", ${totalUsers}, "Liste:", ${fn:length(allUsers)});
            console.log("  - Total Destinations:", ${totalDestinations}, "Liste:", ${fn:length(allDestinations)});
            console.log("  - Total Bookings:", ${totalBookings}, "Liste:", ${fn:length(allBookings)});
            console.log("  - Recent Bookings:", ${fn:length(recentBookings)});
            
            <c:forEach var="user" items="${allUsers}" varStatus="status">
                console.log("[AdminDashboard] User ${status.index + 1}: ID=${user.id}, Email=${user.email}");
            </c:forEach>
            
            <c:forEach var="destination" items="${allDestinations}" varStatus="status">
                console.log("[AdminDashboard] Destination ${status.index + 1}: ID=${destination.id}, City=${destination.city}");
            </c:forEach>
            
            <c:forEach var="booking" items="${allBookings}" varStatus="status">
                console.log("[AdminDashboard] Booking ${status.index + 1}: ID=${booking.id}, Status=${booking.status}");
            </c:forEach>
        });
        </script>
    </body>
</html>