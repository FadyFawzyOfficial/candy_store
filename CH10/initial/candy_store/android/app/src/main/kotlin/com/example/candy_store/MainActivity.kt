package com.example.candy_store

import android.content.Context
import android.content.SharedPreferences
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity(), LocalStorageApi {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        LocalStorageApi.setUp(flutterEngine.dartExecutor.binaryMessenger, this)
    }

    override fun addFavorite(id: String) {
        toggleFavorite(id, true)
    }

    override fun getFavorites(): List<FavoriteProduct>{
        val preferences = getSharedPreferences()
        val favorites = preferences.getStringSet("favorites", HashSet()) ?: HashSet()
        return favorites.map { FavoriteProduct(id = it) }
    }

    override fun isFavorite(id: String, callback: (Result<Boolean>) -> Unit) {
        val preferences = getSharedPreferences()
        val favorites = preferences.getStringSet("favorites", HashSet()) ?: HashSet()
        return callback(Result.success(favorites.contains(id)))
    }

    override fun removeFavorite(id: String){
        toggleFavorite(id, false)
    }

    private fun toggleFavorite(id: String, isFavorite: Boolean) {
        val preferences = getSharedPreferences()
        val allFavorites = HashSet<String>()
        val favorites = preferences.getStringSet("favorites", HashSet()) ?: HashSet()
        allFavorites.addAll(favorites)
        if (isFavorite) {
            allFavorites.add(id)
        } else {
            allFavorites.remove(id)
        }
        preferences.edit().putStringSet("favorites", allFavorites).apply()
    }

    private fun getSharedPreferences(): SharedPreferences {
        return applicationContext.getSharedPreferences("favorites", Context.MODE_PRIVATE)
    }
}
