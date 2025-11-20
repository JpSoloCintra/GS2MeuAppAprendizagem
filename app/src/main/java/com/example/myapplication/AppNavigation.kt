package com.example.myapplication
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.compose.runtime.Composable

@Composable
fun AppNavigation(nav: NavHostController, viewModel: CandidateViewModel) {

    NavHost(navController = nav, startDestination = "list") {

        composable("list") {
            CandidateListScreen(viewModel) { id ->
                nav.navigate("metrics/$id")
            }
        }

        composable("metrics/{id}") { backStack ->
            val id = backStack.arguments?.getString("id")!!.toLong()
            MetricsScreen(viewModel, id)
        }
    }
}