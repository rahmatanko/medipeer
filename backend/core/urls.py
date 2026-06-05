from django.urls import path
from . import views

urlpatterns = [
    path("", views.dashboard, name="dashboard"),

    path("marketplace/", views.marketplace, name="marketplace"),
    path("marketplace/detail/", views.note_detail, name="note_detail"),
    path("marketplace/upload/", views.note_upload, name="note_upload"),

    path("gigs/", views.gigs, name="gigs"),
    path("gigs/create/", views.gig_create, name="gig_create"),

    path("groups/", views.groups, name="groups"),
    path("groups/detail/", views.group_detail, name="group_detail"),
    path("groups/create/", views.group_create, name="group_create"),

    path("search/", views.search_results, name="search_results"),
    path("profile/", views.profile, name="profile"),
    path("contact/", views.contact, name="contact"),
    path("admin-analytics/", views.admin_analytics, name="admin_analytics"),
]