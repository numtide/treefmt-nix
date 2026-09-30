{ lib, mkFormatterModule, ... }:
{
  meta = {
    maintainers = [ "HeitorAugustoLN" ];
    platforms = lib.platforms.all;
  };

  imports = [
    (mkFormatterModule {
      name = "emacs-lisp-indent";
      package = "emacs-nox";

      args = [
        "--batch"
        "--eval"
        ''
          (while command-line-args-left
            (let ((file (pop command-line-args-left)))
              (with-current-buffer (find-file-noselect file)
                (let ((make-backup-files nil)
                      (create-lockfiles nil))
                  (indent-region (point-min) (point-max))
                  (save-buffer)))))
        ''
      ];

      includes = [ "*.el" ];
    })
  ];
}
