from django import forms
from django.contrib.auth.models import User
from django.contrib.auth.forms import UserCreationForm
from .models import Student


class UserRegistrationForm(UserCreationForm):
    """Extended registration form with email field and Medipol validation"""
    email = forms.EmailField(
        required=True,
        help_text="Use your Medipol email (@medipol.edu.tr or @std.medipol.edu.tr)"
    )
    first_name = forms.CharField(max_length=100, required=True, label="Full Name")

    class Meta:
        model = User
        fields = ('first_name', 'email', 'password1', 'password2')

    def clean_email(self):
        """Validate Medipol email and check for duplicates"""
        email = self.cleaned_data.get('email').lower()
        
        # Validate Medipol email
        if not (email.endswith('@medipol.edu.tr') or email.endswith('@std.medipol.edu.tr')):
            raise forms.ValidationError(
                "Access Denied: You must use a valid Medipol email address."
            )
        
        # Check if email already exists
        if User.objects.filter(email=email).exists():
            raise forms.ValidationError("This email is already registered.")
        
        return email

    def save(self, commit=True):
        """Save user and create associated Student profile"""
        user = super().save(commit=False)
        user.email = self.cleaned_data['email'].lower()
        user.username = self.cleaned_data['email'].lower()  # Use email as username
        
        if commit:
            user.save()
            # Create Student profile automatically
            Student.objects.get_or_create(
                user=user,
                defaults={
                    'student_name': user.first_name,
                    'student_email': user.email,
                    'student_id': user.email.split('@')[0],  # Generate from email
                    'student_department': 'Medicine',
                    'reputation_score': 5.00
                }
            )
        
        return user


class UserLoginForm(forms.Form):
    """Traditional login form"""
    email = forms.EmailField(label="Email", widget=forms.EmailInput(attrs={
        'class': 'form-control',
        'placeholder': 'Enter your Medipol email'
    }))
    password = forms.CharField(
        label="Password",
        widget=forms.PasswordInput(attrs={
            'class': 'form-control',
            'placeholder': 'Enter your password'
        })
    )

    def clean(self):
        """Validate credentials"""
        cleaned_data = super().clean()
        email = cleaned_data.get('email', '').lower()
        password = cleaned_data.get('password')

        if email and password:
            try:
                user = User.objects.get(email=email)
                if not user.check_password(password):
                    raise forms.ValidationError("Invalid email or password.")
            except User.DoesNotExist:
                raise forms.ValidationError("Invalid email or password.")

        return cleaned_data


class StudentProfileForm(forms.ModelForm):
    """Form for editing student profile"""
    class Meta:
        model = Student
        fields = ('student_name', 'student_department', 'graduation_year')
        widgets = {
            'student_name': forms.TextInput(attrs={'class': 'form-control'}),
            'student_department': forms.TextInput(attrs={'class': 'form-control'}),
            'graduation_year': forms.NumberInput(attrs={'class': 'form-control'}),
        }
