#! /usr/bin/gawk -f

BEGIN {
	if (ARGC != 1) {
		str = buildstr(ARGV)
		$0 = str
		initstack()
		parse()
		printstack()
		exit
	}

	# No command line args, read stdin
	initstack()
}

# For each line from stdin
{
	parse()
	printstack()
}

END {
	if (ARGC != 1 && Sp != 1)
		printstack()
}

# buildstr --- build a string from array

function buildstr(data,		i, ret)
{
	ret = ""
	for (i = 1; i in data; i++)
		ret = ret " " data[i]

	return ret
}

# initstack --- clear out stack

function initstack()
{
	Sp = 0
	delete Stack
}

# parse --- parse reverse polish data in $0 and execute

function parse(		i)
{
	for (i = 1; i <= NF; i++) {
		if ($i == "+") {
			Stack[Sp-1] += Stack[Sp]
			Sp--
		} else if ($i == "-") {
			Stack[Sp-1] -= Stack[Sp]
			Sp--
		} else if ($i == "*" || $i == "x" || $i == "X") {
			Stack[Sp-1] *= Stack[Sp]
			Sp--
		} else if ($i == "/") {
			Stack[Sp-1] /= Stack[Sp]
			Sp--
		} else if ($i == "%") {
			Stack[Sp-1] %= Stack[Sp]
			Sp--
		} else if ($i == "^" || $i == ":") {
			Stack[Sp-1] ^= Stack[Sp]
			Sp--
		} else if ($i == "@") {	# flip the sign of top of stack
			Stack[Sp] = -Stack[Sp]
		} else if ($i == "!") {	# flip the logical status of top of stack
			Stack[Sp] = ! Stack[Sp]
		} else if ($i == "=") {
			Stack[Sp-1] = (Stack[Sp-1] == Stack[Sp])
			Sp--
		} else if ($i == "<") {
			Stack[Sp-1] = (Stack[Sp-1] < Stack[Sp])
			Sp--
		} else if ($i == "<=") {
			Stack[Sp-1] = (Stack[Sp-1] <= Stack[Sp])
			Sp--
		} else if ($i == ">") {
			Stack[Sp-1] = (Stack[Sp-1] > Stack[Sp])
			Sp--
		} else if ($i == ">=") {
			Stack[Sp-1] = (Stack[Sp-1] >= Stack[Sp])
			Sp--
		} else if ($i == "&") {
			Stack[Sp-1] = (Stack[Sp-1] != 0 && Stack[Sp] != 0)
			Sp--
		} else if ($i == "|") {
			Stack[Sp-1] = (Stack[Sp-1] != 0 || Stack[Sp] != 0)
			Sp--
		} else if ($i == "p") {	# top of stack
			print Stack[Sp]
		} else if ($i == "P") {	# all of stack
			printstack()
		} else if ($i == "h") {	# top of stack, in hex
			printf "%#x\n", Stack[Sp]
		} else if ($i == "d") {
			if (Sp != 1) {
				delete Stack[Sp]
				Sp--
			}
		} else if ($i == "D") {
			initstack()
		} else {
			gsub(/,/, "", $i)
			Stack[++Sp] = $i
		}
	}
}

# printstack --- print the stack

function printstack(	i, print_index)
{
	print_index = (Sp != 1)
	for (i = Sp; i > 0; i--) {
		if (print_index)
			printf("Stack[%d]: %g\n", i, Stack[i])
		else
			print Stack[i]
	}
}
