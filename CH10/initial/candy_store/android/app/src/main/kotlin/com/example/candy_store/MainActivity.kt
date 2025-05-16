package com.example.candy_store

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FLutterEngine)
    val favoriteMethodChannel = MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "com.example.candy_store/favorite"
    )
}
