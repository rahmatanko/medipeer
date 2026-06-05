from django.shortcuts import render

def dashboard(request):
    return render(request, "dashboard.html")

def marketplace(request):
    return render(request, "marketplace/list.html")

def note_detail(request):
    return render(request, "marketplace/detail.html")

def note_upload(request):
    return render(request, "marketplace/note_upload.html")

def gigs(request):
    return render(request, "gigs/list.html")

def gig_create(request):
    return render(request, "gigs/gig_create.html")

def groups(request):
    return render(request, "groups/list.html")

def group_detail(request):
    return render(request, "groups/detail.html")

def group_create(request):
    return render(request, "groups/group_create.html")

def search_results(request):
    return render(request, "search/results.html")

def contact(request):
    return render(request, "contact.html")

def admin_analytics(request):
    return render(request, "admin_analytics.html")