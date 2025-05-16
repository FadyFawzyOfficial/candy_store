package com.example.candy_store

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FLutterEngine)
    val favoriteMethodChannel = MethodChannel(
        flutterEngine.dartExecutor.binaryMessenger,
        "com.example.candy_store/favorite"
    )

    // 1. We have added a method handler to the favoriteMethodChannel method channel using
    // the setMethodCallHandler method.
    favoriteMethodChannel.setMethodCallHandler { call, result ->
        // 2. When we override this method, we receive 2 parameters - call and results.
        // The call parameter contains information about the method called from the Flutter side,
        // including the method name and arguments.
        // The result parameters is used to pass information back to the Flutter side
        // after we have finished processing the method.
        // 3. Since we can have multiple methods passed through a single MethodChannel channel,
        // we need a way to identify which specific method was called.
        // To achieve this, we check the call.method parameter.
        when (call.method) {
            "addFavorite" -> {
                // 4. In this case, we are implementing the addFavorite method and handling it here.
                // Similarly, we would add handlers for other method names. It is crucial that the 
                // method names match exactly, as we are performing string comparisons.
                // 5. Now, we need to retrieve the parameters from the call parameter.
                // It's important to note that these parameters can be nullable.
                // Since we can't ensure strong typing and guarantee that the caller will
                // pass a parameter named id of type String, we need to perform null checking and type casting.
                // This process can be inconvenient and prone to errors. We will explore ways to improve it soon.
                // For now, this is the default approach.
                val id = call.argument<String>("id")
                if( id == null) {
                    // 6. If the parameter is null, which is an invalid case for us,
                    // we should return an error to the caller. We can do this by calling result.error
                    // and passing the error parameters.
                    // This notifies the caller that the method execution has completed with an error.
                    result.error("INVALID_VALUE", "id is null", null)
                } else {
                    // 7. On the other hand, if everything goes well, we should call result.success.
                    // Depending on the method, we may want to return a result.
                    // For example, in the case of getFavorite, it could be a List<String> type containing id parameters.
                    // In the case of addFavorite, we don't have any thing to return, so we simple pass null,
                    // which basically means void. It's important to return a result in some form because otherwise,
                    // the asynchronous method on the Flutter side will never complete.
                    toggleFavorite(id, true)
                    result.success(null)
                }
            }
        } else -> {
            // This brings us to the last step. If we receive a method name that we don't know hot to handle,
            // we still need to return a result. In this case, we call result.notImplemented,
            // which completes with a specific error on the Flutter side.
            result.notImplemented()
        }
    }
}
