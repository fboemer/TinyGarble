#/usr/bin/python3

import os
import subprocess


def test_relu():

    clock_cycles = 8
    N = 8  # bit-width of inputs
    relu_scd = './relu.scd'
    scd_eval = '../../build/scd/SCD_Evaluator_Main'

    for g_input in [0, 50, 100, 150, 200, 250]:
        for e_input in [0, 50, 100, 150, 200, 250]:
            g_hex_in = hex(g_input)[2:]
            e_hex_in = hex(e_input)[2:]

            cmd = ' '.join(
                map(str, [
                    scd_eval, '--scd_file', relu_scd, \
                        '--clock_cycles', clock_cycles, \
                        '--g_input', g_hex_in,
                        '--e_input', e_hex_in
                ]))

            print("Calling", cmd)

            result = subprocess.run([cmd], shell=True, stdout=subprocess.PIPE)
            print('result', result)
            output = result.stdout.decode('utf-8')
            print('result', output.strip())
            output = int('0x' + output, 16)

            exp_output = (g_input + e_input) % 2**N
            #exp_output = 1 if (g_input + e_input) % 2**N > 2**(N - 1) else 0

            print('inputs:', g_input, e_input, 'expect:', exp_output,
                  'output:', output, '\n')

            assert (exp_output == output)


def main():
    test_relu()


main()
