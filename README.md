# Open Source Doctor Appointment Booking System using PHP
![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(1).png)

[Edoc](https://github.com/HashenUdara/edoc-doctor-appointment-system/) is a Simple web project that is made for e-channeling Using PHP,HTML & CSS.
This initiative facilitates online appointment requests for clients or patients of medical establishments, including clinics and hospitals. This project can also help doctors to manage their appointment with their patients. This doctor's appointment system will organize the schedules of each patient's appointment, which will be submitted as a request to the doctor they have selected. The system comprises three key roles: administrator, doctor, and patient. The system admin will populate the list of the doctors with their specialties and along with the doctor's details and system credentials. The patients can browse the doctor's appointment system website to find a doctor that has the specialty of their needs. Patients can review the doctor's weekly schedule, enabling them to select a suitable day and time for their appointment. Subsequently, they can submit their appointment request. After that, the doctors can view all their appointments and the appointment request of the patients for their availability.

<!-- DevOps Pipeline Test - $(Get-Date -Format "yyyy-MM-dd HH:mm:ss") -->

## Features

### Admin
  
- Admin can add doctors, edit doctors, delete doctors    
- Schedule new doctors sessions, remove sessions   
- View patients details    
- View booking of patients    
    
    
 
 
### Doctors

- View their Appointments
- View their scheduled sessions
- View details of patients
- Delete account    
- Eedit account settings
    

    
### Patiens(Clients)
  
  - Make appointment online
  - Create accounts themslves
  - View their old booking
  - Delete account
  - Edit account settings    

    
| Admin Dashboard | Doctor Dashboard | Patient Dashboard |
| -------| -------| -------|
| Email: `admin@edoc.com` | Email: `doctor@edoc.com` |   Email: `patient@edoc.com` | 
| Password: `123` |  Password: `123` |  Password: `123` |
| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(3).png)| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(9).png) |    ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(6).png)  |

 
  
-----------------------------------------------


# GET STARTED

1. Open your XAMPP Control Panel and start Apache and MySQL.
2. Extract the downloaded source code zip file.
3. Copy the extracted source code folder and paste it into the XAMPP's "htdocs" directory.
4. Browse the PHPMyAdmin in a browser. i.e. http://localhost/phpmyadmin
5. Create a new database naming `edoc`.
6. Import the provided SQL file. The file is known as DATABASE edoc.sql located inside the source code root folder.
7. Browse the Doctor's Appointment Systsem in a browser. i.e. http://localhost/edoc-echanneling-main/.


## Screenshots

| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(1).png) | ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(2).png)| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(3).png)| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(4).png)|
|--------------| --------------|   --------------|  --------------|    
|  ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(5).png)| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(6).png)| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(7).png)| ![](https://github.com/hshnudr/edoc-echanneling/blob/main/Screenshots/Screenshot%20(8).png)|

# The Project was developed using the following:

Apache Version: 	`2.4.39`

PHP Version: 		`7.3.5`

Server Software: 	`Apache/2.4.39 (Win64) PHP/7.3.5`

MySQL Version: 		`5.7.26`

Demo video: https://youtu.be/mAWHYAHmit4



## CI/CD Pipeline Status

### Latest Pipeline Test - SCRUM-11
**Date:** $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
**Purpose:** Complete end-to-end CI/CD workflow verification
**Jira Issue:** https://mohammedsalghi24.atlassian.net/browse/SCRUM-11

**Expected Workflow:**
1. ✅ Code commit from VS Code
2. 🔄 GitHub webhook triggers Jenkins
3. 🔄 Jira issue update (SCRUM-11) 
4. 🔄 JMeter performance test execution
5. 🔄 Docker image build and push to Docker Hub
6. 🔄 Pipeline completion notification

**Test Components:**
- GitHub Integration: Push from VS Code
- Jira Integration: Issue SCRUM-11 tracking  
- Jenkins Automation: Pipeline execution
- JMeter Testing: Performance validation
- Docker Hub: Image publishing
- Notifications: Pipeline status updates

## 🚀 Development Environment Access

### CI/CD Pipeline Access
- **Jenkins Dashboard**: http://localhost:8081
- **Jenkins Admin Password**: `0cb027ef0d2143a6a28b95dc695f6939`
- **Web Application**: http://localhost:8080
- **Database**: localhost:3306
- **Jira Project**: https://mohammedsalghi24.atlassian.net/browse/SCRUM-11

### Quick Commands
```bash
# Check all running services
docker ps

# Access Jenkins logs
docker logs jenkins-fresh

# Restart Jenkins
docker restart jenkins-fresh

# Build and run the web application
docker-compose up -d
```

---