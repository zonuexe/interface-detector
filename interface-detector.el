;;; interface-detector --- Interactive interfaces integration -*- lexical-binding: t -*-

;; Copyright (C) 2016 USAMI Kenta

;; Author: USAMI Kenta <tadsan@zonu.me>
;; Created: 20 May 2016
;; Version: 0.0.1
;; Keywords: extensions convenience
;; Homepage: https://github.com/zonuexe/interface-detector

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Setup:

;; Integration interactive interface.  (Helm, ido and Anything...)
;;
;; For users:
;;
;;     (setq interface-detector-interface 'helm)
;;
;; For Lisp package authors:
;;
;;     (require 'interface-detector)
;;     (let ((interface-detector-expected '(anything helm ido)))
;;       (interface-detector))
;;
;; By constraining the expected value enclosed in let,
;; to protect your code from damage when new interactive interface has added.

;;; Code:
(defgroup interface-detector ()
  "Interactive interfaces integration"
  :group 'convenience)

(defvar interface-detector-expected '(anything helm ido smex popup-el x-popup)
  "List of expected interfaces symbol.")

(defcustom interface-detector-interface nil
  "Your interactive interface."
  :type '(choice (const :tag "Auto"     nil)
                 (const :tag "Default"  'default)
                 (const :tag "Anything" 'anything)
                 (const :tag "Helm"     'helm)
                 (const :tag "Ivy/Counsel" 'counsel)
                 (const :tag "IDO"      'ido)))

;;;###autoload
(defun interface-detector ()
  "Return symbol of mutched interface name.
Return NIL if mutch any interactive interface or `interface-detector-interface' is 'default."
  (if (eq interface-detector-interface 'default)
      nil
    (car-safe
     (memq
      (or interface-detector-interface
          (cond
           ((and window-system menu-prompting) 'x-popup)
           ((fboundp 'popup-menu) 'popup-el)
           ((and (boundp 'smex-initialized-p) smex-initialized-p) 'smex)
           ((and (boundp 'counsel-mode) counsel-mode) 'counsel)
           ((and (boundp 'ido-mode) ido-mode) 'ido)
           ((and (boundp 'helm-mode) helm-mode) 'helm)
           ((fboundp 'anything) 'anything)
           (:else nil)))
      interface-detector-expected))))

(provide 'interface-detector)
;;; interface-detector.el ends here
