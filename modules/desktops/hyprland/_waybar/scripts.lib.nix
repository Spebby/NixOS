{
  pkgs,
  playerctl,
  jq,
}:

{
  queryMediaScript = pkgs.writeShellScript "queryMedia" ''
    #!/bin/sh
    player_priority="cider, spotify, vlc, firefox, chromium"
    metadata_format="{\"playerName\": \"{{ playerName }}\", \"status\": \"{{ status }}\", \"title\": \"{{ title }}\", \"artist\": \"{{ artist }}\"}"

    ${playerctl} --follow -a --player "$player_priority" metadata --format "$metadata_format" |
      while read -r _; do
        active_stream=$(${playerctl} -a --player "$player_priority" metadata --format "$metadata_format" | ${jq} -s 'first([.[] | select(.status == "Playing")][] // empty)')
        echo ""
        echo "$active_stream" | ${jq} --unbuffered --compact-output --arg maxlen 50 '
          def truncate($len):
            (if length > ($len | tonumber)
             then (.[0:($len | tonumber - 3)] + "...")
             else . end) | gsub("&"; "&amp;");

          .class = .playerName
          | .alt = .playerName
          | .text = "\(.title) - \(.artist)"
          | .text |= truncate($maxlen | tonumber)'
      done
  '';
}
