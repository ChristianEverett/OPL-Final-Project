#lang racket/gui

(require racket/gui
         racket/draw)
; create the application frame
(define make-frame
  (new frame%
       [label "Home Automation"]
       [width 700]
       [height 500]))
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
       [label "Temperature and Time"]))
; create left panels buttons
(define left-panel-stuff
  (lambda ()
    (begin
       (define left-child-panel (new horizontal-panel%
                                     [parent left-frame-panel]))
       (define button-nums
         (new text-field%
              [parent left-child-panel]
              [label ""]
              [init-value "Door Control"]))
       (new button%
            [parent left-child-panel]
            [label "Door"]
            [min-width 100]
            [min-height 100]))))
;make fram visible
(left-panel-stuff)
(send make-frame show #t)