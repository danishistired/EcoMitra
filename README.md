# 🌍 **Ecomitra - Smart Waste Management System**  

Ecomitra is a **smart waste reporting system** that allows users to **capture waste images using a Flutter mobile app**, automatically geotag the location, and send reports to a **Flask-based backend**. The **web dashboard** then displays reported waste locations using an **interactive map**.  

---

## 🚀 **Project Overview**  

### 🛠 **Problem Solved**  
Waste mismanagement is a growing issue in urban areas. Many communities struggle to **report and track waste** efficiently. **Ecomitra** simplifies the process by allowing users to **capture waste images with location data** and submit reports for proper action.  

### 🔑 **Key Features**  
✅ **Flutter Mobile App** – Capture and upload waste images with GPS location.  
✅ **Flask Backend** – Handles API requests, stores data, and processes images.  
✅ **Interactive Web Dashboard** – Displays reports with images and maps.  
✅ **Leaflet.js Mapping** – Shows reported waste locations for easy tracking.  
✅ **Google Maps API** – Converts coordinates to readable addresses.  

---

# 🛠 **Dependencies & Setup**  

Before running Ecomitra, ensure you have the following:

📌 Backend Requirements
Python 3.9+

Flask == 2.2.2

Flask-CORS == 3.0.10

Pillow == 9.2.0

Werkzeug == 2.2.2

📌 Frontend Requirements
HTML, CSS, JavaScript

Leaflet.js (for mapping)

Bootstrap 5

📌 Other Tools
Google Maps API (for address conversion)

Geolocation API (for user location tracking)



## 📌 **Backend (Flask API)**  
**Install dependencies:**  

The repository for the EcoMitra WebClient with the backend, frontend and flask files can be found [here](https://github.com/danishistired/EcoMitraWebClient).

```sh
pip install flask flask-cors pillow werkzeug
```

### **Run the Flask Server:**  
```sh
python app.py
```
Flask will start at **`http://192.168.x.x:5000/`**  

---

## 📌 **Mobile App (Flutter)**  

### **1️⃣ Install Flutter**  
Download **Flutter SDK** from: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)  
Ensure Flutter is installed by running:  
```sh
flutter doctor
```

### **2️⃣ Install Required Tools**  
✅ Install **VS Code** or **Android Studio**  
✅ Install the **Flutter & Dart extensions** in VS Code  

### **3️⃣ Set Up an Emulator or Device**  
📱 **Option 1: Use Android Emulator**  
- Open **Android Studio**  
- Go to **AVD Manager** (Android Virtual Device Manager)  
- Create & run a **Pixel 5 (or any device)** with API level **30+**  

📱 **Option 2: Use a Physical Android Device**  
- Enable **USB Debugging** in Developer Options  
- Connect phone via **USB cable**  

### **4️⃣ Clone the Project**  
```sh
git clone https://github.com/your-repo/ecomitra.git
cd ecomitra/flutter_app
```

### **5️⃣ Install Flutter Dependencies**  
```sh
flutter pub get
```

### **6️⃣ Run the Flutter App**  
```sh
flutter run
```

---

## 📸 **How to Upload a Photo**  

1️⃣ **Open the Flutter app**  
2️⃣ Tap **"Scan Image"**  
3️⃣ Capture a **photo of the waste**  
4️⃣ Click **"Send"** to upload  
5️⃣ The image and **GPS location** are sent to the Flask backend  
6️⃣ View the report in the **Web Dashboard**  

---

## 📌 **Web Dashboard (Frontend)**  

### **1️⃣ Open `index.html`**  
Simply open `index.html` in a browser to view reported waste locations.  

### **2️⃣ Test the API with `cURL` (Optional)**  
```sh
curl -X POST -F "image=@path/to/test/image" -F "latitude=12.34" -F "longitude=56.78" http://192.168.x.x:5000/upload
```

---

# 📜 **Project Structure**  

```
ecomitra/
│── backend/                # Flask API (Python)
│   ├── app.py              # Main backend script
│   ├── uploads/            # Stores uploaded images
│   └── requirements.txt    # Backend dependencies
│
│── flutter_app/            # Flutter Mobile App
│   ├── lib/
│   │   ├── main.dart       # Flutter entry point
│   │   ├── scan_screen.dart # Image capture & upload
│   ├── pubspec.yaml        # Flutter dependencies
│
│── web_dashboard/          # Web Dashboard
│   ├── index.html          # Frontend UI
│   ├── script.js           # Handles API calls
│   ├── styles.css          # Styling
│
└── README.md               # Documentation
```

---

## 👥 **Team Members**  
- **Danish** – Flutter & Backend Developer  
- **Varun** – Web Devleloper
- **Rahul** – UI/UX Designer

---

## 📜 **License**  
This project is licensed under the **GNU License** and can be found [here](https://github.com/danishistired/EcoMitra/blob/main/LICENSE.md).  

---

## 💡 **Future Plans**  
🔹 **AI-based waste classification** for better waste analysis.  
🔹 **Push notifications** for authorities to respond quickly.  
🔹 **Mobile app integration with Google Maps for live tracking.**
🔹 **Allowing users to add comments to the images they send.**

---

## 🤝 **Contributing**  
We welcome contributions! Fork the repo, make changes, and submit a pull request.  

🚀 **Ecomitra - Making Waste Management Smarter!**  
