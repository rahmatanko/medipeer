from django.test import TestCase, Client
from django.contrib.auth.models import User
from core.models import Student
from core.forms import UserRegistrationForm, UserLoginForm


class AuthenticationTests(TestCase):
    """Test suite for user authentication system"""
    
    def setUp(self):
        """Set up test client and test data"""
        self.client = Client()
        self.register_url = '/auth/register/'
        self.login_url = '/auth/login/'
        self.logout_url = '/auth/logout/'
        self.dashboard_url = '/'

    def test_registration_page_loads(self):
        """Test that registration page loads successfully"""
        response = self.client.get(self.register_url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'auth/register.html')

    def test_login_page_loads(self):
        """Test that login page loads successfully"""
        response = self.client.get(self.login_url)
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed(response, 'auth/login.html')

    def test_user_registration_valid(self):
        """Test successful user registration"""
        data = {
            'first_name': 'John Doe',
            'email': 'john@std.medipol.edu.tr',
            'password1': 'securepwd123',
            'password2': 'securepwd123',
        }
        form = UserRegistrationForm(data=data)
        self.assertTrue(form.is_valid(), form.errors)
        
        # Save the form to create user
        user = form.save()
        
        # Check user was created
        self.assertIsNotNone(user)
        self.assertEqual(user.email, 'john@std.medipol.edu.tr')
        
        # Check student profile was created
        student = Student.objects.filter(user=user).first()
        self.assertIsNotNone(student)
        self.assertEqual(student.student_name, 'John Doe')

    def test_user_registration_invalid_email_domain(self):
        """Test registration with invalid email domain"""
        data = {
            'first_name': 'Jane Doe',
            'email': 'jane@gmail.com',
            'password1': 'securepwd123',
            'password2': 'securepwd123',
        }
        form = UserRegistrationForm(data=data)
        self.assertFalse(form.is_valid())
        self.assertIn('email', form.errors)

    def test_user_registration_duplicate_email(self):
        """Test registration with duplicate email"""
        # Create first user
        User.objects.create_user(
            username='test@std.medipol.edu.tr',
            email='test@std.medipol.edu.tr',
            password='pass123'
        )
        
        # Try to register with same email
        data = {
            'first_name': 'Another User',
            'email': 'test@std.medipol.edu.tr',
            'password1': 'securepwd123',
            'password2': 'securepwd123',
        }
        form = UserRegistrationForm(data=data)
        self.assertFalse(form.is_valid())
        self.assertIn('email', form.errors)

    def test_user_login_valid(self):
        """Test successful login"""
        # Create user
        User.objects.create_user(
            username='login@std.medipol.edu.tr',
            email='login@std.medipol.edu.tr',
            password='loginpass123',
            first_name='Login Test'
        )
        
        # Test login form
        data = {
            'email': 'login@std.medipol.edu.tr',
            'password': 'loginpass123',
        }
        form = UserLoginForm(data=data)
        self.assertTrue(form.is_valid(), form.errors)

    def test_user_login_invalid_email(self):
        """Test login with non-existent email"""
        data = {
            'email': 'nonexistent@std.medipol.edu.tr',
            'password': 'anypassword',
        }
        form = UserLoginForm(data=data)
        self.assertFalse(form.is_valid())

    def test_user_login_invalid_password(self):
        """Test login with wrong password"""
        # Create user
        User.objects.create_user(
            username='password@std.medipol.edu.tr',
            email='password@std.medipol.edu.tr',
            password='correctpass123'
        )
        
        # Try wrong password
        data = {
            'email': 'password@std.medipol.edu.tr',
            'password': 'wrongpass123',
        }
        form = UserLoginForm(data=data)
        self.assertFalse(form.is_valid())

    def test_student_profile_creation(self):
        """Test that student profile is created with correct data"""
        data = {
            'first_name': 'Profile Test',
            'email': 'profile@medipol.edu.tr',
            'password1': 'securepwd123',
            'password2': 'securepwd123',
        }
        form = UserRegistrationForm(data=data)
        user = form.save()
        
        # Check student profile
        student = Student.objects.get(user=user)
        self.assertEqual(student.student_name, 'Profile Test')
        self.assertEqual(student.student_email, 'profile@medipol.edu.tr')
        self.assertEqual(student.reputation_score, 5.00)
        self.assertTrue(student.student_id)  # Auto-generated

    def test_email_as_username(self):
        """Test that email is used as username"""
        data = {
            'first_name': 'Username Test',
            'email': 'username@std.medipol.edu.tr',
            'password1': 'securepwd123',
            'password2': 'securepwd123',
        }
        form = UserRegistrationForm(data=data)
        user = form.save()
        
        self.assertEqual(user.username, 'username@std.medipol.edu.tr')
