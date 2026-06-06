from django.db import models
from django.contrib.auth.models import User 

class Student(models.Model):

    user = models.OneToOneField(User, on_delete=models.CASCADE, null=True, blank=True) #links Student to Django's built-in User model

    student_name = models.CharField(max_length=100)
    student_id = models.CharField(max_length=100)
    student_email = models.EmailField(max_length=150, unique=True)
    student_department = models.CharField(max_length=100)
    graduation_year = models.IntegerField(null=True, blank=True)
    reputation_score = models.DecimalField(max_digits=4, decimal_places=2, default=0.00)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.student_name

class Course(models.Model):
    course_name = models.CharField(max_length=150)
    course_code = models.CharField(max_length=20, unique=True)
    course_department = models.CharField(max_length=100)
    semester = models.CharField(max_length=20)
    instructor = models.CharField(max_length=100)

    def __str__(self):
        return self.course_name

class enrolls_in(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    enrollment_year = models.IntegerField()
    
    class Meta:
        unique_together = ('student', 'course')

class Note(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    author = models.ForeignKey(Student, on_delete=models.CASCADE)
    note_title = models.CharField(max_length=150)
    note_description = models.TextField(null=True, blank=True)
    note_price = models.DecimalField(max_digits=8, decimal_places=2, default=0.00)
    file_path = models.FileField(upload_to='notes/')
    upload_date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.note_title
    
class note_tag(models.Model):
    note = models.ForeignKey(Note, on_delete=models.CASCADE)
    tag_name = models.CharField(max_length=50)

    class Meta:
        unique_together = ('note', 'tag_name')

class content_protection_log(models.Model):
    note = models.ForeignKey(Note, on_delete=models.CASCADE)
    watermark_status = models.CharField(max_length=30)
    plagirarism_result = models.CharField(max_length=30)
    content_fingerprint_data = models.TextField()
    checked_at = models.DateTimeField(auto_now_add=True)

class  Study_group(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    creator = models.ForeignKey(Student, on_delete=models.CASCADE)
    group_name = models.CharField(max_length=120)
    description = models.TextField(null=True, blank=True)
    max_members = models.IntegerField()
    creation_date = models.DateTimeField(auto_now_add=True)

class joins(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    group = models.ForeignKey(Study_group, on_delete=models.CASCADE)
    join_date = models.DateTimeField(auto_now_add=True)
    role = models.CharField(max_length=30, default='member')

    class Meta:
        unique_together = ('student', 'group')

class Gig(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    gig_name = models.CharField(max_length=150)
    gig_description = models.TextField(null=True, blank=True)
    gig_price = models.DecimalField(max_digits=8, decimal_places=2)
    gig_status = models.CharField(max_length=30, default='open')
    services_type = models.CharField(max_length=50)
    creation_date = models.DateTimeField(auto_now_add=True)

class transaction(models.Model):
    buyer = models.ForeignKey(Student, on_delete=models.CASCADE)
    note = models.ForeignKey(Note, on_delete=models.CASCADE, null=True, blank=True)
    gig = models.ForeignKey(Gig, on_delete=models.CASCADE, null=True, blank=True)
    transaction_date = models.DateTimeField(auto_now_add=True)
    amount = models.DecimalField(max_digits=8, decimal_places=2)
    payment_status = models.CharField(max_length=30, default='pending')
    payment_method = models.CharField(max_length=50)

class Rating(models.Model):
    giver = models.ForeignKey(Student, on_delete=models.CASCADE, related_name='given_ratings')
    score = models.IntegerField()
    comment = models.TextField(null=True, blank=True)
    rating_date = models.DateTimeField(auto_now_add=True)

class note_rating(models.Model):
    rating = models.OneToOneField(Rating, on_delete=models.CASCADE, primary_key=True)
    note = models.ForeignKey(Note, on_delete=models.CASCADE)

class gig_rating(models.Model):
    rating = models.OneToOneField(Rating, on_delete=models.CASCADE, primary_key=True)
    gig = models.ForeignKey(Gig, on_delete=models.CASCADE)

class student_rating(models.Model):
    rating = models.OneToOneField(Rating, on_delete=models.CASCADE, primary_key=True)
    student = models.ForeignKey(Student, on_delete=models.CASCADE)

