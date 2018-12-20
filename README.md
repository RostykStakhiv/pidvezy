# Pidvezy
## GENERAL
### Project Description
**Pidvezy** is a mobile application, which allows users without transport join users with transport to reach their destination.

### Links
- [UML Diagram](https://htmlpreview.github.io/?https://github.com/RostykStakhiv/pidvezy/blob/master/Docs/PidvezyDiagram.html)
- [SOLID Compliancy](https://github.com/RostykStakhiv/pidvezy/blob/master/Docs/solid-compliant.md)
- [Architecture](https://github.com/RostykStakhiv/pidvezy/blob/master/Docs/architecture.md)

### Background
Cities have problem with transport overload. Reaching any point in the city takes a lot of time, but we use transport inefficiently. City transport in many cities is a non-reliable service, because user cannot track the status of each bus and be sure, that he reaches destination on time.
### Purpose
The purpose of this application:
  - Unload the traffic in the cities
  - Made usage of the oil more effective. 
  - Flexible services
### Assumptions and Constraints
Assumptions:
  - Relative applications (Uber, Uklon, BlaBlaCar)
  - High-load for server

Constraints:
  - Non-flexible delivery system of AppStore

### Points of Contact
List the names, titles, and roles of the major participants in the project.  At a minimum, list the following:
  - Project Manager, Developer – Rostyslav Stakhiv
  - Developer – Oleksa Boyko
  - Developer – Yuri Neklesa
## FUNCTIONAL REQUIREMENTS
### Data Requirements
Our backend is using MongoDB Database.

### Functional Process Requirements
Application consists from the next flows:
  - Authentication
  - My Routes
  - Profile
  - Create Route
  - Find Route
  - Search results
  - Route details

### Security
The application is protected in the next steps: 
  - Using secured protocol
  - Encrypted data
### Reliability
Reliability is the probability that the system will be able to process work correctly and completely without being aborted.

State the following in this section:
  - What damage can result from this system’s failure?
    - User will not reach the destination
    - Complete or partial loss of the ability to perform a functionality
    - Loss of user’s loyalty

### Performance
Describe the requirements for the following:
  - Response time for queries and updates: 500 ms

### Threat model
![tm](/Docs/Images/threatmodel.png?raw=true)

### Resilency model
![tm](/Docs/Images/resilencyModel.jpg?raw=true)
