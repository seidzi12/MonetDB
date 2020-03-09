# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0.  If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright 1997 - July 2008 CWI, August 2008 - 2020 MonetDB B.V.

sed '/^$/q' $0			# copy copyright from this file

cat <<EOF
# This file was generated by using the script ${0##*/}.

module batcalc;

EOF

integer=(bte sht int lng hge)	# all integer types
numeric=(${integer[@]} flt dbl)	# all numeric types
alltypes=(bit ${numeric[@]} oid str)

for tp in hge; do
    cat <<EOF
pattern iszero(b:bat[:$tp]) :bat[:bit]
address CMDbatISZERO
comment "Unary check for zero over the tail of the bat";
pattern iszero(b:bat[:$tp],s:bat[:oid]) :bat[:bit]
address CMDbatISZERO
comment "Unary check for zero over the tail of the bat with candidates list";
pattern iszero(b:bat[:$tp],r:bat[:bit]) :bat[:bit]
address CMDbatISZERO
comment "Unary check for zero over the tail of the bat";
pattern iszero(b:bat[:$tp],s:bat[:oid],r:bat[:bit]) :bat[:bit]
address CMDbatISZERO
comment "Unary check for zero over the tail of the bat with candidates list";

EOF
done
echo

com="Unary bitwise not over the tail of the bat"
for tp in hge; do
    cat <<EOF
pattern not(b:bat[:$tp]) :bat[:$tp]
address CMDbatNOT
comment "$com";
pattern not(b:bat[:$tp],s:bat[:oid]) :bat[:$tp]
address CMDbatNOT
comment "$com with candidates list";
pattern not(b:bat[:$tp],r:bat[:bit]) :bat[:$tp]
address CMDbatNOT
comment "$com";
pattern not(b:bat[:$tp],s:bat[:oid],r:bat[:bit]) :bat[:$tp]
address CMDbatNOT
comment "$com with candidates list";

EOF
done
echo

for tp in hge; do
    cat <<EOF
pattern sign(b:bat[:$tp]) :bat[:bte]
address CMDbatSIGN
comment "Unary sign (-1,0,1) over the tail of the bat";
pattern sign(b:bat[:$tp],s:bat[:oid]) :bat[:bte]
address CMDbatSIGN
comment "Unary sign (-1,0,1) over the tail of the bat with candidates list";
pattern sign(b:bat[:$tp],r:bat[:bit]) :bat[:bte]
address CMDbatSIGN
comment "Unary sign (-1,0,1,r:bat[:bit]) over the tail of the bat";
pattern sign(b:bat[:$tp],s:bat[:oid],r:bat[:bit]) :bat[:bte]
address CMDbatSIGN
comment "Unary sign (-1,0,1,r:bat[:bit]) over the tail of the bat with candidates list";

EOF
done
echo

for func in 'abs:ABS:Unary abs over the tail of the bat' \
    '-:NEG:Unary neg over the tail of the bat' \
    '++:INCR:Unary increment over the tail of the bat' \
    '--:DECR:Unary decrement over the tail of the bat'; do
    op=${func%%:*}
    com=${func##*:}
    func=${func%:*}
    func=${func#*:}
    for tp in hge; do
	cat <<EOF
pattern $op(b:bat[:$tp]) :bat[:$tp]
address CMDbat${func}
comment "$com";
pattern $op(b:bat[:$tp],s:bat[:oid]) :bat[:$tp]
address CMDbat${func}
comment "$com with candidates list";
pattern $op(b:bat[:$tp],r:bat[:bit]) :bat[:$tp]
address CMDbat${func}
comment "$com";
pattern $op(b:bat[:$tp],s:bat[:oid],r:bat[:bit]) :bat[:$tp]
address CMDbat${func}
comment "$com with candidates list";

EOF
    done
    echo
done

for func in +:ADD -:SUB \*:MUL; do
    name=${func#*:}
    op=${func%:*}
    for ((i = 0; i < ${#numeric[@]}; i++)); do
	tp1=${numeric[i]}
	for ((j = 0; j < ${#numeric[@]}; j++)); do
	    tp2=${numeric[j]}
	    for ((k = ${#numeric[@]} - 1; k >= 0; k--)); do
		if ((k < i || k < j)); then
		    continue
		fi
		tp3=${numeric[k]}
		if [[ $tp1$tp2$tp3 == *hge* ]]; then
		    :		# at least one of them must be hge
		else
		    continue
		fi
		if ((k == i || k == j)); then
		    cat <<EOF
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B1 $op B2, signal error on overflow";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B1 $op B2 with candidates list, signal error on overflow";
pattern ${name,,}_noerror(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp3]
address CMDbat${name}
comment "Return B1 $op B2, overflow causes NIL value";
pattern ${name,,}_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp3]
address CMDbat${name}
comment "Return B1 $op B2 with candidates list, overflow causes NIL value";
pattern $op(b:bat[:$tp1],v:$tp2) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B $op V, signal error on overflow";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B $op V with candidates list, signal error on overflow";
pattern ${name,,}_noerror(b:bat[:$tp1],v:$tp2) :bat[:$tp3]
address CMDbat${name}
comment "Return B $op V, overflow causes NIL value";
pattern ${name,,}_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp3]
address CMDbat${name}
comment "Return B $op V with candidates list, overflow causes NIL value";
pattern $op(v:$tp1,b:bat[:$tp2]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return V $op B, signal error on overflow";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return V $op B with candidates list, signal error on overflow";
pattern ${name,,}_noerror(v:$tp1,b:bat[:$tp2]) :bat[:$tp3]
address CMDbat${name}
comment "Return V $op B, overflow causes NIL value";
pattern ${name,,}_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp3]
address CMDbat${name}
comment "Return V $op B with candidates list, overflow causes NIL value";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B1 $op B2, signal error on overflow";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B1 $op B2 with candidates list, signal error on overflow";
pattern ${name,,}_noerror(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}
comment "Return B1 $op B2, overflow causes NIL value";
pattern ${name,,}_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}
comment "Return B1 $op B2 with candidates list, overflow causes NIL value";
pattern $op(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B $op V, signal error on overflow";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return B $op V with candidates list, signal error on overflow";
pattern ${name,,}_noerror(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}
comment "Return B $op V, overflow causes NIL value";
pattern ${name,,}_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}
comment "Return B $op V with candidates list, overflow causes NIL value";
pattern $op(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return V $op B, signal error on overflow";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}signal
comment "Return V $op B with candidates list, signal error on overflow";
pattern ${name,,}_noerror(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}
comment "Return V $op B, overflow causes NIL value";
pattern ${name,,}_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}
comment "Return V $op B with candidates list, overflow causes NIL value";

EOF
		else
		    cat <<EOF
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B1 $op B2, guarantee no overflow by returning larger type";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B1 $op B2 with candidates list, guarantee no overflow by returning larger type";
pattern $op(b:bat[:$tp1],v:$tp2) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B $op V, guarantee no overflow by returning larger type";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B $op V with candidates list, guarantee no overflow by returning larger type";
pattern $op(v:$tp1,b:bat[:$tp2]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return V $op B, guarantee no overflow by returning larger type";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return V $op B with candidates list, guarantee no overflow by returning larger type";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B1 $op B2, guarantee no overflow by returning larger type";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B1 $op B2 with candidates list, guarantee no overflow by returning larger type";
pattern $op(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B $op V, guarantee no overflow by returning larger type";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return B $op V with candidates list, guarantee no overflow by returning larger type";
pattern $op(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return V $op B, guarantee no overflow by returning larger type";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbat${name}enlarge
comment "Return V $op B with candidates list, guarantee no overflow by returning larger type";

EOF
		fi
	    done
	done
    done
done

for ((i = 0; i < ${#numeric[@]}; i++)); do
    tp1=${numeric[i]}
    for ((j = 0; j < ${#numeric[@]}; j++)); do
	tp2=${numeric[j]}
	for ((k = ${#numeric[@]} - 1; k >= i; k--)); do
	    tp3=${numeric[k]}
	    [[ $tp1$tp2$tp3 == *hge* ]] || continue
	    cat <<EOF
pattern /(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B1 / B2, signal error on overflow";
pattern /(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B1 / B2 with candidates list, signal error on overflow";
pattern div_noerror(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp3]
address CMDbatDIV
comment "Return B1 / B2, overflow causes NIL value";
pattern div_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp3]
address CMDbatDIV
comment "Return B1 / B2 with candidates list, overflow causes NIL value";
pattern /(b:bat[:$tp1],v:$tp2) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B / V, signal error on overflow";
pattern /(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B / V with candidates list, signal error on overflow";
pattern div_noerror(b:bat[:$tp1],v:$tp2) :bat[:$tp3]
address CMDbatDIV
comment "Return B / V, overflow causes NIL value";
pattern div_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp3]
address CMDbatDIV
comment "Return B / V with candidates list, overflow causes NIL value";
pattern /(v:$tp1,b:bat[:$tp2]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return V / B, signal error on overflow";
pattern /(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return V / B with candidates list, signal error on overflow";
pattern div_noerror(v:$tp1,b:bat[:$tp2]) :bat[:$tp3]
address CMDbatDIV
comment "Return V / B, overflow causes NIL value";
pattern div_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp3]
address CMDbatDIV
comment "Return V / B with candidates list, overflow causes NIL value";
pattern /(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B1 / B2, signal error on overflow";
pattern /(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B1 / B2 with candidates list, signal error on overflow";
pattern div_noerror(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIV
comment "Return B1 / B2, overflow causes NIL value";
pattern div_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIV
comment "Return B1 / B2 with candidates list, overflow causes NIL value";
pattern /(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B / V, signal error on overflow";
pattern /(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return B / V with candidates list, signal error on overflow";
pattern div_noerror(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp3]
address CMDbatDIV
comment "Return B / V, overflow causes NIL value";
pattern div_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIV
comment "Return B / V with candidates list, overflow causes NIL value";
pattern /(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return V / B, signal error on overflow";
pattern /(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIVsignal
comment "Return V / B with candidates list, signal error on overflow";
pattern div_noerror(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIV
comment "Return V / B, overflow causes NIL value";
pattern div_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatDIV
comment "Return V / B with candidates list, overflow causes NIL value";

EOF
	done
    done
done
echo

for ((i = 0; i < ${#numeric[@]}; i++)); do
    tp1=${numeric[i]}
    for ((j = 0; j < ${#numeric[@]}; j++)); do
	tp2=${numeric[j]}
	for ((k = ${#numeric[@]} - 1; k >= 0; k--)); do
	    if ((k < i && k < j)); then
		continue
	    fi
	    tp3=${numeric[k]}
	    case $tp3 in
	    dbl)
		case $tp1$tp2 in
		*dbl*) ;;
		*) continue;;
		esac
		;;
	    flt)
		case $tp1$tp2 in
		*dbl*) continue;;
		*flt*) ;;
		*) continue;;
		esac
		;;
	    *)
		case $tp1$tp2 in
		*flt*|*dbl*) continue;;
		*) ;;
		esac
		;;
	    esac
	    [[ $tp1$tp2$tp3 == *hge* ]] || continue
	    cat <<EOF
pattern %(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B1 % B2, signal error on divide by zero";
pattern %(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B1 % B2 with candidates list, signal error on divide by zero";
pattern mod_noerror(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp3]
address CMDbatMOD
comment "Return B1 % B2, divide by zero causes NIL value";
pattern mod_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp3]
address CMDbatMOD
comment "Return B1 % B2 with candidates list, divide by zero causes NIL value";
pattern %(b:bat[:$tp1],v:$tp2) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B % V, signal error on divide by zero";
pattern %(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B % V with candidates list, signal error on divide by zero";
pattern mod_noerror(b:bat[:$tp1],v:$tp2) :bat[:$tp3]
address CMDbatMOD
comment "Return B % V, divide by zero causes NIL value";
pattern mod_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp3]
address CMDbatMOD
comment "Return B % V with candidates list, divide by zero causes NIL value";
pattern %(v:$tp1,b:bat[:$tp2]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return V % B, signal error on divide by zero";
pattern %(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return V % B with candidates list, signal error on divide by zero";
pattern mod_noerror(v:$tp1,b:bat[:$tp2]) :bat[:$tp3]
address CMDbatMOD
comment "Return V % B, divide by zero causes NIL value";
pattern mod_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp3]
address CMDbatMOD
comment "Return V % B with candidates list, divide by zero causes NIL value";
pattern %(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B1 % B2, signal error on divide by zero";
pattern %(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B1 % B2 with candidates list, signal error on divide by zero";
pattern mod_noerror(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatMOD
comment "Return B1 % B2, divide by zero causes NIL value";
pattern mod_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatMOD
comment "Return B1 % B2 with candidates list, divide by zero causes NIL value";
pattern %(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B % V, signal error on divide by zero";
pattern %(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return B % V with candidates list, signal error on divide by zero";
pattern mod_noerror(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp3]
address CMDbatMOD
comment "Return B % V, divide by zero causes NIL value";
pattern mod_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatMOD
comment "Return B % V with candidates list, divide by zero causes NIL value";
pattern %(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return V % B, signal error on divide by zero";
pattern %(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatMODsignal
comment "Return V % B with candidates list, signal error on divide by zero";
pattern mod_noerror(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp3]
address CMDbatMOD
comment "Return V % B, divide by zero causes NIL value";
pattern mod_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp3]
address CMDbatMOD
comment "Return V % B with candidates list, divide by zero causes NIL value";

EOF
	done
    done
done
echo

for op in and or xor; do
    for tp in hge; do
	cat <<EOF
pattern ${op}(b1:bat[:$tp],b2:bat[:$tp]) :bat[:$tp]
address CMDbat${op^^}
comment "Return B1 ${op^^} B2";
pattern ${op}(b1:bat[:$tp],b2:bat[:$tp],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp]
address CMDbat${op^^}
comment "Return B1 ${op^^} B2 with candidates list";
pattern $op(b:bat[:$tp],v:$tp) :bat[:$tp]
address CMDbat${op^^}
comment "Return B ${op^^} V";
pattern $op(b:bat[:$tp],v:$tp,s:bat[:oid]) :bat[:$tp]
address CMDbat${op^^}
comment "Return B ${op^^} V with candidates list";
pattern $op(v:$tp,b:bat[:$tp]) :bat[:$tp]
address CMDbat${op^^}
comment "Return V ${op^^} B";
pattern $op(v:$tp,b:bat[:$tp],s:bat[:oid]) :bat[:$tp]
address CMDbat${op^^}
comment "Return V ${op^^} B with candidates list";
pattern ${op}(b1:bat[:$tp],b2:bat[:$tp],r:bat[:bit]) :bat[:$tp]
address CMDbat${op^^}
comment "Return B1 ${op^^} B2";
pattern ${op}(b1:bat[:$tp],b2:bat[:$tp],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp]
address CMDbat${op^^}
comment "Return B1 ${op^^} B2 with candidates list";
pattern $op(b:bat[:$tp],v:$tp,r:bat[:bit]) :bat[:$tp]
address CMDbat${op^^}
comment "Return B ${op^^} V";
pattern $op(b:bat[:$tp],v:$tp,s:bat[:oid],r:bat[:bit]) :bat[:$tp]
address CMDbat${op^^}
comment "Return B ${op^^} V with candidates list";
pattern $op(v:$tp,b:bat[:$tp],r:bat[:bit]) :bat[:$tp]
address CMDbat${op^^}
comment "Return V ${op^^} B";
pattern $op(v:$tp,b:bat[:$tp],s:bat[:oid],r:bat[:bit]) :bat[:$tp]
address CMDbat${op^^}
comment "Return V ${op^^} B with candidates list";

EOF
    done
    echo
done

for func in '<<:lsh' '>>:rsh'; do
    op=${func%:*}
    func=${func#*:}
    for tp1 in ${integer[@]}; do
	for tp2 in ${integer[@]}; do
	    case $tp1$tp2 in
	    *hge*) ;;
	    *) continue;;
	    esac
	    cat <<EOF
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B1 $op B2, raise error on out of range second operand";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B1 $op B2 with candidates list, raise error on out of range second operand";
pattern ${func}_noerror(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B1 $op B2, out of range second operand causes NIL value";
pattern ${func}_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B1 $op B2 with candidates list, out of range second operand causes NIL value";
pattern $op(b:bat[:$tp1],v:$tp2) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B $op V, raise error on out of range second operand";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B $op V with candidates list, raise error on out of range second operand";
pattern ${func}_noerror(b:bat[:$tp1],v:$tp2) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B $op V, out of range second operand causes NIL value";
pattern ${func}_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B $op V with candidates list, out of range second operand causes NIL value";
pattern $op(v:$tp1,b:bat[:$tp2]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return V $op B, raise error on out of range second operand";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return V $op B with candidates list, raise error on out of range second operand";
pattern ${func}_noerror(v:$tp1,b:bat[:$tp2]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return V $op B, out of range second operand causes NIL value";
pattern ${func}_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return V $op B with candidates list, out of range second operand causes NIL value";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B1 $op B2, raise error on out of range second operand";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B1 $op B2 with candidates list, raise error on out of range second operand";
pattern ${func}_noerror(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B1 $op B2, out of range second operand causes NIL value";
pattern ${func}_noerror(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B1 $op B2 with candidates list, out of range second operand causes NIL value";
pattern $op(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B $op V, raise error on out of range second operand";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return B $op V with candidates list, raise error on out of range second operand";
pattern ${func}_noerror(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B $op V, out of range second operand causes NIL value";
pattern ${func}_noerror(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return B $op V with candidates list, out of range second operand causes NIL value";
pattern $op(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return V $op B, raise error on out of range second operand";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}signal
comment "Return V $op B with candidates list, raise error on out of range second operand";
pattern ${func}_noerror(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return V $op B, out of range second operand causes NIL value";
pattern ${func}_noerror(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDbat${func^^}
comment "Return V $op B with candidates list, out of range second operand causes NIL value";

EOF
	done
    done
    echo
done

for func in '<:lt' '<=:le' '>:gt' '>=:ge' '==:eq' '!=:ne'; do
    op=${func%:*}
    func=${func#*:}
    for tp1 in ${numeric[@]}; do
	for tp2 in ${numeric[@]}; do
	    case $tp1$tp2 in
	    *hge*) ;;
	    *) continue;;
	    esac
	    cat <<EOF
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2 with candidates list";
pattern $op(b:bat[:$tp1],v:$tp2) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V with candidates list";
pattern $op(v:$tp1,b:bat[:$tp2]) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B with candidates list";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2 with candidates list";
pattern $op(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V with candidates list";
pattern $op(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B with candidates list";

EOF
	    case $op in
	    == | !=)
		cat <<EOF
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2 with candidates list";
pattern $op(b:bat[:$tp1],v:$tp2,nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V with candidates list";
pattern $op(v:$tp1,b:bat[:$tp2],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B with candidates list";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2";
pattern $op(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B1 $op B2 with candidates list";
pattern $op(b:bat[:$tp1],v:$tp2,r:bat[:bit],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V";
pattern $op(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return B $op V with candidates list";
pattern $op(v:$tp1,b:bat[:$tp2],r:bat[:bit],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B";
pattern $op(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit],nil_matches:bit) :bat[:bit]
address CMDbat${func^^}
comment "Return V $op B with candidates list";

EOF
		;;
	    esac
	done
    done
    echo
done

op=${func%:*}
func=${func#*:}
for tp1 in ${numeric[@]}; do
    for tp2 in ${numeric[@]}; do
	case $tp1$tp2 in
	*hge*) ;;
	*) continue;;
	esac
	cat <<EOF
pattern cmp(b1:bat[:$tp1],b2:bat[:$tp2]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B1 </==/> B2";
pattern cmp(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B1 </==/> B2 with candidates list";
pattern cmp(b:bat[:$tp1],v:$tp2) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B </==/> V";
pattern cmp(v:$tp1,b:bat[:$tp2]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if V </==/> B";
pattern cmp(b:bat[:$tp1],v:$tp2,s:bat[:oid]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B </==/> V with candidates list";
pattern cmp(v:$tp1,b:bat[:$tp2],s:bat[:oid]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if V </==/> B with candidates list";
pattern cmp(b1:bat[:$tp1],b2:bat[:$tp2],r:bat[:bit]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B1 </==/> B2";
pattern cmp(b1:bat[:$tp1],b2:bat[:$tp2],s1:bat[:oid],s2:bat[:oid],r:bat[:bit]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B1 </==/> B2 with candidates list";
pattern cmp(b:bat[:$tp1],v:$tp2,r:bat[:bit]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B </==/> V";
pattern cmp(v:$tp1,b:bat[:$tp2],r:bat[:bit]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if V </==/> B";
pattern cmp(b:bat[:$tp1],v:$tp2,s:bat[:oid],r:bat[:bit]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if B </==/> V with candidates list";
pattern cmp(v:$tp1,b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:bte]
address CMDbatCMP
comment "Return -1/0/1 if V </==/> B with candidates list";

EOF
    done
done
echo

for tp in hge; do
    cat <<EOF
pattern avg(b:bat[:$tp]) :dbl
address CMDcalcavg
comment "average of non-nil values of B with candidates list";
pattern avg(b:bat[:$tp],s:bat[:oid]) :dbl
address CMDcalcavg
comment "average of non-nil values of B";
pattern avg(b:bat[:$tp]) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-nil values of B";
pattern avg(b:bat[:$tp],s:bat[:oid]) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-nil values of B with candidates list";
pattern avg(b:bat[:$tp],scale:int) :dbl
address CMDcalcavg
comment "average of non-nil values of B with candidates list";
pattern avg(b:bat[:$tp],s:bat[:oid],scale:int) :dbl
address CMDcalcavg
comment "average of non-nil values of B";
pattern avg(b:bat[:$tp],scale:int) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-nil values of B";
pattern avg(b:bat[:$tp],s:bat[:oid],scale:int) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-nil values of B with candidates list";
pattern avg(b:bat[:$tp]) :dbl
address CMDcalcavg
comment "average of non-r:bat[:bit],nil values of B with candidates list";
pattern avg(b:bat[:$tp],s:bat[:oid]) :dbl
address CMDcalcavg
comment "average of non-r:bat[:bit],nil values of B";
pattern avg(b:bat[:$tp]) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-r:bat[:bit],nil values of B";
pattern avg(b:bat[:$tp],s:bat[:oid]) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-r:bat[:bit],nil values of B with candidates list";
pattern avg(b:bat[:$tp],scale:int) :dbl
address CMDcalcavg
comment "average of non-r:bat[:bit],nil values of B with candidates list";
pattern avg(b:bat[:$tp],s:bat[:oid],scale:int) :dbl
address CMDcalcavg
comment "average of non-r:bat[:bit],nil values of B";
pattern avg(b:bat[:$tp],scale:int) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-r:bat[:bit],nil values of B";
pattern avg(b:bat[:$tp],s:bat[:oid],scale:int) (:dbl, :lng)
address CMDcalcavg
comment "average and number of non-r:bat[:bit],nil values of B with candidates list";

EOF
done

for tp1 in ${alltypes[@]}; do
    if [[ $tp1 == str ]]; then
	continue
    fi
    for tp2 in ${alltypes[@]}; do
	case $tp1$tp2 in
	*hge*) ;;
	*) continue;;
	esac
	cat <<EOF
pattern $tp1(b:bat[:$tp2]) :bat[:$tp1]
address CMDconvertsignal_$tp1
comment "cast from $tp2 to $tp1, signal error on overflow";
pattern $tp1(b:bat[:$tp2],s:bat[:oid]) :bat[:$tp1]
address CMDconvertsignal_$tp1
comment "cast from $tp2 to $tp1 with candidates list, signal error on overflow";
pattern ${tp1}_noerror(b:bat[:$tp2]) :bat[:$tp1]
address CMDconvert_$tp1
comment "cast from $tp2 to $tp1";
pattern ${tp1}_noerror(b:bat[:$tp2],s:bat[:oid]) :bat[:$tp1]
address CMDconvert_$tp1
comment "cast from $tp2 to $tp1 with candidates list";
pattern $tp1(b:bat[:$tp2],r:bat[:bit]) :bat[:$tp1]
address CMDconvertsignal_$tp1
comment "cast from $tp2 to $tp1, signal error on overflow";
pattern $tp1(b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDconvertsignal_$tp1
comment "cast from $tp2 to $tp1 with candidates list, signal error on overflow";
pattern ${tp1}_noerror(b:bat[:$tp2],r:bat[:bit]) :bat[:$tp1]
address CMDconvert_$tp1
comment "cast from $tp2 to $tp1";
pattern ${tp1}_noerror(b:bat[:$tp2],s:bat[:oid],r:bat[:bit]) :bat[:$tp1]
address CMDconvert_$tp1
comment "cast from $tp2 to $tp1 with candidates list";

EOF
    done
done
