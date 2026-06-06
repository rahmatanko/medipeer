from rest_framework import serializers
from django.contrib.auth.models import User

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    email = serializers.EmailField(required=True)

    class Meta:
        model = User
        fields = ('username', 'email', 'password')

    def validate_email(self, value):
        email_string = value.lower()
        if not (email_string.endswith('@medipol.edu.tr') or email_string.endswith('@std.medipol.edu.tr')):
            raise serializers.ValidationError("Access Denied: You must use a valid Medipol email address.")
        
        if User.objects.filter(email=email_string).exists():
            raise serializers.ValidationError("This email is already taken.")
            
        return email_string

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password']
        )
        return user