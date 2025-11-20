package com.example.myapplication
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.clickable
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.lazy.LazyColumn

@Composable
fun CandidateListScreen(
    viewModel: CandidateViewModel,
    onCandidateClick: (Long) -> Unit
) {
    val candidates by viewModel.candidates.observeAsState(emptyList())

    LaunchedEffect(Unit) {
        viewModel.loadCandidates()
    }

    LazyColumn {
        items(candidates) { candidate ->
            Text(
                text = candidate.name,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(16.dp)
                    .clickable { onCandidateClick(candidate.id) }
            )
        }
    }
}