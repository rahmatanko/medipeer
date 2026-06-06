from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.models import User


class EmailBackend(ModelBackend):
    """
    Custom authentication backend that allows users to authenticate with email
    """
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            # Try to find user by email
            user = User.objects.get(email=username)
        except User.DoesNotExist:
            return None

        # Check password and return user if valid
        if user.check_password(password) and self.user_can_authenticate(user):
            return user
        return None

    def get_user(self, user_id):
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None
