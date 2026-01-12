### 💠 Setup

- Ran DVWA using Docker (temporary run):

  ```bash
  docker run --rm -it -p 8081:80 vulnerables/web-dvwa
  ```

  This method removes the container once it stops.
  
- ✅ **Alternative (persistent container):**

  Use this command to keep the container available even after stopping:

  ```bash
  docker run -it --name dvwa -p 8081:80 vulnerables/web-dvwa
  ```

  This allows you to manage the container via Docker Desktop and restart it easily.

- Accessed DVWA at:

  ```
  http://localhost:8081
  ```

- Logged in with default credentials:
  - **Username**: `admin`
  - **Password**: `password`
    
- Initialized the database by clicking **Create / Reset Database**
- Set **Security Level** to **Low** (under `DVWA Security` menu)

---
