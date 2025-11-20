package com.example.myapplication
import retrofit2.http.GET
import retrofit2.http.Path

interface CandidateApiService {

    @GET("candidates")
    suspend fun getAllCandidates(): List<Candidate>

    @GET("candidates/{id}/score")
    suspend fun getCandidateScore(@Path("id") id: Long): Int

    @GET("metrics/{userId}")
    suspend fun getLearningMetrics(@Path("userId") userId: Long): LearningMetric
}