#!/bin/bash
# Not as polished as I want it to be yet; I want to add the ability to use
# custom headers at some point and distribute this properly.

HEADER_START='${font Iosevka:size=12:weight=bold}'
HEADER_END='${font Iosevka:size=12}'
OTHER_HEADER="Uncategorised"
ARGS=(-d $HOME/.todo/config-conky -Pn)
TODAY=$(date -d "-4hours" +%Y-%m-%d)
DONERX="s:[0-9]* x [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} ::"
MATCH='(\$\{.*\})?([0-9]*) (.*)'
SWITCH='${color bebec1}\2${color} \1\3'

while getopts rbo:p: OPT; do
	case $OPT in
		    r) SWITCH='\1\3 \| \2'; ALIGN='${alignr}'; ALNRX="s/^/$ALIGN/" ;;
		        b) DONE_BOTTOM=yes ;;
			    o) OTHER_HEADER="$OPTARG" ;;
			        p) PADDING=$OPTARG ;;  # Conky likes to shift around a lot without this.
			esac
		done
		shift $((OPTIND - 1))

		DONE=$(todo.sh ${ARGS[@]} lf done.txt $TODAY | head -n -2)
		EMAILS=$(todo.sh ${ARGS[@]} ls @Emails | head -n -2)
		DEVELOPMENT=$(todo.sh ${ARGS[@]} ls @Development | head -n -2)
		OTHER=$(todo.sh ${ARGS[@]} ls -@Emails -@Development | head -n -2)

		[[ -n "$PADDING" ]] && {
			    LINES=0
		    SEP=0
		        [[ -n "$DONE" ]] && LINES=$(($LINES + $(echo "$DONE" | wc -l) + 1))
			    [[ -n "$DONE" ]] && [[ -n "$EMAILS" ]] && LINES=$(($LINES + 1))
			        [[ -n "$EMAILS" ]] && LINES=$(($LINES + $(echo "$EMAILS" | wc -l) + 1))
				    [[ -n "$EMAILS" ]] && [[ -n "$DEVELOPMENT" ]] && LINES=$(($LINES + 1))
				        [[ -n "$DEVELOPMENT" ]] && LINES=$(($LINES + $(echo "$DEVELOPMENT" | wc -l) + 1))
					    [[ -n "$DEVELOPMENT" ]] && [[ -n "$OTHER" ]] && LINES=$(($LINES + 1))
					        [[ -n "$OTHER" ]] && LINES=$(($LINES + $(echo "$OTHER" | wc -l) + 1))
						    LINES=$(($PADDING - $LINES))
					    }

				    [[ -z "$DONE_BOTTOM" ]] && {
					        [[ -n "$PADDING" ]] && for i in $(seq 1 $LINES); do echo; done
				        [[ -n "$DONE" ]] && {
						        echo "${HEADER_START}${ALIGN}Done today${HEADER_END}"
					        echo "$DONE" | sed -e "s:[0-9]* x $TODAY ::" -e "$ALNRX"
						        [[ -n "$EMAILS$DEVELOPMENT$OTHER" ]] && echo '${color}'
							    }
					    }
				    [[ -n "$EMAILS" ]] && {
					        echo "${HEADER_START}${ALIGN}Emails${HEADER_END}"
				        echo "$EMAILS" | sed -r -e 's: @Emails::gI' -e "s/$MATCH/$SWITCH/" -e "$ALNRX"
					    [[ -n "$DEVELOPMENT$OTHER" ]] && echo '${color}'
				    }
			    [[ -n "$DEVELOPMENT" ]] && {
				        echo "${HEADER_START}${ALIGN}Development${HEADER_END}"
			        echo "$DEVELOPMENT" | sed -r -e 's: @Development::gI' -e "s/$MATCH/$SWITCH/" -e "$ALNRX"
				    [[ -n "$OTHER" ]] && echo '${color}'
			    }
		    [[ -n "$OTHER" ]] && {
			        echo "$HEADER_START$ALIGN$OTHER_HEADER$HEADER_END"
		        echo "$OTHER" | sed -r -e "s/$MATCH/$SWITCH/" -e "$ALNRX"
		}
	[[ -n "$DONE_BOTTOM" ]] && {
		    [[ -n "$DONE" ]] && {
		            [[ -n "$OTHER" ]] && echo '${color}'
	        echo "$HEADER_START$ALIGN'Done Today'$HEADER_END"
		        echo "$DONE" | sed -e "$DONERX" -e "$ALNRX"
			    }
		        [[ -n "$PADDING" ]] && for i in $(seq 1 $LINES); do echo; done
		}
