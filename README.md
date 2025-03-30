# 🌍 **Ecomitra - Smart Waste Management System**  

Ecomitra is a **smart waste reporting system** that enables users to capture waste images using a **Flutter mobile app**, automatically geotag the location, and send reports to a **Flask-based backend**. The web dashboard then displays reported waste locations using an **interactive map**.  

---

## 🚀 **Project Overview**  

### 🛠 **Problem Solved**  
Unmanaged waste is a significant environmental issue. Many communities struggle with efficient waste reporting and disposal tracking. **Ecomitra** provides a seamless way for users to report waste **instantly**, ensuring better waste management.  

### 🔑 **Key Features**  
✅ **Flutter Mobile App** – Users capture and upload waste images with GPS location.  
✅ **Flask Backend** – Handles API requests, stores data, and processes images.  
✅ **Interactive Web Dashboard** – Displays waste reports with images and maps.  
✅ **Leaflet.js Mapping** – Shows reported waste locations for easy visualization.  
✅ **Google Maps API** – Converts coordinates to readable addresses.  

---

# 🛠 **Dependencies & Setup**  

## 📌 **Backend (Flask API)**  
**Install dependencies:**  
```sh
pip install flask flask-cors pillow werkzeug
```

### Run the Flask Server:  
```sh
python app.py
```
Flask will start at `http://127.0.0.1:5000/`  

---

## 📌 **Mobile App (Flutter)**  

### **1️⃣ Install Flutter**  
Download **Flutter SDK** from: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)  
Ensure Flutter is correctly installed by running:  
```sh
flutter doctor
```

### **2️⃣ Clone the Project**  
```sh
git clone https://github.com/your-repo/ecomitra.git
cd ecomitra/flutter_app
```

### **3️⃣ Install Dependencies**  
```sh
flutter pub get
```

### **4️⃣ Run the Flutter App**  
Connect a device or emulator, then start the app:  
```sh
flutter run
```

---

## 📌 **Web Dashboard (Frontend)**  

### **1️⃣ Open `index.html`**  
Simply open `index.html` in a browser to view reported waste.  

### **2️⃣ Test the API with `cURL` (Optional)**  
```sh
curl -X POST -F "image=@test.jpg" -F "latitude=12.34" -F "longitude=56.78" http://127.0.0.1:5000/upload
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
- **[Your Name]** – Flutter & Backend Developer  
- **[Other Member Name]** – Web Developer  

---

## 📜 **License**  
This project is licensed under the **GNU License**.  

---

## 💡 **Future Plans**  
🔹 **AI-based waste classification** for better waste analysis.  
🔹 **Push notifications** for authorities to respond quickly.  
🔹 **Mobile app integration with Google Maps for live tracking.**  

---

## 🤝 **Contributing**  
We welcome contributions! Fork the repo, make changes, and submit a pull request.  

🚀 **Ecomitra - Making Waste Management Smarter!**
