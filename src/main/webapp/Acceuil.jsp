<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Accueil - VoyageConnect</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    
    body {
        background-color: #f8fafc;
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }
    
    .main-content {
        flex: 1;
    }
    
    .hero-section {
        background: linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)), 
                    url('https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');
        background-size: cover;
        background-position: center;
        height: 85vh;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        color: white;
        padding: 0 20px;
        position: relative;
    }
    
    .hero-content {
        max-width: 800px;
        z-index: 2;
    }
    
    .hero-content h1 {
        font-size: 3.5rem;
        margin-bottom: 20px;
        text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5);
        font-weight: 800;
    }
    
    .hero-content p {
        font-size: 1.3rem;
        margin-bottom: 30px;
        line-height: 1.6;
        text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5);
    }
    
    .cta-buttons {
        display: flex;
        gap: 20px;
        justify-content: center;
        flex-wrap: wrap;
    }
    
    .cta-button {
        display: inline-block;
        background: linear-gradient(135deg, #1a56db 0%, #0ea5e9 100%);
        color: white;
        padding: 15px 35px;
        border-radius: 30px;
        text-decoration: none;
        font-weight: 600;
        font-size: 1.1rem;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(26, 86, 219, 0.3);
        border: 2px solid transparent;
    }
    
    .cta-button:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 25px rgba(26, 86, 219, 0.4);
        border-color: white;
    }
    
    .cta-button.secondary {
        background: transparent;
        border: 2px solid white;
    }
    
    .cta-button.secondary:hover {
        background: rgba(255, 255, 255, 0.1);
    }
    
    .destination-info {
        position: absolute;
        bottom: 30px;
        left: 30px;
        background: rgba(0, 0, 0, 0.7);
        padding: 15px 25px;
        border-radius: 10px;
        color: white;
        max-width: 400px;
    }
    
    .destination-info h3 {
        font-size: 1.5rem;
        margin-bottom: 5px;
        color: #fbbf24;
    }
    
    .destination-info p {
        font-size: 1rem;
        opacity: 0.9;
    }
    
    @media (max-width: 768px) {
        .hero-content h1 {
            font-size: 2.5rem;
        }
        
        .hero-content p {
            font-size: 1.1rem;
        }
        
        .cta-buttons {
            flex-direction: column;
            align-items: center;
        }
        
        .cta-button {
            width: 100%;
            max-width: 250px;
        }
        
        .destination-info {
            left: 20px;
            right: 20px;
            max-width: none;
        }
    }
</style>
</head>
<body>
<%@include file="Header.jsp" %>

<div class="main-content">
    <!-- Section unique avec image de destination -->
    <section class="hero-section">
        <div class="hero-content">
            <h1>Explorez le monde avec VoyageConnect</h1>
            <p>Découvrez des destinations extraordinaires, vivez des expériences uniques et créez des souvenirs inoubliables. Votre prochaine aventure vous attend.</p>
            
            <div class="cta-buttons">
                <a href="${pageContext.request.contextPath}/destinations" class="cta-button">
                    <i class="fas fa-globe-americas"></i> Voir les destinations
                </a>
                <a href="${pageContext.request.contextPath}/destinations" class="cta-button secondary">
                    <i class="fas fa-search"></i> Rechercher un voyage
                </a>
            </div>
        </div>
        
        <!-- Info sur la destination de l'image -->
        <div class="destination-info">
            <h3><i class="fas fa-map-marker-alt"></i> Îles Maldives</h3>
            <p>Paradis tropical avec plages de sable blanc et eaux turquoise. L'évasion parfaite pour un voyage de rêve.</p>
        </div>
    </section>
</div>

<%@include file="Footer.jsp" %>

<script>
    // Animation simple pour le contenu
    document.addEventListener('DOMContentLoaded', function() {
        const heroContent = document.querySelector('.hero-content');
        const destinationInfo = document.querySelector('.destination-info');
        
        // Animation d'apparition
        heroContent.style.opacity = '0';
        heroContent.style.transform = 'translateY(20px)';
        heroContent.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
        
        destinationInfo.style.opacity = '0';
        destinationInfo.style.transform = 'translateY(20px)';
        destinationInfo.style.transition = 'opacity 0.8s ease 0.3s, transform 0.8s ease 0.3s';
        
        // Démarrer l'animation après un court délai
        setTimeout(() => {
            heroContent.style.opacity = '1';
            heroContent.style.transform = 'translateY(0)';
            
            destinationInfo.style.opacity = '1';
            destinationInfo.style.transform = 'translateY(0)';
        }, 300);
    });
</script>
</body>
</html>