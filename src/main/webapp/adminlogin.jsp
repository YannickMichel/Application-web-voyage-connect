<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Administration - VoyageConnect</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    /* Variables de couleurs */
    :root {
        --admin-red: #dc2626;
        --admin-red-dark: #b91c1c;
        --admin-red-light: #fef2f2;
        --primary-blue: #1a56db;
        --success-green: #10b981;
        --warning-yellow: #f59e0b;
        --background-light: #f5f7fa;
        --card-white: #ffffff;
        --text-dark: #1e293b;
        --text-muted: #64748b;
        --border-light: #e5e7eb;
        --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    }
    
    /* Reset et styles de base */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
        min-height: 100vh;
        color: var(--text-dark);
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 20px;
    }
    
    /* Container principal */
    .admin-container {
        width: 100%;
        max-width: 900px;
        margin: 0 auto;
    }
    
    /* Header admin */
    .admin-header {
        text-align: center;
        margin-bottom: 40px;
    }
    
    .admin-title {
        font-size: 2.5rem;
        font-weight: 800;
        color: var(--admin-red);
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 15px;
    }
    
    .admin-subtitle {
        color: var(--text-muted);
        font-size: 1.1rem;
        max-width: 600px;
        margin: 0 auto;
    }
    
    /* Section de choix */
    .admin-choice-section {
        display: flex;
        gap: 30px;
        margin-bottom: 40px;
        flex-wrap: wrap;
        justify-content: center;
    }
    
    .admin-choice-card {
        flex: 1;
        min-width: 280px;
        max-width: 400px;
        background: var(--card-white);
        border-radius: 20px;
        overflow: hidden;
        box-shadow: var(--shadow);
        transition: all 0.3s ease;
        cursor: pointer;
        border: 2px solid transparent;
    }
    
    .admin-choice-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        border-color: var(--admin-red);
    }
    
    .admin-choice-card.active {
        border-color: var(--admin-red);
        box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
    }
    
    .choice-card-header {
        background: linear-gradient(135deg, var(--admin-red) 0%, var(--admin-red-dark) 100%);
        color: white;
        padding: 25px;
        text-align: center;
    }
    
    .choice-icon {
        font-size: 2.5rem;
        margin-bottom: 15px;
    }
    
    .choice-title {
        font-size: 1.5rem;
        font-weight: 600;
        margin-bottom: 5px;
    }
    
    .choice-description {
        font-size: 0.95rem;
        opacity: 0.9;
    }
    
    .choice-card-body {
        padding: 25px;
        text-align: center;
    }
    
    .choice-btn {
        background: var(--admin-red);
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 10px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 10px;
        font-size: 1rem;
    }
    
    .choice-btn:hover {
        background: var(--admin-red-dark);
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
    }
    
    /* Section des formulaires */
    .admin-forms-section {
        background: var(--card-white);
        border-radius: 20px;
        overflow: hidden;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        margin-top: 20px;
    }
    
    .admin-form-container {
        padding: 40px;
    }
    
    /* Tabs */
    .admin-tabs {
        display: flex;
        border-bottom: 2px solid var(--border-light);
        margin-bottom: 30px;
        background: var(--admin-red-light);
        border-radius: 10px 10px 0 0;
        overflow: hidden;
    }
    
    .admin-tab {
        flex: 1;
        padding: 20px;
        background: none;
        border: none;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        color: var(--text-muted);
    }
    
    .admin-tab.active {
        background: var(--card-white);
        color: var(--admin-red);
        border-bottom: 3px solid var(--admin-red);
    }
    
    /* Formulaires */
    .admin-form {
        display: none;
        animation: fadeIn 0.5s ease;
    }
    
    .admin-form.active {
        display: block;
    }
    
    .form-title {
        font-size: 1.8rem;
        color: var(--admin-red);
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    .form-subtitle {
        color: var(--text-muted);
        margin-bottom: 30px;
    }
    
    /* Messages */
    .message-container {
        margin-bottom: 30px;
    }
    
    .error-message {
        background: #fee2e2;
        color: var(--admin-red);
        padding: 15px 20px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 15px;
        border-left: 4px solid var(--admin-red);
    }
    
    .success-message {
        background: #d1fae5;
        color: var(--success-green);
        padding: 15px 20px;
        border-radius: 10px;
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 15px;
        border-left: 4px solid var(--success-green);
    }
    
    /* Styles de formulaire */
    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
        margin-bottom: 25px;
    }
    
    .form-group {
        margin-bottom: 20px;
    }
    
    .form-group.full-width {
        grid-column: span 2;
    }
    
    .form-label {
        display: block;
        margin-bottom: 8px;
        font-weight: 600;
        color: var(--text-dark);
        font-size: 0.95rem;
    }
    
    .form-label i {
        margin-right: 8px;
        color: var(--admin-red);
    }
    
    .form-input {
        width: 100%;
        padding: 14px 16px;
        border: 2px solid var(--border-light);
        border-radius: 10px;
        font-size: 1rem;
        transition: all 0.3s ease;
        background: #f9fafb;
    }
    
    .form-input:focus {
        outline: none;
        border-color: var(--admin-red);
        background: white;
        box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
    }
    
    .input-with-icon {
        position: relative;
    }
    
    .input-icon {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        color: var(--text-muted);
    }
    
    .form-input.with-icon {
        padding-left: 45px;
    }
    
    /* Password strength */
    .password-strength {
        margin-top: 10px;
        padding: 10px;
        border-radius: 8px;
        font-size: 0.9rem;
        display: none;
    }
    
    .password-strength.weak {
        display: block;
        background: #fee2e2;
        color: var(--admin-red);
    }
    
    .password-strength.medium {
        display: block;
        background: #fef3c7;
        color: var(--warning-yellow);
    }
    
    .password-strength.strong {
        display: block;
        background: #d1fae5;
        color: var(--success-green);
    }
    
    /* Password toggle */
    .password-toggle {
        position: absolute;
        right: 14px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: var(--text-muted);
        cursor: pointer;
        font-size: 1.1rem;
        padding: 5px;
    }
    
    .password-toggle:hover {
        color: var(--admin-red);
    }
    
    /* Bouton de soumission */
    .submit-btn {
        width: 100%;
        padding: 16px;
        background: linear-gradient(135deg, var(--admin-red) 0%, var(--admin-red-dark) 100%);
        color: white;
        border: none;
        border-radius: 10px;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        margin-top: 30px;
    }
    
    .submit-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(220, 38, 38, 0.3);
    }
    
    /* Lien retour */
    .back-link {
        text-align: center;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid var(--border-light);
    }
    
    .back-link a {
        color: var(--admin-red);
        text-decoration: none;
        font-weight: 600;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        transition: color 0.3s ease;
    }
    
    .back-link a:hover {
        color: var(--admin-red-dark);
        text-decoration: underline;
    }
    
    /* Requirements list */
    .requirements-list {
        background: #f8fafc;
        padding: 20px;
        border-radius: 10px;
        margin: 25px 0;
        border-left: 4px solid var(--admin-red);
    }
    
    .requirements-list h4 {
        margin-bottom: 15px;
        color: var(--admin-red);
        font-size: 1.1rem;
    }
    
    .requirements-list ul {
        list-style: none;
        padding: 0;
    }
    
    .requirements-list li {
        margin-bottom: 10px;
        padding-left: 25px;
        position: relative;
    }
    
    .requirements-list li:before {
        content: '•';
        color: var(--admin-red);
        position: absolute;
        left: 0;
        font-size: 1.5rem;
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
    
    /* Responsive */
    @media (max-width: 768px) {
        .admin-container {
            max-width: 100%;
        }
        
        .admin-choice-section {
            flex-direction: column;
            align-items: center;
        }
        
        .admin-choice-card {
            width: 100%;
            max-width: 100%;
        }
        
        .form-grid {
            grid-template-columns: 1fr;
        }
        
        .form-group.full-width {
            grid-column: span 1;
        }
        
        .admin-form-container {
            padding: 25px;
        }
        
        .admin-title {
            font-size: 2rem;
        }
        
        .admin-tabs {
            flex-direction: column;
        }
        
        .admin-tab {
            padding: 15px;
        }
    }
    
    @media (max-width: 480px) {
        body {
            padding: 10px;
        }
        
        .admin-form-container {
            padding: 20px;
        }
        
        .admin-title {
            font-size: 1.8rem;
        }
        
        .form-title {
            font-size: 1.5rem;
        }
    }
</style>
</head>
<body>

    <div class="admin-container">
        <!-- Header -->
        <div class="admin-header">
            <h1 class="admin-title">
                <i class="fas fa-user-shield"></i>
                Administration VoyageConnect
            </h1>
            <p class="admin-subtitle">
                Gestion sécurisée des accès administrateurs - Accès restreint au personnel autorisé
            </p>
        </div>
        
        <!-- Section de choix (mobile friendly) -->
        <div class="admin-choice-section">
            <div class="admin-choice-card active" id="loginChoiceCard" onclick="showForm('login')">
                <div class="choice-card-header">
                    <i class="fas fa-sign-in-alt choice-icon"></i>
                    <h3 class="choice-title">Connexion Admin</h3>
                    <p class="choice-description">Accédez au dashboard d'administration</p>
                </div>
                <div class="choice-card-body">
                    <button class="choice-btn">
                        <i class="fas fa-arrow-right"></i>
                        Se connecter
                    </button>
                </div>
            </div>
            
            <div class="admin-choice-card" id="createChoiceCard" onclick="showForm('create')">
                <div class="choice-card-header">
                    <i class="fas fa-user-plus choice-icon"></i>
                    <h3 class="choice-title">Créer un Admin</h3>
                    <p class="choice-description">Ajouter un nouvel administrateur</p>
                </div>
                <div class="choice-card-body">
                    <button class="choice-btn">
                        <i class="fas fa-plus-circle"></i>
                        Créer un compte
                    </button>
                </div>
            </div>
        </div>
        
        <!-- Section des formulaires -->
        <div class="admin-forms-section">
            <!-- Tabs pour desktop -->
            <div class="admin-tabs">
                <button class="admin-tab active" onclick="showForm('login')">
                    <i class="fas fa-sign-in-alt"></i>
                    Connexion Admin
                </button>
                <button class="admin-tab" onclick="showForm('create')">
                    <i class="fas fa-user-plus"></i>
                    Créer un Admin
                </button>
            </div>
            
            <div class="admin-form-container">
                <!-- Messages d'erreur/succès -->
                <div class="message-container">
                    <c:if test="${not empty error}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>${error}</span>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty success}">
                        <div class="success-message">
                            <i class="fas fa-check-circle"></i>
                            <span>${success}</span>
                        </div>
                    </c:if>
                </div>
                
                <!-- ========== FORMULAIRE DE CONNEXION ADMIN ========== -->
                <form id="loginForm" class="admin-form active" action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
                    <input type="hidden" name="action" value="login">
                    
                    <h2 class="form-title">
                        <i class="fas fa-sign-in-alt"></i>
                        Connexion Administrateur
                    </h2>
                    <p class="form-subtitle">
                        Accès sécurisé au dashboard d'administration
                    </p>
                    
                    <div class="form-group">
                        <label class="form-label" for="loginEmail">
                            <i class="fas fa-envelope"></i> Email Administrateur
                        </label>
                        <div class="input-with-icon">
                            <div class="input-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <input type="email" 
                                   id="loginEmail" 
                                   name="email" 
                                   class="form-input with-icon" 
                                   placeholder="admin@voyageconnect.com"
                                   required
                                   value="${param.email}"
                                   autocomplete="username">
                        </div>
                        <small style="color: var(--text-muted); display: block; margin-top: 5px;">
                            Seuls les emails @voyageconnect.com sont autorisés
                        </small>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label" for="loginPassword">
                            <i class="fas fa-lock"></i> Mot de passe
                        </label>
                        <div class="input-with-icon">
                            <div class="input-icon">
                                <i class="fas fa-lock"></i>
                            </div>
                            <input type="password" 
                                   id="loginPassword" 
                                   name="password" 
                                   class="form-input with-icon" 
                                   placeholder="Votre mot de passe administrateur"
                                   required
                                   autocomplete="current-password">
                            <button type="button" class="password-toggle" onclick="togglePassword('loginPassword', this)">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <!-- Section des exigences pour connexion -->
                    <div class="requirements-list">
                        <h4><i class="fas fa-shield-alt"></i> Sécurité d'accès :</h4>
                        <ul>
                            <li>Email doit se terminer par @voyageconnect.com</li>
                            <li>Mot de passe administrateur requis</li>
                            <li>Journalisation des connexions activée</li>
                            <li>Protection contre les attaques par force brute</li>
                        </ul>
                    </div>
                    
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-sign-in-alt"></i>
                        Accéder au Dashboard Admin
                    </button>
                </form>
                
                <!-- ========== FORMULAIRE DE CRÉATION D'ADMIN ========== -->
                <form id="createForm" class="admin-form" action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
                    <input type="hidden" name="action" value="create">
                    
                    <h2 class="form-title">
                        <i class="fas fa-user-plus"></i>
                        Créer un Nouvel Administrateur
                    </h2>
                    <p class="form-subtitle">
                        Ajouter un membre au personnel administratif
                    </p>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="createFirstName">
                                <i class="fas fa-user"></i> Prénom *
                            </label>
                            <input type="text" 
                                   id="createFirstName" 
                                   name="firstName" 
                                   class="form-input" 
                                   placeholder="Prénom"
                                   required
                                   value="${param.firstName}">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="createLastName">
                                <i class="fas fa-user-tag"></i> Nom *
                            </label>
                            <input type="text" 
                                   id="createLastName" 
                                   name="lastName" 
                                   class="form-input" 
                                   placeholder="Nom"
                                   required
                                   value="${param.lastName}">
                        </div>
                        
                        <div class="form-group full-width">
                            <label class="form-label" for="createEmail">
                                <i class="fas fa-envelope"></i> Email Administrateur *
                            </label>
                            <div class="input-with-icon">
                                <div class="input-icon">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <input type="email" 
                                       id="createEmail" 
                                       name="email" 
                                       class="form-input with-icon" 
                                       placeholder="nouveladmin@voyageconnect.com"
                                       required
                                       value="${param.email}">
                            </div>
                            <small style="color: var(--text-muted); display: block; margin-top: 5px;">
                                Doit se terminer par @voyageconnect.com
                            </small>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="createPhone">
                                <i class="fas fa-phone"></i> Téléphone
                            </label>
                            <input type="text" 
                                   id="createPhone" 
                                   name="phone" 
                                   class="form-input" 
                                   placeholder="+212XXXXXXXXX"
                                   value="${param.phone}">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="createRole">
                                <i class="fas fa-user-tag"></i> Rôle
                            </label>
                            <select id="createRole" name="role" class="form-input">
                                <option value="ADMIN" selected>Administrateur</option>
                                <option value="MANAGER">Manager</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="createPassword">
                                <i class="fas fa-lock"></i> Mot de passe *
                            </label>
                            <div class="input-with-icon">
                                <div class="input-icon">
                                    <i class="fas fa-lock"></i>
                                </div>
                                <input type="password" 
                                       id="createPassword" 
                                       name="password" 
                                       class="form-input with-icon" 
                                       placeholder="Mot de passe sécurisé"
                                       required
                                       minlength="8"
                                       oninput="checkPasswordStrength(this.value)">
                                <button type="button" class="password-toggle" onclick="togglePassword('createPassword', this)">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label" for="confirmPassword">
                                <i class="fas fa-lock"></i> Confirmer le mot de passe *
                            </label>
                            <div class="input-with-icon">
                                <div class="input-icon">
                                    <i class="fas fa-lock"></i>
                                </div>
                                <input type="password" 
                                       id="confirmPassword" 
                                       name="confirmPassword" 
                                       class="form-input with-icon" 
                                       placeholder="Répétez le mot de passe"
                                       required
                                       minlength="8">
                                <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword', this)">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Indicateur de force du mot de passe -->
                    <div id="passwordStrength" class="password-strength"></div>
                    
                    <!-- Section des exigences pour création -->
                    <div class="requirements-list">
                        <h4><i class="fas fa-list-check"></i> Exigences pour le compte admin :</h4>
                        <ul>
                            <li>Email doit être unique et se terminer par @voyageconnect.com</li>
                            <li>Mot de passe d'au moins 8 caractères</li>
                            <li>Doit contenir des majuscules, minuscules et chiffres</li>
                            <li>Les privilèges admin sont accordés immédiatement</li>
                            <li>Notification de création envoyée par email</li>
                        </ul>
                    </div>
                    
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-user-plus"></i>
                        Créer le Compte Administrateur
                    </button>
                </form>
                
                <!-- Lien retour -->
                <div class="back-link">
                    <a href="${pageContext.request.contextPath}/Acceuil.jsp">
                        <i class="fas fa-arrow-left"></i>
                        Retour à l'accueil
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Variables globales
        let currentForm = 'login';
        
        // Fonction pour afficher un formulaire
        function showForm(formType) {
            // Mettre à jour l'état actuel
            currentForm = formType;
            
            // Mettre à jour les tabs
            document.querySelectorAll('.admin-tab').forEach(tab => tab.classList.remove('active'));
            document.querySelectorAll('.admin-choice-card').forEach(card => card.classList.remove('active'));
            
            // Mettre à jour les formulaires
            document.querySelectorAll('.admin-form').forEach(form => form.classList.remove('active'));
            
            // Activer le bon formulaire et tab
            if (formType === 'login') {
                document.querySelector('.admin-tab:nth-child(1)').classList.add('active');
                document.getElementById('loginChoiceCard').classList.add('active');
                document.getElementById('loginForm').classList.add('active');
                document.getElementById('loginEmail').focus();
            } else {
                document.querySelector('.admin-tab:nth-child(2)').classList.add('active');
                document.getElementById('createChoiceCard').classList.add('active');
                document.getElementById('createForm').classList.add('active');
                document.getElementById('createFirstName').focus();
            }
        }
        
        // Toggle visibilité mot de passe
        function togglePassword(inputId, button) {
            const passwordInput = document.getElementById(inputId);
            const icon = button.querySelector('i');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
                button.style.color = '#dc2626';
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
                button.style.color = '#64748b';
            }
        }
        
        // Vérifier la force du mot de passe
        function checkPasswordStrength(password) {
            const strengthIndicator = document.getElementById('passwordStrength');
            
            if (!password) {
                strengthIndicator.className = 'password-strength';
                strengthIndicator.textContent = '';
                return;
            }
            
            let strength = 0;
            let message = '';
            
            // Vérifications
            if (password.length >= 8) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            // Déterminer le niveau
            if (strength < 3) {
                strengthIndicator.className = 'password-strength weak';
                message = 'Faible : Ajoutez des majuscules, minuscules et chiffres';
            } else if (strength < 5) {
                strengthIndicator.className = 'password-strength medium';
                message = 'Moyen : Ajoutez un caractère spécial pour renforcer';
            } else {
                strengthIndicator.className = 'password-strength strong';
                message = 'Fort : Mot de passe sécurisé ✓';
            }
            
            strengthIndicator.innerHTML = `
                <i class="fas fa-${strength < 3 ? 'exclamation-triangle' : strength < 5 ? 'check' : 'shield-alt'}"></i>
                ${message}
            `;
        }
        
        // Validation du formulaire de création
        document.getElementById('createForm').addEventListener('submit', function(e) {
            const email = document.getElementById('createEmail').value.trim();
            const password = document.getElementById('createPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const firstName = document.getElementById('createFirstName').value.trim();
            const lastName = document.getElementById('createLastName').value.trim();
            
            // Validation de l'email
            if (!email.endsWith('@voyageconnect.com')) {
                e.preventDefault();
                alert('L\'email doit se terminer par @voyageconnect.com');
                document.getElementById('createEmail').focus();
                return false;
            }
            
            // Validation des noms
            if (!firstName || !lastName) {
                e.preventDefault();
                alert('Veuillez remplir le prénom et le nom');
                return false;
            }
            
            // Validation du mot de passe
            if (password.length < 8) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins 8 caractères');
                document.getElementById('createPassword').focus();
                return false;
            }
            
            // Vérification des critères du mot de passe
            const hasUpperCase = /[A-Z]/.test(password);
            const hasLowerCase = /[a-z]/.test(password);
            const hasNumbers = /\d/.test(password);
            
            if (!hasUpperCase || !hasLowerCase || !hasNumbers) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre');
                document.getElementById('createPassword').focus();
                return false;
            }
            
            // Vérification de la confirmation du mot de passe
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas');
                document.getElementById('confirmPassword').focus();
                return false;
            }
            
            return true;
        });
        
        // Validation du formulaire de connexion
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.getElementById('loginEmail').value.trim();
            
            if (!email.endsWith('@voyageconnect.com')) {
                e.preventDefault();
                alert('Accès refusé : Seuls les emails @voyageconnect.com sont autorisés');
                document.getElementById('loginEmail').focus();
                return false;
            }
            
            return true;
        });
        
        // Auto-focus sur le premier champ au chargement
        document.addEventListener('DOMContentLoaded', function() {
            // Vérifier s'il y a un paramètre d'action dans l'URL
            const urlParams = new URLSearchParams(window.location.search);
            const action = urlParams.get('action');
            
            if (action === 'create') {
                showForm('create');
            } else {
                showForm('login');
            }
            
            // Animation d'entrée
            const formsSection = document.querySelector('.admin-forms-section');
            formsSection.style.opacity = '0';
            formsSection.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                formsSection.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                formsSection.style.opacity = '1';
                formsSection.style.transform = 'translateY(0)';
            }, 100);
            
            // Formatage automatique du téléphone
            const phoneInput = document.getElementById('createPhone');
            if (phoneInput) {
                phoneInput.addEventListener('input', function(e) {
                    let value = this.value.replace(/\D/g, '');
                    
                    if (value.length > 0) {
                        // Format +212 X XX XX XX XX
                        if (!value.startsWith('212') && value.length > 9) {
                            value = '212' + value.substring(0, 9);
                        }
                        
                        let formatted = '';
                        if (value.startsWith('212')) {
                            formatted = '+212 ';
                            value = value.substring(3);
                        }
                        
                        for (let i = 0; i < value.length; i++) {
                            if (i === 2 || i === 4 || i === 6 || i === 8) {
                                formatted += ' ';
                            }
                            formatted += value[i];
                        }
                        this.value = formatted;
                    }
                });
            }
        });
        
        // Validation en temps réel pour l'email admin
        document.getElementById('createEmail')?.addEventListener('blur', function() {
            const email = this.value.trim();
            if (email && !email.endsWith('@voyageconnect.com')) {
                this.style.borderColor = '#dc2626';
                this.style.backgroundColor = '#fef2f2';
            } else {
                this.style.borderColor = '';
                this.style.backgroundColor = '';
            }
        });
        
        document.getElementById('loginEmail')?.addEventListener('blur', function() {
            const email = this.value.trim();
            if (email && !email.endsWith('@voyageconnect.com')) {
                this.style.borderColor = '#dc2626';
                this.style.backgroundColor = '#fef2f2';
            } else {
                this.style.borderColor = '';
                this.style.backgroundColor = '';
            }
        });
    </script>
</body>
</html>