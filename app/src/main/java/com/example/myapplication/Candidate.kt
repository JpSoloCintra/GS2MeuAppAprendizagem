package com.example.myapplication

data class Candidate(
    val id: Long,
    val name: String,
    val score: Int,
    val skills: List<String>
)

data class LearningMetric(
    val userId: Long,
    val completedCourses: Int,
    val totalHours: Int,
    val updatedAt: String
)