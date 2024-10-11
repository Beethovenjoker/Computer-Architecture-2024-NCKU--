#include <stdio.h>
#include <stdint.h>

#define MOD 1000000007

// Function for calculating leading zeros
static inline int my_clz(uint32_t x)
{
    int count = 0;
    for (int i = 31; i >= 0; --i)
    {
        if (x & (1U << i))
            break;
        count++;
    }
    return count;
}

// Concatenate binary representations from 1 to n
int concatenatedBinary(int n)
{
    long result = 0;

    for (int i = 1; i <= n; ++i)
    {
        // Calculate the bit length of the number = 32 - leading zeros
        int length = 32 - my_clz(i);
        // Left shift by length bits and add i to result
        result = ((result << length) | i) % MOD;
    }

    return (int)result;
}
