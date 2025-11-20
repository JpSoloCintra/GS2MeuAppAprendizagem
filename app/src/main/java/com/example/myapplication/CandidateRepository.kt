package com.example.myapplication.repository
import com.example.myapplication.RetrofitClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
class CandidateRepository {

    private val api = RetrofitClient.api

    suspend fun fetchCandidates() = api.getAllCandidates()

    suspend fun fetchScore(id: Long) = api.getCandidateScore(id)

    suspend fun fetchMetrics(userId: Long) =
        api.getLearningMetrics(userId)
}