(asdf:defsystem :ledger-asset-prices
  :description "Download asset prices and save them as ledger price file"
  :author "Piotr Jaszczyk <piotr.jaszczyk@gmail.com>"

  :license "MIT"
  :version "0.0.1"

  :depends-on (:alexandria :str :jsown :drakma)

  :in-order-to ((asdf:test-op (asdf:test-op :ledger-asset-prices/test)))

  :serial t
  :components ((:file "package")
               (:module "src"
                :serial t
                :components ((:file "main")))))


(asdf:defsystem :ledger-asset-prices/test
  :description "Test suite for ledger-asset-prices"

  :author "Piotr Jaszczyk <piotr.jaszczyk@gmail.com>"
  :license "MIT"

  :depends-on (:ledger-asset-prices :1am)

  :serial t
  :components ((:file "package.test")
               (:module "test"
                :serial t
                :components ((:file "tests"))))
  :perform (asdf:test-op (op system)
                         (funcall (read-from-string "ledger-asset-prices.test:run-tests"))))

