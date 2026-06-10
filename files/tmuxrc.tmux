set -g default-command "${SHELL}"
set-option -g mouse on
set-option -g focus-events on
set -g set-clipboard on
set-option -g automatic-rename on
set-option -g status-style bg=default
set-option -ga terminal-overrides ",xterm*:Tc"

# Split with same directory
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
