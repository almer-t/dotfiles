;; *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*
;; EMACS MAIN DOT-FILE (Almer S. Tigelaar)
;; *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*

;; Custom Loaders
;; ==============

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
	     '("marmalade" . "https://marmalade-repo.org/packages/"))
(package-initialize)

(require 'cl)
;; Guarantee all packages are installed on start  ;;prev: color-theme-solarized
(defvar packages-list
  '(better-defaults
    solarized-theme
    ergoemacs-mode
    multi-web-mode
    less-css-mode
    markdown-mode
    magit
    find-file-in-project
    py-yapf
    auto-complete
    highlight-indentation
    flymake-python-pyflakes
    ipython
    )
  "List of packages needs to be installed at launch")

(defun has-package-not-installed ()
  (loop for p in packages-list
        when (not (package-installed-p p)) do (return t)
        finally (return nil)))
(when (has-package-not-installed)
  ;; Check for new packages (package versions)
  (message "%s" "Get latest versions of all packages...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; Install the missing packages
  (dolist (p packages-list)
    (when (not (package-installed-p p))
      (package-install p))))

;; Custom
;; ======

(setq custom-file "~/.emacs-custom")

(setq ido-use-virtual-buffers t)

;; Modes and Themes
;; ================

(set-face-attribute 'default nil :font "Hack 12")
(set-face-attribute 'default t :font "Hack 12")
(set-default-font "Hack 12")

;; solarized-theme
(load-theme 'solarized-dark t)

;; Mark column 80
(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)

;; Indentation highlight
;;(require 'highlight-indentation)
;;(set-face-background 'highlight-indentation-face "#e3e3d3")
;;(set-face-background 'highlight-indentation-current-column-face "#c3b3b3")

;; color-theme-solarized (future)
;; Switch Theme Solarized Light and Dark
;; Source: https://github.com/pyr/dot.emacs/blob/master/customizations/40-theme.el

;;(custom-set-variables '(solarized-termcolors 256))
;;(setq solarized-default-background-mode 'dark)
;;(load-theme 'solarized t)

;;(defun set-background-mode (frame mode)
;;  (set-frame-parameter frame 'background-mode mode)
;; (when (not (display-graphic-p frame))
;;    (set-terminal-parameter (frame-terminal frame) 'background-mode mode))
;;  (enable-theme 'solarized))

;;(defun switch-theme ()
;;  (interactive)
;;  (let ((mode  (if (eq (frame-parameter nil 'background-mode) 'dark)
;;                   'light 'dark)))
;;    (set-background-mode nil mode)))

;;(add-hook 'after-make-frame-functions
;;         (lambda (frame) (set-background-mode frame solarized-default-background-mode)))

;;(set-background-mode nil solarized-default-background-mode)
;;(global-set-key (kbd "C-c t") 'switch-theme)

;; flymake
(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)

;; autocomplete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;; js2 mode
(require 'js2-mode) 

;; multi-web-mode load

(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js2-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (js2-mode "{% call macros.javascript() %}" "{% endblock script %}")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
;;(multi-web-global-mode 1)

;; markdown
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;(autoload 'gfm-mode "gfm-mode"
;   "Major mode for editing GitHub Flavored Markdown files" t)
;(add-to-list 'auto-mode-alist '("README.*\\.md\\'" . gfm-mode))

;; Keyboard Settings
;; =================

(setq ergoemacs-theme nil)
(setq ergoemacs-keyboard-layout "programmer-dv")
(require 'ergoemacs-mode)
(global-set-key "\M-s" 'ergoemacs-end-of-line-or-what)
(global-set-key "\M-;" 'comment-dwim)
(ergoemacs-mode 1)
(put 'downcase-region 'disabled nil)
(desktop-save-mode 1)

;; Smex (ido)
;;(global-set-key (kbd "A-x") 'smex)
;;(global-set-key (kbd "A-X") 'smex-major-mode-commands)
;; This is your old M-x.
;;(global-set-key (kbd "C-c C-c M-a") 'execute-extended-command)


; C mode key-bindings
(define-key c-mode-map "\C-k" 'kill-line-and-reindent)
(define-key c-mode-map [(control <)] 'c-beginning-of-defun)
(define-key c-mode-map [(control >)] 'c-end-of-defun)
(define-key c-mode-map "\M-a" 'c-beginning-of-statement)
(define-key c-mode-map "\M-e" 'c-end-of-statement)
(define-key c-mode-map "\C-\M-h" 'c-mark-function)
(define-key c-mode-map "\C-\M-j" 'c-mark-statement)
(define-key c-mode-map [return] 'c-context-line-break)

; C++ mode keybindings
(define-key c++-mode-map "\C-k" 'kill-line-and-reindent)
(define-key c++-mode-map [(control <)] 'c-beginning-of-defun)
(define-key c++-mode-map [(control >)] 'c-end-of-defun)
(define-key c++-mode-map "\M-a" 'c-beginning-of-statement)
(define-key c++-mode-map "\M-e" 'c-end-of-statement)
(define-key c++-mode-map "\C-\M-h" 'c-mark-function)
(define-key c++-mode-map "\C-\M-j" 'c-mark-statement)
(define-key c++-mode-map [return] 'c-context-line-break)

;; Tried this, but it's really confusing
;;(setq modifier-keys-are-sticky t)

;; Keybindings Under Considerations (though should be mapped to ErgoMacs)
;;(global-set-key (kbd "C-z") ctl-x-map)
;;(global-set-key (kbd "M-z") 'execute-extended-command)
;;(global-set-key (kbd "C-x C-h") help-map)
;;(global-set-key (kbd "C-h") 'previous-line)

;; COMPILATION WINDOWS SETTINGS
;; ============================
(setq compilation-window-height 10)
(setq compilation-scroll-output t)
(setq compile-auto-highlight t)

;; Hide compilation windows after compiling successfully.
;; Adapted from: http://www.bloomington.in.us/~brutt/emacs-c-dev.html
(setq compilation-finish-function
      (lambda (buf str)	
	(save-excursion
	  (set-buffer buf)
	  (setq bufstr (buffer-string))
	  (if (or (string-match "exited abnormally" str) (string-match "^make:.*\[.*\].*Error.*$" bufstr))
	      ;;there were errors
	      (message "compilation errors, press C-x ` to visit")	  
	    ;;no errors, maybe warnings?
	    (if (string-match "^.*warning:.*$" bufstr)
		(message "compilation warnings, press C-x ` to visit")
	      ;;no errors and warnings, make the compilation window go away in 0.5 seconds and bury it.
	      (run-at-time 0.5 nil 'delete-windows-on buf)
	      (run-at-time 0.5 nil 'bury-buffer buf)
	      (message "compilation successful"))))))

;; PROGRAMMING SPECIFIC STYLES
;; ===========================
;; (Reference: http://cc-mode.sourceforge.net/html-manual/Syntactic-Symbols.html#Syntactic%20Symbols)

; Indent HTML/Javascript with tabs rendered as four spaces
(add-hook 'html-mode-hook
          (lambda()
            (setq tab-width 4)
            (setq tab-stop-list (number-sequence 4 200 4))
            (setq sgml-basic-offset 4)
            (setq indent-tabs-mode nil)))
(add-hook 'js2-mode-hook
          (lambda()
            (setq tab-width 4)
            (setq tab-stop-list (number-sequence 4 200 4))
            (setq js2-basic-offset 4)
            (setq indent-tabs-mode nil)))
(add-hook 'css-mode-hook
          (lambda()
            (setq tab-width 4)
            (setq tab-stop-list (number-sequence 4 200 4))
            (setq css-indent-offset 4)
            (setq indent-tabs-mode nil)))

; HIO Java Style
(c-add-style "hio-java"
	     '("java-style-basis"
	       (parens-require-spaces . nil)            ; Do not require a space before a opening paren
	       (c-hanging-braces-alist
		(defun-open after)                      ; Opening brace on same line as function definition
		(defun-close before after)              ; Closing brace of function definition on seperate line
		(substatement-open after)               ; Newline after opening a substatement
		(substatement-close before after)       ; Newline before and after closing a substatement
		(block-open)                            ; No newlines on block open (block is "if", "while", etc..)
		(block-close)                           ; No newlines on block close
		(class-open after)                      ; After class open brace
		(class-close before after)              ; Before and after class close brace
		(inline-open after)                     ; Function inside class, opening brace on same line
		(inline-close before after)             ; Function inside class, closing brace on seperate line
		(statement-case-open after))            ; Newline after opening a case statement
	       (c-cleanup-list
		brace-else-brace                        ; Force braces on one line for "else" construct
		brace-elseif-brace                      ; Force braces on one line for "else if" construct
		brace-catch-brace                       ; Force braces on one line for "catch" construct
		empty-defun-braces                      ; Clean-up empty function braces
		defun-close-semi                        ; Place closing semi-colon on same line as statement
		compact-empty-funcall)))                ; Remove space between function call and parens if arglist is empty

; HIO C++ Style
(c-add-style "hio-c++"
	     '("c-and-c++-style-basis"
	       (c-basic-offset . 8)                     ; 8 spaces indent
	       (parens-require-spaces . nil)            ; Do not require a space before a opening paren
	       (c-offsets-alist
		(access-label . -)	                ; C++ class labels
		(inclass . ++)		                ; C++ function inside class
		(comment-intro . c-lineup-comment)      ; Line up continued comments
		(substatement-open . 0))                ; Brace on same level als previous line
	       (c-hanging-braces-alist
		(defun-open after)                      ; Opening brace on same line as function definition
		(defun-close before after)              ; Closing brace of function definition on seperate line
		(substatement-open after)               ; Newline after opening a substatement
		(substatement-close after)              ; Newline after closing a substatement
		(block-open)                            ; No newlines on block open (block is "if", "while", etc..)
		(block-close)                           ; No newlines on block close
		(class-open after)                      ; After class open brace
		(class-close after)                     ; After class close brace
		(topmost-intro after))                  ; This basically means after the function return type
	       (c-hanging-colons-alist
		(access-label after))                   ; After C++ class label
	       (c-cleanup-list
		brace-else-brace                        ; Force braces on one line for "else" construct
		brace-elseif-brace                      ; Force braces on one line for "else if" construct
		brace-catch-brace                       ; Force braces on one line for "catch" construct
		defun-close-semi                        ; Place closing semi-colon on same line as statement
		scope-operator)))                       ; Clean-up two consecutive colons in C++

; GNOME C Style
(c-add-style "gnome-c"
	     '("c-and-c++-style-basis"
	       (c-basic-offset . 8)                     ; 8 spaces indent
	       (parens-require-spaces . t)              ; Require a space before a opening paren
	       (c-offsets-alist
		(comment-intro . c-lineup-comment)      ; Line-up comments
		(statement-cont . c-lineup-math)        ; Align equals signs
		(access-label . -)                      ; C++ class labels
		(inclass . +)                           ; C++ function inside class
		(comment-intro . c-lineup-comment)      ; Line up continued comments
		(arglist-intro . c-lineup-arglist-intro-after-paren)
		(arglist-close . c-lineup-arglist)
		(substatement-open . 0))                ; Brace on same level als previous line
	       (c-hanging-braces-alist
		(defun-open before after)               ; Opening brace on seperate line.
		(defun-close before after)              ; Closing brace of function definition on seperate line
		(substatement-open after)               ; Newline after opening a substatement
		(substatement-close after)              ; Newline after closing a substatement
		(block-open)                            ; No newlines on block open (block is "if", "while", etc..)
		(block-close)                           ; No newlines on block close
		(class-open after)                      ; After class open brace
		(class-close after)                     ; After class close brace
		(topmost-intro after))                  ; This basically means after the function return type
	       (c-cleanup-list
		brace-else-brace                        ; Force braces on one line for "else" construct
		brace-elseif-brace                      ; Force braces on one line for "else if" construct
		brace-catch-brace                       ; Force braces on one line for "catch" construct
		defun-close-semi                        ; Place closing semi-colon on same line as statement
		space-before-funcall)))                 ; Space before function call.

; DOP Style
(c-add-style "dop"
	     '("c-and-c++-style-basis"
	       (c-basic-offset . 3)	                ; 3 spaces indent
	       (parens-require-spaces . nil)            ; Don't require a space before an opening paren
	       (c-offsets-alist
		(stream-op . c-lineup-streamop)	        ; Line-up stream operators << and >>
		(comment-intro . c-lineup-comment)      ; Line-up comments
		(substatement-open . 0)	                ; Brace on same level als previous line
		(case-label . +)	                ; Indent case labels
		(inclass . +)		                ; Single indent inside class
		(access-label . -)                      ; C++ class labels, effectively a single indent
		(inline-open . 0))	                ; C++ function inside class
	       (c-hanging-braces-alist
		(substatement-open before after))       ; Place braces on single line
	       (c-cleanup-list
		scope-operator                          ; Clean-up "::" to be on the same line
		empty-defun-braces)))	                ; Clean-up empty function braces

; Personal C++ Style
(c-add-style "personal-c++"
	     '("c-and-c++-style-basis"
	       (c-basic-offset . 8)                     ; 8 spaces indent (tab is rendered as 8 spaces)
	       (parens-require-spaces . nil)              ; Require a space before a opening paren

	       (c-offsets-alist
		(string . c-lineup-dont-change)           ; String continued on the next line (using a '\' on previous line)
		(c . c-lineup-C-comments)                 ; Comments continued on the next line "/* blah\n * blah"
		(defun-open . 0)                          ; Top-level function definition open
		(defun-close . 0)                         ; Top-level function definition close
		(defun-block-intro . +)                   ; First line in top-level function definition
		(class-open . 0)                          ; Class definition open
		(class-close . 0)                         ; Class definition close
		(inline-open . +)                         ; Inline function inside class open
		(inline-close . 0)                        ; Inline function inside class close
		(func-decl-cont . +)                      ; Function declaration continued on the next line
		(knr-argdecl-intro . +)                   ; Argument declaration list first line "int main(a,b,c)\nint a;\n ..."
		(knr-argdecl . 0)                         ; Argument declaration list other lines "... int b;\nvoid* c;\n"
		(topmost-intro . 0)                       ; Function return type (first line in top-level function declaration) "void\nfunc(..."
		(topmost-intro-cont . 0)                  ; Rest of function declaration, before the opening brace "func(...)"
		(member-init-intro . +)                   ; Initializer list, first line "Classname (int b, int c) : a(b), ..."
		(member-init-cont . c-lineup-multi-inher) ; Initializer list, continued lines "... d(c)"
		(inher-intro . +)                         ; Inheritance "class Blah :\npublic Bleh\n ..." (C++)
		(inher-cont . c-lineup-multi-inher)       ; Continued inheritance "... public Blo\npublic Bli\n"
		(block-open . 0)                          ; Compound statement open e.g. "{" in a function
		(block-close . 0)                         ; Compound statement/conditional brace close
		(brace-list-open . 0)                     ; Open brace in enum/array initializer "static int[5] = {"
		(brace-list-close . 0)                    ; Close brace in enum/array initializer
		(brace-list-intro . +)                    ; Brace list first line
		(brace-list-entry . 0)                    ; Brace list continued lines
		(brace-entry-open . 0)                    ; Sub brace list open
		(statement . 0)                           ; A statement like "a = 5".
		(statement-cont . c-lineup-math)          ; Statement continued on the next line.
		(statement-block-intro . +)               ; First line a compound statement, e.g. after "if {\n" or plain "{"
		(statement-case-intro . +)                ; First line of case statement "case 1:\na=5 ..."
		(statement-case-open . 0)                 ; First line of case surrounded by braces "case 1:\n{ ..."
		(substatement . +)                        ; First line after conditional/loop construct
		(substatement-open . 0)                   ; Brace opening substatement block
		(case-label . +)                          ; Label in switch block
		(access-label . -)                        ; Access control label like "private:" (C++), effectively none
		(label . 0)                               ; Any other label (not case or access)
		(do-while-closure . 0)                    ; When the 'while' of do-while is on a seperate line
		(else-clause . 0)                         ; "else" on a line belonging to a prior "if"
		(catch-clause . 0)                        ; "catch" (or "finally") on a line beloging to a prior "try"
		(comment-intro . c-lineup-comment)        ; First line in a comment (see also "c" above)
		(arglist-intro . +)                       ; First line in an argument list "func x(\nint a ..." starting on a SEPARATE line
		(arglist-cont . 0)                        ; Other lines in an argument list starting on a separate line
		(arglist-cont-nonempty . c-lineup-arglist) ; Other lines in an argument list where the first line started on the same line as the function definition "func x(int a\n ..."
		(arglist-close . +)                       ; Closing of the argument list on a separate line ");"
		(stream-op . c-lineup-streamop)           ; Stream operators "<<" and ">>" (C++)
		(inclass . +)                             ; Inside a class definition (C++/JAVA)
		(cpp-macro . [0])                         ; Start of pre-processor macro definition. The [] denotes an absolute position, column 0 on the line.
		(cpp-macro-cont . c-lineup-dont-change)   ; Continued macro definition (using \ at eof)
		(friend . 0)                              ; C++ friend declaration
		(objc-method-intro . [0])                 ; First line of objective C method definition
		(objc-method-args-cont . c-lineup-ObjC-method-args) ; Continued lines of objective C methode definition
		(objc-method-call-cont . c-lineup-ObjC-method-call) ; Continued lines of an objective c method call
		(extern-lang-open . 0)                              ; Brace that opens an extern block (C++)
		(extern-lang-close . 0)                             ; Brace that closes an extern block (C++)
		(inextern-lang . +)                                 ; Inside an extern block (C++)
		(namespace-open . 0)                                ; Brace that opens a namespace block (C++)
		(namespace-close . 0)                               ; Brace that closes a namespace block (C++)
		(innamespace . +)                                   ; Inside a namespace block (C++)
		(template-args-cont c-lineup-template-args +)       ; Continued template arguments (C++)
		(inlambda . c-lineup-inexpr-block)                  ; Like inclass (PIKE)
		(lambda-intro-cont . +)                             ; Like inclass (PIKE)
		(inexpr-statement . 0)                              ; Statement block inside expression (C++/PIKE)
		(inexpr-class . +))                                 ; Class declaration inside expression (JAVA)

	       (c-hanging-braces-alist                  ; Newlines after and before braces
		(defun-open before after)               ; Top-level function open brace "func ()\n{\n"
		(defun-close before after)              ; Top-level function close brace "\n}\n"
		(class-open after)                      ; Class open brace "class blah {\n"
		(class-close before after)              ; Class close brace "\n};\n"
		(inline-open before after)              ; In-line function open brace (defun-open inside class)
		(inline-close before after)             ; In-line function close brace (defun-close inside class)
		(block-open)                            ; Compound statement brace open e.g. "{" in a function
		(block-close . c-snug-do-while)         ; Compound statement/conditional brace close, "} while ()" on same line
		(substatement-open after)               ; Conditional brace open e.g. "if (...) {", "while (...) {"
		(statement-case-open after)             ; Brace opening a labeled condition inside a case statement "case 1: {\n"
		(extern-lang-open before after)         ; Extern block open brace "extern "c"\n{\n"
		(extern-lang-close before after)        ; Extern block close brace
		(brace-list-open)                       ; Open brace in enum/array initializer "static int[5] = {"
		(brace-list-close after)                ; Close brace in enum/array initializer
;;		(brace-list-intro)                      ; First line in brace list, not applicable here in hanging braces alist
		(brace-entry-open)                      ; Sub open brace within enum/array initializer "static int[5][2] = { {"
		(namespace-open before after)           ; Namespace block open brace "namespace "blah"\n{\n" (C++)
		(namespace-close)                       ; Namespace block close brace (C++)
		(inexpr-class-open)                     ; Class definition in expression open brace "func (new Blah {\n..." (JAVA)
		(inexpr-class-close))                   ; Class definition in expression close brace (JAVA)
		
	       (c-hanging-colons-alist                  ; Newlines after and before colons
		(case-label)                            ; Case label colon, no newline because of statement-case-open "case 1:"
		(label after)                           ; Goto label colon "TEST:\n"
		(access-label after)                    ; Access label colon "private:\n" (C++)
		(member-init-intro)                     ; Initializer list colon "void func() : ..." (C++)
		(inher-intro))                          ; Inheritance colon "class Blah : public Bleh" (C++)
		
	       (c-cleanup-list                        ; Clean-ups after typing
		brace-catch-brace                     ; Place "} catch (...) {" on one line
		brace-else-brace                      ; Place "} else {" on one line
		brace-elseif-brace                    ; Place "} else if (...) {" on one line
		defun-close-semi                      ; Place the ";" behind the "}" in struct/class defs like this "};"
		list-close-comma                      ; Place the "," behind the "}" in array initializers like "},"
		scope-operator)))                     ; Place C++ scope colons behind eachother "::"

; Jan C++ Style
(c-add-style "jan-c++"
	     '("c-and-c++-style-basis"
	       (c-basic-offset . 8)                     ; 8 spaces indent (tab is rendered as 8 spaces)
	       (parens-require-spaces . t)              ; Require a space before a opening paren

	       (c-offsets-alist
		(string . c-lineup-dont-change)           ; String continued on the next line (using a '\' on previous line)
		(c . c-lineup-C-comments)                 ; Comments continued on the next line "/* blah\n * blah"
		(defun-open . 0)                          ; Top-level function definition open
		(defun-close . 0)                         ; Top-level function definition close
		(defun-block-intro . +)                   ; First line in top-level function definition
		(class-open . 0)                          ; Class definition open
		(class-close . 0)                         ; Class definition close
		(inline-open . +)                         ; Inline function inside class open
		(inline-close . 0)                        ; Inline function inside class close
		(func-decl-cont . +)                      ; Function declaration continued on the next line
		(knr-argdecl-intro . +)                   ; Argument declaration list first line "int main(a,b,c)\nint a;\n ..."
		(knr-argdecl . 0)                         ; Argument declaration list other lines "... int b;\nvoid* c;\n"
		(topmost-intro . 0)                       ; Function return type (first line in top-level function declaration) "void\nfunc(..."
		(topmost-intro-cont . 0)                  ; Rest of function declaration, before the opening brace "func(...)"
		(member-init-intro . +)                   ; Initializer list, first line "Classname (int b, int c) : a(b), ..."
		(member-init-cont . c-lineup-multi-inher) ; Initializer list, continued lines "... d(c)"
		(inher-intro . +)                         ; Inheritance "class Blah :\npublic Bleh\n ..." (C++)
		(inher-cont . c-lineup-multi-inher)       ; Continued inheritance "... public Blo\npublic Bli\n"
		(block-open . 0)                          ; Compound statement open e.g. "{" in a function
		(block-close . 0)                         ; Compound statement/conditional brace close
		(brace-list-open . 0)                     ; Open brace in enum/array initializer "static int[5] = {"
		(brace-list-close . 0)                    ; Close brace in enum/array initializer
		(brace-list-intro . +)                    ; Brace list first line
		(brace-list-entry . 0)                    ; Brace list continued lines
		(brace-entry-open . 0)                    ; Sub brace list open
		(statement . 0)                           ; A statement like "a = 5".
		(statement-cont . c-lineup-math)          ; Statement continued on the next line.
		(statement-block-intro . +)               ; First line a compound statement, e.g. after "if {\n" or plain "{"
		(statement-case-intro . +)                ; First line of case statement "case 1:\na=5 ..."
		(statement-case-open . 0)                 ; First line of case surrounded by braces "case 1:\n{ ..."
		(substatement . +)                        ; First line after conditional/loop construct
		(substatement-open . 0)                   ; Brace opening substatement block
		(case-label . 0)                          ; Label in switch block
		(access-label . -)                        ; Access control label like "private:" (C++), effectively single indent since 'inclass' also indents once
		(label . 0)                               ; Any other label (not case or access)
		(do-while-closure . 0)                    ; When the 'while' of do-while is on a seperate line
		(else-clause . 0)                         ; "else" on a line belonging to a prior "if"
		(catch-clause . 0)                        ; "catch" (or "finally") on a line beloging to a prior "try"
		(comment-intro . c-lineup-comment)        ; First line in a comment (see also "c" above)
		(arglist-intro . +)                       ; First line in an argument list "func x(\nint a ..." starting on a SEPARATE line
		(arglist-cont . 0)                        ; Other lines in an argument list starting on a separate line
		(arglist-cont-nonempty . c-lineup-arglist) ; Other lines in an argument list where the first line started on the same line as the function definition "func x(int a\n ..."
		(arglist-close . +)                       ; Closing of the argument list on a separate line ");"
		(stream-op . c-lineup-streamop)           ; Stream operators "<<" and ">>" (C++)
		(inclass . ++)                             ; Inside a class definition (C++/JAVA)
		(cpp-macro . [0])                         ; Start of pre-processor macro definition. The [] denotes an absolute position, column 0 on the line.
		(cpp-macro-cont . c-lineup-dont-change)   ; Continued macro definition (using \ at eof)
		(friend . 0)                              ; C++ friend declaration
		(objc-method-intro . [0])                 ; First line of objective C method definition
		(objc-method-args-cont . c-lineup-ObjC-method-args) ; Continued lines of objective C methode definition
		(objc-method-call-cont . c-lineup-ObjC-method-call) ; Continued lines of an objective c method call
		(extern-lang-open . 0)                              ; Brace that opens an extern block (C++)
		(extern-lang-close . 0)                             ; Brace that closes an extern block (C++)
		(inextern-lang . +)                                 ; Inside an extern block (C++)
		(namespace-open . 0)                                ; Brace that opens a namespace block (C++)
		(namespace-close . 0)                               ; Brace that closes a namespace block (C++)
		(innamespace . +)                                   ; Inside a namespace block (C++)
		(template-args-cont c-lineup-template-args +)       ; Continued template arguments (C++)
		(inlambda . c-lineup-inexpr-block)                  ; Like inclass (PIKE)
		(lambda-intro-cont . +)                             ; Like inclass (PIKE)
		(inexpr-statement . 0)                              ; Statement block inside expression (C++/PIKE)
		(inexpr-class . +))                                 ; Class declaration inside expression (JAVA)

	       (c-hanging-braces-alist                  ; Newlines after and before braces
		(defun-open after)                      ; Top-level function open brace "func () {\n"
		(defun-close before after)              ; Top-level function close brace "\n}\n"
		(class-open after)                      ; Class open brace "class blah {\n"
		(class-close before after)              ; Class close brace "\n};\n"
		(inline-open after)                     ; In-line function open brace (defun-open inside class)
		(inline-close before after)             ; In-line function close brace (defun-close inside class)
		(block-open)                            ; Compound statement brace open e.g. "{" in a function
		(block-close . c-snug-do-while)         ; Compound statement/conditional brace close, "} while ()" on same line
		(substatement-open after)               ; Conditional brace open e.g. "if (...) {", "while (...) {"
		(statement-case-open after)             ; Brace opening a labeled condition inside a case statement "case 1: {\n"
		(extern-lang-open before after)         ; Extern block open brace "extern "c"\n{\n"
		(extern-lang-close before after)        ; Extern block close brace
		(brace-list-open)                       ; Open brace in enum/array initializer "static int[5] = {"
		(brace-list-close after)                ; Close brace in enum/array initializer
;;		(brace-list-intro)                      ; First line in brace list, not applicable here in hanging braces alist
		(brace-entry-open)                      ; Sub open brace within enum/array initializer "static int[5][2] = { {"
		(namespace-open before after)           ; Namespace block open brace "namespace "blah"\n{\n" (C++)
		(namespace-close)                       ; Namespace block close brace (C++)
		(inexpr-class-open)                     ; Class definition in expression open brace "func (new Blah {\n..." (JAVA)
		(inexpr-class-close))                   ; Class definition in expression close brace (JAVA)
		
	       (c-hanging-colons-alist                  ; Newlines after and before colons
		(case-label)                            ; Case label colon, no newline because of statement-case-open "case 1:"
		(label after)                           ; Goto label colon "TEST:\n"
		(access-label after)                    ; Access label colon "private:\n" (C++)
		(member-init-intro)                     ; Initializer list colon "void func() : ..." (C++)
		(inher-intro))                          ; Inheritance colon "class Blah : public Bleh" (C++)
		
	       (c-cleanup-list                        ; Clean-ups after typing
		brace-catch-brace                     ; Place "} catch (...) {" on one line
		brace-else-brace                      ; Place "} else {" on one line
		brace-elseif-brace                    ; Place "} else if (...) {" on one line
		defun-close-semi                      ; Place the ";" behind the "}" in struct/class defs like this "};"
		list-close-comma                      ; Place the "," behind the "}" in array initializers like "},"
		scope-operator                        ; Place C++ scope colons behind eachother "::"
;;		space-before-funcall)                 ; Do not place a space between function name and args "func ()"
		)))

;; Utility Functions
;; =================

;; Utility Function to quickly join lines over a selected region

(defun join-region (beg end)
  "Apply join-line over region."
  (interactive "r")
  (if mark-active
          (let ((beg (region-beginning))
                        (end (copy-marker (region-end))))
                (goto-char beg)
                (while (< (point) end)
                  (join-line 1))))) 

(defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer 
          (delq (current-buffer) 
                (remove-if-not 'buffer-file-name (buffer-list)))))

(defun remove-control-m () 
  "Remove all ^M's from a buffer" 
  (interactive) 
  (let* ((where (point-marker))) 
    (beginning-of-buffer) 
    (while (search-forward "\r" nil t) 
      (replace-match "" nil t)) 
    (goto-char where))) 

(defun kill-line-and-reindent ()
  (interactive)
  (kill-line)
  (indent-according-to-mode))

(defun c-mark-statement ()
  (interactive)
  (c-beginning-of-defun)
  (set-mark-command)
  (c-end-of-defun))

(defun c-kill-statement ()
  (c-beginning-of-defun)
  (set-mark-command)
  (c-end-of-defun)
  (kill-region))

(defun cpp-directory-compile(&optional args)
  (interactive "p")
  (compile "make"))

(defun toplevel-compile (&optional args)
  (interactive "p")
  (setq newpath default-directory)
  (setq start nil)
  ;; Find last occurence of /src in the path
  (setq srcloc -1)
  (setq prevsrcloc -1)
  (while (not (equalp srcloc nil))
    (progn
      (setq prevsrcloc srcloc)
      (setq srcloc (string-match "/src" newpath (+ prevsrcloc 1)))))
  ;; Cut everything the last /src (and everything behind it) from the path
  (setq cdpath (substring newpath 0 prevsrcloc))
  (cd cdpath)
  (compile "make")
  (cd newpath))
