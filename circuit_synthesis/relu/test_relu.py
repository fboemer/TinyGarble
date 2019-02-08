#/usr/bin/python3

import os
import subprocess
import random


def int_to_hex(x, HEX_LEN):
    x_hex = hex(x)[2:]
    if (len(x_hex) > HEX_LEN):
        print(x, ' too large to hexify')
    else:
        x_hex = '0' * (HEX_LEN - len(x_hex)) + x_hex
        return x_hex


def test_relu():

    clock_cycles = 8
    N = 8  # bit-width of inputs
    HEX_LEN = int(N / 4)  # HEX width of input
    MAX_N_HALVES = 2**(N - 1)
    relu_scd = './relu.scd'
    scd_eval = '../../build/scd/SCD_Evaluator_Main'

    random.seed(1)

    for x in [0, 50, 100, 150, 200, 250]:
        for r1 in [0, 50, 100, 150, 200, 250]:
            if x - r1 < 0:
                continue

            r2 = int(random.random() * MAX_N_HALVES)

            e_in = x - r1
            e_hex_in = int_to_hex(e_in, HEX_LEN)

            r1_hex = int_to_hex(r1, HEX_LEN)
            r2_hex = int_to_hex(r2, HEX_LEN)

            g_hex_in = r1_hex + r2_hex

            print('g_hex_in', g_hex_in)

            cmd = ' '.join(
                map(str, [
                    scd_eval, '--scd_file', relu_scd, \
                        '--clock_cycles', clock_cycles, \
                        '--g_input', g_hex_in,
                        '--e_input', e_hex_in
                ]))

            print("Calling", cmd)

            result = subprocess.run([cmd], shell=True, stdout=subprocess.PIPE)
            output = result.stdout.decode('utf-8')
            print('result', output.strip())
            output = int('0x' + output, 16)

            exp_output = (x) % 2**N

            print('inputs:', g_hex_in, e_hex_in, 'expect:', exp_output,
                  'output:', output, '\n')

            assert (exp_output == output)


def main():
    test_relu()


main()
