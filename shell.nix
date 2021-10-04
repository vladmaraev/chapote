with import (fetchTarball https://github.com/NixOS/nixpkgs/archive/21.05.tar.gz)
{ overlays = [ (self: super: {})]; };
  let  
     myEmacs = emacsWithPackages (epkgs: with epkgs; [org-ref]);
     myEmacsConfig = writeText "default.el" ''
       (add-to-list 'load-path "${emacsPackages.org-ref}")
       (require 'org-ref)
       (setq org-export-with-smart-quotes t)   
         (add-to-list 'org-export-smart-quotes-alist 
               '("british"
                 (primary-opening :utf-8 "‘" :html "&lsquo;" :latex "`" :texinfo "`")
                 (primary-closing :utf-8 "’" :html "&rsquo;" :latex "'" :texinfo "'")
                 (secondary-opening :utf-8 "“" :html "&ldquo;" :latex "``" :texinfo "``")
                 (secondary-closing :utf-8 "”" :html "&rdquo;" :latex "\'\'" :texinfo "\'\'")
                 (apostrophe :utf-8 "’" :html "&rsquo;")))
     '';
in stdenv.mkDerivation {
  shellHook = ''
    export MYEMACSLOAD=${myEmacsConfig}
  '';
  name = "docsEnv";
  buildInputs = [ haskellPackages.lhs2tex
                  # python3Packages.pygments
                  myEmacs
                  biber
                  # zip
                  (texlive.combine {
                       inherit (texlive)
                       algorithm2e
                       acmart
                       biblatex
                       boondox
                       collection-fontsrecommended
                         comment
                         csquotes
                       cleveref
                       environ
                       fontaxes
                       framed
                       fvextra
                       harvard
                       ifplatform
                       ifsym
                       inconsolata
                       kastrup
                       latexmk
                       libertine
                       listings
                       lm
                       logreq
                         mathpartir
                         microtype
                       minted
                       makecell
                       multirow
                       mweights
                       ncclatex
                       ncctools
                       newtx
                       newtxsf
                       newtxtt
                       newunicodechar
                         prftree
                         ragged2e
                       relsize
                       scheme-small wrapfig marvosym wasysym
                       soul
                       stmaryrd
                         lazylist polytable # lhs2tex
                       todonotes
                       totpages
                       trimspaces
                       thmtools
                       ucs
                       wasy cm-super unicode-math filehook lm-math capt-of
                       xargs
                       xstring ucharcat
                         xypic
                         xpatch
                       xifthen
                       ifmtarg
                       ;
                     })
                ];
}
