;; sip010-token
;; <add a description here>
(impl-trait .sip010-ft-trait.sip010-ft-trait)




;; -------------------------------------------------------------------------------
;; Define variables and constants for the contract 
;; -------------------------------------------------------------------------------
(define-constant contract-owner tx-sender)

(define-fungible-token sip010-token u100000000)

(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u102))


;; -------------------------------------------------------------------------------
;; Implement traits interface methods
;; -------------------------------------------------------------------------------
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
	(begin
		(asserts! (is-eq tx-sender sender) err-not-token-owner)
		(ft-transfer? sip010-token amount sender recipient)
	)
)

(define-read-only (get-name)
	(ok "Tiny Market Example Coin")
)

(define-read-only (get-symbol)
	(ok "TMEC")
)

(define-read-only (get-decimals)
	(ok u6)
)

(define-read-only (get-balance (who principal))
	(ok (ft-get-balance sip010-token who))
)

(define-read-only (get-total-supply)
	(ok (ft-get-supply sip010-token))
)

(define-read-only (get-token-uri)
	(ok none)
)

(define-public (mint (amount uint) (recipient principal))
	(begin
		(asserts! (is-eq tx-sender contract-owner) err-owner-only)
		(ft-mint? sip010-token amount recipient)
	)
)