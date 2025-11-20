package com.example.myapplication
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitClient {
    val api: CandidateApiService by lazy {
        Retrofit.Builder()
            .baseUrl("http://10.0.2.2:8080") // backend local
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(CandidateApiService::class.java)
    }
}