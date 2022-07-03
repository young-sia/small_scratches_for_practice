# This is a sheet of many kinds of fibonacci series
import numpy as np


# ver1. using recursive function
def fibonacci_ver1(n):
    if n == 1 or n == 2:
        return 1
    else:
        return fibonacci_ver1(n - 1) + fibonacci_ver1(n - 2)


# ver2. using for statement
def fibonacci_ver2(n):
    fibo_list_ver2 = [0] * 21
    fibo_list_ver2[1] = 1
    fibo_list_ver2[2] = 1
    for i in range(3, n + 1):
        fibo_list_ver2[i] = fibo_list_ver2[i - 1] + fibo_list_ver2[i - 2]
    return fibo_list_ver2


# ver3. using generator
def fibonacci_ver3(n):
    variable1, variable2 = 0, 1
    i = 0
    fibo_list_ver3 = [0]
    while i < n:
        variable1, variable2 = variable2, variable1 + variable2
        fibo_list_ver3 += [variable1]
        i += 1
    return fibo_list_ver3


# ver4. memoization method
def fibonacci_ver4(n):
    fibo_list_ver4 = [0, 1]
    if n == 1:
        return 0
    elif n == 2:
        return 1
    else:
        for temp_ver4 in range(2, n + 1):
            fibo_list_ver4 += [fibo_list_ver4[temp_ver4 - 1] + fibo_list_ver4[temp_ver4 - 2]]
    return fibo_list_ver4


# ver.5 using matrix operational method
def fibonacci_ver5(n):
    fibo_list_ver5 = list()
    fibo_matrix = np.matrix([[1, 1], [1, 0]])
    for temp in range(1, n + 1):
        fibo_list_ver5 += [(fibo_matrix ** temp)[0, 1]]
    return fibo_list_ver5


# ver else . using lambda - but need to think more, only works on console
# fibonacci_ver6 = lambda count_ver6: 1 if count_ver6 <= 2
# else fibonacci_ver6(count_ver6-1) + fibonacci_ver6(count_ver6 - 2)
# def fibonacci_ver6(n):
#     fibo_list_ver6 = list()
#     for temp in range(1, n+1):
#         fibo_temp_ver6 = lambda count_ver6: 1 if count_ver6 <= 2 \
#             else fibonacci_ver6(count_ver6-1) + fibonacci_ver6(count_ver6 - 2)
#         fibo_list_ver6[temp] += fibo_temp_ver6(temp)


def main():
    fibo_list_ver1 = [0] * 21
    for temp_ver1 in range(1, 21):
        fibo_list_ver1[temp_ver1] = fibonacci_ver1(temp_ver1)
    fibo_list_ver2 = fibonacci_ver2(20)
    fibo_list_ver3 = fibonacci_ver3(20)
    fibo_list_ver4 = fibonacci_ver4(20)
    fibo_list_ver5 = fibonacci_ver5(20)
    fibo_list_ver6 = fibonacci_ver6(20)
    print('Fibonacci Series')
    print(f'20th number of ver1: {fibo_list_ver1[20]}')
    print(f'ver1 of fibonacci series is {fibo_list_ver1}')
    print(f'20th number of ver2: {fibo_list_ver2[20]}')
    print(f'ver2 of fibonacci series is {fibo_list_ver2}')
    print(f'20th number of ver3: {fibo_list_ver3[20]}')
    print(f'ver3 of fibonacci series is {fibo_list_ver3}')
    print(f'20th number of ver4: {fibo_list_ver4[20]}')
    print(f'ver4 of fibonacci series is {fibo_list_ver4}')
    print(f'20th number of ver5: {fibo_list_ver5[19]}')
    print(f'ver5 of fibonacci series is {fibo_list_ver5}')
    print(f'20th number of ver6: {fibo_list_ver6[19]}')
    print(f'ver6 of fibonacci series is {fibo_list_ver6}')


if __name__ == '__main__':
    main()
