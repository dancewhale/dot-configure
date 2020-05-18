;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
;; Global Config for Mac
(file-truename "~/.doom.d/")
(setq my_base_path (file-truename "~/Dropbox/emacs"))

(when (eq system-type 'darwin)
  (progn
    (setq envpath (concat my_base_path "/mac"))
    (setq system_font "Kai")
    (message "config for darwin.")
  )
)

(when (eq system-type 'gnu/linux)
  (progn
    (setq envpath (concat my_base_path "/linux"))
    (setq system_font "WenQuanYi Micro Hei Mono-14")
    (message "config for darwin.")
  )
)

(load-file (concat doom-private-dir "/function.el"))


;;;-------------------------------------------------
;; 增加全局快捷键
;;;-------------------------------------------------
;;;跳转gtd文件
(define-prefix-command 'key-cao-map)
(global-set-key (kbd "s-u") 'key-cao-map)
(define-key key-cao-map (kbd "s-j") 'org-starter-find-file-by-key)


;;;-------------------------------------------------
;; 修改默认doom的theme
;;;-------------------------------------------------
(setq doom-theme 'doom-dracula)


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


;;;-------------------------------------------------
;; rime input-method
;; rime的输入法在doom中的配置的编译失败可以手工介入
;; 在repos中的emacs-rime目录中执行make lib后
;; 把编译好的so和.c文件放入build/rime目录之下。
;;;-------------------------------------------------
(require 'rime)
(setq rime-user-data-dir (concat my_base_path "/chinese/rime"))
(custom-set-variables '(rime-librime-root (concat my_base_path "/lib/librime")))

(setq rime-posframe-properties
      (list :background-color "#333333"
            :foreground-color "#dcdccc"
            :font system_font
            :internal-border-width 10))

(setq default-input-method "rime"
      rime-show-candidate 'posframe)
(global-set-key (kbd "s-j") 'toggle-input-method)


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


;;;-------------------------------------------------
;;; org的个人配置,如何记录、如何作笔记。
;;;-------------------------------------------------
(setq org-directory "~/Dropbox/org")

(setq org-log-into-drawer t)
(setq org-todo-keywords
        '((sequence
           "PROJ(p)"  ; An ongoing project that cannot be completed in one step
           "☞ TODO(t)"  ; A task that needs doing & is ready to do
           "☟ NEXT(n)"  ;tasks are things that I can work on right now; they are not blocked by anything and can be picked up.
           "⚔ INPROCESS(s!)"  ; A task that is in progress
           "⚑ WAITING(w@)"  ; Something is holding up this task; or it is paused
           "|"
           "☕ BREAK(b)"
           "✔ DONE(d!)"  ; Task successfully completed
           "✘ CANCELED(c@/!)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "EVENT(e)"
           "✍ NOTE(N)"
           "FIXME(f)"
           "❤ Love(l)"
           "REVIEW(r)"
           ))) ; Task was completed


(use-package org-starter
  :config
  (org-starter-def "~/Dropbox/org"
                   :files
                   ("GTD/gtd.org"                      :agenda t :key "g" :refile (:maxlevel .5))
                   ("GTD/notes.org"                    :agenda t :key "n" :refile (:maxlevel .5))
                   ("GTD/myself.org"                   :agenda t :key "m" :refile (:maxlevel .5))
                   ("GTD/Habit.org"                    :agenda t :key "h" :refile (:maxlevel .5))
                   )
)

(after! org (setq org-capture-templates nil))

(org-starter-define-file "gtd.org" :directory "~/Dropbox/org/GTD" :agenda t)
(org-starter-define-file "notes.org" :directory "~/Dropbox/org/GTD" :agenda t)
(org-starter-def-capture "g" "Things plan to do." entry
              (file+headline "gtd.org" "Inbox")
                 "* ☞ TODO %?  %^g" :prepend t)
(org-starter-def-capture "n" "Notes need to remember." entry
              (file+headline "notes.org" "Inbox")
                 "* ☞ TODO %?" :prepend t)
(org-starter-def-capture "m" "Things for you self." entry
              (file+headline "gtd.org" "Inbox")
                 "* ☞ TODO %?  %^g" :prepend t)
