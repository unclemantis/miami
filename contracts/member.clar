
;; member
;; <add a description here>

;; constants
;;

;; data maps and vars
;;

(define-map members { member-id: principal } { name: (string-utf8 50), image-url: (string-utf8 50), email: (string-utf8 50) })

(define-data-var member-ids (list 100 principal) (list ))

;; private functions
;;

;; public functions
;;

(define-read-only (is-member (member-id principal))
    (begin
        (if (is-some (map-get? members { member-id: member-id }))
            true
            false)))

(define-read-only (get-member-ids)
    (var-get member-ids))

(define-read-only (get-member (member-id principal))
    (map-get? members { member-id: member-id }))

(define-public (create-member (name (string-utf8 50)) (image-url (string-utf8 50)) (email (string-utf8 50)))
    (begin
        (asserts! (map-insert members { member-id: tx-sender } { name: name, image-url: image-url, email: email })
            (err u1))
        (ok (var-set member-ids (unwrap-panic (as-max-len? (append (var-get member-ids) tx-sender) u2))))))
