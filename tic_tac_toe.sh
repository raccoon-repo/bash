#!/bin/bash

traces=('123' '456' '789' '159' '753' '147' '258' '963')

###############
#  . | . | .  #
# ----------- #
#  . | . | .  #
# ----------- #
#  . | . | .  #
###############

#      1   2   3   4   5   6   7   8   9
grid=('.' '.' '.' '.' '.' '.' '.' '.' '.')
over=0


function check_cell {
    local cell=$1

    if [ "${grid[$cell]}" == "." ] && [ $cell -lt 9 ] && [ $cell -ge 0 ]
    then
        #cell is empty
        echo 1
    else
        #cell is occupied
        echo O
    fi
}

# $1 - is the number of the move
function readInput {
    local cell
    local checked
    local checked_in
    local even=$(( $1 % 2 ))
    read -p 'q to quit. enter the number of the cell: ' cell

    if [ $cell == "q" ]
    then
        over=1
        return 0
    else
        checked=$( check_cell $(( cell - 1 )) )
        checked_in=$( check_input $cell )

        while [ "$checked" == "O" ] || [ "$checked_in" == "O" ]
        do
            drawGrid
            echo "number of the cell must be a number and in range from 1 to 9"
            echo "do not input numbre of the already occupied cell"

            read -p 'q to quit: enter the number of the cell: ' cell
            
            if [ $cell == "q" ]
            then
                over=1
                return 0
            else
                checked=$( check_cell $(( cell - 1 )) )
                cheked_in=$( check_input $cell )
            fi
        done
    
        if [ $even -eq 0 ]
        then
            grid[$(( cell - 1 ))]="X"
        else
            grid[$(( cell - 1 ))]="O"
        fi
    fi
}

function check_input {
    local cell
    cell=$(($1))
    if [ $cell -lt 10 ] && [ $cell -gt 0 ]
    then
        #passed cell value is correct
        echo 1
    else
        #cell value is incorrect
        echo O
    fi
}


function main_loop {
    local move=0
    local won
    while [ $over -eq 0 ]
    do
        if [ $move -eq 9 ]
        then
            read -p 'do you want to play again? [y/n]' dec
            if [ "$dec" == "y" ]
            then
                move=0
                grid=('.' '.' '.' '.' '.' '.' '.' '.' '.')
            else
                return 0
            fi
        else
            echo
            drawGrid
            readInput $move
            drawGrid
            ((move++))

            won=$( check_traces )
            case $won in
                'X')
                    echo "X won the game!"
                    return 0
                ;;
                'O')
                    echo "O won the game!"
                    return 0
                ;;
                *)
                ;;
            esac
        fi
    done
}

function check_traces {
    local res
    for trace in ${traces[@]}
    do
        local pos1=$((${trace:0:1} - 1))
        local pos2=$((${trace:1:1} - 1))
        local pos3=$((${trace:2:2} - 1))

        if [ "${grid[$pos1]}" == "X" ] && [ "${grid[$pos2]}" == "X" ] && [ "${grid[$pos3]}" == "X" ]
        then
            res='X'
            break
        elif [ "${grid[$pos1]}" == "O" ] && [ "${grid[$pos2]}" == "O" ] && [ "${grid[$pos3]}" == "O" ]
        then
            res='O'
            break
        else
            continue
        fi
    done

    echo $res
}

function drawGrid {
    clear
    echo
    echo " $( cval 1 ) | $( cval 2 ) | $( cval 3 ) "
    echo "-----------"
    echo " $( cval 4 ) | $( cval 5 ) | $( cval 6 ) "
    echo "-----------"
    echo " $( cval 7 ) | $( cval 8 ) | $( cval 9 ) "   
    echo
}

# returns a value of a cell
function cval {
    local cell=$(($1 - 1))
    echo ${grid[$cell]}
}

main_loop