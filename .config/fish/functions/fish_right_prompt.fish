function fish_right_prompt
    set -l normal (set_color normal)
    set -l yellow (set_color yellow)
    set -l brblack (set_color brblack)
    set -l magenta (set_color magenta)
    set -l cyan (set_color cyan)
    
    # Material You design container
    set -l segments

    # Show execution time for long-running commands with circular indicator
    if test $CMD_DURATION
        set -l duration (math $CMD_DURATION / 1000)
        if test $duration -ge 5
            set -l duration_str ""
            
            if test $duration -ge 60
                set duration_str $duration_str(math $duration / 60)"m "
            end
            
            if test (math $duration % 60) -gt 0
                set duration_str $duration_str(math $duration % 60)"s"
            end
            
            set segments $segments "$magenta⬤ $duration_str$normal"
        end
    end
    
    # Show background jobs with circular indicator
    set -l jobs_count (jobs -p | wc -l)
    if test $jobs_count -gt 0
        set segments $segments "$yellow⬤ $jobs_count$normal"
    end
    
    # Show runtime environment with circular indicator
    if test -n "$VIRTUAL_ENV"
        set -l venv (basename "$VIRTUAL_ENV")
        set segments $segments "$cyan⬤ py:$venv$normal"
    else if test -f "package.json"
        set segments $segments "$cyan⬤ node$normal"
    else if test -f "Gemfile"
        set segments $segments "$cyan⬤ ruby$normal"
    else if test -f "go.mod"
        set segments $segments "$cyan⬤ go$normal"
    else if test -f "Cargo.toml"
        set segments $segments "$cyan⬤ rust$normal"
    end
    
    # Join all segments with a space
    set -l joined_segments (string join " " $segments)
    
    # If we have segments, add a separator
    if test -n "$joined_segments"
        echo -n "$joined_segments $brblack|$normal "
    end
    
    # Current time with Material You style
    echo -n "$brblack⬤ "(date "+%H:%M:%S")"$normal"
end 