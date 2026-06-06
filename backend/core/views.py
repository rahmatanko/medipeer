from django.shortcuts import get_object_or_404, redirect, render
from django.contrib import messages
from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from .serializers import RegisterSerializer 
from .models import Course, Note, Student, Gig, Study_group

@api_view(["POST"])
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
    return render(request, "marketplace/list.html"), {"notes": all_notes}

def note_detail(request, note_id):
    note = get_object_or_404(Note, id=note_id)
    return render(request, "marketplace/detail.html", {"note": note})

def note_upload(request):

    if request.method == "GET":
        return render(request, "marketplace/note_upload.html")
    elif request.method == "POST":
        title = request.POST.get("note_title")
        description = request.POST.get("note_description")
        price = request.POST.get("note_price", 0.00)
        file = request.FILES.get("file_path")
        course_code = request.POST.get("course_code")

        try:
            student_profile = request.user.student
        except:
            messages.error(request, "Error: User does not have an associated student profile.")
        
            return redirect("note_upload")
        
        try:
            course = Course.objects.get(course_code=course_code)
        except Course.DoesNotExist:
            messages.error(request, "Error: Course with the provided code does not exist.")
            return redirect("note_upload")
        
        Note.objects.create(
            course=course,
            author=student_profile,
            note_title=title,
            note_description=description,
            note_price=price,
            file_path=file
        )

        messages.success(request, "Note uploaded successfully!")
        return redirect("marketplace")
         
def gigs(request):

    all_gigs = Gig.objects.all().order_by("-id")
    return render(request, "gigs/list.html", {"gigs": all_gigs})

def gig_create(request):

    if request.method == "GET":
        return render(request, "gigs/gig_create.html")
    elif request.method == "POST":
        title = request.POST.get("gig_title")
        description = request.POST.get("gig_description")
        budget = request.POST.get("budget", 0.00)
        course_code = request.POST.get("course_code")

        try:
            student_profile = request.user.student
        except:
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
            gig_title=title,
            gig_description=description,
            budget=budget
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

def search_results(request):
    return render(request, "search/results.html")

def contact(request):
    return render(request, "contact.html")

def admin_analytics(request):
    return render(request, "admin_analytics.html")

def profile(request):
    return render(request, "profile.html")