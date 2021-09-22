
;; proposal
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map proposal-body { proposal-id: int } { body: (string-utf8 3000) })

;; private functions
;;

;; public functions
;;

(define-public (insert-body (proposal-id int) (body (string-utf8 3000)))
    (ok (map-insert proposal-body { proposal-id: proposal-id } { body: body }))
)

(define-read-only (get-proposal-body (proposal-id int))
    (map-get? proposal-body { proposal-id: proposal-id })
)