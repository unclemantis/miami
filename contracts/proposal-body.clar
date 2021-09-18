
;; proposal
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map proposal-body { id: int } { body: (string-utf8 3000) })

;; private functions
;;

;; public functions
;;

(define-public (insert-body (id int) (body (string-utf8 3000)))
    (ok (map-insert proposal-body { id: id } { body: body }))
)

(define-read-only (get-proposal-body (id int))
    (map-get? proposal-body { id: id })
)