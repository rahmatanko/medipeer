from django.urls import path
from . import views
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

urlpatterns = [
    # Authentication URLs (HTML forms)
    path("auth/register/", views.register, name="register"),
    path("auth/login/", views.user_login, name="login"),
    path("auth/logout/", views.user_logout, name="logout"),
    path("profile/", views.profile_view, name="profile"),
    path("profile/edit/", views.edit_profile, name="edit_profile"),

    # Dashboard and Main Pages
    path("", views.dashboard, name="dashboard"),

    # Marketplace URLs
    path("marketplace/", views.marketplace, name="marketplace"),
    path("marketplace/detail/<int:note_id>/", views.note_detail, name="note_detail"),
    path("marketplace/upload/", views.note_upload, name="note_upload"),

    # Gigs URLs
    path("gigs/", views.gigs, name="gigs"),
    path("gigs/create/", views.gig_create, name="gig_create"),

    # Study Groups URLs
    path("groups/", views.groups, name="groups"),
    path("groups/join/<int:group_id>/", views.join_group, name="join_group"),
    path("groups/detail/", views.group_detail, name="group_detail"),
    path("groups/create/", views.group_create, name="group_create"),

    # Other Pages
    path("search/", views.search_results, name="search_results"),
    path("profile/", views.profile, name="profile"),
    path("contact/", views.contact, name="contact"),
    path("admin-analytics/", views.admin_analytics, name="admin_analytics"),

    # API Authentication URLs (JSON)
    path("api/auth/register/", views.register_student, name="api_register"),
    path("api/auth/login/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/auth/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
]