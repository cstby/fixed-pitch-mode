;;; fixed-pitch.el --- Use fixed-pitch only in sensible buffers -*- lexical-binding: t; -*-

;; Copyright (C) 2020, Carl Steib

;; Author: Carl Steib
;; URL: https://github.com/cstby/fixed-pitch
;; Version: 0.0.0
;; Package-Requires: ((emacs "27.1"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; This file is not part of Emacs.

;;; Commentary:

;; Provides a minor mode for using the fixed-pitch face.  Allows users to use a
;; variable-pitch font as the default while still using fixed-pitch for code.

;;; Code:

(defcustom fixed-pitch-whitelist-hooks '()
  "List of hooks that should activate `fixed-pitch-mode'."
  :type '(repeat symbol)
  :group 'fixed-pitch)

(defcustom fixed-pitch-blacklist-hooks '()
  "List of hooks that should never activate `fixed-pitch-mode'."
  :type '(repeat symbol)
  :group 'fixed-pitch)

(defcustom fixed-pitch-dont-change-cursor nil
  "Whether `fixed-pitch-mode' should keep the cursor type.

If non-nil, fixed-pitch mode will set the cursor to 'box when
activated and 'bar when deactivated."
  :type 'boolean
  :group 'fixed-pitch)

(defcustom fixed-pitch-use-extended-default nil
  "Whether the extended-defaults hooks should activate `fixed-pitch-mode'."
  :type 'boolean
  :group 'fixed-pitch)

;; These hooks are indisputably suited to fixed-pitch.
(defvar fixed-pitch-default-hooks
  '(dired-mode-hook
    comint-mode-hook
    magit-mode-hook
    prog-mode-hook
    profiler-report-mode-hook))

;; These hooks might be suited to fixed-pitch.
(defvar fixed-pitch-extended-default-hooks
  '(which-key-init-buffer-hook
    org-agenda-mode-hook
    eval-expression-minibuffer-setup-hook))

(dolist (hook (if (null fixed-pitch-use-extended-default)
		  fixed-pitch-default-hooks
		(append fixed-pitch-extended-default-hooks
			fixed-pitch-default-hooks)))
  (add-hook hook 'fixed-pitch-mode))

(dolist (hook fixed-pitch-whitelist-hooks)
  (add-hook hook 'fixed-pitch-mode))

(dolist (hook fixed-pitch-blacklist-hooks)
  (remove-hook hook 'fixed-pitch-mode))

;;;###autoload
(define-minor-mode fixed-pitch-mode
  "Use monospace typeface in the appropriate context."
  :lighter " fxd"
  (if fixed-pitch-mode
      (progn (unless fixed-pitch-dont-change-cursor (setq cursor-type 'box))
             (buffer-face-set 'fixed-pitch))
    (unless fixed-pitch-dont-change-cursor (setq cursor-type 'bar))
    (buffer-face-set)))

(provide 'fixed-pitch)
;;; fixed-pitch.el ends here
