#!/usr/bin/env bash

# Generate separate styles for light and dark themes
# Changes have to be committed and pushed in the submodule afterwards!
hugo gen chromastyles --style=monokailight > themes/dead-simple/assets/syntax_light.css
hugo gen chromastyles --style=onedark > themes/dead-simple/assets/syntax_dark.css
