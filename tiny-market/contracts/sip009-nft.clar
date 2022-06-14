;; sip009-nft
;; <add a description here>
(impl-trait .sip009-nft-trait.sip009-nft-trait)

;; SIP009 NFT trait on mainnet
;; (impl-trait 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9.nft-trait.nft-trait)

;; -------------------------------------------------------------------------------
;; Define variables and constants for the contract 
;; -------------------------------------------------------------------------------
(define-constant contract-owner tx-sender)

(define-constant err-owner-only (err u100))
(define-constant err-token-id-failure (err u101))
(define-constant err-not-token-owner (err u102))

(define-non-fungible-token sip009-nft uint)

(define-data-var last-token-id uint u0)

;; -------------------------------------------------------------------------------
;; Implement traits interface methods
;; -------------------------------------------------------------------------------
(define-read-only (get-last-token-id)
	(ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
	(ok none)
)

(define-read-only (get-owner (token-id uint))
	(ok (nft-get-owner? sip009-nft token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
	(begin
		(asserts! (is-eq tx-sender sender) err-not-token-owner)
		(nft-transfer? sip009-nft token-id sender recipient)
	)
)

(define-public (mint (recipient principal))
	(let ((token-id (+ (var-get last-token-id) u1)))
		(asserts! (is-eq tx-sender contract-owner) err-owner-only)
		(try! (nft-mint? sip009-nft token-id recipient))
		(asserts! (var-set last-token-id token-id) err-token-id-failure)
		(ok token-id)
	)
)

;; -------------------------------------------------------------------------------