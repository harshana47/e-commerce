<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            font-family: Arial, sans-serif;
        }
        .login-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .login-header {
            background-color: #F54744FF;
            color: #fff;
            padding: 20px;
            text-align: center;
            border-radius: 10px 10px 0 0;
        }
        .btn-primary {
            background-color: #ed5a57;
            border-color: #F54744FF;
            font-size: 16px;
            padding: 10px;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
        .form-label {
            font-weight: 600;
        }
        .alert-danger {
            font-size: 14px;
        }
        .text-muted {
            font-size: 14px;
        }
        .form-icon {
            position: absolute;
            top: 73%;
            left: 10px;
            transform: translateY(-50%);
            font-size: 18px;
            color: #6c757d;
        }
        .form-control {
            padding-left: 35px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card login-card">
                <div class="login-header">
                    <h2><i class="fas fa-sign-in-alt me-2"></i>Login</h2>
                </div>
                <div class="card-body p-4">
                    <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger" role="alert">
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                    <% } %>
                    <form action="login" method="post">
                        <div class="mb-3 position-relative">
                            <label for="email" class="form-label">Email Address</label>
                            <i class="fas fa-envelope form-icon"></i>
                            <input type="email" class="form-control" id="email" name="email" required>
                        </div>
                        <div class="mb-3 position-relative">
                            <label for="password" class="form-label">Password</label>
                            <i class="fas fa-lock form-icon"></i>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100"><i class="fas fa-sign-in-alt me-2"></i>Login</button>
                    </form>
                    <p class="text-center text-muted mt-3">
                        Don't have an account? <a href="register.jsp" class="text-decoration-none"><i class="fas fa-user-plus me-1"></i>Register</a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>
