# Event Reservation Database

Is a powerful tool designed to streamline the management of ticket reservations for large events. Just run the script — it handles everything: database creation, table setup, sample data, and security logic.

---

**Built with:**

- SQL (T-SQL for Microsoft SQL Server)

---

## Overview

- Creates the production database: `SRB_IM`
- Builds all required tables and relationships
- Populates sample data (users, events, payments, etc.)
- Creates a separate test database: `SRB_IM_Testy`
- Includes basic **security and data validation logic**

  
_No manual steps needed — everything is inside the SQL script._

---

### 🔑 Key Features

- 🎟️ **Database Initialization** – Automates the setup of a comprehensive database, saving developers time and effort.
- 📊 **Sample Data Population** – Provides essential sample data for user profiles and events, allowing for quick testing and development.
- 👤 **User Management** – Facilitates user registration and profile management, enhancing user experience and engagement.
- 🎉 **Event Management** – Supports the creation and management of events, making it easier to implement event-related functionalities.
- 🔐 **Security & Data Validation** – Implements non-declarative mechanisms such as procedures and triggers to enforce business rules and improve data integrity beyond standard constraints.

---

## ⚙️ Requirements

To run this project, you need:

- **Microsoft SQL Server** (2019 or later recommended)
- **SQL Server Management Studio (SSMS)**
-  Permissions to run `CREATE DATABASE`, `CREATE TABLE`, and `INSERT` statements

---

## 🚀 Getting Started

1. **Clone the repository:**
   
  ```sh
   git clone https://github.com/B0HDAN1337/Event_Reservation_Database
  ```

2. **Navigate to the project directory:**

  ```sh
    cd Event_Reservation_Database
  ```

3. **Run the SQL script:**

- Launch **SQL Server Management Studio**
- Open the file: `SRB_IM.sql`
- Connect to your database server
- Run the script by pressing **F5** or clicking the **Execute** button

---

## 🧪 Testing

The script also creates a separate test database: `SRB_IM_Testy`.  
This version includes sample data (users, events, reservations, etc.), allowing you to test queries and features without affecting your production structure in `SRB_IM`.

---
