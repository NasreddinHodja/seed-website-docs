;; setup project publishing

(when (file-directory-p "./public")
  (delete-directory "./public" t))
(make-directory "./public" t)

;; init package system
(require 'package)
(setq package-user-dit (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; dependencies
(unless package-archive-contents
  (package-refresh-contents))

(package-install 'htmlize)
(unless (package-installed-p 'json-mode)
  (package-install 'json-mode))
(unless (package-installed-p 'typescript-mode)
  (package-install 'typescript-mode))

(require 'ox-publish)
(require 'json-mode)
(require 'typescript-mode)


;; define publish project
(setq org-publish-project-alist
      '(("docs-content"
         :base-directory "./content"
         :publishing-directory "./public"
         :recursive t
         :publishing-function org-html-publish-to-html
         :with-author nil
         :with-creator nil
         :with-toc nil
         :section-numbers nil
         :time-stamp-file nil
         )

        ("docs-static"
         :base-directory "./static"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|svg"
         :publishing-directory "./public/static"
         :recursive t
         :publishing-function org-publish-attachment)

        ("seed-website-dev-docs" :components ("docs-content" "docs-static"))))

;; customize html output
(setq org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; generate site output
(org-publish-all t)

(message "Build complete!")
