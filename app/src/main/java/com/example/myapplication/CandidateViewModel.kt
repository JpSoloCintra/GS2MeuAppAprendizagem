package com.example.myapplication
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.LiveData

class CandidateViewModel(
    private val repository: CandidateRepository = CandidateRepository()
) : ViewModel() {

    private val _candidates = MutableLiveData<List<Candidate>>()
    val candidates: LiveData<List<Candidate>> = _candidates

    private val _metrics = MutableLiveData<LearningMetric>()
    val metrics: LiveData<LearningMetric> = _metrics

    fun loadCandidates() {
        viewModelScope.launch {
            _candidates.value = repository.fetchCandidates()
        }
    }

    fun loadMetrics(userId: Long) {
        viewModelScope.launch {
            _metrics.value = repository.fetchMetrics(userId)
        }
    }
}