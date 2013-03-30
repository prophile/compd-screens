from __future__ import print_function

import sys
import string

blank_line = False
in_codeblock = False

for line in sys.stdin:
    if line[-1] == '\n':
        line = line[:-1]
    if not line:
        print('')
        blank_line = True
    else:
        if blank_line and not in_codeblock and line[0] in string.whitespace:
            in_codeblock = True
            print('~~~~coffeescript')
            print('')
        elif in_codeblock and line[0] not in string.whitespace:
            if not blank_line:
                print('')
            print('~~~~')
            print('')
            in_codeblock = False
        print(line)
        blank_line = False

if in_codeblock:
    if not blank_line:
        print('')
    print('~~~~')

