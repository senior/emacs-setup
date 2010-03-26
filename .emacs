;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Global
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "~/elisp"))
(add-to-list 'load-path (expand-file-name "~/elisp/drag-stuff"))

(require 'tabbar)
(require 'color-theme)
(require 'drag-stuff)

(global-font-lock-mode t)
(setq debug-on-error t)
(setq transient-mark-mode t)
(setq visible-bell 1)
(column-number-mode)
(autoload 'tabbar-mode "Tabbar mode enabled" t)
(server-start)
(tabbar-mode)
(color-theme-rotor)
(drag-stuff-global-mode t)
(setq truncate-lines t)
(setq scroll-conservatively 10000)
(setq x-select-enable-clipboard t)

(put 'dired-find-alternate-file 'disabled nil)

(setq
 backup-by-copying t    
 backup-directory-alist
 '(("." . "~/backups"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)

(defun auto-revert ()
  (interactive)
  (message "starting revert")
  (revert-buffer t t nil)
  (message "revert complete"))

(set-face-attribute 'default nil :font "DejaVu Sans Mono-8")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; JDE
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "~/elisp/jdee-2.4.0.1/lisp"))
(add-to-list 'load-path (expand-file-name "~/elisp/elib-1.0"))
(load-file (expand-file-name "~/elisp/cedet-1.0pre6/common/cedet.el"))

(require 'speedbar)
(require 'eieio)
(require 'semantic)
(require 'jde)

(setq semantic-load-turn-useful-things-on t)
(setq jde-check-version-flag nil)
(setq semanticdb-default-save-directory "~/backups")

(setq jde-jdk-registry (quote (("1.6.0" . "/home/ryan/java_devl/jdk1.6.0_11"))))

(autoload 'speedbar-frame-mode "speedbar" "Popup a speedbar frame" t)
(autoload 'speedbar-get-focus "speedbar" "Jump to speedbar frame" t)

(add-to-list 'auto-mode-alist '("\\.jsp\\'" . html-helper-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Eshell
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defalias 'ff 'find-file)
(defalias 'ffo 'find-file-other-window)

(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
	(beginning-of-line))))
(add-hook 'eshell-mode-hook
	  '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))

(global-set-key (kbd "C-c e") 'eshell)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; HTML/XML
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "~/elisp/nxml-mode"))

(require 'html-helper-mode)
(require 'nxml-mode)

(define-skeleton html-list-item
  "HTML list item tag."
  nil
  "<li>" _  "</li>")
(define-skeleton html-paragraph
  "HTML paragraph item tag."
  nil
  "<p>" _
  "</p>")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;Org-mode
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "~/elisp/org-6.34c/lisp"))

(require 'org-install)
(require 'remember)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-hide-leading-stars t)

(setq org-agenda-files (file-expand-wildcards "~/org-notes/*.org"))

(appt-activate t)

(org-remember-insinuate)
(setq org-directory "~/org-notes/")
(setq org-default-notes-file (concat org-directory "/general-notes.org"))
(define-key global-map "\C-cr" 'org-remember)

 (setq org-remember-templates
       '(("Todo" ?t "* TODO %?\n  %i\n  %a" "~/org-notes/TODO.org" "Tasks")
	 ("To Read" ?r "* TODO :READ: %^g [#%^{Priority|A|B|C}] %?\n  %^L\n" "~/org-notes/Reading.org" "Tasks")
        ("Idea" ?i "* %^{Title}\n  %i\n  %a" "~/org-notes/Ideas.org" "New Ideas")))

(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'auto-fill-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; OCaml
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path (expand-file-name "~/elisp/tuareg-mode-1.46.2/"))

(setq auto-mode-alist (cons '("\\.ml\\w?" . tuareg-mode) auto-mode-alist))
(autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
(autoload 'camldebug "camldebug" "Run the Caml debugger" t)
(autoload 'tuareg-run-caml "tuareg" "REPL for OCaml" t)
(if (and (boundp 'window-system) window-system)
    (require 'font-lock))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Clojure/Slime
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun compile-load-withns ()
  "Compiles the clj file, loads it into the repl switches the current namespace of the repl to the one the file is in and then switches to the slime repl buffer"
  (interactive)
  (slime-compile-and-load-file)
  (slime-repl-set-package (slime-current-package))
  (slime-switch-to-output-buffer))

(defun get-all-buffer-names ()
  "Returns the names of all of the currently open buffers as a string"
  (let (value)
     (dolist (buff (buffer-list) value)
      (setq value (cons (buffer-name buff) value)))))

(defun kill-sldb-buffers ()
  "kills all of the currently open sldb buffers"
  (interactive)
  (dolist (buff (get-all-buffer-names))
    (if (string= (substring buff 0 5) "*sldb")
	(kill-buffer buff))))

(defun slime-local ()
  "Connects to a swank instance running on localhost, port 4005"
  (interactive)
  (slime-connect "127.0.0.1" "4005"))

(add-hook 'clojure-mode-hook (lambda ()(define-key clojure-mode-map "\C-cd" 'compile-load-withns)))
(add-hook 'clojure-mode-hook (lambda ()(define-key clojure-mode-map "\C-ck" 'kill-sldb-buffers)))
;	     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ibuffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'ibuffer) 
(setq ibuffer-saved-filter-groups
  (quote (("default"      
            ("Org" ;; 
              (mode . org-mode))  
            ("Clojure" ;; 
              (or
                (mode . slime-mode)
                (mode . clojure-mode)))
                ))))

(add-hook 'ibuffer-mode-hook
  (lambda ()
    (ibuffer-switch-to-saved-filter-groups "default")))

(global-set-key (kbd "C-x C-b") 'ibuffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; N3
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~elisp/n3-mode.el")
(autoload 'n3-mode "n3-mode" "Major mode for OWL or N3 files" t)

;; Turn on font lock when in n3 mode
(add-hook 'n3-mode-hook
          'turn-on-font-lock)

(setq auto-mode-alist
      (append
       (list
        '("\\.n3" . n3-mode)
        '("\\.owl" . n3-mode))
       auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; erc
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'erc)

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))



