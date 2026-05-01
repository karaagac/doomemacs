(setq doom-theme 'doom-one)
(setq doom-font (font-spec :family "Monaco" :size 15))

(map! :leader
      :desc "Save file" "w" #'save-buffer)

(map! :leader
      :desc "Kill current buffer"
      "k" #'kill-current-buffer)

(map! :leader
      :desc "Run Java file"
      "r j" #'my/run-java-file)

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(after! consult
  (consult-customize
   +default/search-project
   +default/search-other-project
   +default/search-project-for-symbol-at-point
   +default/search-cwd
   +default/search-other-cwd
   +default/search-notes-for-symbol-at-point
   +default/search-emacsd
   :preview-key 'any))

(setq doom-theme 'doom-tokyo-night)


;;(custom-theme-set-faces!
;; 'doom-one
(after! org
  (custom-set-faces!
   '(org-level-1 :weight bold :height 1.6 :inherit outline-1)
   '(org-level-2 :weight bold :height 1.5 :inherit outline-2)
   '(org-level-3 :weight bold :height 1.4 :foreground "#ffb86c" :inherit outline-3)
   '(org-level-4 :weight bold :height 1.3 :inherit outline-4)
   '(org-level-5 :weight bold :height 1.2 :inherit outline-5)
   '(org-level-6 :weight bold :height 1.1 :inherit outline-6)
   '(org-level-7 :weight bold :height 1.05 :inherit outline-7)
   '(org-level-8 :weight bold :height 1.0 :inherit outline-8)))

(setq org-directory "~/org/")
(add-hook 'org-mode-hook #'hl-todo-mode)

(setq org-roam-directory "~/orgroam")
(setq org-roam-index-file "~/orgroam/index.org")

(setq display-line-numbers-type t)

(after! org
  (setq org-ellipsis "")) ;;remove [...] next to headings.
;;(setq confirm-kill-emacs nil)

(setq lsp-completion-provider :capf)

(defun my/run-java-file ()
  "Compile and run Java file correctly (safe project-root detection)."
  (interactive)
  (let* ((file (buffer-file-name))
         (project (or (projectile-project-root)
                      (locate-dominating-file file "src")
                      (error "No project root found")))
         (src-root (concat project "src/main/java/"))
         (relative (file-relative-name file src-root))
         (class (file-name-sans-extension relative))
         (pkg-class (replace-regexp-in-string "/" "." class)))
    (compile
     (format "cd %s && javac %s && java -cp . %s"
             src-root
             relative
             pkg-class))))
