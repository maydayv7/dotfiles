# ################################################################################### #
#                               My Epic P10k Config                                   #
# Configuration for Powerlevel10k with Powerline Prompt Style and Colorful Background #
# ################################################################################### #

# Temporarily Change Options
'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Unset all Configuration Options
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # Required: ZSH >= 5.1
  autoload -Uz is-at-least && is-at-least 5.1 || return

  # Segments shown on the LEFT
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    ## Line 1
    os_icon                 # OS Identifier
    context                 # USER@HOSTNAME
    dir                     # Current Directory
    vcs                     # 'git' Status

    ## Line 2
    newline                 # \n
  )

  # Segments shown on the RIGHT
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    ## Line 1
    status                  # Exit Code of the Last Command
    background_jobs         # Presence of Background Jobs
    direnv                  # 'direnv' Status (https://direnv.net/)
    asdf                    # ASDF Version Manager (https://github.com/asdf-vm/asdf)
    virtualenv              # Python Virtual Environment (https://docs.python.org/3/library/venv.html)
    anaconda                # Conda Environment (https://conda.io/)
    pyenv                   # Python Environment (https://github.com/pyenv/pyenv)
    goenv                   # Go Environment (https://github.com/syndbg/goenv)
    nodenv                  # Node.js Version from NodENV (https://github.com/nodenv/nodenv)
    nvm                     # Node.js Version from NVM (https://github.com/nvm-sh/nvm)
    nodeenv                 # Node.js Environment (https://github.com/ekalinin/nodeenv)
    # node_version          # Node.js Version
    # go_version            # Go Version (https://golang.org)
    # rust_version          # Rustc Version (https://www.rust-lang.org)
    # dotnet_version        # .NET Version (https://dotnet.microsoft.com)
    # php_version           # PHP Version (https://www.php.net/)
    # laravel_version       # Laravel PHP Framework Version (https://laravel.com/)
    # java_version          # java Version (https://www.java.com/)
    # package               # Name@Version from Package.json (https://docs.npmjs.com/files/package.json)
    rbenv                   # Ruby Version from RbENV (https://github.com/rbenv/rbenv)
    rvm                     # Ruby Version from RVM (https://rvm.io)
    fvm                     # Flutter Version Management (https://github.com/leoafarias/fvm)
    luaenv                  # Lua Version from LuaENV (https://github.com/cehoffman/luaenv)
    jenv                    # Java Version from JENV (https://github.com/jenv/jenv)
    plenv                   # Perl Version from PlENV (https://github.com/tokuhirom/plenv)
    phpenv                  # PHP Version from PHPENV (https://github.com/phpenv/phpenv)
    scalaenv                # Scala version from ScalaENV (https://github.com/scalaenv/scalaenv)
    haskell_stack           # Haskell Version from Stack (https://haskellstack.org/)
    kubecontext             # Current Kubernetes Context (https://kubernetes.io/)
    terraform               # Terraform Workspace (https://www.terraform.io)
    aws                     # AWS Profile (https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
    aws_eb_env              # AWS Elastic Beanstalk Environment (https://aws.amazon.com/elasticbeanstalk/)
    azure                   # Azure Account Name (https://docs.microsoft.com/en-us/cli/azure)
    gcloud                  # Google Cloud CLI Account and Project (https://cloud.google.com/)
    google_app_cred         # Google Application Credentials (https://cloud.google.com/docs/authentication/production)
    nordvpn                 # NordVPN Connection Status (https://nordvpn.com/)
    ranger                  # Ranger Shell (https://github.com/ranger/ranger)
    vim_shell               # 'vim' Shell Indicator (:sh)
    midnight_commander      # Midnight Commander Shell (https://midnight-commander.org/)
    nix_shell               # Nix Shell (https://nixos.org/nixos/nix-pills/developing-with-nix-shell.html)
    vi_mode                 # 'vi' Mode
    # vpn_ip                # VPN Indicator
    # load                  # CPU Load
    # disk_usage            # Disk Usage
    ram                     # Free RAM
    # swap                  # used SWAP
    todo                    # ToDo Items (https://github.com/todotxt/todo.txt-cli)
    timewarrior             # TimeWarrior Tracking Status (https://timewarrior.net/)
    taskwarrior             # TaskWarrior Task Count (https://taskwarrior.org/)
    battery                 # Internal Battery
    command_execution_time  # Duration of the Last Command
    time                    # Current Time

    ## Line 2
    newline                 # \n
    # ip                    # IP Address and Bandwidth Usage
    # public_ip             # Public IP Address
    # wifi                  # WiFi Speed
  )

  ## Prompt
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

  # Character Set
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete

  # Icons
  typeset -g POWERLEVEL9K_ICON_PADDING=none
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=232
  typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=7

  #typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='⭐' # Custom Icon

  # Connectors
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='%242F╭─'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX='%242F├─'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='%242F╰─'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='%242F─╮'
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX='%242F─┤'
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='%242F─╯'

  # Fillers
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR='─'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=
  if [[ $POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR != ' ' ]]; then
    typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND=242
    typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_FIRST_SEGMENT_END_SYMBOL='%{%}'
    typeset -g POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='%{%}'
  fi

  # Separators
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='\uE0B3'
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR='\uE0B2'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\uE0B2'
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
  typeset -g POWERLEVEL9K_EMPTY_LINE_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=

  # Characters
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_{LEFT,RIGHT}_WHITESPACE=

  # Reload
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  (( ! $+functions[p10k] )) || p10k reload

  #E Directory Handling
  # Colors
  typeset -g POWERLEVEL9K_DIR_BACKGROUND=6
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=0
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=250
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=0

  # Unshortened Anchors
  local anchor_files=(
    .bzr
    .citc
    .git
    .hg
    .node-version
    .python-version
    .go-version
    .ruby-version
    .lua-version
    .java-version
    .perl-version
    .php-version
    .tool-version
    .shorten_folder_marker
    .svn
    .terraform
    CVS
    Cargo.toml
    composer.json
    go.mod
    package.json
    stack.yaml
  )

  # Shorteners
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER='...'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
  typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=true
  typeset -g POWERLEVEL9K_DIR_SHOW_WRITABLE=v2

  #typeset -g POWERLEVEL9K_LOCK_ICON='⭐' # Custom Icon
  #typeset -g POWERLEVEL9K_DIR_PREFIX='in ' # Custom Prefix

  # Custom Directories Styling
  typeset -g POWERLEVEL9K_DIR_CLASSES=(
    '~/work(|/*)'  WORK     ''
    '~(|/*)'       HOME     ''
    '*'            DEFAULT  ''
  )

  ## Version Control
  # Colors
  #typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND=2
  #typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=3
  #typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=2
  #typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=3
  #typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND=8

  # Icons
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON='\uF126 '
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

  # Formatter
  function my_git_formatter() {
    emulate -L zsh

    if [[ -n $P9K_CONTENT ]]; then
      typeset -g my_git_format=$P9K_CONTENT
      return
    fi

    # Styling
    local       meta='%7F' # White Foreground
    local      clean='%0F' # Black Foreground
    local   modified='%0F' # Black Foreground
    local  untracked='%0F' # Black Foreground
    local conflicted='%1F' # Red Foreground

    local res
    local where
    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      res+="${clean}${(g::)POWERLEVEL9K_VCS_BRANCH_ICON}"
      where=${(V)VCS_STATUS_LOCAL_BRANCH}
    elif [[ -n $VCS_STATUS_TAG ]]; then
      res+="${meta}#"
      where=${(V)VCS_STATUS_TAG}
    fi

    (( $#where > 32 )) && where[13,-13]="…"
    res+="${clean}${where//\%/%%}"  # escape %
    [[ -z $where ]] && res+="${meta}@${clean}${VCS_STATUS_COMMIT[1,8]}"
    if [[ -n ${VCS_STATUS_REMOTE_BRANCH:#$VCS_STATUS_LOCAL_BRANCH} ]]; then
      res+="${meta}:${clean}${(V)VCS_STATUS_REMOTE_BRANCH//\%/%%}"  # escape %
    fi

    (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${clean}⇣${VCS_STATUS_COMMITS_BEHIND}"
    (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_COMMITS_AHEAD  )) && res+="${clean}⇡${VCS_STATUS_COMMITS_AHEAD}"
    (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" ${clean}⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
    (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && res+=" "
    (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && res+="${clean}⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
    (( VCS_STATUS_STASHES        )) && res+=" ${clean}*${VCS_STATUS_STASHES}"
    [[ -n $VCS_STATUS_ACTION     ]] && res+=" ${conflicted}${VCS_STATUS_ACTION}"
    (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"
    (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
    (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
    (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}${(g::)POWERLEVEL9K_VCS_UNTRACKED_ICON}${VCS_STATUS_NUM_UNTRACKED}"
    (( VCS_STATUS_HAS_UNSTAGED == -1 )) && res+=" ${modified}─"
    typeset -g my_git_format=$res
  }
  functions -M my_git_formatter 2>/dev/null

  # Controllers
  typeset -g POWERLEVEL9K_VCS_BACKENDS=(git)
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1
  typeset -g POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='~'
  typeset -g POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING=true
  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter()))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_{STAGED,UNSTAGED,UNTRACKED,CONFLICTED,COMMITS_AHEAD,COMMITS_BEHIND}_MAX_NUM=-1

  #typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon
  #typeset -g POWERLEVEL9K_VCS_PREFIX='on ' # Custom Prefix

  ## Command Status
  typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true

  # Success
  typeset -g POWERLEVEL9K_STATUS_OK=true
  typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=6
  typeset -g POWERLEVEL9K_STATUS_OK_BACKGROUND=0

  # Failure
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION='✔'
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND=6
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_BACKGROUND=0

  # Error Code
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=6
  typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=0

  # Termination
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND=6
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_BACKGROUND=0

  # Partial Failure
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION='✘'
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND=2
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_BACKGROUND=0

  ## Command Duration
  # Colors
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=6
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=0

  # Precision
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

  #typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon
  #typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='took ' # Custom Prefix

  ## Background Jobs
  # Colors
  #typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=6
  #typeset -g POWERLEVEL9K_BACKGROUND_JOBS_BACKGROUND=0

  # Controller
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false

  #typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Context
  # Colors
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND=0
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND=4
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_FOREGROUND=0
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_BACKGROUND=4
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND=0
  typeset -g POWERLEVEL9K_CONTEXT_BACKGROUND=4

  # Format
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{REMOTE,REMOTE_SUDO}_TEMPLATE='%n ✠ %m'
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n ✠ %m'
  #typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,SUDO}_{CONTENT,VISUAL_IDENTIFIER}_EXPANSION=

  #typeset -g POWERLEVEL9K_CONTEXT_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon
  #typeset -g POWERLEVEL9K_CONTEXT_PREFIX='with ' # Custom Prefix

  ## RAM
  # Colors
  typeset -g POWERLEVEL9K_RAM_FOREGROUND=0
  typeset -g POWERLEVEL9K_RAM_BACKGROUND=6

  #typeset -g POWERLEVEL9K_RAM_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## SWAP
  # Colors
  #typeset -g POWERLEVEL9K_SWAP_FOREGROUND=0
  #typeset -g POWERLEVEL9K_SWAP_BACKGROUND=3

  #typeset -g POWERLEVEL9K_SWAP_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Battery
  # Colors
  typeset -g POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20
  typeset -g POWERLEVEL9K_BATTERY_LOW_FOREGROUND=1
  typeset -g POWERLEVEL9K_BATTERY_{CHARGING,CHARGED}_FOREGROUND=0
  typeset -g POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND=0
  typeset -g POWERLEVEL9K_BATTERY_STAGES='\uf58d\uf579\uf57a\uf57b\uf57c\uf57d\uf57e\uf57f\uf580\uf581\uf578'
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false
  typeset -g POWERLEVEL9K_BATTERY_BACKGROUND=4

  ## WiFi
  # Colors
  #typeset -g POWERLEVEL9K_WIFI_FOREGROUND=0
  #typeset -g POWERLEVEL9K_WIFI_BACKGROUND=4

  # Signal Strength
  #typeset -g my_wifi_fg=(0 0 0 0 0)
  #typeset -g my_wifi_icon=('WiFi' 'WiFi' 'WiFi' 'WiFi' 'WiFi')
  #typeset -g POWERLEVEL9K_WIFI_CONTENT_EXPANSION='%F{${my_wifi_fg[P9K_WIFI_BARS+1]}}$P9K_WIFI_LAST_TX_RATE Mbps'
  #typeset -g POWERLEVEL9K_WIFI_VISUAL_IDENTIFIER_EXPANSION='%F{${my_wifi_fg[P9K_WIFI_BARS+1]}}${my_wifi_icon[P9K_WIFI_BARS+1]}'

  #typeset -g POWERLEVEL9K_WIFI_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## IP
  # Colors
  typeset -g POWERLEVEL9K_IP_BACKGROUND=4
  typeset -g POWERLEVEL9K_IP_FOREGROUND=0
  #typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND=7
  #typeset -g POWERLEVEL9K_PUBLIC_IP_BACKGROUND=0
  #typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND=0
  #typeset -g POWERLEVEL9K_VPN_IP_BACKGROUND=6

  # Controllers
  typeset -g POWERLEVEL9K_IP_CONTENT_EXPANSION='${P9K_IP_RX_RATE:+⇣$P9K_IP_RX_RATE }${P9K_IP_TX_RATE:+⇡$P9K_IP_TX_RATE }$P9K_IP_IP'
  typeset -g POWERLEVEL9K_IP_INTERFACE='e.*'
  typeset -g POWERLEVEL9K_VPN_IP_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_VPN_IP_INTERFACE='(gpd|wg|(.*tun))[0-9]*'
  typeset -g POWERLEVEL9K_VPN_IP_SHOW_ALL=false

  # Custom Icons
  #typeset -g POWERLEVEL9K_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_PUBLIC_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_VPN_IP_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Time
  # Colors
  #typeset -g POWERLEVEL9K_TIME_FOREGROUND=0
  #typeset -g POWERLEVEL9K_TIME_BACKGROUND=7

  # Format
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=false

  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION='' # Custom Icon
  #typeset -g POWERLEVEL9K_TIME_PREFIX='at ' # Custom Prefix

  ## CPU Load
  typeset -g POWERLEVEL9K_LOAD_WHICH=5

  # Colors
  #typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND=0
  #typeset -g POWERLEVEL9K_LOAD_NORMAL_BACKGROUND=2
  #typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND=0
  #typeset -g POWERLEVEL9K_LOAD_WARNING_BACKGROUND=3
  #typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND=0
  #typeset -g POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND=1

  #typeset -g POWERLEVEL9K_LOAD_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Disk Usage
  # Colors
  #typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND=3
  #typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_BACKGROUND=0
  #typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND=0
  #typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_BACKGROUND=3
  #typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND=7
  #typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_BACKGROUND=1

  # Thresholds
  typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL=90
  typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL=95
  typeset -g POWERLEVEL9K_DISK_USAGE_ONLY_WARNING=false

  #typeset -g POWERLEVEL9K_DISK_USAGE_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## DirENV
  # Colors
  #typeset -g POWERLEVEL9K_DIRENV_FOREGROUND=3
  #typeset -g POWERLEVEL9K_DIRENV_BACKGROUND=0

  #typeset -g POWERLEVEL9K_DIRENV_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## ASDF
  # Colors
  typeset -g POWERLEVEL9K_ASDF_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_BACKGROUND=7

  # Controllers
  typeset -g POWERLEVEL9K_ASDF_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_ASDF_SHOW_SYSTEM=true
  typeset -g POWERLEVEL9K_ASDF_SHOW_ON_UPGLOB=

  # Versions
  # Ruby
  typeset -g POWERLEVEL9K_ASDF_RUBY_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_RUBY_BACKGROUND=1
  #typeset -g POWERLEVEL9K_ASDF_RUBY_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_RUBY_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Python
  typeset -g POWERLEVEL9K_ASDF_PYTHON_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_PYTHON_BACKGROUND=4
  #typeset -g POWERLEVEL9K_ASDF_PYTHON_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_PYTHON_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Go
  typeset -g POWERLEVEL9K_ASDF_GOLANG_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_GOLANG_BACKGROUND=4
  #typeset -g POWERLEVEL9K_ASDF_GOLANG_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_GOLANG_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Node
  typeset -g POWERLEVEL9K_ASDF_NODEJS_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_NODEJS_BACKGROUND=2
  #typeset -g POWERLEVEL9K_ASDF_NODEJS_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_NODEJS_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Rust
  typeset -g POWERLEVEL9K_ASDF_RUST_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_RUST_BACKGROUND=208
  #typeset -g POWERLEVEL9K_ASDF_RUST_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_RUST_SHOW_ON_UPGLOB='*.foo|*.bar'

  # .NET
  typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_BACKGROUND=5
  #typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Flutter
  typeset -g POWERLEVEL9K_ASDF_FLUTTER_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_FLUTTER_BACKGROUND=4
  #typeset -g POWERLEVEL9K_ASDF_FLUTTER_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_FLUTTER_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Lua
  typeset -g POWERLEVEL9K_ASDF_LUA_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_LUA_BACKGROUND=4
  #typeset -g POWERLEVEL9K_ASDF_LUA_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_LUA_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Java
  typeset -g POWERLEVEL9K_ASDF_JAVA_FOREGROUND=1
  typeset -g POWERLEVEL9K_ASDF_JAVA_BACKGROUND=7
  #typeset -g POWERLEVEL9K_ASDF_JAVA_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_JAVA_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Perl
  typeset -g POWERLEVEL9K_ASDF_PERL_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_PERL_BACKGROUND=4
  #typeset -g POWERLEVEL9K_ASDF_PERL_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_PERL_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Erlang
  typeset -g POWERLEVEL9K_ASDF_ERLANG_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_ERLANG_BACKGROUND=1
  #typeset -g POWERLEVEL9K_ASDF_ERLANG_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_ERLANG_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Elixir
  typeset -g POWERLEVEL9K_ASDF_ELIXIR_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_ELIXIR_BACKGROUND=5
  #typeset -g POWERLEVEL9K_ASDF_ELIXIR_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_ELIXIR_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Postgres
  typeset -g POWERLEVEL9K_ASDF_POSTGRES_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_POSTGRES_BACKGROUND=6
  #typeset -g POWERLEVEL9K_ASDF_POSTGRES_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_POSTGRES_SHOW_ON_UPGLOB='*.foo|*.bar'

  # PHP
  typeset -g POWERLEVEL9K_ASDF_PHP_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_PHP_BACKGROUND=5
  #typeset -g POWERLEVEL9K_ASDF_PHP_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_PHP_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Haskell
  typeset -g POWERLEVEL9K_ASDF_HASKELL_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_HASKELL_BACKGROUND=3
  #typeset -g POWERLEVEL9K_ASDF_HASKELL_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_HASKELL_SHOW_ON_UPGLOB='*.foo|*.bar'

  # Julia
  typeset -g POWERLEVEL9K_ASDF_JULIA_FOREGROUND=0
  typeset -g POWERLEVEL9K_ASDF_JULIA_BACKGROUND=2
  #typeset -g POWERLEVEL9K_ASDF_JULIA_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_ASDF_JULIA_SHOW_ON_UPGLOB='*.foo|*.bar'

  ## NordVPN
  # Colors
  #typeset -g POWERLEVEL9K_NORDVPN_FOREGROUND=7
  #typeset -g POWERLEVEL9K_NORDVPN_BACKGROUND=4

  # Controllers
  typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_NORDVPN_{DISCONNECTED,CONNECTING,DISCONNECTING}_VISUAL_IDENTIFIER_EXPANSION=

  #typeset -g POWERLEVEL9K_NORDVPN_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Ranger
  # Colors
  #typeset -g POWERLEVEL9K_RANGER_FOREGROUND=3
  #typeset -g POWERLEVEL9K_RANGER_BACKGROUND=0

  #typeset -g POWERLEVEL9K_RANGER_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Vim Shell
  # Colors
  #typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND=0
  #typeset -g POWERLEVEL9K_VIM_SHELL_BACKGROUND=2

  #typeset -g POWERLEVEL9K_VIM_SHELL_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Midnight Commander
  # Colors
  #typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND=3
  #typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_BACKGROUND=0

  #typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Nix Shell
  # Colors
  typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=0
  typeset -g POWERLEVEL9K_NIX_SHELL_BACKGROUND=4

  # Controllers
  #typeset -g POWERLEVEL9K_NIX_SHELL_CONTENT_EXPANSION=
  #typeset -g POWERLEVEL9K_NIX_SHELL_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Vi Mode
  # Colors
  typeset -g POWERLEVEL9K_VI_MODE_FOREGROUND=0
  typeset -g POWERLEVEL9K_VI_COMMAND_MODE_STRING=NORMAL
  typeset -g POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND=2
  typeset -g POWERLEVEL9K_VI_VISUAL_MODE_STRING=VISUAL
  typeset -g POWERLEVEL9K_VI_MODE_VISUAL_BACKGROUND=4
  typeset -g POWERLEVEL9K_VI_OVERWRITE_MODE_STRING=OVERTYPE
  typeset -g POWERLEVEL9K_VI_MODE_OVERWRITE_BACKGROUND=3
  typeset -g POWERLEVEL9K_VI_INSERT_MODE_STRING=
  typeset -g POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND=8

  ## ToDo
  # Colors
  #typeset -g POWERLEVEL9K_TODO_FOREGROUND=0
  #typeset -g POWERLEVEL9K_TODO_BACKGROUND=8

  # Controllers
  typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL=true
  typeset -g POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED=false
  #typeset -g POWERLEVEL9K_TODO_CONTENT_EXPANSION='$P9K_TODO_FILTERED_TASK_COUNT'

  #typeset -g POWERLEVEL9K_TODO_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## TimeWarrior
  # Colors
  #typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND=255
  #typeset -g POWERLEVEL9K_TIMEWARRIOR_BACKGROUND=8

  # Format
  typeset -g POWERLEVEL9K_TIMEWARRIOR_CONTENT_EXPANSION='${P9K_CONTENT:0:24}${${P9K_CONTENT:24}:+…}'

  #typeset -g POWERLEVEL9K_TIMEWARRIOR_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## TaskWarrior
  # Colors
  #typeset -g POWERLEVEL9K_TASKWARRIOR_FOREGROUND=0
  #typeset -g POWERLEVEL9K_TASKWARRIOR_BACKGROUND=6

  # Format
  #typeset -g POWERLEVEL9K_TASKWARRIOR_CONTENT_EXPANSION='$P9K_TASKWARRIOR_PENDING_COUNT'

  #typeset -g POWERLEVEL9K_TASKWARRIOR_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Languages
  ## Python
  # Colors
  #typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_VIRTUALENV_BACKGROUND=4
  #typeset -g POWERLEVEL9K_PYENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_PYENV_BACKGROUND=4

  # Controllers
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION=false
  typeset -g POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV=false
  typeset -g POWERLEVEL9K_VIRTUALENV_{LEFT,RIGHT}_DELIMITER=
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PYENV_SHOW_SYSTEM=true
  typeset -g POWERLEVEL9K_PYENV_CONTENT_EXPANSION='${P9K_CONTENT}${${P9K_PYENV_PYTHON_VERSION:#$P9K_CONTENT}:+ $P9K_PYENV_PYTHON_VERSION}'

  # Custom Icons
  #typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_PYENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Anaconda
  # Colors
  #typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND=0
  #typeset -g POWERLEVEL9K_ANACONDA_BACKGROUND=4

  # Format
  typeset -g POWERLEVEL9K_ANACONDA_CONTENT_EXPANSION='${${${${CONDA_PROMPT_MODIFIER#\(}% }%\)}:-${CONDA_PREFIX:t}}'

  #typeset -g POWERLEVEL9K_ANACONDA_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Go
  # Colors
  #typeset -g POWERLEVEL9K_GOENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_GOENV_BACKGROUND=4
  #typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND=255
  #typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=2

  # Controllers
  typeset -g POWERLEVEL9K_GOENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_GOENV_SHOW_SYSTEM=true
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true

  # Custom Icons
  #typeset -g POWERLEVEL9K_GOENV_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Node
  # Colors
  #typeset -g POWERLEVEL9K_NODENV_FOREGROUND=2
  #typeset -g POWERLEVEL9K_NODENV_BACKGROUND=0
  #typeset -g POWERLEVEL9K_NODEENV_FOREGROUND=2
  #typeset -g POWERLEVEL9K_NODEENV_BACKGROUND=0
  #typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=7
  #typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=2
  #typeset -g POWERLEVEL9K_NVM_FOREGROUND=0
  #typeset -g POWERLEVEL9K_NVM_BACKGROUND=5

  # Controllers
  typeset -g POWERLEVEL9K_NODENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_NODENV_SHOW_SYSTEM=true
  typeset -g POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION=false
  typeset -g POWERLEVEL9K_NODEENV_{LEFT,RIGHT}_DELIMITER=
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true

  # Custom Icons
  #typeset -g POWERLEVEL9K_NODENV_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_NODEENV_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_NVM_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Rust
  # Colors
  #typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND=0
  #typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=208

  # Controllers
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true

  # Custom Icon
  #typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## .NET
  # Colors
  #typeset -g POWERLEVEL9K_DOTNET_VERSION_FOREGROUND=7
  #typeset -g POWERLEVEL9K_DOTNET_VERSION_BACKGROUND=5

  # Controllers
  typeset -g POWERLEVEL9K_DOTNET_VERSION_PROJECT_ONLY=true

  # Custom Icon
  #typeset -g POWERLEVEL9K_DOTNET_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## PHP
  # Colors
  typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND=0
  typeset -g POWERLEVEL9K_PHP_VERSION_BACKGROUND=5
  typeset -g POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY=true
  #typeset -g POWERLEVEL9K_PHPENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_PHPENV_BACKGROUND=5

  # Controllers
  typeset -g POWERLEVEL9K_PHPENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PHPENV_SHOW_SYSTEM=true

  # Custom Icons
  #typeset -g POWERLEVEL9K_PHP_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_PHPENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Laravel
  # Colors
  typeset -g POWERLEVEL9K_LARAVEL_VERSION_FOREGROUND=1
  typeset -g POWERLEVEL9K_LARAVEL_VERSION_BACKGROUND=7

  #typeset -g POWERLEVEL9K_LARAVEL_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Ruby
  # Colors
  #typeset -g POWERLEVEL9K_RBENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_RBENV_BACKGROUND=1
  #typeset -g POWERLEVEL9K_RVM_FOREGROUND=0
  #typeset -g POWERLEVEL9K_RVM_BACKGROUND=240

  # Controllers
  typeset -g POWERLEVEL9K_RBENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_RBENV_SHOW_SYSTEM=true
  typeset -g POWERLEVEL9K_RVM_SHOW_GEMSET=false
  typeset -g POWERLEVEL9K_RVM_SHOW_PREFIX=false

  # Custom Icons
  #typeset -g POWERLEVEL9K_RBENV_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_RVM_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Java
  # Colors
  typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=1
  typeset -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=7
  #typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND=0
  #typeset -g POWERLEVEL9K_PACKAGE_BACKGROUND=6
  #typeset -g POWERLEVEL9K_JENV_FOREGROUND=1
  #typeset -g POWERLEVEL9K_JENV_BACKGROUND=7

  # Controllers
  typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_JAVA_VERSION_FULL=false
  #typeset -g POWERLEVEL9K_PACKAGE_CONTENT_EXPANSION='${P9K_PACKAGE_NAME//\%/%%}@${P9K_PACKAGE_VERSION//\%/%%}'
  typeset -g POWERLEVEL9K_JENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_JENV_SHOW_SYSTEM=true

  # Custom Icons
  #typeset -g POWERLEVEL9K_JAVA_VERSION_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_PACKAGE_VISUAL_IDENTIFIER_EXPANSION='⭐'
  #typeset -g POWERLEVEL9K_JENV_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Flutter
  # Colors
  #typeset -g POWERLEVEL9K_FVM_FOREGROUND=0
  #typeset -g POWERLEVEL9K_FVM_BACKGROUND=4

  #typeset -g POWERLEVEL9K_FVM_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Lua
  # Colors
  #typeset -g POWERLEVEL9K_LUAENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_LUAENV_BACKGROUND=4

  # Controllers
  typeset -g POWERLEVEL9K_LUAENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_LUAENV_SHOW_SYSTEM=true

  #typeset -g POWERLEVEL9K_LUAENV_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Perl
  # Colors
  #typeset -g POWERLEVEL9K_PLENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_PLENV_BACKGROUND=4

  # Controllers
  typeset -g POWERLEVEL9K_PLENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PLENV_SHOW_SYSTEM=true

  #typeset -g POWERLEVEL9K_PLENV_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Scala
  # Colors
  #typeset -g POWERLEVEL9K_SCALAENV_FOREGROUND=0
  #typeset -g POWERLEVEL9K_SCALAENV_BACKGROUND=1

  # Controllers
  typeset -g POWERLEVEL9K_SCALAENV_SOURCES=(shell local global)
  typeset -g POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_SCALAENV_SHOW_SYSTEM=true

  #typeset -g POWERLEVEL9K_SCALAENV_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Haskell
  # Colors
  #typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND=0
  #typeset -g POWERLEVEL9K_HASKELL_STACK_BACKGROUND=3

  # Controllers
  typeset -g POWERLEVEL9K_HASKELL_STACK_SOURCES=(shell local)
  typeset -g POWERLEVEL9K_HASKELL_STACK_ALWAYS_SHOW=true

  #typeset -g POWERLEVEL9K_HASKELL_STACK_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Terraform
  typeset -g POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT=false

  # Classes
  typeset -g POWERLEVEL9K_TERRAFORM_CLASSES=(
      '*prod*'  PROD
      '*test*'  TEST
      '*'       OTHER
  )

  # Format
  typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND=4
  typeset -g POWERLEVEL9K_TERRAFORM_OTHER_BACKGROUND=0
  #typeset -g POWERLEVEL9K_TERRAFORM_OTHER_VISUAL_IDENTIFIER_EXPANSION='⭐'

  ## Kubernetes
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile'

  # Classes
  typeset -g POWERLEVEL9K_KUBECONTEXT_CLASSES=(
      '*prod*'  PROD
      '*test*'  TEST
      '*'       DEFAULT
  )

  # Format
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND=7
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_BACKGROUND=5
  #typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

  # Expansions
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION=
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${P9K_KUBECONTEXT_CLOUD_CLUSTER:-${P9K_KUBECONTEXT_NAME}}'
  POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION+='${${:-/$P9K_KUBECONTEXT_NAMESPACE}:#/default}'

  #typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX='at ' # Custom Prefix

  ## AWS
  typeset -g POWERLEVEL9K_AWS_SHOW_ON_COMMAND='aws|awless|terraform|pulumi|terragrunt'

  # Colors
  #typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND=2
  #typeset -g POWERLEVEL9K_AWS_EB_ENV_BACKGROUND=0

  # Classes
  typeset -g POWERLEVEL9K_AWS_CLASSES=(
      '*prod*'  PROD
      '*test*'  TEST
      '*'       DEFAULT
  )

  # Format
  #typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND=7
  #typeset -g POWERLEVEL9K_AWS_DEFAULT_BACKGROUND=1
  #typeset -g POWERLEVEL9K_AWS_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

  #typeset -g POWERLEVEL9K_AWS_EB_ENV_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Azure
  typeset -g POWERLEVEL9K_AZURE_SHOW_ON_COMMAND='az|terraform|pulumi|terragrunt'

  # Colors
  #typeset -g POWERLEVEL9K_AZURE_FOREGROUND=7
  #typeset -g POWERLEVEL9K_AZURE_BACKGROUND=4

  #typeset -g POWERLEVEL9K_AZURE_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon

  ## Google
  typeset -g POWERLEVEL9K_GCLOUD_SHOW_ON_COMMAND='gcloud|gcs'
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_SHOW_ON_COMMAND='terraform|pulumi|terragrunt'

  # Colors
  #typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND=7
  #typeset -g POWERLEVEL9K_GCLOUD_BACKGROUND=4

  # Classes
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES=(
      '*:*prod*:*'  PROD
      '*:*test*:*'  TEST
      '*'             DEFAULT
  )

  # Format
  typeset -g POWERLEVEL9K_GCLOUD_PARTIAL_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_ID//\%/%%}'
  typeset -g POWERLEVEL9K_GCLOUD_COMPLETE_CONTENT_EXPANSION='${P9K_GCLOUD_PROJECT_NAME//\%/%%}'
  #typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND=7
  #typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_BACKGROUND=4
  #typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_VISUAL_IDENTIFIER_EXPANSION='⭐'

  # Controllers
  typeset -g POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS=60
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_CONTENT_EXPANSION='${P9K_GOOGLE_APP_CRED_PROJECT_ID//\%/%%}'

  #typeset -g POWERLEVEL9K_GCLOUD_VISUAL_IDENTIFIER_EXPANSION='⭐' # Custom Icon
}
typeset -g POWERLEVEL9K_CONFIG_FILE=${${(%):-%x}:a}
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
