#include <stdio.h>
#include <stdint.h>

#define MOD 1000000007

static inline int my_clz(uint32_t x)
{
    if (x == 0)
        return 32; // If the number is 0, return 32 (all bits are zero)

    int n = 0; // Counter for the number of leading zeros

    // Calculate the number of leading zeros through bit shifting
    if (x <= 0x0000FFFF)
    {
        n += 16;
        x <<= 16;
    } // If the top 16 bits are 0, shift 16 bits
    if (x <= 0x00FFFFFF)
    {
        n += 8;
        x <<= 8;
    } // If the top 8 bits are 0, shift 8 bits
    if (x <= 0x0FFFFFFF)
    {
        n += 4;
        x <<= 4;
    } // If the top 4 bits are 0, shift 4 bits
    if (x <= 0x3FFFFFFF)
    {
        n += 2;
        x <<= 2;
    } // If the top 2 bits are 0, shift 2 bits
    if (x <= 0x7FFFFFFF)
    {
        n += 1;
    } // If the highest bit is 0, add 1

    return n; // Return the number of leading zeros
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
