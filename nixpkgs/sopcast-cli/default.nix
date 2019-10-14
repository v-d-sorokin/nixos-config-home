{ stdenv, runCommand, writeScript, sopcast, mpv
}:

let
  script = writeScript "sopcast" ''
    #! ${stdenv.shell} -e
    ${sopcast}/bin/sp-sc-auth $1 3908 8908 >/dev/null &
    while [ 1 ] ; do
    # mplayer http://localhost:8908/tv.asf -fs -fixed-vo -zoom -cache 2048 $2 $3
    #  vlc http://localhost:8908/tv.asf
      ${mpv}/bin/mpv http://localhost:8908/tv.asf -fs $2 $3 || true
      sleep 1
    done
  '';
in runCommand "sopcast-cli" {} ''
  mkdir -p $out/bin
  cp ${script} $out/bin/sopcast.sh
''
