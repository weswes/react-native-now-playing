package com.reactlibrary;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.support.annotation.Nullable;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

public class RNNowPlayingModule extends ReactContextBaseJavaModule {
  public static final int REQUEST_CODE_READ_STORAGE = 180;
  private Context context;
  private final ReactApplicationContext reactContext;

  public RNNowPlayingModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.registerListenedMusic(reactContext);
  }

  @Override
  public String getName() {
    return "RNNowPlaying";
  }

  private void sendEvent(String eventName, @Nullable WritableMap params){
    Log.v("intent", "send event");
    try{
      if (getReactApplicationContext().hasActiveCatalystInstance()) {
        Log.v("intent", "send event hasActiveCatalystInstance ok");
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
        Log.v("intent", "send event ok");
      }
    } catch (Exception ex){
      Log.v("intent", "send event ko thread interrupt");
    }

  }

  public void registerListenedMusic(Context context) {
    IntentFilter iF = new IntentFilter();
    iF.addAction("com.android.music.playstatechanged");
    iF.addAction("com.android.music.metachanged");
    iF.addAction("com.spotify.mobile.android.metadatachanged");

    this.context = context;
    context.registerReceiver(mReceiver, iF);
  }


  private BroadcastReceiver mReceiver;
  {
    mReceiver = new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {

        String action = intent.getAction();
        String cmd = intent.getStringExtra("command");
        String artist = intent.getStringExtra("artist");
        String album = intent.getStringExtra("album");
        String track = intent.getStringExtra("track");
        Long duration = intent.getLongExtra("duration", 0);
        Boolean playing = intent.getBooleanExtra("playing", false);

        if (artist == null && album == null && track == null){
          return;
        }

        AudioManager manager = (AudioManager)(context).getSystemService(Context.AUDIO_SERVICE);

        Log.v("intent", "ecoute locale detectée ac:" + action + " cmd:" + cmd + " track " + track + " playing " + playing + "music active: " + manager.isMusicActive());

        if (playing){
          WritableMap params = Arguments.createMap();
          params.putString("title", track);
          params.putString("artist", artist);
          params.putString("albumTitle", album);
          sendEvent("NowPlayingEvent", params);
        }
      }
    };
  }
}