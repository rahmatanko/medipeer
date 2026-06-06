#MediPeer - Student Academic Marketplace and Collaboration Platform

MediPeer is a web-based platform that enables students to connect, collaborate, and exchange academic services. The platform features a marketplace for buying and selling study notes, a gig marketplace for academic services, and study group management tools.

Table of Contents

1. Overview
2. Features
3. Tech Stack
4. Project Structure
5. Installation and Setup
6. Database Setup
7. Running the Application
8. API Documentation
9. Contributing
10. License

Overview

MediPeer is designed to bridge the gap between students seeking academic help and those offering their expertise. Whether you need quality notes, tutoring services, or a study group, MediPeer provides a comprehensive platform for academic peer-to-peer services.

Key Objectives:
- Create a secure marketplace for academic resources
- Build a reputation system to ensure quality and trustworthiness
- Enable students to offer and find academic services (gigs)
- Facilitate study group formation and management
- Track transactions and maintain user ratings

Features

Student Profiles
- Comprehensive student profiles with reputation scores
- Track academic achievements and class information
- View student history and completed services

Marketplace
- Browse and purchase study notes from peers
- Upload and sell your own study materials
- Search and filter notes by course
- Rate and review notes and sellers

Academic Gigs
- Create and manage academic service offerings (tutoring, assignment help, etc.)
- Browse available gigs by category and price
- Track gig status and completion
- Earn reputation through completed services

Study Groups
- Create or join study groups by course
- Group capacity management
- Track group membership and roles
- Collaborative learning environment

Reputation System
- Dynamic reputation scoring based on user activities
- Tracks ratings from notes, gigs, and study group participation
- Visible reputation badges to build trust

Transactions
- Secure transaction management
- Multiple payment method support
- Transaction history and status tracking

Admin Dashboard
- Analytics and platform monitoring
- User and transaction management
- Platform statistics

Tech Stack

Backend
- Python with Django framework
- Django REST Framework for API development
- SimpleJWT for authentication and authorization

Frontend
- HTML5 for semantic markup
- CSS3 for responsive styling
- Bootstrap Icons for UI elements
- JavaScript for interactivity

Database
- PostgreSQL relational database
- Advanced PL/pgSQL triggers and procedures
- Transaction management for data consistency

Deployment
- Standard WSGI-compatible server
- PostgreSQL database server
- Static file serving

Project Structure

medipeer/
├── backend/                    # Django application root
│   ├── manage.py              # Django management utility
│   ├── medipeer/              # Project settings
│   │   └── settings.py        # Configuration file
│   ├── core/                  # Main application
│   │   ├── models.py          # Database models
│   │   ├── views.py           # Request handlers
│   │   ├── urls.py            # URL routing
│   │   ├── serializers.py     # API serializers
│   │   ├── apps.py            # App configuration
│   │   ├── admin.py           # Django admin
│   │   ├── static/            # Static files (CSS, JS, images)
│   │   └── templates/         # HTML templates
│   └── requirements.txt       # Python dependencies
├── database/                  # Database scripts
│   ├── schema.sql             # Database schema definition
│   ├── triggers.sql           # Database triggers for automation
│   ├── procedures.sql         # Stored procedures
│   └── transactions.sql       # Transaction examples
└── README.md                  # This file

Key Files

backend/core/urls.py - Defines all application routes
backend/core/views.py - Implements page logic and API endpoints
backend/templates/ - HTML templates for different pages
backend/core/static/css/ - Stylesheets for frontend components
database/triggers.sql - Automated reputation calculations
database/procedures.sql - Business logic procedures

Installation and Setup

Prerequisites

- Python 3.8 or higher
- PostgreSQL 12 or higher
- pip package manager
- Virtual environment tool (venv or virtualenv)

Step 1: Clone the Repository

git clone https://github.com/rahmatanko/medipeer.git
cd medipeer

Step 2: Create Virtual Environment

python -m venv venv

Activate virtual environment:
- On Windows: venv\Scripts\activate
- On macOS/Linux: source venv/bin/activate

Step 3: Install Dependencies

cd backend
pip install -r requirements.txt

Step 4: Create Environment Variables

Create a .env file in the backend directory:

SECRET_KEY=your-secret-key-here
DEBUG=True
DATABASE_NAME=medipeer
DATABASE_USER=postgres
DATABASE_PASSWORD=your-password
DATABASE_HOST=localhost
DATABASE_PORT=5432
ALLOWED_HOSTS=localhost,127.0.0.1

Step 5: Configure PostgreSQL Database Connection

Update backend/medipeer/settings.py with your database credentials:

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'medipeer',
        'USER': 'postgres',
        'PASSWORD': 'your-password',
        'HOST': 'localhost',
        'PORT': '5432',
    }
}

Database Setup

Step 1: Create PostgreSQL Database

createdb medipeer

Step 2: Load Database Schema

psql -U postgres -d medipeer -f database/schema.sql

Step 3: Load Stored Procedures

psql -U postgres -d medipeer -f database/procedures.sql

Step 4: Load Triggers

psql -U postgres -d medipeer -f database/triggers.sql

Step 5: Load Sample Transactions (Optional)

psql -U postgres -d medipeer -f database/transactions.sql

Database Schema Overview

Core Tables:
- student: Student profiles and personal information
- course: Academic courses
- study_group: Study groups with capacity limits
- joins: Tracks group membership
- note: Study notes for sale
- note_rating: Ratings for notes
- gig: Academic services offered by students
- gig_rating: Ratings for gigs
- rating: Generic rating system
- transaction: Payment transactions
- student_rating: Direct student-to-student ratings

Key Features:
- Automatic reputation score calculation via triggers
- Transaction management for payment processing
- Capacity constraints for study groups
- Multi-dimensional rating system

Running the Application

Step 1: Apply Django Migrations

python manage.py migrate

Step 2: Create Superuser (Admin Account)

python manage.py createsuperuser

Follow the prompts to create an admin account with username and password.

Step 3: Start Development Server

python manage.py runserver

The application will be available at: http://localhost:8000

Accessing the Platform:
- Main Dashboard: http://localhost:8000/
- Admin Panel: http://localhost:8000/admin/
- Marketplace: http://localhost:8000/marketplace/
- Gigs: http://localhost:8000/gigs/
- Study Groups: http://localhost:8000/groups/
- Profile: http://localhost:8000/profile/

API Documentation

Authentication Endpoints

POST /api/auth/register/
Register a new student account

Request Body:
{
    "username": "student@example.com",
    "password": "secure_password",
    "first_name": "John",
    "last_name": "Doe",
    "student_email": "john@university.edu",
    "student_name": "John Doe",
    "student_department": "Computer Science",
    "graduation_year": 2024
}

POST /api/auth/login/
Obtain JWT token for authentication

Request Body:
{
    "username": "student@example.com",
    "password": "secure_password"
}

POST /api/auth/token/refresh/
Refresh JWT token

Request Body:
{
    "refresh": "refresh_token_here"
}

Main Routes

Authentication (HTML Forms)
- GET/POST /auth/register/ - User registration page
- GET/POST /auth/login/ - User login page
- GET /auth/logout/ - Logout user
- GET/POST /profile/ - View user profile
- GET/POST /profile/edit/ - Edit profile

Dashboard
- GET / - Main dashboard

Marketplace
- GET /marketplace/ - Browse notes
- GET /marketplace/detail/<note_id>/ - View note details
- GET/POST /marketplace/upload/ - Upload new note

Academic Gigs
- GET /gigs/ - Browse gigs
- GET/POST /gigs/create/ - Create new gig

Study Groups
- GET /groups/ - Browse study groups
- GET/POST /groups/create/ - Create new group
- POST /groups/join/<group_id>/ - Join a group
- GET /groups/detail/ - View group details

Other Routes
- GET /search/ - Search results
- GET /contact/ - Contact page
- GET /admin-analytics/ - Admin analytics dashboard

Reputation System

The reputation system automatically calculates scores based on multiple factors:

Factors Influencing Reputation:
1. Note Ratings: Quality of study materials
2. Gig Ratings: Quality of academic services provided
3. Student Ratings: Direct peer-to-peer ratings
4. Participation: Active involvement in study groups

Reputation Score Breakdown:
- Notes rated: 50%
- Groups led: 25%
- Gigs completed: 15%
- Mentoring: 10%

Triggers automatically update reputation when new ratings are added to the system.

Transaction Processing

Secure transactions are handled through:

Note Purchase Flow:
1. Student selects note in marketplace
2. Initiates payment
3. Transaction created with "Completed" status
4. Buyer gains access to note content
5. Seller receives payment
6. Reputation updated

Gig Transaction Flow:
1. Student creates or applies for gig
2. Agreement and price confirmed
3. Transaction created with "In Progress" status
4. Upon completion, status updated to "Completed"
5. Ratings exchanged between parties
6. Reputation recalculated

Database Transactions:

The system uses BEGIN/COMMIT/ROLLBACK for data consistency:
- Changes are atomic - either fully applied or fully rolled back
- Savepoints allow partial rollbacks within transactions
- All financial transactions maintain integrity

Contributing

We welcome contributions to MediPeer. To contribute:

1. Fork the repository
2. Create a feature branch (git checkout -b feature/new-feature)
3. Commit your changes (git commit -m 'Add new feature')
4. Push to the branch (git push origin feature/new-feature)
5. Open a Pull Request

Please ensure:
- Code follows Django and Python best practices
- Database changes are properly documented
- All new features include appropriate tests
- Documentation is updated accordingly

Common Development Tasks

Add New Model:
1. Define model in backend/core/models.py
2. Create migration: python manage.py makemigrations
3. Apply migration: python manage.py migrate

Add New Route:
1. Create view function in backend/core/views.py
2. Add URL pattern to backend/core/urls.py
3. Create template if needed

Add API Endpoint:
1. Create serializer in backend/core/serializers.py
2. Create API view
3. Register in URL routing

Troubleshooting

Common Issues

Database connection error:
- Verify PostgreSQL is running
- Check database credentials in settings.py
- Ensure medipeer database exists

Port 8000 already in use:
python manage.py runserver 8001

Missing CSS/Images:
python manage.py collectstatic

Module not found errors:
pip install -r requirements.txt

License

This project is licensed under the MIT License - see the LICENSE file for details.

Support and Documentation

For additional help or documentation, please visit:
- Django Documentation: https://docs.djangoproject.com/
- PostgreSQL Documentation: https://www.postgresql.org/docs/
- Django REST Framework: https://www.django-rest-framework.org/

Questions?

For questions, issues, or suggestions, please open an issue in the GitHub repository or contact the project maintainers.

Last Updated: 2024
