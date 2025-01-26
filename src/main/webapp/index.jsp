<%--
  Created by IntelliJ IDEA.
  User: pabod
  Date: 1/25/2025
  Time: 11:20 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Personal Chef Website Landing Page</title>
    <link rel="stylesheet" href="style.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap');

        * {
            margin: 0;
            padding: 0;
            scroll-behavior: smooth;
            box-sizing: border-box;
            scroll-padding-top: 2rem;
            list-style: none;
            text-decoration: none;
            font-family: 'Poppins', sans-serif;
        }

        :root {
            --main-color: #f54744;
            --text-color: #2f2f2f;
            --bg-color: #fff;

            --big-font: 3.2rem;
            --h2-font: 2rem;
        }

        section { padding: 50px 10%; }
        body { color: var(--text-color); background: var(--bg-color); }

        header {
            position: fixed;
            width: 100%;
            top: 0;
            right: 0;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #fff4f3;
            padding: 18px 10%;
        }

        .logo { font-size: 1.2rem; font-weight: 600; color: var(--main-color); }
        .navbar { display: flex; }
        .navbar a {
            font-size: 1rem;
            padding: 10px 20px;
            color: var(--text-color);
            font-weight: 500;
            transition: .5s ease;
        }

        .navbar a:hover { background: var(--main-color); color: #fff; border-radius: 2rem; }

        .dropdown .dropbtn {
            cursor: pointer;
        }

        .navbar li .dropdown-content {
            display: none;
            position: absolute;
            background-color: inherit;
            min-width: 160px;
            box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
            z-index: 1;
        }

        .navbar li .dropdown-content a {
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
            /* Keep the color styles from the navbar */
        }

        .navbar li:hover .dropdown-content {
            display: block;
        }

        .navbar li a:hover {
        }

        .navbar li .dropdown-content a:hover {
        }

        #menu-icon {
            font-size: 2rem;
            cursor: pointer;
            display: none;
        }

        .home {
            width: 100%;
            min-height: 100vh;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            align-items: center;
            background: #fff4f3;
            gap: 1.5rem;
        }

        .home-img img { width: 90%; }

        .home-text h3 {
            color: var(--main-color);
            font-size: 1rem;
            font-weight: 400;
            padding: 10px;
            width: 160px;
            border-radius: 2rem;
            background: #feeceb;
        }

        .home-text h1 { font-size: var(--big-font); }
        .home-text span { color: var(--main-color); }
        .home-text p { min-width: 80%; margin: 1rem 0 1.1rem; }

        .btn {
            background: var(--main-color);
            display: inline-block;
            padding: 10px 20px;
            border-radius: 2rem;
            color: #fff;
        }

        .btn:hover { background: #fc5552; }

        .heading { text-align: center; }
        .heading p { text-transform: uppercase; font-weight: 500; color: var(--main-color); }
        .heading h2 { font-size: var(--h2-font); }

        .services-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, auto));
            gap: 1.5rem;
            margin-top: 4rem;
        }

        .box {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        .box img { width: 100px; height: 100px; object-fit: contain; }
        .box h2 { font-size: 1.2rem; margin: 1.7rem 0 1rem; }

        .chefs .chefs-container {
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .chefs .chefs-container .chef-box {
            position: relative;
            height: 420px;
            flex: 1 1 18rem;
            overflow: hidden;
        }

        .chefs .chefs-container .chef-box img { width: 100%; height: 100%; object-fit: cover; }
        .chefs .chefs-container .chef-box .text {
            position: absolute;
            top: -100%;
            left: 0;
            width: 100%;
            height: 100%;
            text-align: center;
            padding: 20px;
            padding-top: 8rem;
            background: rgba(255, 244, 243, .78);
            transition: .5s ease;
        }
        .chefs .chefs-container .chef-box:hover .text { top: 0; }
        .chef-box .text h2 { font-size: 1.2rem; }
        .chef-box .text p { margin: 0.4rem 0 1rem; }

        .contact-form { display: flex; justify-content: center; margin-top: 4rem; }
        .contact-form form { display: flex; flex-direction: column; }
        .contact-form form input, textarea {
            width: 400px;
            padding: 14px;
            margin-bottom: 10px;
            border-radius: .5rem;
            border: none;
            outline: none;
            background: #fff4f3;
        }

        .contact-form form input textarea { resize: none; height: 200px; }

        .contact-form form .contact-button {
            font-weight: 500;
            color: #fff;
            background: var(--main-color);
            cursor: pointer;
        }

        .contact-form form .contact-button:hover { background: #fc5552; }

        .copyright { padding: 20px; text-align: center; }

        @media (max-width: 991px) {
            header { padding: 10px 4%; }
            section { padding: 50px 4%; }

            :root {
                --big-font: 2.7rem;
                --h2-font: 1.7rem;
            }
        }

        @media (max-width: 768px) {
            :root {
                --big-font: 2rem;
                --h2-font: 1.4rem;
            }

            #menu-icon { display: initial; color: var(--text-color); }

            header .navbar {
                position: absolute;
                top: -400px;
                left: 0;
                right: 0;
                display: flex;
                flex-direction: column;
                text-align: center;
                background: #fff4f3;
                box-shadow: 0px 4px 4px rgb(0, 0, 0 , 10%);
                transition: .5s;
            }

            .navbar.active { top: 100%; }
            .navbar a { padding: 1.5rem; display: block; }
            .navbar a:hover { background: none; color: var(--main-color); }

            .home { grid-template-columns: 1fr; }
            .home-text { padding-top: 2rem; }
        }

        @media (max-width: 415px) {
            .contact-form form input, textarea { width: auto; }
        }
    </style>
</head>
<body>
<header>
    <a href="#" class="logo">Lusty Bites</a>
    <i class='bx bx-menu' id="menu-icon"></i>

    <ul class="navbar">
        <li><a href="#home">Home</a></li>
        <li><a href="#services">Services</a></li>
        <li><a href="#chefs">Our Chefs</a></li>
        <li><a href="#contact">Contact</a></li>
        <li><a href="productBrowsing">Foods</a></li>
        <!-- Dropdown for Login -->
        <li class="dropdown">
            <a href="javascript:void(0)" class="dropbtn">Login</a>
            <div class="dropdown-content">
                <a href="login.jsp">Customer</a>
                <a href="login.jsp">Admin</a>
            </div>
        </li>
    </ul>

</header>

<section class="home" id="home">
    <div class="home-text">
        <h3>More than Faster</h3>
        <h1>Be the fastest <br>In delivery <br>Your <span>Food</span></h1>
        <p>Select chefs known for their quick service and efficient order processing</p>
        <a href="#" class="btn">Contact Here</a>
    </div>

    <div class="home-img">
        <img src="https://i.postimg.cc/90kdsFZ8/chef.png" alt="chef image">
    </div>
</section>

<section class="services" id="services">
    <div class="heading">
        <p>What we serve</p>
        <h2>Your Favorite Food <br>Delivery Partner</h2>
    </div>

    <div class="services-container">
        <div class="box">
            <img src="https://i.postimg.cc/FH6Kckmn/order.png" alt="order image">
            <h2>Easy to Order</h2>
            <p>We ensure that your personal chef has a system in place for quick order preparation</p>
        </div>

        <div class="box">
            <img src="https://i.postimg.cc/qvNJkBnc/ship.png" alt="ship image">
            <h2>Fastest Delivery</h2>
            <p>This includes readiness to handle peak times and using efficient cooking methods</p>
        </div>

        <div class="box">
            <img src="https://i.postimg.cc/mZVBC1yN/deliver.png" alt="deliver image">
            <h2>Best Quality</h2>
            <p>We use spill-proof and sturdy containers to keep food intact during transit</p>
        </div>
    </div>
</section>

<section class="chefs" id="chefs">
    <div class="heading">
        <p>Our Chefs</p>
        <h2>Our Awesome Chefs'</h2>
    </div>

    <div class="chefs-container">
        <div class="chef-box">
            <img src="https://i.postimg.cc/SNC0VXWv/chef1.png" alt="chefs image">
            <div class="text">
                <h2>John Watson</h2>
                <p>With a passion for Asian cuisine, John participated in the last International Chinese Culinary Competition that started in Vancouver. He loves to bring to your customers diverse international dishes</p>
                <a href="#" class="btn">Hire Now</a>
            </div>
        </div>

        <div class="chef-box">
            <img src="https://i.postimg.cc/zf9Sdfwx/chef2.png" alt="chefs image">
            <div class="text">
                <h2>Alexa Gomez</h2>
                <p>With a desire for competition, Alexa participated in many chef competitions, including the MasterChef España. In these competitions, he honed his skills and creativity in the kitchen</p>
                <a href="#" class="btn">Hire Now</a>
            </div>
        </div>

        <div class="chef-box">
            <img src="https://i.postimg.cc/Xv3n9fmL/chef3.jpg" alt="chefs image">
            <div class="text">
                <h2>Richard Walker</h2>
                <p>With in-depth culinary knowledge of 20 years in the area, throughout his career, Richard has taken on roles as a mentor and teacher. His spirit has a passion for teaching and excellence in the culinary field</p>
                <a href="#" class="btn">Hire Now</a>
            </div>
        </div>
    </div>
</section>

<section class="contact" id="contact">
    <div class="heading">
        <p>Have Any Questions?</p>
        <h2>Contact Us</h2>
    </div>

    <div class="contact-form">
        <form action="">
            <input type="text" placeholder="Your Name">
            <input type="email" name="" id="emailId" placeholder="Enter your email...">
            <textarea name="" id="nameId" cols="30" rows="10" placeholder="Write Your Message Here..."></textarea>
            <input type="button" value="Send" class="contact-button">
        </form>
    </div>
</section>

<div class="copyright">
    <p>&#169; ULTRA CODE All Rights Reserved</p>
</div>
<script>
    let menu = document.querySelector('#menu-icon');
    let navbar = document.querySelector('.navbar');

    menu.onclick = () => {
        menu.classList.toggle('bx-x');
        navbar.classList.toggle('active');
    }

    window.onscroll = () => {
        navbar.classList.remove('active');
        menu.classList.remove('bx-x');
    }
</script>

<script src="main.js"></script>
</body>
</html>
