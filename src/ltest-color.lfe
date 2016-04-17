(defmodule ltest-color
  (doc "Partial LFE port of [erlang-color].

  [erlang-color]: https://github.com/julianduque/erlang-color")
  (export (black  1) (blackb  1)
          (white  1) (whiteb  1)
          (red    1) (redb    1)
          (yellow 1) (yellowb 1)
          (green  1) (greenb  1)
          (blue   1) (blueb   1)))

(include-lib "ltest/include/color.lfe")


(defun black   (text) (color  (black)  text))
(defun blackb  (text) (colorb (black)  text))
(defun white   (text) (color  (white)  text))
(defun whiteb  (text) (colorb (white)  text))
(defun red     (text) (color  (red)    text))
(defun redb    (text) (colorb (red)    text))
(defun yellow  (text) (color  (yellow) text))
(defun yellowb (text) (colorb (yellow) text))
(defun green   (text) (color  (green)  text))
(defun greenb  (text) (colorb (green)  text))
(defun blue    (text) (color  (blue)   text))
(defun blueb   (text) (colorb (blue)   text))

(defun get-color-option () (ltest-util:get-arg 'color "true"))


(defun color (color) (binary ((ESC) binary) (color binary) ((END) binary)))

(defun color (color text) (list (color color) text (reset)))

(defun colorb (color text) (list (colorb color) text (reset)))

(defun colorb (color)
  (binary ((ESC) binary) (color binary)
    ((SEP) binary) ((BOLD) binary) ((END) binary)))

(defun reset () (binary ((ESC) binary) ((RST) binary) ((END) binary)))
