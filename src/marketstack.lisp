(in-package :ledger-asset-prices)

(defun alist-str-get (al k)
  (cdr (assoc k al :test 'equal)))

(defun alist-get (al k)
  (cdr (assoc k al)))

(defparameter *currencies-by-exchange*
  '(("XWAR" . "PLN")
    ("XNYS" . "USD")
    ("XFRA" . "EUR")
    ("XETRA" . "EUR")
    ("XLON" . "GBP")))

(defparameter *marketstack-api-key*
  (uiop:getenv "MARKETSTACK_API_KEY"))


(defun marketstack-uri (ticker date)
  (quri:make-uri :scheme "http"
                 :host "api.marketstack.com"
                 :path (str:concat "/v1/eod/" date)
                 :query (quri:url-encode-params (list (cons "access_key" *marketstack-api-key*)
                                                      (cons "symbols" ticker)))))

(defun currency-for-exchange (ex)
  (alist-str-get *currencies-by-exchange* ex))

(defun convert-api-response (stock date body)
  (let ((data (first (alist-str-get body "data")))
         (mul (or (alist-get stock :multiplier) 1)))
    (if data
        (list
         (cons :raw-body body)
         (cons :date date)
         (cons :ticker (alist-get stock :ticker))
         (cons :price (* (alist-str-get data "close") mul))
         (cons :currency (currency-for-exchange (alist-str-get data "exchange"))))
        ;; TODO: raise error
        (progn
          (format t "Stock price not found for ~a.~%" (alist-get stock :api-ticker))
          nil))))

(defmethod fetch-price ((api (eql :marketstack)) stock date)
  (let* ((uri (marketstack-uri (alist-get stock :api-ticker) date))
         (stream (dex:get uri))
         (body (jonathan:parse stream :as :alist)))
    (convert-api-response stock date body)))

#+nil
(progn

  (setf *marketstack-api-key* "")

  (fetch-price :marketstack '((:ticker . "BERKSHIRE")
                              (:api . :marketstack)
                              (:api-ticker . "BRK.B"))
               "2021-02-25")
  
  (fetch-price :marketstack
               '((:ticker . "SWDA_LN_ETF" )
                 (:api . :marketstack)
                 (:api-ticker . "SWDA.XLON")
                 (:multiplier . 0.01))
               "2021-02-25")

  )
