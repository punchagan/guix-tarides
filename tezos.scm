; SPDX-FileCopyrightText: 2022 Tarides <contact@tarides.com>
;
; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (tezos)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system dune)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages multiprecision)
  #:use-module (tarides ocaml))

(define-public ocaml-tezos-base58
  (package
   (name "ocaml-tezos-base58")
   (version "1.0.0")
   (home-page "https://github.com/tarides/tezos-base58")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
	   (url home-page)
	   (commit version)))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "08s3klpj0zq2ax19n35swgl3m279a59c29xx0sr29k0898kpz96j"))))
   (build-system dune-build-system)
   (arguments `(#:test-target "."))
   (propagated-inputs (list ocaml-zarith ocaml-digestif ocaml-fmt))
   (synopsis "Base58 encoding for Tezos")
   (description "Self-contained package for base58 encoding used by Tezos.")
   (license license:expat)))

(define tezos
  (package
   (name "tezos")
   (version "15.0")
   (home-page "https://gitlab.com/tezos/tezos")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
	   (url (string-append home-page ".git"))
	   (commit (string-append "v" version))))
     (sha256
      (base32
       "0jmzgw4ay1kjywhq8ygbndddfgwm05w2zki853wx04vdgd9i1zi9"))))
   (build-system dune-build-system)
   (synopsis "Tezos")
   (description "Tezos")
   (license license:expat)))

(define-public ocaml-tezos-stdlib
  (package
   (inherit tezos)
   (name "ocaml-tezos-stdlib")
   (propagated-inputs
    (list ocaml-lwt
	  ocaml-hex
	  ocaml-zarith
	  ocaml-zarith-stubs-js
	  ocaml-ppx-expect
	  ocaml-ringo-0.9
	  gmp))
   (native-inputs
    (list ocaml-alcotest
	  ocaml-qcheck))
   (arguments `(#:package "tezos-stdlib"
		#:test-target "."
		;; TODO package tezos-test-helpers for tests
		#:tests? #f))))