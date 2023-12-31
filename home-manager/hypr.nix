{config, pkgs, ...}:
let

  mk-decrease-border = pkgs.writeShellApplication {
    name = "border-down";
    text = ''
      border_file="/home/malcolm/.config/hypr/.border.txt"
      echo "5" > "$border_file"
      border_size=$(<"$border_file")
      hyprctl keyword general:border_size "$border_size"
    '';
  };
  mk-increase-border = pkgs.writeShellApplication {
    name = "border-up";
    text = ''
    border_file="/home/malcolm/.config/hypr/.border.txt"

    if [ ! -f "$border_file" ]; then
      echo "5" > "$border_file"
    fi

    border_size=$(<"$border_file")

    increase_border() {
      border_size=$((border_size + 5))
      echo "$border_size" > "$border_file"
    }
    increase_border

    hyprctl keyword general:border_size "$border_size"
    '';
  };
  
  mk-start = pkgs.writeShellApplication {
    name = "start";
    runtimeInputs = [pkgs.waybar pkgs.dunst];
    text = ''
    waybar &
    nm-applet --indicator &
    dunst &
    '';
  };

  mk-toggle-gaps =  pkgs.writeShellApplication {
    name = "toggle-gaps";
    runtimeInputs = [pkgs.cowsay];
    text = ''

TOGGLE=$HOME/.toggle

if [ ! -e "$TOGGLE" ]; then
	touch "$TOGGLE"
	hyprctl keyword general:gaps_in 0
	hyprctl keyword general:gaps_out 0
	hyprctl keyword decoration:rounding 0
else
	rm "$TOGGLE"
	hyprctl keyword general:gaps_in 10
	hyprctl keyword general:gaps_out 20
	hyprctl keyword decoration:rounding 15
fi
    '';
};
in
{

  home.packages = with pkgs; [
    wayland
    grim
    slurp
    swappy
  ];

  home.file."/home/malcolm/.config/swappy/config".text = ''
  [Default]
  save_dir=$HOME/Pictures/Screenshots
  save_filename_format=swappy-%Y%m%d-%H%M%S.png
  show_panel=false
  line_size=5
  text_size=20
  text_font=sans-serif
  paint_mode=brush
  early_exit=false
  fill_shape=false
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
    
########################################################################################
AUTOGENERATED HYPR CONFIG.
PLEASE USE THE CONFIG PROVIDED IN THE GIT REPO /examples/hypr.conf AND EDIT IT,
OR EDIT THIS ONE ACCORDING TO THE WIKI INSTRUCTIONS.
########################################################################################
#
# TODO Auth Agent, the KDE one
# TODO Desktop Portal for screen sharing
# TODO Dunst for notifications

#
# Please note not all available settings / options are set here.
# For a full list, see the wiki
#

# autogenerated = 1 # remove this line to remove the warning

# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,auto


# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
exec-once = bash ${mk-start}/bin/start
exec-once = wl-paste --type text --watch cliphist store

# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Some default env vars.
env = XCURSOR_SIZE,24

# forec the hyprchan
misc {

  force_hypr_chan = true
  disable_hyprland_logo = false
  animate_manual_resizes = true
  animate_mouse_windowdragging = true
}


# TODO device specific config to allow ferris sweep behave diffrently than another device

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    sensitivity = 1.0
    gaps_out = 20
    border_size = 2
    # Active border color
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    # Inactive borde color
    col.inactive_border = rgba(595959aa)
    # Resizing windows
    resize_on_border  = true
    hover_icon_on_border = true

    layout = dwindle
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    # anti aliasing on edges
    multisample_edges = true

    # Active opacity
    active_opacity = 0.9
    # inactive_opacity = 0.75
    fullscreen_opacity = 1.0

    blur {
        enabled = true
        size = 5
        passes = 1
        new_optimizations = true
        xray = true
        brightness = 1.0
    }

    drop_shadow = yes
    shadow_range = 10
    shadow_ignore_window = true
    shadow_render_power = 1
    col.shadow = rgba(1a1a1aee)

    dim_inactive = true
    # screen_shader = path to custom screen shader
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default

    bezier = epicurve,0.27,0.66,0.49,1.01
    animation=windowsIn, 1, 2, epicurve
    animation=workspaces,1,7,default,slidefadevert

}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = off
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
device:epic-mouse-v1 {
    sensitivity = -0.5
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

windowrule = float, ^(dolphin)$

binds {

  workspace_back_and_forth = true

}

# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Q, exec, kitty
# Passes the selected screen into standard output and pipes it to swappy
bind = $mainMod, D, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -
bind = $mainMod, C, killactive, 
bind = $mainMod, M, exit, 
bind = $mainMod, E, exec, dolphin
bind = $mainMod, SPACE, togglefloating, 
bind = $mainMod, R, exec, rofi -show drun -show-icons
bind = $mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle

bind = $mainMod, Tab, cyclenext,
bind = $mainMod, Y, bringactivetotop,

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# TODO Special workspace
# bind = $mainMod, ;, movetoworkspace, special,

# Special scripts
bind = $mainMod, G, exec, bash ${mk-decrease-border}/bin/border-down
bind = $mainMod, B, exec, bash ${mk-increase-border}/bin/border-up
bind = $mainMod, H, exec, bash ${mk-toggle-gaps}/bin/toggle-gaps
'';
  };
      home.file.".config/hypr/colors".text = ''
$background = rgba(1d192bee)
$foreground = rgba(c3dde7ee)

$color0 = rgba(1d192bee)
$color1 = rgba(465EA7ee)
$color2 = rgba(5A89B6ee)
$color3 = rgba(6296CAee)
$color4 = rgba(73B3D4ee)
$color5 = rgba(7BC7DDee)
$color6 = rgba(9CB4E3ee)
$color7 = rgba(c3dde7ee)
$color8 = rgba(889aa1ee)
$color9 = rgba(465EA7ee)
$color10 = rgba(5A89B6ee)
$color11 = rgba(6296CAee)
$color12 = rgba(73B3D4ee)
$color13 = rgba(7BC7DDee)
$color14 = rgba(9CB4E3ee)
$color15 = rgba(c3dde7ee)
    '';

}
