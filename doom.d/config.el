;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Global Config for Mac
(file-truename "~/.doom.d/")

(when (eq system-type 'darwin)
  (progn
    (setq envpath (file-truename "~/Dropbox/MacForEmacs"))
    (message "config for darwin.")
  )
)

(when (eq system-type 'gnu/linux)
  (progn
    (setq envpath (file-truename "~/Dropbox/LinuxForEmacs"))
    (message "config for darwin.")
  )
)
;;;-------------------------------------------------
;; notdeft配置
;;;-------------------------------------------------
(setq notdeft-xapian-program (concat envpath "/bin/notdeft-xapian"))
(setenv "XAPIAN_CJK_NGRAM" "1")
(setq notdeft-directories '("~/.roam/"))

;;;-------------------------------------------------
;; roam 的配置
;;;-------------------------------------------------
(setq org-roam-directory "~/.roam/")

;;; ----------------------------
;;; global的键位设置
;;; ----------------------------
;;; (define-key org-mode-map (kbd "C-c i") 'org-insert-heading)


;;;-------------------------------------------------
;;; zetteldeft 配置
;;;-------------------------------------------------
;;;防止doom默认配置下zettel-new-file出现双标题.
(set-file-template! 'org-mode :ignore t)
(require 'zetteldeft)
(setq deft-use-filter-string-for-filename nil)

;; zetteldeft的快捷键配置
(global-set-key (kbd "C-c d d") 'deft)
(global-set-key (kbd "C-c d D") 'zetteldeft-deft-new-search)
(global-set-key (kbd "C-c d R") 'deft-refresh)
(global-set-key (kbd "C-c d s") 'zetteldeft-search-at-point)
(global-set-key (kbd "C-c d c") 'zetteldeft-search-current-id)
(global-set-key (kbd "C-c d f") 'zetteldeft-follow-link)
(global-set-key (kbd "C-c d F") 'zetteldeft-avy-file-search-ace-window)
(global-set-key (kbd "C-c d l") 'zetteldeft-avy-link-search)
(global-set-key (kbd "C-c d t") 'zetteldeft-avy-tag-search)
(global-set-key (kbd "C-c d T") 'zetteldeft-tag-buffer)
(global-set-key (kbd "C-c d i") 'zetteldeft-find-file-id-insert)
(global-set-key (kbd "C-c d I") 'zetteldeft-find-file-full-title-insert)
(global-set-key (kbd "C-c d o") 'zetteldeft-find-file)
(global-set-key (kbd "C-c d n") 'zetteldeft-new-file)
(global-set-key (kbd "C-c d N") 'zetteldeft-new-file-and-link)
(global-set-key (kbd "C-c d r") 'zetteldeft-file-rename)
(global-set-key (kbd "C-c d x") 'zetteldeft-count-words)

;; rime input-method
(add-load-path! (file-truename "~/emacs-rime"))
(require 'rime)
(setq rime-user-data-dir "~/.config/fcitx/rime")

(setq rime-posframe-properties
      (list :background-color "#333333"
            :foreground-color "#dcdccc"
            :font "WenQuanYi Micro Hei Mono-14"
            :internal-border-width 10))

(setq default-input-method "rime"
      rime-show-candidate 'posframe)


;;;-------------------------------------------------
;; org-editor启动
;;;-------------------------------------------------
(require 'anki-editor)


;;;-------------------------------------------------
;;; org-journal的个人配置,该包主要用于工作学习日志
;;;-------------------------------------------------
(require 'org-journal)
(customize-set-variable 'org-journal-dir "~/Dropbox/org/worklog")
(customize-set-variable 'org-journal-new-date-entry "%A, %d %B %Yz")
(customize-set-variable 'org-journal-file-type `weekly)
(customize-set-variable 'org-journal-file-format "%Y%m%d")

(defun org-journal-date-format-func (time)
  "Custom function to insert journal date header,
and some custom text on a newly created journal file."
  (when (= (buffer-size) 0)
    (insert
     (pcase org-journal-file-type
      (`daily "#+TITLE: Daily Journal")
       (`weekly "#+TITLE: Weekly Journal")
       (`monthly "#+TITLE: Monthly Journal")
       (`yearly "#+TITLE: Yearly Journal"))))
  (concat org-journal-date-prefix (format-time-string "%A, %x" time)))

(setq org-journal-date-format 'org-journal-date-format-func)

(load-file (concat doom-private-dir "/function.el"))
