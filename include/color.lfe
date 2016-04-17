;;;; Partial LFE port of https://github.com/julianduque/erlang-color/blob/master/include/color.hrl

(defmacro ESC  () #"\e[")
(defmacro RST  () #"0")
(defmacro BOLD () #"1")
(defmacro SEP  () #";")
(defmacro END  () #"m")

;;; Foreground Colors
(defmacro black   () #"30")
(defmacro red     () #"31")
(defmacro green   () #"32")
(defmacro yellow  () #"33")
(defmacro blue    () #"34")
;; (defmacro magenta () #"35")
;; (defmacro cyan    () #"36")
(defmacro white   () #"37")
;; (defmacro default () #"39")
