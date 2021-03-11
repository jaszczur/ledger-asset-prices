(in-package :ledger-asset-prices)

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

        (restart-case (error 'stock-not-found-error :stock stock)
          (use-value (value)
            :interactive read-new-value
            value)))))

(defun extract-error-message (body)
  (let ((ms-error (jonathan:parse body :as :alist)))
    (alist-str-get (alist-str-get ms-error "error") "message")))

(defmethod fetch-stock-price ((api (eql :marketstack)) stock date)
  (handler-case
      (let* ((uri (marketstack-uri (alist-get stock :api-ticker) date))
             (stream (dex:get uri))
             (body (jonathan:parse stream :as :alist)))
        (convert-api-response stock date body))
    (dex:http-request-failed (c)
      (restart-case (error 'stock-fetch-error :stock stock
                                              :cause c
                                              :message (extract-error-message (dex:response-body c)))
        (use-value (value)
          :interactive read-new-value
          value)))))

#+nil
(progn

  (setf *marketstack-api-key* "")

  (fetch-stock-price :marketstack '((:ticker . "BERKSHIRE")
                              (:api . :marketstack)
                              (:api-ticker . "BRK.B"))
               "2021-02-25")
  

  (fetch-stock-price :marketstack '((:ticker . "APIERROR")
                              (:api . :marketstack)
                              (:api-ticker . "BRK.Bhhh"))
               "2021-02-25")

  (fetch-stock-price :marketstack
               '((:ticker . "SWDA_LN_ETF" )
                 (:api . :marketstack)
                 (:api-ticker . "SWDA.XLON")
                 (:multiplier . 0.01))
               "2021-02-25")

  )
