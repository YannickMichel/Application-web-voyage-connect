<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<meta charset="UTF-8">
<title>Insert title here</title>

<style>
        /* Footer principal */
        .voyage-footer {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            color: #e2e8f0;
            padding: 3rem 0 1rem;
            margin-top: 4rem;
            position: relative;
            overflow: hidden;
        }
        
        .voyage-footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(90deg, #1a56db, #fbbf24, #0ea5e9);
        }
        
        /* Container du contenu */
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }
        
        /* Logo footer */
        .footer-logo {
            color: white;
            font-size: 1.8rem;
            font-weight: 800;
            text-decoration: none;
            display: inline-block;
            margin-bottom: 1rem;
        }
        
        .footer-logo i {
            color: #fbbf24;
            margin-right: 10px;
        }
        
        /* Texte principal */
        .footer-slogan {
            font-size: 1.2rem;
            color: #94a3b8;
            margin-bottom: 1.5rem;
            line-height: 1.6;
        }
        
        .footer-text {
            color: #94a3b8;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }
        
        /* Titres sections */
        .footer-title {
            color: white;
            font-size: 1.3rem;
            margin-bottom: 1.5rem;
            position: relative;
            padding-bottom: 10px;
        }
        
        .footer-title::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 40px;
            height: 3px;
            background: #fbbf24;
            border-radius: 2px;
        }
        
        /* Liens */
        .footer-links {
            list-style: none;
            padding: 0;
        }
        
        .footer-links li {
            margin-bottom: 0.8rem;
        }
        
        .footer-links a {
            color: #cbd5e1;
            text-decoration: none;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .footer-links a:hover {
            color: white;
            transform: translateX(5px);
        }
        
        .footer-links a i {
            color: #0ea5e9;
        }
        
        /* Contact */
        .contact-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 1rem;
        }
        
        .contact-item i {
            color: #fbbf24;
            margin-top: 3px;
        }
        
        /* Newsletter */
        .newsletter {
            margin-top: 1.5rem;
        }
        
        .newsletter-input {
            width: 100%;
            padding: 12px 15px;
            border: none;
            border-radius: 25px;
            background: #334155;
            color: white;
            margin-bottom: 10px;
        }
        
        .newsletter-btn {
            width: 100%;
            padding: 12px;
            background: #1a56db;
            color: white;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .newsletter-btn:hover {
            background: #0ea5e9;
            transform: translateY(-2px);
        }
        
        /* Bas du footer */
        .footer-bottom {
            text-align: center;
            padding-top: 2rem;
            margin-top: 3rem;
            border-top: 1px solid #334155;
            color: #94a3b8;
        }
        
        .social-icons {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin: 1.5rem 0;
        }
        
        .social-icon {
            color: #cbd5e1;
            font-size: 1.3rem;
            transition: all 0.3s;
        }
        
        .social-icon:hover {
            color: white;
            transform: translateY(-5px);
        }
        
        /* Back to top */
        .back-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            width: 50px;
            height: 50px;
            background: #1a56db;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 1.2rem;
            box-shadow: 0 4px 15px rgba(26, 86, 219, 0.3);
            transition: all 0.3s;
            opacity: 0;
            visibility: hidden;
            z-index: 1000;
        }
        
        .back-top.show {
            opacity: 1;
            visibility: visible;
        }
        
        .back-top:hover {
            background: #0ea5e9;
            transform: translateY(-5px);
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .footer-content {
                text-align: center;
            }
            
            .footer-title::after {
                left: 50%;
                transform: translateX(-50%);
            }
            
            .footer-links a {
                justify-content: center;
            }
            
            .contact-item {
                justify-content: center;
            }
            
            .back-top {
                bottom: 20px;
                right: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Footer -->
    <footer class="voyage-footer">
        <div class="footer-content">
            <!-- Colonne 1: Présentation -->
            <div>
                <a href="${pageContext.request.contextPath}/" class="footer-logo">
                    <i class="fas fa-plane-departure"></i>VoyageConnect
                </a>
                
                <p class="footer-slogan">
                    ✈️ Votre passeport vers l'extraordinaire
                </p>
                
                <p class="footer-text">
                    Depuis 2020, nous transformons vos rêves de voyage en réalités inoubliables. 
                    Des plages paradisiaques aux sommets enneigés, nous vous accompagnons à chaque étape.
                </p>
                
                <p class="footer-text">
                    <i class="fas fa-award" style="color: #fbbf24;"></i>
                    <strong> 5000+ voyageurs satisfaits</strong>
                </p>
            </div>
            
            <!-- Colonne 2: Liens rapides -->
            <div>
                <h3 class="footer-title">Explorez</h3>
                <ul class="footer-links">
                    <li>
                        <a href="${pageContext.request.contextPath}/destinations">
                            <i class="fas fa-chevron-right"></i>Destinations populaires
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/offres">
                            <i class="fas fa-chevron-right"></i>Offres spéciales
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/guides">
                            <i class="fas fa-chevron-right"></i>Guides de voyage
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/circuits">
                            <i class="fas fa-chevron-right"></i>Circuits organisés
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Colonne 3: Contact -->
            <div>
                <h3 class="footer-title">Contact</h3>
                
                <div class="contact-item">
                    <i class="fas fa-map-marker-alt"></i>
                    <div>
                        <strong>Rabat, Maroc</strong><br>
                        Agdal Avenue de France
                    </div>
                </div>
                
                <div class="contact-item">
                    <i class="fas fa-phone"></i>
                    <div>
                        <strong>+212 07 04 58 00 22</strong><br>
                        Lun-Ven: 9h-18h
                    </div>
                </div>
                
                <div class="contact-item">
                    <i class="fas fa-envelope"></i>
                    <div>
                        <strong>contact@voyageconnect.com</strong><br>
                        Réponse sous 24h
                    </div>
                </div>
                
                <!-- Newsletter -->
                <div class="newsletter">
                    <h4 style="color: white; margin-bottom: 1rem;">Restez informés</h4>
                    <input type="email" class="newsletter-input" placeholder="Votre email">
                    <button class="newsletter-btn">S'abonner</button>
                </div>
            </div>
        </div>
        
        <!-- Bas du footer -->
        <div class="footer-bottom">
            <div class="social-icons">
                <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-tiktok"></i></a>
                <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
            </div>
            
            <p>
                &copy; 2024 VoyageConnect - Tous droits réservés | 
                <a href="#" style="color: #0ea5e9; text-decoration: none;">Mentions légales</a> | 
                <a href="#" style="color: #0ea5e9; text-decoration: none;">Politique de confidentialité</a>
            </p>
            
            <p style="margin-top: 1rem; font-size: 0.9rem;">
                <i class="fas fa-heart" style="color: #ef4444;"></i>
                Conçu avec passion pour vos plus beaux voyages
            </p>
        </div>
    </footer>
    
    <!-- Bouton retour en haut -->
    <a href="#" class="back-top" id="backTop">
        <i class="fas fa-chevron-up"></i>
    </a>
    
    <script>
        // Bouton retour en haut
        const backTop = document.getElementById('backTop');
        
        window.addEventListener('scroll', function() {
            if (window.scrollY > 300) {
                backTop.classList.add('show');
            } else {
                backTop.classList.remove('show');
            }
        });
        
        backTop.addEventListener('click', function(e) {
            e.preventDefault();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
        
        // Newsletter
        document.querySelector('.newsletter-btn').addEventListener('click', function() {
            const email = document.querySelector('.newsletter-input').value;
            if (email) {
                alert('Merci ! Vous recevrez nos meilleures offres à ' + email);
                document.querySelector('.newsletter-input').value = '';
            }
        });
        
        // Enter pour newsletter
        document.querySelector('.newsletter-input').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.querySelector('.newsletter-btn').click();
            }
        });
        
        // Année actuelle dans le copyright
        document.addEventListener('DOMContentLoaded', function() {
            const year = new Date().getFullYear();
            document.querySelector('.footer-bottom p').innerHTML = 
                document.querySelector('.footer-bottom p').innerHTML.replace('2024', year);
        });
    </script>
</body>
</html>