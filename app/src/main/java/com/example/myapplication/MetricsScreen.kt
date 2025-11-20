package com.example.myapplication
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.height
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text

@Composable
fun MetricsScreen(viewModel: CandidateViewModel, userId: Long) {

    val metrics by viewModel.metrics.observeAsState()

    LaunchedEffect(Unit) {
        viewModel.loadMetrics(userId)
    }

    metrics?.let {
        Column(Modifier.padding(16.dp)) {

            Text("Métricas de Aprendizado", style = MaterialTheme.typography.headlineMedium)
            Spacer(Modifier.height(20.dp))

            Text("Cursos concluídos: ${it.completedCourses}")
            Text("Total de horas: ${it.totalHours}")
            Text("Atualizado em: ${it.updatedAt}")
        }
    }
}