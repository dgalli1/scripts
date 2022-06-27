function phpswitch --description "Switch CLI PHP Version"
  echo OLD: /usr/local/php/php{$CURRENT_PHP}
  echo NEW: /usr/local/php/php{$argv}
  if test -d /usr/local/php/php{$argv}/
    set PATH (string match -v /usr/local/php/php{CURRENT_PHP} $PATH)
    set PATH /usr/local/php/php{$argv}/ $PATH
    set -gx CURRENT_PHP $argv
  else
    echo "choosen php version does't exists available versions:"
    ls /usr/local/php
  end
end
