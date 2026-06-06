from urllib import request
from django.db import models
from django.shortcuts import get_object_or_404, redirect, render
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.views.decorators.http import require_http_methods
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from .serializers import RegisterSerializer 
from .forms import UserRegistrationForm, UserLoginForm, StudentProfileForm
from .models import Course, Note, Student, Gig, Study_group, enrolls_in, joins

# ==================== AUTHENTICATION VIEWS ====================

@require_http_methods(["GET", "POST"])
def register(request):
    """User registration view with database linkage"""
    if request.user.is_authenticated:
        return redirect('dashboard')
    
    if request.method == 'POST':
        form = UserRegistrationForm(request.POST)
        if form.is_valid():
            user = form.save()
            messages.success(request, 'Registration successful! You can now log in.')
            return redirect('login')
        else:
            for field, errors in form.errors.items():
                for error in errors:
                    messages.error(request, f"{field}: {error}")
    else:
        form = UserRegistrationForm()
    
    return render(request, 'auth/register.html', {'form': form})


@require_http_methods(["GET", "POST"])
def user_login(request):
    """User login view with session management"""
    if request.user.is_authenticated:
        return redirect('dashboard')
    
    if request.method == 'POST':
        form = UserLoginForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email'].lower()
            password = form.cleaned_data['password']
            
            # Authenticate using email
            try:
                user = authenticate(request, username=email, password=password)
                if user is not None:
                    login(request, user)
                    messages.success(request, f'Welcome back, {user.first_name}!')
                    return redirect('dashboard')
            except:
                pass
            
            messages.error(request, 'Invalid email or password.')
    else:
        form = UserLoginForm()
    
    return render(request, 'auth/login.html', {'form': form})


@login_required(login_url='login')
def user_logout(request):
    """User logout view"""
    logout(request)
    messages.success(request, 'You have been logged out successfully.')
    return redirect('login')


@login_required(login_url='login')
def edit_profile(request):
    """Edit student profile"""
    try:
        student = request.user.student
    except Student.DoesNotExist:
        messages.error(request, 'Student profile not found.')
        return redirect('dashboard')
    
    if request.method == 'POST':
        form = StudentProfileForm(request.POST, instance=student)
        if form.is_valid():
            form.save()
            messages.success(request, 'Profile updated successfully!')
            return redirect('profile')
    else:
        form = StudentProfileForm(instance=student)
    
    return render(request, 'profile_edit.html', {'form': form, 'student': student})


@login_required(login_url='login')
def profile_view(request):
    """Render the current authenticated student's profile."""
    try:
        student = request.user.student
    except Student.DoesNotExist:
        messages.error(request, 'Student profile not found.')
        return redirect('dashboard')

    enrolled_courses = enrolls_in.objects.filter(student=student).select_related('course')
    notes_count = Note.objects.filter(author=student).count()
    gigs_count = Gig.objects.filter(student=student).count()
    groups_joined = joins.objects.filter(student=student).count()

    return render(request, 'profile.html', {
        'student': student,
        'enrolled_courses': enrolled_courses,
        'notes_count': notes_count,
        'gigs_count': gigs_count,
        'groups_joined': groups_joined,
    })


# ==================== API AUTHENTICATION VIEWS ====================

@permission_classes([AllowAny])
def register_student(request):
    serializer = RegisterSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        return Response({"message": "Student registered successfully"}, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

def dashboard(request):
    return render(request, "dashboard.html")

def marketplace(request):

    all_notes = Note.objects.all().order_by("-upload_date")
    return render(request, "marketplace/list.html", {"notes": all_notes})

def note_detail(request, note_id):
    note = get_object_or_404(Note, id=note_id)
    return render(request, "marketplace/detail.html", {"note": note})

@login_required(login_url='login')
def note_upload(request):
    """Upload a note with file storage and PostgreSQL integration"""
    
    if request.method == "GET":
        return render(request, "marketplace/note_upload.html")
    
    elif request.method == "POST":
        # Extract form data
        title = request.POST.get("note_title", "").strip()
        description = request.POST.get("note_description", "").strip()
        price = request.POST.get("note_price", "0.00")
        file = request.FILES.get("file_path")
        course_code = request.POST.get("course_code", "").strip()

        # Validation: Title
        if not title:
            messages.error(request, "Error: Note title is required.")
            return redirect("note_upload")

        # Validation: Course code
        if not course_code:
            messages.error(request, "Error: Course code is required.")
            return redirect("note_upload")

        # Validation: File
        if not file:
            messages.error(request, "Error: You must upload a file.")
            return redirect("note_upload")

        # Validate file type (PDF only)
        if not file.name.lower().endswith('.pdf'):
            messages.error(request, "Error: Only PDF files are allowed.")
            return redirect("note_upload")

        # Validate file size (max 10MB)
        if file.size > 10 * 1024 * 1024:  # 10MB in bytes
            messages.error(request, "Error: File size exceeds 10MB limit.")
            return redirect("note_upload")

        # Validate price
        try:
            price = float(price)
            if price < 0:
                messages.error(request, "Error: Price cannot be negative.")
                return redirect("note_upload")
        except ValueError:
            messages.error(request, "Error: Invalid price format.")
            return redirect("note_upload")

        # Get student profile
        try:
            student_profile = request.user.student
        except Student.DoesNotExist:
            messages.error(request, "Error: User does not have an associated student profile.")
            return redirect("note_upload")
        
        # Get or verify course exists
        try:
            course = Course.objects.get(course_code=course_code)
        except Course.DoesNotExist:
            messages.error(request, "Error: Course with the provided code does not exist.")
            return redirect("note_upload")
        
        # Create note with file upload - Django ORM handles PostgreSQL storage
        try:
            note = Note.objects.create(
                course=course,
                author=student_profile,
                note_title=title,
                note_description=description,
                note_price=price,
                file_path=file  # Django FileField handles file storage and path in DB
            )
            
            messages.success(request, f"Note '{title}' uploaded successfully! It's now live in the marketplace.")
            return redirect("marketplace")
            
        except Exception as e:
            messages.error(request, f"Error uploading note: {str(e)}")
            return redirect("note_upload")
    
    # Default fallback
    return redirect("marketplace")
         
def gigs(request):

    all_gigs = Gig.objects.all().order_by("-id")
    return render(request, "gigs/list.html", {"gigs": all_gigs})

@login_required(login_url='login')
def gig_create(request):

    if request.method == "GET":
        return render(request, "gigs/gig_create.html")
    elif request.method == "POST":
        title = request.POST.get("gig_name")
        price = request.POST.get("gig_price", 0.00)
        services_type = request.POST.get("services_type", "tutoring")

        description = request.POST.get("gig_description")
        course_code = request.POST.get("course_code")

        try:
            student_profile = request.user.student
        except Student.DoesNotExist:
            messages.error(request, "Error: User does not have an associated student profile.")
            return redirect("gig_create")
        
        try:
            course = Course.objects.get(course_code=course_code)
        except Course.DoesNotExist:
            messages.error(request, "Error: Course with the provided code does not exist.")
            return redirect("gig_create")
        Gig.objects.create(
             course=course,
            student=student_profile,
            gig_name=title,
            gig_description=description,
            gig_price=price,
            services_type=services_type,
            )

        messages.success(request, "Gig created successfully!")
        return redirect("gigs")
    
def groups(request):
    all_groups = Study_group.objects.all().order_by("-id")
    return render(request, "groups/list.html", {"groups": all_groups})

def group_detail(request):
    return render(request, "groups/detail.html")

def group_create(request):

    if request.method == "POST":
        name = request.POST.get("group_name")
        course_code = request.POST.get("course_code")
        try:
            course = Course.objects.get(course_code=course_code)
            new_group = Study_group.objects.create(group_name=name, course=course)
            new_group.members.add(request.user.student)
            messages.success(request, "Group created successfully!")
        except:
            messages.error(request, "Error: Failed to create group.")
        return redirect("groups")
    return render(request, "groups/group_create.html")

def join_group(request, group_id):
    group = get_object_or_404(Study_group, id=group_id)

    if request.user.student in group.members.all():
        messages.warning(request, "You are already a member of this group.")
        return redirect("groups")
    try:
        group.members.add(request.user.student)
        messages.success(request, "You have joined the group successfully!")
    except:
        messages.error(request, "Error: Failed to join the group.")
    return redirect("groups")

def search_results(request):
    query = request.GET.get('q', '').strip()
    
    notes = []
    gigs = []
    groups = []

    if query:
        notes = Note.objects.filter(
            models.Q(note_title__icontains=query) |
            models.Q(note_description__icontains=query)
        ).select_related('course', 'author')

        gigs = Gig.objects.filter(
            models.Q(gig_name__icontains=query) |
            models.Q(gig_description__icontains=query)
        ).select_related('course', 'student')

        groups = Study_group.objects.filter(
            models.Q(group_name__icontains=query) |
            models.Q(description__icontains=query)
        ).select_related('course', 'creator')

    return render(request, 'search/results.html', {
        'query': query,
        'notes': notes,
        'gigs': gigs,
        'groups': groups,
        'total': len(notes) + len(gigs) + len(groups),
    })

def contact(request):
    return render(request, "contact.html")

def admin_analytics(request):
    from .models import Student, Note, Gig, Study_group
    return render(request, "admin_analytics.html", {
        'total_students': Student.objects.count(),
        'total_notes': Note.objects.count(),
        'total_gigs': Gig.objects.count(),
        'total_groups': Study_group.objects.count(),
        'recent_students': Student.objects.order_by('-created_at')[:5],
        'recent_notes': Note.objects.order_by('-upload_date').select_related('course', 'author')[:5],
        'recent_gigs': Gig.objects.order_by('-creation_date').select_related('course')[:5],
        'top_students': Student.objects.order_by('-reputation_score')[:5],
    })

def profile(request):
    return render(request, "profile.html")
