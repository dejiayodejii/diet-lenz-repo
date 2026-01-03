import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:diet_lenz/features/onboarding/view/splash_screen.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override the storage service provider with the actual instance
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load user profile if user is authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final apiService = ref.read(apiServiceProvider);
      final token = apiService.getAuthToken();

      if (token != null && token.isNotEmpty) {
        // User is authenticated, load their profile
        ref.read(userProfileViewModelProvider.notifier).getUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition.top,
      textPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diet Lenz',
        theme: AppTheme.darkTheme,
        navigatorKey: NavigationService.navigationKey,
        home: const SplashScreen(),
      ),
    );
  }
}
 
// {Camera@d19345e[id=0]} Releasing session in state CLOSING
// D/Camera2CameraImpl( 8024): {Camera@d19345e[id=0]} closing camera
// D/AndroidRuntime( 8024): Shutting down VM
// E/AndroidRuntime( 8024): FATAL EXCEPTION: main
// E/AndroidRuntime( 8024): Process: com.dietlenz.diet, PID: 8024
// E/AndroidRuntime( 8024): java.lang.IllegalArgumentException: Unsupported value: 'io.flutter.plugins.camerax.ObserverProxyApi$ObserverImpl@652418b' of type 'io.flutter.plugins.camerax.ObserverProxyApi$ObserverImpl'
// E/AndroidRuntime( 8024): 	at io.flutter.plugins.camerax.CameraXLibraryPigeonProxyApiBaseCodec.writeValue(CameraXLibrary.g.kt:961)
// E/AndroidRuntime( 8024): 	at io.flutter.plugin.common.StandardMessageCodec.writeValue(StandardMessageCodec.java:277)
// E/AndroidRuntime( 8024): 	at io.flutter.plugins.camerax.CameraXLibraryPigeonCodec.writeValue(CameraXLibrary.g.kt:1359)
// E/AndroidRuntime( 8024): 	at io.flutter.plugins.camerax.CameraXLibraryPigeonProxyApiBaseCodec.writeValue(CameraXLibrary.g.kt:845)
// E/AndroidRuntime( 8024): 	at io.flutter.plugin.common.StandardMessageCodec.encodeMessage(StandardMessageCodec.java:76)
// E/AndroidRuntime( 8024): 	at io.flutter.plugin.common.BasicMessageChannel.send(BasicMessageChannel.java:107)
// E/AndroidRuntime( 8024): 	at io.flutter.plugins.camerax.PigeonApiObserver.onChanged(CameraXLibrary.g.kt:1890)
// E/AndroidRuntime( 8024): 	at io.flutter.plugins.camerax.ObserverProxyApi$ObserverImpl$1.run(ObserverProxyApi.java:32)
// E/AndroidRuntime( 8024): 	at android.app.Activity.runOnUiThread(Activity.java:8243)
// E/AndroidRuntime( 8024): 	at io.flutter.plugins.camerax.ProxyApiRegistrar.runOnMainThread(ProxyApiRegistrar.java:84)
// E/AndroidRuntime( 8024): 	at io.flutter.plugins.camerax.ObserverProxyApi$ObserverImpl.onChanged(ObserverProxyApi.java:28)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.LiveData.considerNotify(LiveData.java:133)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.LiveData.dispatchingValue(LiveData.java:151)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.LiveData.setValue(LiveData.java:309)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.MutableLiveData.setValue(MutableLiveData.java:50)
// E/AndroidRuntime( 8024): 	at androidx.camera.camera2.internal.Camera2CameraInfoImpl$RedirectableLiveData$$ExternalSyntheticLambda0.onChanged(Unknown Source:2)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.MediatorLiveData$Source.onChanged(MediatorLiveData.java:171)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.LiveData.considerNotify(LiveData.java:133)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.LiveData.dispatchingValue(LiveData.java:151)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.LiveData.setValue(LiveData.java:309)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.MutableLiveData.setValue(MutableLiveData.java:50)
// E/AndroidRuntime( 8024): 	at androidx.lifecycle.LiveData$1.run(LiveData.java:93)
// E/AndroidRuntime( 8024): 	at android.os.Handler.handleCallback(Handler.java:959)
// E/AndroidRuntime( 8024): 	at android.os.Handler.dispatchMessage(Handler.java:100)
// E/AndroidRuntime( 8024): 	at android.os.Looper.loopOnce(Looper.java:257)
// E/AndroidRuntime( 8024): 	at android.os.Looper.loop(Looper.java:342)
// E/AndroidRuntime( 8024): 	at android.app.ActivityThread.main(ActivityThread.java:9634)
// E/AndroidRuntime( 8024): 	at java.lang.reflect.Method.invoke(Native Method)
// E/AndroidRuntime( 8024): 	at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:619)
// E/AndroidRuntime( 8024): 	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:929)
// I/Process ( 8024): Sending signal. PID: 8024 SIG: 9
// Lost connection to device.