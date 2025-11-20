package com.example.myapplication

class CandidateRepository {

    private val api = RetrofitClient.api

    suspend fun fetchCandidates() = api.getAllCandidates()

    suspend fun fetchScore(id: Long) = api.getCandidateScore(id)

    suspend fun fetchMetrics(userId: Long) =
        api.getLearningMetrics(userId)
}