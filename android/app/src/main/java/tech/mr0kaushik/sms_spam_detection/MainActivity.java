package tech.mr0kaushik.sms_spam_detection;


import android.content.res.AssetFileDescriptor;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.gson.Gson;
import com.google.gson.stream.JsonReader;

import org.tensorflow.lite.Interpreter;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.StringTokenizer;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {

    private static final String TAG = "MainActivity";
    private static final String CHANNEL = "spam_sms_tf_lite/model";
    protected Interpreter tfLite;

    private HashMap<String, Double> map;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        getTokenizer();

        try {
            tfLite = new Interpreter(loadModelFile(), new Interpreter.Options().setAllowBufferHandleOutput(true));
        } catch (Exception exc) {
            //TODO: handle exception
            Log.w(TAG, "configureFlutterEngine: Unable to load model " + exc.getMessage());
            exc.printStackTrace();
        }

        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(this);

    }

    public float predictMessage(String message) {

        if (message == null) {
            return 0f;
        }

        if (map == null)
            return 0f;

        message = message.toLowerCase(Locale.ENGLISH).replaceAll("[^a-zA-Z0-9]", " ").trim();
        float[][] matrix = new float[1][1000];
        List<Integer> seq = new ArrayList<>();
        StringTokenizer tokenizer = new StringTokenizer(message);
        while (tokenizer.hasMoreTokens()) {
            String key = tokenizer.nextToken();
            if (map.containsKey(key)) {
                int idx = map.get(key).intValue();
                if (idx < 1000) {
                    seq.add(idx);
                    matrix[0][idx] = 1;
                }
            }
        }

        if (tfLite != null) {
            float[][] output_data = new float[1][1];
            tfLite.run(matrix, output_data);
            return output_data[0][0];
        }
        Log.w(TAG, "predictMessage: TensorFlow Model {tflite} returns null");
        return 0;

    }

    private ByteBuffer loadModelFile() throws Exception {
        AssetFileDescriptor fileDescriptor = getAssets().openFd("model.tflite");
        FileInputStream inputStream = new FileInputStream(fileDescriptor.getFileDescriptor());
        FileChannel fileChannel = inputStream.getChannel();
        long startOffset = fileDescriptor.getStartOffset();
        long declaredLength = fileDescriptor.getDeclaredLength();
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength).duplicate();
    }

    public void getTokenizer() {
        final String path = "tokenizer.json";
        try {
            Gson gson = new Gson();
            InputStream is = getAssets().open(path);
            JsonReader reader = new JsonReader(new InputStreamReader(is));
            map = gson.fromJson(reader, HashMap.class);
            is.close();
        } catch (IOException ex) {
            Log.w(TAG, "getTokenizer: unable to load " + path + " ", ex.fillInStackTrace());
//            ex.printStackTrace();
        }
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("predictMessage")) {

            List<String> args = call.argument("args");
            float prediction = -1f;
            if (args != null) {
                prediction = predictMessage(args.get(0));
            }
            if (prediction != -1f) {
                result.success(String.valueOf(prediction));
            } else {
                result.error("UNAVAILABLE", "prediction  not available.", null);
            }
        } else {
            result.notImplemented();
        }
    }
}
