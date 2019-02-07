#/usr/bin/python3

import os
import subprocess


def test_relu():

    clock_cycles = 8
    relu_scd = './relu.scd'
    scd_eval = '../../build/scd/SCD_Evaluator_Main'

    g_input = 1234
    e_input = 1010

    cmd = ' '.join(
        map(str, [
            scd_eval, '--scd_file', relu_scd, '--g_input', g_input,
            '--e_input', e_input, '--clock_cycles', clock_cycles
        ]))
    '''cmd = scd_eval + ' --scd_file ' + relu_scd \
                   + ' --g_input ' + g_input \
                  + ' --e_input ' + e_input \
                    + ' --c ' + clock_cycles'''

    print("Calling", cmd)

    result = subprocess.run([cmd], shell=True, stdout=subprocess.PIPE)

    output = int(result.stdout)

    assert (g_input + e_input == output)

    print('Test passed:', g_input, '+', e_input, '=', output)


def main():
    test_relu()


main()
