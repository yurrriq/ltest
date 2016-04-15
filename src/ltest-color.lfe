(defmodule ltest-color
  (export (black  1) (blackb  1)
          (white  1) (whiteb  1)
          (red    1) (redb    1)
          (yellow 1) (yellowb 1)
          (green  1) (greenb  1)
          (blue   1) (blueb   1)))

(eval-when-compile
  (defun defcolors*
    ([`(,color . ,colors) defs]
     (defcolors* colors (cons `(defcolor ,color (fun color ,color 1)) defs)))
    ([() defs]
     `(progn ,@defs)))
  (defun docstring (color)
    (++ "If [[get-color-option/0]] returns `` 'true ``, return an iolist\n"
        "  that will print `str` in " (color->string color)
        ", otherwise `str`."))
  (defun color->string (color)
    (let ((color (atom_to_list color)))
      (case (lists:last color)
        (#\b (++ "bold " (lists:droplast color)))
        (_   color)))))

(defmacro defcolor (color func)
  `(defun ,color (str)
     ,(docstring color)
     (if (get-color-option)
       (funcall ,func str)
       str)))

(defmacro defcolors color-funcs (defcolors* color-funcs ()))

(defcolors
  black  blackb
  white  whiteb
  red    redb
  yellow yellowb
  green  greenb
  blue   blueb)

(defun get-color-option () (ltest-util:get-arg 'color "true"))
