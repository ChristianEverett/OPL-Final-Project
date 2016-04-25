# Project Title: Home Automation

###Authors
Christian Everett @ChristianEverett<br>
Rotana Nou @RotanaNou

### Statement
Create a home automation system with a raspberry pi. System will use a desktop gui client (in racket) to POST commands and GET states (of devices) to/from an http server running on the pi. The pi will process the commands and execute them (such as switching relays on/off through the pi's GPIO to enable/disable lights, garage doors, locks or other devices).

This project intrests me because I think it has alot of practical applications and is something I myself would consider using.

I hope to learn more about how a larger scale racket application functions, and how to make use of external racket librarys such as the racket GUI library.

![Alt text](https://github.com/oplS16projects/Everett-Nou/blob/master/GUI.PNG "GUI")

###External Libarys
(require racket/gui racket/draw)<br>
(require racket/date slideshow/pict)<br>
(require net/url)<br>
(require (prefix-in url-connect: net/url-connect))<br>
(require net/http-client)<br>
(require net/uri-codec)<br>
(require json)<br>

###Favorite Scheme Expressions
#####Christian Everett
This expression uses object message passing to represent
an HTTP connection to a particular host
```racket
;; HTTP Connection Object
(define (Create-Connection host)
  (define (set-device-state device state)
    (http-sendrecv host	 
 	 	 "/execute_command.php?action=2"	 
 	 	 #:ssl? #f	 
 	 	 #:port 80	 	 
 	 	 #:method "POST"	 	 
 	 	 #:data (alist->form-urlencoded
                         (list (cons 'command device)
                               (cons 'state state)))
                 #:headers (list "Content-Type: application/x-www-form-urlencoded")))
  (define (get-device-states)
    (http-sendrecv host	 
 	 	 "/execute_command.php?action=1"	 
 	 	 #:ssl? #f	 
 	 	 #:port 80	 	 
 	 	 #:method "GET"	 	 
 	 	 #:data #f))
  (define (dispatch method)
    (cond ((eq? method 'POST) set-device-state)
          ((eq? method 'GET) get-device-states)))
  dispatch)
```

### Analysis
This project will use several topics covered in class. We will be using a state modification encapsulated in an object oriented approach. This object will represent the connection between client and server. We will also use map and filter when processing the returned json dataset from the server. We will also use Iteration or Recursion in some way when processing the dataset. We will also be using objects to encapsulate UI elements with the racket GUI library.

### Data set or other source materials
Several source materials will be used in this project inluding:
* A Raspberry pi will be used as the controller to handle the logic of automating devices
* A four channel relay will be controlled via the Raspberry pi's GPIO pins
* Wireless adapter to allow the pi to communicate with the client over the network

### Deliverable and Demonstration
The demonstration/deliverables will inlcude a live interactive demo of the project. Users will be able to interact with the GUI racket client to switch devices (leds) on/off. The user will be able to Physically see the device state change.

### Evaluation of Results
The level of success of this project will be determined by the ablilty to successfully send requests from the racket client to change state of a device. Verify that the devices state has changed (view a light turn on or something) and then GET the state of the device and verify that the returned json matchs the correct state.

## Architecture Diagram
![Alt text](https://github.com/oplS16projects/OPL-Final-Project/blob/master/Diagram.PNG "Project Architecture")

The Client will be a Racket application that exposes a user Inerface for the user to interact with. The Client will submit POST and GET requests to an HTTP server on the raspberry pi.

The Apache HTTP server will return a table of device states on a GET request on action 1.

GET  request format: <host>/execute_command.php?action=1<br>
body: void<br>
return: list of json objects in the form: {"command":"```<device>```","state":"```<state>```"}<br>

The Apache HTTP server will accepted a device state change through the form of a POST request. The HTTP server will add the state change to a table of pending state changes (MySQL DB).

POST request format: <host>/execute_command.php?action=2<br>
body: command=```<device>```&state=```<state>``` <br>
return: void<br>

A Daemon will periodically read the table of pending commands and go through and execute each one. For now this will just be toggling of GPIO pins on or off to switch one of the switchs on the four channel relay. 

## Schedule
Explain how you will go from proposal to finished product. 

There are three deliverable milestones to explicitly define, below.

The nature of deliverables depend on your project, but may include things like processed data ready for import, core algorithms implemented, interface design prototyped, etc. 

You will be expected to turn in code, documentation, and data (as appropriate) at each of these stages.

Write concrete steps for your schedule to move from concept to working system. 

### First Milestone (Fri Apr 15)
* HTTP Client in racket (no GUI)
* HTTP Server implementation

### Second Milestone (Fri Apr 22)
* GUI for client in racket (version 1)

### Final Presentation (last week of semester)
* GPIO Controller
* GUI for client in racket (version 2)

## Group Responsibilities
Here each group member gets a section where they, as an individual, detail what they are responsible for in this project. Each group member writes their own Responsibility section. Include the milestones and final deliverable.

### Christian Everett @ChristianEverett
* Implement scripts for Apache HTTP Server
* Write a script to enable/disable GPIO pins
* Work on racket HTTP client

### Rotana Nou @RotanaNou
* Work on GUI (User Interface) for client in racket
* Work on racket HTTP client


