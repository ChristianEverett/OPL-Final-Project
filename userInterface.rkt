#lang racket/gui
;requires fields
(require racket/gui
         racket/draw)
(require racket/date slideshow/pict)

;define fields 
(define main-frame-width 600)
(define main-frame-height 350)
(define left-panel-button-height 10)
(define left-panel-button-width 150)
(define middle-msg-panel-width 50)
(define middle-msg-panel-height 10)

; create the application frame
(define make-frame
  (new frame%
       [label "Home Automation"]
       [width main-frame-width]
       [height main-frame-height]))
; display message 
(define msg (new message% [parent make-frame]
                          [label "No events so far..."]))
; create horizontal panel of inside parent frame
(define horizontal-panel
  (new horizontal-panel% [parent make-frame]))
; create left panel
(define left-frame-panel
  (new group-box-panel%
       [parent horizontal-panel]
       [label "Control Category"]))
; create middle panel
(define middle-frame-panel
  (new group-box-panel%
       [parent horizontal-panel]
       [label "Switches Status"]))
; create most right panel 
(define right-frame-panel
  (new group-box-panel%
       [parent horizontal-panel]
       [label "Time and Temperature"]))
; create left panels buttons
;First button from top
(define left-panel1-stuff
  (lambda ()
    (begin
       (define left-child-panel (new horizontal-panel%
                                     [parent left-frame-panel]))
       (new button%
            [parent left-child-panel]
            [label "Front Door"]
            [min-width left-panel-button-width]
            [min-height left-panel-button-height])
       )))
;second button from top
(define left-panel2-stuff
  (lambda ()
    (begin
       (define left-child-panel (new horizontal-panel%
                                     [parent left-frame-panel]))
       (new button%
            [parent left-child-panel]
            [label "Television"]
            [min-width left-panel-button-width]
            [min-height left-panel-button-height])
       )))
;third button from top
(define left-panel3-stuff
  (lambda ()
    (begin
       (define left-child-panel (new horizontal-panel%
                                     [parent left-frame-panel]))
       (new button%
            [parent left-child-panel]
            [label "Air Conditioner"]
            [min-width left-panel-button-width]
            [min-height left-panel-button-height])
       )))
;litchen light button 
(define left-panel4-stuff
  (lambda ()
    (begin
       (define left-child-panel (new horizontal-panel%
                                     [parent left-frame-panel]))
       (new button%
            [parent left-child-panel]
            [label "Kitchen Light"]
            [min-width left-panel-button-width]
            [min-height left-panel-button-height])
       )))
;status log
;First message status
(define middle-panel1-stuff
  (lambda ()
    (begin
       (define middle-child-panel (new horizontal-panel%
                                     [parent middle-frame-panel]))
       (new message%
            [parent middle-child-panel]
            [label "Front Door: off"]
            [min-width middle-msg-panel-width]
            [min-height middle-msg-panel-height])
       )))
;second message status
(define middle-panel2-stuff
  (lambda ()
    (begin
       (define middle-child-panel (new horizontal-panel%
                                     [parent middle-frame-panel]))
       (new message%
            [parent middle-child-panel]
            [label "Television: off"]
            [min-width middle-msg-panel-width]
            [min-height middle-msg-panel-height])
       )))
; Third message status
(define middle-panel3-stuff
  (lambda ()
    (begin
       (define middle-child-panel (new horizontal-panel%
                                     [parent middle-frame-panel]))
       (new message%
            [parent middle-child-panel]
            [label "Air Conditioner: off"]
            [min-width middle-msg-panel-width]
            [min-height middle-msg-panel-height])
       )))
; Fourth message status
(define middle-panel4-stuff
  (lambda ()
    (begin
       (define middle-child-panel (new horizontal-panel%
                                     [parent middle-frame-panel]))
       (new message%
            [parent middle-child-panel]
            [label "Kitchen Light: off"]
            [min-width middle-msg-panel-width]
            [min-height middle-msg-panel-height])
       )))

; create temperature texfield and label
(define right-panel-stuff
  (lambda ()
    (begin
       (define right-child-panel (new horizontal-panel%
                                     [parent right-frame-panel]))
       (new message%
            [parent right-child-panel]
            [label "Temperature:"]
            [min-width middle-msg-panel-width]
            [min-height middle-msg-panel-height])
       (new text-field%
            [parent right-child-panel]
            [label ""]
            [init-value "60 Degree"])
       )))

; create clock

(define (make-clock c-hour c-min c-second [r 100])
  (define (d-clock stretch c-ang
                   #:wid-length [wid-length 1]
                   #:make-color [make-color "Black"])
    (dc (lambda (draw-c xc yc)
              (define tic-pen (send draw-c get-pen))
              (send draw-c set-pen (new pen%
                                        [width wid-length]
                                        [color make-color]))
              (send draw-c draw-line
                    (+ xc r) (+ yc r)
                    (+ xc r (* stretch (sin c-ang)))
                    (+ yc r (* stretch (cos c-ang))))
              (send draw-c set-pen tic-pen))
            (* 2 r) (* 2 r)))
  (cc-superimpose
   (for/fold ([c-p (circle (* 2 r))])
             ([c-ang (in-range 0 (* 2 pi) (/ pi 6))]
              [c-h (cons 12 (range 1 12))])
     (define c-ang* c-ang)
     (define r* (* r 0.8))
     (define c-t (text (number->string c-h) '(bold . "Helvetica")))
     (define a (- (* r* (sin c-ang*)) (/ (pict-width c-t) 2)))
     (define b (+ (* r* (cos c-ang*)) (/ (pict-height c-t) 2)))
     (pin-over c-p (+ r a) (- r b) c-t))
   (d-clock (* r 0.5) (+ pi (* (modulo c-hour 12) (- (/ pi 6))))
            #:wid-length 3)
   (d-clock (* r 0.7) (+ pi (* c-min (- (/ pi 30))))
            #:wid-length 2)
   (d-clock (* r 0.7) (+ pi (* c-second (- (/ pi 30))))
            #:make-color "purple")
   (disk (* r 0.1))))

;create clock canvas 
(define clock-canvas
  (new canvas% [parent right-frame-panel]
       [paint-callback
        (lambda (clock-canvas dc)
          (define date (current-date))
          (draw-pict (make-clock (date-hour date)
                            (date-minute date)
                            (date-second date)
                            (/ (send clock-canvas get-width) 3.3)) dc 0 0))]))

; update the clock

(define time-update
  (new timer% [notify-callback (lambda () (send clock-canvas refresh-now))]
       [interval 1000]))

; make everyting visible
(right-panel-stuff)
(left-panel1-stuff)
(left-panel2-stuff)
(left-panel3-stuff)
(left-panel4-stuff)
(middle-panel1-stuff)
(middle-panel2-stuff)
(middle-panel3-stuff)
(middle-panel4-stuff)
(send make-frame show #t)