(setq doom-theme 'doom-tokyo-night)
(setq doom-font (font-spec :family "Monaco" :size 16))

(map! :leader
      :desc "Save file" "w" #'save-buffer)

(map! :leader
      :desc "Kill current buffer"
      "k" #'kill-current-buffer)

(map! :leader
      :desc "Run Java file"
      "r j" #'my/run-java-file)

;; key binding to funtion in images header.
(map! :leader
      :desc "Toggle inline images"
      "t i" #'my/org-toggle-images)

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

(after! org
  (require 'org-id)
  (setq org-id-method 'uuid)
  (setq org-directory "~/org/")
  (setq org-ellipsis "")

  (add-hook 'org-mode-hook #'hl-todo-mode)

  (custom-set-faces!
   '(org-level-1 :weight bold :height 1.6 :inherit outline-1)
   '(org-level-2 :weight bold :height 1.5 :inherit outline-2)
   '(org-level-3 :weight bold :height 1.4 :foreground "#ffb86c" :inherit outline-3)
   '(org-level-4 :weight bold :height 1.3 :inherit outline-4)
   '(org-level-5 :weight bold :height 1.2 :inherit outline-5)
   '(org-level-6 :weight bold :height 1.1 :inherit outline-6)
   '(org-level-7 :weight bold :height 1.05 :inherit outline-7)
   '(org-level-8 :weight bold :height 1.0 :inherit outline-8)))

(setq org-roam-directory "~/orgroam")
(setq org-roam-index-file "~/orgroam/index.org")

;;create id in org-roam file
(defun my/org-roam-capture-create-id ()
  "Create an ID for the captured node."
  (when (and (not org-note-abort)
             (org-roam-capture-p))
    (org-id-get-create)))

(add-hook 'org-capture-prepare-finalize-hook 'my/org-roam-capture-create-id)

(setq display-line-numbers-type 'relative)

;;(setq confirm-kill-emacs nil)

(setq
 ;; Inline images.
 org-startup-with-inline-images t
 org-image-actual-width nil
 )

(defun my/org-toggle-images ()
  (interactive)
  (if org-inline-image-overlays
      (org-remove-inline-images)
    (org-display-inline-images)))

(defun my/tangle-config-org ()
  "Tangle config.org safely."
  (when (and buffer-file-name
             (string-equal
              (expand-file-name buffer-file-name)
              (expand-file-name "~/.doom.d/config.org")))
    (org-babel-tangle)))

(add-hook 'after-save-hook #'my/tangle-config-org)

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
