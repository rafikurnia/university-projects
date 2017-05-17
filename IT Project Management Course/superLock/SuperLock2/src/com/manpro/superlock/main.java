package com.manpro.superlock;

import com.manpro.superlock.R;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.Intent;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.DecimalFormat;
import java.util.Set;
import java.util.UUID;

public class main extends Activity implements SensorEventListener {

	private ImageView imageArrow;
	private EditText editField;
	private TextView textAxisX;
	private TextView textAxisY;
	private TextView textAxisZ;
	private TextView textStatus;
	private TextView textCommand;
	private TextView textConnection;
	private Button buttonConnect;
	private Button buttonSendData;
	private Button buttonDisconnect;
	private Button buttonToggle;

	private SensorManager sensorManager;
	private Sensor accelerometer;

	private double lastX, lastY, lastZ;
	private boolean initialized;
	private final double NOISE = 1.0;

	private BluetoothAdapter bluetoothAdapter;
	private BluetoothSocket bluetoothSocket;
	private BluetoothDevice bluetoothDevice;

	private final String BTdevice = "superLock";

	private OutputStream outputStream;
	private InputStream inputStream;
	private Thread workerThread;
	private byte[] readBuffer;
	private int readBufferPosition;
	private boolean gpioState = false;
	private boolean isConnected = false;
	private String sentData;
	volatile boolean stopWorker;

	private String superLockInput = null;

	private String sensorData;
	private StringBuilder sendData;

	static public String customFormat(String pattern, double value) {
		DecimalFormat myFormatter = new DecimalFormat(pattern);
		String output = myFormatter.format(value);
		return output;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		imageArrow = (ImageView) findViewById(R.id.imageArrow);
		editField = (EditText) findViewById(R.id.editField);
		textAxisX = (TextView) findViewById(R.id.textAxisX);
		textAxisY = (TextView) findViewById(R.id.textAxisY);
		textAxisZ = (TextView) findViewById(R.id.textAxisZ);
		textStatus = (TextView) findViewById(R.id.textStatus);
		textCommand = (TextView) findViewById(R.id.textCommand);
		textConnection = (TextView) findViewById(R.id.textConnection);
		buttonConnect = (Button) findViewById(R.id.buttonConnect);
		buttonDisconnect = (Button) findViewById(R.id.buttonDisconnect);
		buttonSendData = (Button) findViewById(R.id.buttonSendData);
		buttonToggle = (Button) findViewById(R.id.buttonToggle);

		buttonDisconnect.setEnabled(false);
		buttonSendData.setEnabled(false);
		buttonToggle.setEnabled(false);

		sensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
		accelerometer = sensorManager
				.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
		sensorManager.registerListener(this, accelerometer,
				SensorManager.SENSOR_DELAY_NORMAL);

		initialized = false;

		sensorData = new String();
		sendData = new StringBuilder();

		buttonConnect.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				try {
					findBT();
					connectBT();
				} catch (IOException ex) {
					textConnection.setText("unable to connect!");
				}
			}
		});

		buttonDisconnect.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				try {
					disconnectBT();
				} catch (IOException ex) {
					textStatus.setText("unable to disconnect!");
				}
			}
		});

		buttonSendData.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				try {
					sendDataString("*");
					sendDataString("12");
					sendDataString("|");
					sendDataString("99");
					sendDataString("|");
					sendDataString("99");
					sendDataString("|");
					sentData = editField.getText().toString();
					sendDataString(sentData);
					sendDataString("#");
					editField.setText("");
				} catch (IOException ex) {
					textStatus.setText("unable to send data!");
				}
			}
		});

		buttonToggle.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				try {
					sendDataString("*");
					sendDataString("10");
					sendDataString("|");
					sendDataString("10");
					sendDataString("|");
					if (gpioState) {
						sendDataString("2");
						gpioState = false;
					} else {
						gpioState = true;
						sendDataString("3");
					}
					sendDataString("#");
				} catch (IOException ex) {
					textStatus.setText("unable to send data!");
				}
			}
		});

	}

	@Override
	protected void onResume() {
		super.onResume();
		sensorManager.registerListener(this, accelerometer,
				SensorManager.SENSOR_DELAY_NORMAL);
	}

	@Override
	protected void onPause() {
		super.onPause();
		sensorManager.unregisterListener(this);
	}

	@Override
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
	}

	@Override
	public void onSensorChanged(SensorEvent event) {
		double x = event.values[0];
		double y = event.values[1];
		double z = event.values[2];
		if (!initialized) {
			lastX = x;
			lastY = y;
			lastZ = z;

			textAxisX.setText("0.0");
			textAxisY.setText("0.0");
			textAxisZ.setText("0.0");

			initialized = true;
		} else {
			double deltaX = Math.abs(lastX - x);
			double deltaY = Math.abs(lastY - y);
			double deltaZ = Math.abs(lastZ - z);

			if (deltaX < NOISE)
				deltaX = (float) 0.0;
			if (deltaY < NOISE)
				deltaY = (float) 0.0;
			if (deltaZ < NOISE)
				deltaZ = (float) 0.0;

			lastX = Math.abs(x);
			lastY = Math.abs(y);
			lastZ = Math.abs(z);

			textAxisX.setText(customFormat("0.0", lastX));
			textAxisY.setText(customFormat("0.0", lastY));
			textAxisZ.setText(customFormat("0.0", lastZ));

			imageArrow.setVisibility(View.VISIBLE);
			if (deltaX > deltaY)
				imageArrow.setImageResource(R.drawable.horizontal);
			else if (deltaY > deltaX)
				imageArrow.setImageResource(R.drawable.vertical);
			else
				imageArrow.setVisibility(View.INVISIBLE);
		}
	}

	public void findBT() {
		bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
		if (bluetoothAdapter == null) {
			textStatus.setText("not support bluetooth!");
		}

		if (!bluetoothAdapter.isEnabled()) {
			Intent enableBluetooth = new Intent(
					BluetoothAdapter.ACTION_REQUEST_ENABLE);
			startActivityForResult(enableBluetooth, 0);
		}

		Set<BluetoothDevice> pairedDevices = bluetoothAdapter
				.getBondedDevices();
		if (pairedDevices.size() > 0) {
			for (BluetoothDevice device : pairedDevices) {
				if (device.getName().equals(BTdevice)) {
					bluetoothDevice = device;
					break;
				} else {
					bluetoothDevice = null;
				}
			}
		}
	}

	public void connectBT() throws IOException {
		UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");

		if (bluetoothDevice != null) {
			bluetoothSocket = bluetoothDevice
					.createRfcommSocketToServiceRecord(uuid);
			bluetoothSocket.connect();
			outputStream = bluetoothSocket.getOutputStream();
			inputStream = bluetoothSocket.getInputStream();

			beginListenForData();

			buttonConnect.setEnabled(false);
			buttonDisconnect.setEnabled(true);
			buttonToggle.setEnabled(true);
			buttonSendData.setEnabled(true);
			isConnected = true;
			textConnection.setText("Connected to superLock");
		}
	}

	public void beginListenForData() {
		final Handler handler = new Handler();
		final byte delimiter = 10;

		stopWorker = false;
		readBufferPosition = 0;
		readBuffer = new byte[1024];
		workerThread = new Thread(new Runnable() {

			public void run() {
				while (!Thread.currentThread().isInterrupted() && !stopWorker) {
					try {
						int bytesAvailable = (inputStream.available());
						if (bytesAvailable > 0) {
							byte[] packetBytes = new byte[bytesAvailable];
							inputStream.read(packetBytes);
							for (int i = 0; i < bytesAvailable; i++) {
								byte b = packetBytes[i];
								if (b == delimiter) {
									byte[] encodedBytes = new byte[readBufferPosition - 1];
									System.arraycopy(readBuffer, 0,
											encodedBytes, 0,
											encodedBytes.length);
									final String data = new String(
											encodedBytes, "US-ASCII");
									readBufferPosition = 0;

									handler.post(new Runnable() {
										public void run() {
											superLockInput = data;
											textCommand.setText("data input: "
													+ superLockInput);
											if (superLockInput
													.equals("bismillah")) {
												editField
														.setText("Alhamdulillah");
											}
											if (readBuffer[0] == 66) {
												sendData.delete(0,
														sendData.length());
												sendData.append(customFormat(
														"0.0", lastX));
												sendData.append(" ");
												sendData.append(customFormat(
														"0.0", lastY));

												sensorData = sendData
														.toString();
												try {
													sendDataToDoor(sensorData);
												} catch (IOException e) {

												}
											}
										}

									});

								} else if (readBufferPosition < 1024) {
									try {
										readBuffer[readBufferPosition++] = b;
									} catch (ArrayIndexOutOfBoundsException e) {
										readBufferPosition = 0;
									}
								}
							}

						}
					} catch (IOException ex) {
						stopWorker = true;
						textConnection.setText("Disconnected");
					}
				}
			}
		});
		workerThread.start();
	}

	public void sendDataString(String fromUserData) throws IOException {
		byte[] msgBuffer = fromUserData.getBytes();
		try {
			if (isConnected == true) {
				outputStream.write(msgBuffer);
				textStatus.setText("data sent!");
			} else {
				textStatus.setText("disconnected, no data sent");
			}
		} catch (IOException e) {
			textStatus.setText("send data error");
		}
	}

	public void disconnectBT() throws IOException {
		stopWorker = true;

		outputStream.close();
		inputStream.close();
		bluetoothSocket.close();

		buttonConnect.setEnabled(true);
		buttonDisconnect.setEnabled(false);
		buttonToggle.setEnabled(false);
		buttonSendData.setEnabled(false);

		textConnection.setText("Disconnected");
		textStatus.setText("");
		textCommand.setText("");
		editField.setText("");

		isConnected = false;
	}

	public void sendDataToDoor(String input) throws IOException {
		sendDataString("*");
		sendDataString("25");
		sendDataString("|");
		sendDataString("99");
		sendDataString("|");
		sendDataString("99");
		sendDataString("|");
		sendDataString(input);
		editField.setText(input);
		sendDataString("#");
	}

}