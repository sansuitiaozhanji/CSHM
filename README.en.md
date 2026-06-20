# Campus Secondhand Trading Platform (CSHM)

The Campus Secondhand Trading Platform is a campus-based secondhand item trading system built on Spring Boot and MyBatis, providing convenient services for posting, browsing, and trading secondhand items for students and faculty.

## Project Overview

This project is a complete campus secondhand trading platform adopting a frontend-backend separation architecture. The backend is built with the Spring Boot framework, the frontend uses the JSP template engine, and data is stored in a MySQL database.

## Technology Stack

- **Backend**: Java 17, Spring Boot
- **ORM**: MyBatis
- **Database**: MySQL
- **Frontend**: JSP + Bootstrap
- **Build Tool**: Maven

## Features

### User Module
- User registration and login
- Personal profile management
- View published product listings

### Product Module
- Post secondhand products
- Browse product listings
- View product details
- Edit and delete products
- Filter products by category

### Order Module
- Manage purchased orders
- Manage sold orders

### Admin Module
- User management
- Product approval
- Data statistics dashboard

## Project Structure

```
src/
├── main/
│   ├── java/com/campus/
│   │   ├── common/          # Common classes (Result, PageResult)
│   │   ├── config/          # Configuration classes
│   │   ├── controller/      # Controllers
│   │   │   ├── admin/       # Admin controllers
│   │   │   ├── AuthController.java
│   │   │   ├── CategoryController.java
│   │   │   ├── OrderController.java
│   │   │   ├── ProductController.java
│   │   │   └── UserController.java
│   │   ├── entity/          # Entity classes
│   │   ├── mapper/          # MyBatis Mapper interfaces
│   │   └── service/         # Business service layer
│   ├── resources/
│   │   ├── application.yaml # Configuration file
│   │   └── mapper/          # MyBatis XML mapping files
│   └── webapp/
│       └── WEB-INF/jsp/    # JSP view files
└── sql/
    └── campus_secondhand.sql # Database initialization script
```

## Quick Start

### Prerequisites

- JDK 17+
- Maven 3.6+
- MySQL 5.7+

### Configuration Steps

1. Create a database and import the SQL script:
```bash
mysql -u root -p < sql/campus_secondhand.sql
```

2. Update database configuration (`src/main/resources/application.yaml`):
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/campus_secondhand
    username: your_username
    password: your_password
```

3. Compile and run:
```bash
./mvnw spring-boot:run
```

4. Access the application:
- Frontend: http://localhost:8080
- Default admin account: admin / admin123

## Core APIs

| Module | Endpoint | Description |
|--------|----------|-------------|
| Authentication | `/api/auth/*` | Login and registration |
| User | `/api/user/*` | User management |
| Product | `/api/product/*` | Product CRUD operations |
| Category | `/api/category/*` | Product categories |
| Order | `/api/order/*` | Order management |
| Admin | `/api/admin/*` | Admin functions |

## License

This project is open-sourced under the MIT License.