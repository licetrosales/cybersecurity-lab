# SQL Injection Lab using DVWA

## Objective
Practice and understand SQL Injection vulnerabilities using the Damn Vulnerable Web Application (DVWA).

## Setup

- Ran DVWA directly using Docker Hub image:
  
  ```bash
  docker run --rm -it -p 8081:80 vulnerables/web-dvwa
  ```

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

