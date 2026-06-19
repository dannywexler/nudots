$env.PROMPT_COMMAND_RIGHT = {""}
$env.PROMPT_INDICATOR = $' ) '
$env.PROMPT_INDICATOR_VI_INSERT = $' ) '
$env.PROMPT_INDICATOR_VI_NORMAL = $' > '

$env.PROMPT_COMMAND = { ||
    mut prmpt = $'(ansi light_green_bold)(ansi light_green_reverse)(pwd | str replace $nu.home-dir "~")(ansi reset)(ansi light_green)(ansi reset)'
    $prmpt += $'(get_git_info)'
    return $'($prmpt)(ansi reset)'
}

const INDEX_MAP = {
    idx_added_staged: "ADD_S",
    idx_modified_staged: "MOD_S",
    idx_deleted_staged: "DEL_S",
    idx_renamed: "REN_S",
    idx_type_changed: "TYP_S",
}

const WORKING_MAP = {
    wt_untracked: "UNT",
    wt_deleted: "DEL",
    wt_modified: "MOD",
    wt_renamed: "REN",
    wt_type_changed: "TYP",
}

const STATS_MAP = {
    ignored: "IGN",
    conflicts: "CON",
    ahead: "AHEAD",
    behind: "BEHIND",
    stashes: "STASH",
}

const EMPTY_INFO = {
    tag: "no_tag",
    branch: "no_branch",
}

const info_map = {
    # repo_name: "REPO",
    tag: "TAG",
    branch: "BRN"
}

def get_git_info [] {
    let GSTATS = gstat
    mut GINFO = $'(ansi white_bold) on (ansi reset)(ansi light_blue_bold)(ansi light_blue_reverse)'

    let REPO = $GSTATS | get repo_name
    if $REPO == "no_repository" {
        return ""
    }
    if not ($REPO == $'(pwd | path basename)') {
        $GINFO += $'REPO: ($REPO)'
    }

    for $it in ($info_map | transpose key val) {
        let gval = $GSTATS | get $it.key
        let empty_val = $EMPTY_INFO | get $it.key
        let label = $info_map | get $it.key
        if $gval != $empty_val {
            # $GINFO ++= [$'($label): ($gval)']
            $GINFO += $gval
        }
    }
    mut STATS = []
    for $MAP in [$STATS_MAP, $INDEX_MAP, $WORKING_MAP] {
        for $it in ($MAP | transpose key val) {
            let gval = $GSTATS | get $it.key
            if ($gval | into int) > 0 {
                # $GINFO ++= [$'($it.val): ($gval)']
                $STATS ++= [$'($gval) ($it.val)']
            }
        }
    }
    if ($STATS | is-not-empty) {
        $GINFO += $' ($STATS | str join ", ")'
    }
    $GINFO += $'(ansi reset)(ansi light_blue)'
    return $GINFO
}

