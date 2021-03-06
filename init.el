(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (deeper-blue)))
 '(dabbrev-case-distinction nil)
 '(dabbrev-case-fold-search nil)
 '(dabbrev-case-replace nil)
 '(global-auto-revert-mode t)
 '(ido-enable-last-directory-history nil)
 '(ido-max-work-directory-list 0)
 '(ido-max-work-file-list 0)
 '(ido-record-commands nil)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(menu-bar-mode nil)
 '(show-paren-mode t)
 '(toggle-scroll-bar nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))

;; Disable emacs font set
;; Set font depends on system
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 181 :width normal :foundry "unknown" :family "Inconsolata")))))


;; When MacOS
(when (string-equal system-type "darwin") (set-default-font "Menlo 16"))
;; When Ubuntu
(when (string-equal system-type "gnu/linux") (set-default-font "Inconsolata Medium 12"))


;;;;;;;;;;;;; Google Internal Use ;;;;;;;;;;;;;
(when (require 'google nil 'noerror)
  (progn
    (require 'csearch)                  ;; Search the whole Google code base.
    (require 'google)
    (require 'google-imports)
    (require 'google-java)
    (require 'google-lint)
    (require 'google3-build)            ;; support for blaze builds
    (require 'reformat-file)
    (require 'rotate-among-files)       ;; google-rotate-among-files
    (require 'p4-google)

    (load-file "~/.emacs.d/google3-tidy-dart.el")
    (require 'google3-tidy-dart)
    ;;
    ;; (grok-init)
    ;; (setq grok-sloppy-editing nil)
    ;;
    ;;
    ;;



    ;;make chrome the default browser
    (setq browse-url-browser-function 'browse-url-generic
	  browse-url-generic-program "google-chrome")
    ;;
    ;;allow navigation of dashcase/camelCase etc word at a time(
    ;;awesome for deleting parts of a variable name Hit Alt+D and it
    ;;will delete only a subword.
    (add-hook 'c-mode-common-hook
	      (lambda () (subword-mode 1)))

    ;; Auto imports org only works with Java and C++.
    (add-hook 'java-mode-hook
	      '(lambda ()
		 (add-hook 'write-contents-functions 'google-imports-organize-imports)))
    (add-hook 'c++-mode-common-hook
	      '(lambda ()
		 (add-hook 'write-contents-functions 'google-imports-organize-imports)))
    (add-hook 'dart-mode-hook
	      '(lambda ()
		 (add-hook 'after-save-hook 'google3-tidy-dart nil 'make-it-local)))

    ;;
    ;;
    ;; Turn on red highlighting for characters outside of the 80/100 char limit
    (add-hook 'c++-mode-hook
	      '(lambda () (font-lock-set-up-width-warning 80)))
    (add-hook 'java-mode-hook
	      '(lambda () (font-lock-set-up-width-warning 100)))
    (add-hook 'js-mode-hook
	      '(lambda () (font-lock-set-up-width-warning 80)))
    (add-hook 'dart-mode-hook
	      '(lambda () (font-lock-set-up-width-warning 80)))
    (add-hook 'python-mode-hook
	      '(lambda () (font-lock-set-up-width-warning 80)))
    (add-hook 'sawzall-mode-hook
	      '(lambda () (font-lock-set-up-width-warning 80)))
    (add-hook 'sh-mode-hook
	      '(lambda () (font-lock-set-up-width-warning 80)))
    ;;

    ;;;; fill-column
    ;;
    (add-hook 'java-mode-hook
	      (lambda ()
		(set-fill-column 100)))

    (add-hook 'c-mode-common-hook
	      (lambda ()
		(set-fill-column 80)))

    (add-hook 'dart-mode-hook
	      (lambda ()
		(set-fill-column 80)))
    ;;

    ;;
    ;;
    ;; Suppress the trailing empty to be shown in RED
    (setq google-trailing-whitespace-modes '())
    (message "Suppressed trailing empty space red mode")
    ;;
    ;;
    )
  )
;;;;;;;;;;;;; Google Internal Use ;;;;;;;;;;;;;


;; Auto delete trailling space before saving
(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (add-hook 'before-save-hook 'delete-trailing-whitespace)))

;; Auto backup i.e. "xxxx.txt~" is annoying.
;; Shut it up
(setq make-backup-files nil)

;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
;; create the autosave dir if necessary, since emacs won't.
;;
;; This thing does not work!!!!!!!
;;
;;; make completion buffers disappear after 3 seconds.
;; (add-hook 'completion-setup-hook
;;   (lambda () (run-at-time 3 nil
;;     (lambda () (delete-windows-on "*Completions*")))))


;;;;;; Global viriables
;;
;;
;;; make typing overwrite text selection
(delete-selection-mode t)

;;; Disable what? forgot
(put 'scroll-left 'disabled nil)

;;; Shut up compile saves
(setq compilation-ask-about-save nil)

;;; Enable erase buffer
(put 'erase-buffer 'disabled nil)

;;
;;
;;;;;;


;;;;;; Packages
;;
;;
;;
(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
;;
;;

;; use-package
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(require 'use-package)
;;
;;

;; For compliant packages, in future!
;;
;; (let ((default-directory "~/.emacs.d/lisp/"))
;;   (normal-top-level-add-to-load-path '("."))
;;   (normal-top-level-add-subdirs-to-load-path))

;; common used package
;;
(use-package noflet :ensure t)
;;
;;

(use-package smart-tab :ensure t)
(global-smart-tab-mode 1)

(use-package ido :ensure t)
(use-package ido-ubiquitous :ensure t)
(use-package smex :ensure t)
(ido-mode t)
(ido-ubiquitous-mode t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(smex-initialize)

(use-package kill-ring-ido :ensure t)
(global-set-key (kbd "C-M-y") 'kill-ring-ido)

(use-package visual-regexp :ensure t)
(use-package visual-regexp-steroids :ensure t)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)
;; to use visual-regexp-steroids's isearch instead of the built-in regexp isearch, also include the following lines:
(define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
(define-key esc-map (kbd "C-s") 'vr/isearch-forward) ;; C-M-s

(use-package smooth-scrolling :ensure t)

(use-package rainbow-delimiters :ensure t)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(use-package expand-region :ensure t)
(global-set-key (kbd "C-`") 'er/expand-region)
(global-set-key (kbd "C-\\") 'er/expand-region)

(use-package nlinum :ensure t)
(global-nlinum-mode t)
;;
;;
;;
;;;;;;

;; ;;; auto-save
;; ;; automatically save buffers associated with files on buffer switch
;; ;; and on windows switch
;; (defadvice switch-to-buffer (before save-buffer-now activate)
;;   (when buffer-file-name (save-buffer)))
;; (defadvice other-window (before other-window-now activate)
;;   (when buffer-file-name (save-buffer)))
;; (defadvice windmove-up (before other-window-now activate)
;;   (when buffer-file-name (save-buffer)))
;; (defadvice windmove-down (before other-window-now activate)
;;   (when buffer-file-name (save-buffer)))
;; (defadvice windmove-left (before other-window-now activate)
;;   (when buffer-file-name (save-buffer)))
;; (defadvice windmove-right (before other-window-now activate)
;;   (when buffer-file-name (save-buffer)))

;;;;;;;; Disable stupid secondary region.
;;
;;
(global-unset-key [M-mouse-1])
(global-unset-key [M-drag-mouse-1])
(global-unset-key [M-down-mouse-1])
(global-unset-key [M-mouse-3])
(global-unset-key [M-mouse-2])
;;
;;;;;;;;

;;;;;;;;;; Smart Copy/Kill Current Line
;;
;;

(defun my-smart-copy-kill-selector ()
  "Smartly select current object to be copied or killed based on context.
return a 2-tuple-list."
  (if mark-active
      (progn (message "Copied region") (list (region-beginning) (region-end)))
    ;; else 1
    (if (and (not (equal (point) (line-beginning-position))) (bounds-of-thing-at-point 'symbol))
	(progn (message "Copied symbol: %s" (thing-at-point 'symbol)) (list (car (bounds-of-thing-at-point 'symbol)) (cdr (bounds-of-thing-at-point 'symbol))))
      ;; else 2
      (progn (message "Copied line: %s" (thing-at-point 'line)) (list (line-beginning-position) (line-end-position)))
      );; end of if 2
    );; end of if 1
  )

(defadvice kill-ring-save (before smart-copy-line activate compile)
  "When called interactively with no active region, copy a single line or a a word instead."
  (interactive (my-smart-copy-kill-selector))
  )


(defadvice kill-region (before smart-kill-line activate compile)
  "Same as above."
  (interactive (my-smart-copy-kill-selector))
  )
;;
;;
;;;;;;;;;;


;;;;;;;;;; Fast switch to last buffer
;;
(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open
buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(keyboard-translate ?\C-q ?\H-q)
(global-set-key [?\H-q] 'switch-to-previous-buffer)
;;
;;;;;;;;;;


;;;;;;;;;; Make scrolling move cursors
;;
(defun sfp-page-down ()
  (interactive)
  (setq this-command 'next-line)
  (next-line
   (- (window-text-height)
      next-screen-context-lines)))

(defun sfp-page-up ()
  (interactive)
  (setq this-command 'previous-line)
  (previous-line
   (- (window-text-height)
      next-screen-context-lines)))

(global-set-key [next] 'sfp-page-down)
(global-set-key [prior] 'sfp-page-up)
;;
;;;;;;;;;;


(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;; ~~~~~
;;;; Other window override all
(define-key my-keys-minor-mode-map (kbd "C-o") 'other-window)
(global-set-key (kbd "M-n") 'next-line)
(global-set-key (kbd "M-p") 'previous-line)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x C-k") 'kill-buffer-and-window)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x f") 'dired)
(global-set-key (kbd "<C-M-backspace>") 'backward-kill-sexp)
(define-key my-keys-minor-mode-map (kbd "C-z") 'smex)

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " ning-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode t)
;;;;

;;;; Always show file path in frame title
;;
;;
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
	    '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))


;;;; iBuffer name column width
;;
;;
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 60 60 :left :elide) " "
              (size 9 -1 :right) " "
              (mode 16 16 :left :elide) " " filename-and-process)
        (mark " " (name 16 -1) " " filename)))
;;
;;
;;;;

;;;; Compilation auto scroll ;;;;
;;
;;
(setq compilation-scroll-output 'first-error)
;;
;;
;;;;

;;
;;;;

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "hot pink"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "magenta"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "#ff7f00"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "#FFFF00"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "#00FF00"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "#0000FF"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "#4B0082"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "#8B00FF")))))
(put 'downcase-region 'disabled nil)
