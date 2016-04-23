;#lang racket

(require net/url)
(require (prefix-in url-connect: net/url-connect))
(require net/http-client)
(require net/uri-codec)
(require json)

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

;; Create the HTTP Connection
(define HTTP-Connection (Create-Connection "10.0.0.5"))

;; POST state change
(define (button_press id state)
  ((HTTP-Connection 'POST) (string-append "switch_" id)  state))

;; Get state of device id
(define (get-device-state id)
  (define-values (status headers in) ((HTTP-Connection 'GET)))
  (define (iter jsonlist)
    (cond [(null? jsonlist) #f]
          [(equal? id (lookup jsonlist 'command)) (string->boolean (lookup jsonlist 'state))]
          [else (iter (cdr jsonlist))]))
  (if (string-contains? (bytes->string/utf-8 status) "200 OK")
      (iter (string->jsexpr (port->string in)))
      #f))

;; utils
(define (lookup list key)
  (hash-ref (car list) key))

(define (string->boolean string)
  (if (equal? string "1")
      #t
      #f))