<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Connexion/Inscription - VoyageConnect</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    /* Styles généraux */
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        padding: 0;
        background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        min-height: 100vh;
        color: #333;
    }
    
    .register-container {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: calc(100vh - 120px);
        padding: 40px 20px;
        animation: fadeIn 0.8s ease-out;
    }
    
    .register-card {
        background: white;
        border-radius: 20px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        padding: 40px;
        width: 100%;
        max-width: 500px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    
    .register-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 25px 70px rgba(0, 0, 0, 0.15);
    }
    
    .register-header {
        text-align: center;
        margin-bottom: 30px;
    }
    
    .register-header h1 {
        color: #1a56db;
        font-size: 2.2rem;
        margin-bottom: 10px;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 15px;
    }
    
    .register-header p {
        color: #64748b;
        font-size: 1.1rem;
    }
    
    /* Tabs Connexion/Inscription - CORRIGÉ */
    .auth-tabs {
        display: flex;
        margin-bottom: 30px;
        border-radius: 12px;
        background: #f1f5f9;
        padding: 5px;
        overflow: hidden;
        position: relative;
    }
    
    .auth-tabs::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 50%;
        height: 3px;
        background: #1a56db;
        transition: transform 0.3s ease;
        z-index: 1;
    }
    
    /* Position de la ligne active par défaut */
    .auth-tabs.login-active::after {
        transform: translateX(0);
    }
    
    .auth-tabs.register-active::after {
        transform: translateX(100%);
    }
    
    .auth-tab {
        flex: 1;
        padding: 18px;
        border: none;
        background: none;
        font-weight: 600;
        font-size: 1.1rem;
        cursor: pointer;
        border-radius: 8px;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        color: #64748b;
        position: relative;
        z-index: 2;
    }
    
    .auth-tab.active {
        color: #1a56db;
        background: rgba(255, 255, 255, 0.9);
    }
    
    /* Formulaires - CORRIGÉ */
    .auth-form {
        display: none;
        animation: slideUp 0.5s ease;
    }
    
    .auth-form.active {
        display: block;
    }
    
    .form-row {
        display: flex;
        gap: 20px;
        margin-bottom: 20px;
    }
    
    .form-group {
        margin-bottom: 25px;
        position: relative;
        flex: 1;
    }
    
    .form-label {
        display: block;
        margin-bottom: 10px;
        font-weight: 600;
        color: #374151;
        font-size: 0.95rem;
        transition: color 0.3s;
    }
    
    .form-label i {
        margin-right: 8px;
        color: #1a56db;
    }
    
    .input-with-icon {
        position: relative;
    }
    
    .input-icon {
        position: absolute;
        left: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #9ca3af;
        transition: color 0.3s;
        z-index: 1;
    }
    
    .form-input {
        width: 100%;
        padding: 16px 16px 16px 50px;
        border: 2px solid #e5e7eb;
        border-radius: 12px;
        font-size: 1rem;
        transition: all 0.3s;
        box-sizing: border-box;
        background: #f9fafb;
        position: relative;
    }
    
    .form-input:focus {
        outline: none;
        border-color: #1a56db;
        box-shadow: 0 0 0 3px rgba(26, 86, 219, 0.1);
        background: white;
    }
    
    .form-input:focus + .input-icon {
        color: #1a56db;
    }
    
    /* Password toggle */
    .password-toggle {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        color: #9ca3af;
        cursor: pointer;
        font-size: 1.1rem;
        transition: color 0.3s;
        padding: 5px;
        z-index: 2;
    }
    
    .password-toggle:hover {
        color: #1a56db;
    }
    
    /* Terms checkbox */
    .terms-group {
        display: flex;
        align-items: flex-start;
        gap: 15px;
        margin: 30px 0;
        padding: 20px;
        background: #f8fafc;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
    }
    
    .terms-checkbox {
        margin-top: 4px;
        accent-color: #1a56db;
        width: 20px;
        height: 20px;
        cursor: pointer;
    }
    
    .terms-label {
        font-size: 0.9rem;
        color: #4b5563;
        line-height: 1.5;
    }
    
    .terms-label a {
        color: #1a56db;
        text-decoration: none;
        font-weight: 600;
    }
    
    .terms-label a:hover {
        text-decoration: underline;
    }
    
    /* Boutons */
    .register-btn {
        width: 100%;
        padding: 18px;
        background: linear-gradient(135deg, #1a56db 0%, #3b82f6 100%);
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 12px;
        box-shadow: 0 4px 15px rgba(26, 86, 219, 0.3);
    }
    
    .register-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(26, 86, 219, 0.4);
        background: linear-gradient(135deg, #1e40af 0%, #2563eb 100%);
    }
    
    .register-btn:active {
        transform: translateY(0);
    }
    
    /* Links */
    .login-link {
        text-align: center;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #e5e7eb;
        color: #6b7280;
    }
    
    .login-link a {
        color: #1a56db;
        text-decoration: none;
        font-weight: 600;
        margin-left: 5px;
        transition: color 0.3s;
    }
    
    .login-link a:hover {
        color: #1e40af;
        text-decoration: underline;
    }
    
    /* Messages d'erreur */
    .error-message {
        background: #fee2e2;
        color: #dc2626;
        padding: 15px 20px;
        border-radius: 12px;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        gap: 12px;
        border: 1px solid #fecaca;
        animation: shake 0.5s;
    }
    
    /* Password strength indicator */
    .password-strength {
        margin-top: 10px;
        padding: 10px;
        border-radius: 8px;
        font-size: 0.9rem;
        text-align: center;
        transition: all 0.3s;
    }
    
    /* Animations */
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    @keyframes slideUp {
        from { 
            opacity: 0;
            transform: translateY(20px);
        }
        to { 
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    @keyframes shake {
        0%, 100% { transform: translateX(0); }
        25% { transform: translateX(-5px); }
        75% { transform: translateX(5px); }
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .register-card {
            padding: 30px 20px;
            margin: 20px;
        }
        
        .form-row {
            flex-direction: column;
            gap: 0;
        }
        
        .auth-tab {
            padding: 15px 10px;
            font-size: 1rem;
        }
        
        .register-header h1 {
            font-size: 1.8rem;
        }
    }
</style>
</head>
<body>
<%@include file="Header.jsp" %>

<div class="register-container">
    <div class="register-card">
        <div class="register-header">
            <h1>
                <c:choose>
                    <c:when test="${param.mode == 'register' || mode == 'register'}">
                        <i class="fas fa-user-plus"></i> Inscription
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-sign-in-alt"></i> Connexion
                    </c:otherwise>
                </c:choose>
            </h1>
            <p>
                <c:choose>
                    <c:when test="${param.mode == 'register' || mode == 'register'}">
                        Rejoignez notre communauté de voyageurs
                    </c:when>
                    <c:otherwise>
                        Accédez à votre espace personnel
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        
        <!-- Tabs Connexion/Inscription - CORRIGÉ -->
        <div class="auth-tabs ${empty param.mode and empty mode ? 'login-active' : (param.mode != 'register' and mode != 'register' ? 'login-active' : 'register-active')}">
            <button type="button" class="auth-tab ${empty param.mode and empty mode ? 'active' : (param.mode != 'register' and mode != 'register' ? 'active' : '')}" 
                    onclick="showLoginForm()">
                <i class="fas fa-sign-in-alt"></i> Connexion
            </button>
            <button type="button" class="auth-tab ${param.mode == 'register' or mode == 'register' ? 'active' : ''}" 
                    onclick="showRegisterForm()">
                <i class="fas fa-user-plus"></i> Inscription
            </button>
        </div>
        
        <!-- Messages d'erreur/succès -->
        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>
        
        <!-- ========== FORMULAIRE DE CONNEXION ========== -->
        <form id="loginForm" class="auth-form ${empty param.mode and empty mode ? 'active' : (param.mode != 'register' and mode != 'register' ? 'active' : '')}" 
              action="${pageContext.request.contextPath}/LoginServlet" method="post">
            
            <!-- AJOUT: Champ caché pour indiquer que c'est une connexion -->
            <input type="hidden" name="action" value="login">
            
            <div class="form-group">
                <label class="form-label" for="loginEmail">
                    <i class="fas fa-envelope"></i> Adresse email *
                </label>
                <div class="input-with-icon">
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <input type="email" 
                           id="loginEmail" 
                           name="email" 
                           class="form-input" 
                           placeholder="exemple@email.com"
                           required
                           value="${param.email}">
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="loginPassword">
                    <i class="fas fa-lock"></i> Mot de passe *
                </label>
                <div class="input-with-icon">
                    <div class="input-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <input type="password" 
                           id="loginPassword" 
                           name="password" 
                           class="form-input" 
                           placeholder="Votre mot de passe"
                           required>
                    <button type="button" class="password-toggle" onclick="togglePassword('loginPassword', this)">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
            </div>
            
            <button type="submit" class="register-btn">
                <i class="fas fa-sign-in-alt"></i> Se connecter
            </button>
            
            <div class="login-link">
                Pas encore de compte ? 
                <a href="javascript:void(0)" onclick="showRegisterForm()">
                    S'inscrire maintenant
                </a>
            </div>
        </form>
        
        <!-- ========== FORMULAIRE D'INSCRIPTION ========== -->
        <form id="registerForm" class="auth-form ${param.mode == 'register' or mode == 'register' ? 'active' : ''}" 
              action="${pageContext.request.contextPath}/LoginServlet" method="post">
            
            <!-- Champ caché pour indiquer que c'est une inscription -->
            <input type="hidden" name="action" value="register">
            
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="firstName">
                        <i class="fas fa-user"></i> Prénom *
                    </label>
                    <div class="input-with-icon">
                        <div class="input-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        <input type="text" 
                               id="firstName" 
                               name="firstName" 
                               class="form-input" 
                               placeholder="Votre prénom"
                               required
                               value="${param.firstName}">
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label" for="lastName">
                        <i class="fas fa-user-tag"></i> Nom *
                    </label>
                    <div class="input-with-icon">
                        <div class="input-icon">
                            <i class="fas fa-user-tag"></i>
                        </div>
                        <input type="text" 
                               id="lastName" 
                               name="lastName" 
                               class="form-input" 
                               placeholder="Votre nom"
                               required
                               value="${param.lastName}">
                    </div>
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="registerEmail">
                    <i class="fas fa-envelope"></i> Adresse email *
                </label>
                <div class="input-with-icon">
                    <div class="input-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <input type="email" 
                           id="registerEmail" 
                           name="email" 
                           class="form-input" 
                           placeholder="exemple@email.com"
                           required
                           value="${param.email}">
                </div>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="phone">
                    <i class="fas fa-phone"></i> Numéro de téléphone
                </label>
                <div class="input-with-icon">
                    <div class="input-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <input type="text" 
                           id="phone" 
                           name="phone" 
                           class="form-input" 
                           placeholder="06 12 34 56 78"
                           value="${param.phone}">
                </div>
                <small style="color: #64748b; display: block; margin-top: 8px; font-size: 0.85rem;">
                    Format: 10 chiffres (ex: 06 12 34 56 78)
                </small>
            </div>
            
            <div class="form-group">
                <label class="form-label" for="registerPassword">
                    <i class="fas fa-lock"></i> Mot de passe *
                </label>
                <div class="input-with-icon">
                    <div class="input-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <input type="password" 
                           id="registerPassword" 
                           name="password" 
                           class="form-input" 
                           placeholder="Créez un mot de passe sécurisé"
                           required
                           minlength="8">
                    <button type="button" class="password-toggle" onclick="togglePassword('registerPassword', this)">
                        <i class="fas fa-eye"></i>
                    </button>
                </div>
                <small style="color: #64748b; display: block; margin-top: 8px; font-size: 0.85rem;">
                    Minimum 8 caractères avec majuscule, minuscule et chiffre
                </small>
            </div>
            
            <div class="terms-group">
                <input type="checkbox" 
                       id="terms" 
                       name="terms" 
                       class="terms-checkbox"
                       required>
                <label for="terms" class="terms-label">
                    J'accepte les <a href="#">Conditions d'utilisation</a> et la 
                    <a href="#">Politique de confidentialité</a> de VoyageConnect. 
                    Je consens au traitement de mes données personnelles.
                </label>
            </div>
            
            <button type="submit" class="register-btn">
                <i class="fas fa-user-plus"></i> Créer mon compte
            </button>
            
            <div class="login-link">
                Vous avez déjà un compte ? 
                <a href="javascript:void(0)" onclick="showLoginForm()">
                    Se connecter
                </a>
            </div>
        </form>
    </div>
</div>

<%@include file="Footer.jsp" %>

<script>
    // Fonction pour afficher le formulaire de connexion
    function showLoginForm() {
        // Mettre à jour les tabs
        document.querySelectorAll('.auth-tab').forEach(tab => tab.classList.remove('active'));
        document.querySelector('.auth-tab:nth-child(1)').classList.add('active');
        
        // Mettre à jour les formulaires
        document.querySelectorAll('.auth-form').forEach(form => form.classList.remove('active'));
        document.getElementById('loginForm').classList.add('active');
        
        // Mettre à jour la classe du conteneur des tabs
        document.querySelector('.auth-tabs').classList.remove('register-active');
        document.querySelector('.auth-tabs').classList.add('login-active');
        
        // Mettre à jour le titre
        document.querySelector('.register-header h1').innerHTML = '<i class="fas fa-sign-in-alt"></i> Connexion';
        document.querySelector('.register-header p').textContent = 'Accédez à votre espace personnel';
        
        // Focus sur le premier champ
        document.getElementById('loginEmail').focus();
    }
    
    // Fonction pour afficher le formulaire d'inscription
    function showRegisterForm() {
        // Mettre à jour les tabs
        document.querySelectorAll('.auth-tab').forEach(tab => tab.classList.remove('active'));
        document.querySelector('.auth-tab:nth-child(2)').classList.add('active');
        
        // Mettre à jour les formulaires
        document.querySelectorAll('.auth-form').forEach(form => form.classList.remove('active'));
        document.getElementById('registerForm').classList.add('active');
        
        // Mettre à jour la classe du conteneur des tabs
        document.querySelector('.auth-tabs').classList.remove('login-active');
        document.querySelector('.auth-tabs').classList.add('register-active');
        
        // Mettre à jour le titre
        document.querySelector('.register-header h1').innerHTML = '<i class="fas fa-user-plus"></i> Inscription';
        document.querySelector('.register-header p').textContent = 'Rejoignez notre communauté de voyageurs';
        
        // Focus sur le premier champ
        document.getElementById('firstName').focus();
    }
    
    // Toggle visibilité mot de passe
    function togglePassword(inputId, button) {
        const passwordInput = document.getElementById(inputId);
        const icon = button.querySelector('i');
        
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
            button.style.color = '#1a56db';
        } else {
            passwordInput.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
            button.style.color = '#9ca3af';
        }
    }
    
    // Validation pour l'inscription
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = document.getElementById('registerPassword').value;
        const terms = document.getElementById('terms').checked;
        const phone = document.getElementById('phone').value;
        
        // Validation du téléphone (optionnel mais formaté correctement si rempli)
        if (phone.trim() !== '') {
            const phoneDigits = phone.replace(/\s/g, '');
            if (phoneDigits.length !== 10 || !/^\d{10}$/.test(phoneDigits)) {
                e.preventDefault();
                alert('Le numéro de téléphone doit contenir 10 chiffres.');
                return false;
            }
        }
        
        // Vérifier la force du mot de passe
        if (password.length < 8) {
            e.preventDefault();
            alert('Le mot de passe doit contenir au moins 8 caractères.');
            return false;
        }
        
        // Vérifier les critères du mot de passe
        const hasUpperCase = /[A-Z]/.test(password);
        const hasLowerCase = /[a-z]/.test(password);
        const hasNumbers = /\d/.test(password);
        
        if (!hasUpperCase || !hasLowerCase || !hasNumbers) {
            e.preventDefault();
            alert('Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre.');
            return false;
        }
        
        // Vérifier l'acceptation des conditions
        if (!terms) {
            e.preventDefault();
            alert('Vous devez accepter les conditions d\'utilisation.');
            return false;
        }
        
        // Validation de l'email
        const email = document.getElementById('registerEmail').value;
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            e.preventDefault();
            alert('Veuillez entrer une adresse email valide.');
            return false;
        }
        
        // Formatage final du téléphone pour l'envoi (supprimer les espaces)
        if (phone.trim() !== '') {
            const phoneInput = document.getElementById('phone');
            phoneInput.value = phone.replace(/\s/g, '');
        }
        
        return true;
    });
    
    // Validation en temps réel pour le mot de passe d'inscription
    document.getElementById('registerPassword').addEventListener('input', function() {
        const password = this.value;
        const strengthIndicator = document.createElement('div');
        
        // Supprimer l'ancien indicateur s'il existe
        const oldIndicator = this.parentNode.querySelector('.password-strength');
        if (oldIndicator) oldIndicator.remove();
        
        if (password.length === 0) return;
        
        strengthIndicator.className = 'password-strength';
        
        let strength = 0;
        let message = '';
        let color = '';
        let bgColor = '';
        
        // Vérifications de base
        if (password.length >= 8) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;
        
        // Déterminer le message et la couleur
        switch(strength) {
            case 1:
            case 2:
                message = 'Faible';
                color = '#dc2626';
                bgColor = '#fee2e2';
                break;
            case 3:
                message = 'Moyen';
                color = '#f59e0b';
                bgColor = '#fef3c7';
                break;
            case 4:
                message = 'Bon';
                color = '#0ea5e9';
                bgColor = '#e0f2fe';
                break;
            case 5:
                message = 'Très bon';
                color = '#16a34a';
                bgColor = '#dcfce7';
                break;
        }
        
        strengthIndicator.innerHTML = `
            <span>Force du mot de passe: </span>
            <span style="font-weight: bold; color: ${color}">${message}</span>
        `;
        strengthIndicator.style.backgroundColor = bgColor;
        strengthIndicator.style.color = color;
        
        this.parentNode.appendChild(strengthIndicator);
    });
    
    // Formatage automatique du téléphone
    document.getElementById('phone').addEventListener('input', function(e) {
        let value = this.value.replace(/\D/g, '');
        
        // Limiter à 10 chiffres
        if (value.length > 10) {
            value = value.substring(0, 10);
        }
        
        // Formatage français avec espacement
        if (value.length > 0) {
            let formatted = '';
            for (let i = 0; i < value.length; i++) {
                if (i === 2 || i === 4 || i === 6 || i === 8) {
                    formatted += ' ';
                }
                formatted += value[i];
            }
            value = formatted;
        }
        
        this.value = value;
    });
    
    // Initialisation au chargement
    document.addEventListener('DOMContentLoaded', function() {
        // Déterminer quel formulaire afficher par défaut
        const isRegisterMode = ${param.mode == 'register' or mode == 'register'};
        
        if (isRegisterMode) {
            // S'assurer que le formulaire d'inscription est actif
            document.querySelector('.auth-tab:nth-child(2)').classList.add('active');
            document.getElementById('registerForm').classList.add('active');
            document.getElementById('loginForm').classList.remove('active');
            document.querySelector('.auth-tabs').classList.add('register-active');
            document.querySelector('.auth-tabs').classList.remove('login-active');
            document.getElementById('firstName').focus();
        } else {
            // S'assurer que le formulaire de connexion est actif
            document.querySelector('.auth-tab:nth-child(1)').classList.add('active');
            document.getElementById('loginForm').classList.add('active');
            document.getElementById('registerForm').classList.remove('active');
            document.querySelector('.auth-tabs').classList.add('login-active');
            document.querySelector('.auth-tabs').classList.remove('register-active');
            document.getElementById('loginEmail').focus();
        }
        
        // Animation d'entrée
        document.querySelector('.register-card').style.animation = 'slideUp 0.5s ease-out';
    });
    
    // Effet de focus sur les champs
    document.querySelectorAll('.form-input').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.parentElement.querySelector('.form-label').style.color = '#1a56db';
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.parentElement.querySelector('.form-label').style.color = '#374151';
        });
    });
</script>
</body>
</html>