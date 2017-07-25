/****************************************************************************
*                                                                           *
*              Copyright (C),  Philips Semiconductors BU ID                 *
*                                                                           *
*  All rights are reserved. Reproduction in whole or in part is prohibited  *
*           without the written consent of the copyright owner.             *
*                                                                           *
*  Philips reserves the right to make changes without notice at any time.   *
* Philips makes no warranty, expressed, implied or statutory, including but *
* not limited to any implied warranty of merchantibility or fitness for any *
*   particular purpose, or that the use will not infringe any third party   *
* patent, copyright or trademark. Philips must not be liable for any loss or*
*                      damage arising from its use.                         *
*                                                                           *
*****************************************************************************
*                                                                           *
*       File: HT2CRYPT.C                                                    *
*       Author:  F. Boeh, J. Nowottnick                                     *
*                                                                           *
*****************************************************************************
*      DATE      *          CHANGES DONE                       *    BY      *
*****************************************************************************
*                *                                             *            *
*  Mar 9, 1998   * Start implementation                        * Boeh       *
*  Mar 18, 1998  * First release                               * Boeh       *
*  June 12, 2001 * Remote mode description added               * Nowottnick *
*  June 13, 2001 * Automatic target detection                  * Boeh       *
****************************************************************************/

//#include "global.h"

#include "Ht2crypt_btk.h"


/****************************************************************************
* Table which contains the EXOR value of a 4 bit input.                     *
****************************************************************************/
const u8 exor_table[16]=
{
    0, 1, 1, 0, 1, 0, 0, 1,
    1, 0, 0, 1, 0, 1, 1, 0
};



/****************************************************************************
* Non-linear functions F0, F1 and F2.                                       *
*                                                                           *
* The logic "one" entries of F0 and F1 have multiple bits set which         *
* makes it unnecessary to shift the values when combining the results       *
* to the input vector for F2.                                               *
* (Only bit masking necessary, see function_bit(). )                        *
****************************************************************************/
#define A (1+16)
#define B (2+4+8)

const u8 F0_table[16] =
{
    A, 0, 0, A, A, A, A, 0, 0, 0, A, A, 0, A, 0, 0
};

const u8 F1_table[16] =
{
    B, 0, 0, 0, B, B, B, 0, 0, B, B, 0, 0, B, B, 0
};

const u8 F2_table[32] =
{
    1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0,
    1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0
};

#undef A
#undef B



/****************************************************************************
* Main parameters for HITAG2 cryptographic algorithm.                       *
****************************************************************************/
u8 sr_ident[4]= {0,0,0,0};      //Transponder identifier
const u8 sr_Base_Password[2]=   {0x55, 0x66};
const u8 sr_Immo_BasePassword[4] = {0xff,0xff,0xff,0xff};	//Immo ģʽ�µĻ�վ����
const u8 sr_Trans_Password[2] = {0x44,0x44};
u8 sr_t[2];  /* The 48 bit ...     */
u8 sr_s[4];  /* ... shift register */




u8 sr_function_bit(void)
/****************************************************************************
*                                                                           *
* Description:                                                              *
*   Computes the result of the non-linear function F2= f(t,s) for both      *
*   oneway functions 1 and 2.                                               *
*                                                                           *
* Parameters: none                                                          *
*                                                                           *
* Return: Result of F2, either 0 or 1.                                      *
*                                                                           *
****************************************************************************/
{
    u8 F01_index;  /* Index to tables F0 and F1 */
    u8 F2_index;   /* Index to table F2 */

    F01_index  = GETBIT( sr_t[0], 1 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_t[0], 2 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_t[0], 4 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_t[0], 5 );
    F2_index  = (u8)(F0_table[ F01_index ] & (u8)0x01);

    F01_index  = GETBIT( sr_t[1], 0 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_t[1], 1 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_t[1], 3 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_t[1], 7 );
    F2_index |= (u8)(F1_table[ F01_index ] & (u8)0x02);

    F01_index  = GETBIT( sr_s[1], 5 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[0], 0 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[0], 2 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[0], 6 );
    F2_index |= (u8)(F1_table[ F01_index ] & (u8)0x04);

    F01_index  = GETBIT( sr_s[2], 6 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[1], 0 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[1], 2 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[1], 3 );
    F2_index |= (u8)(F1_table[ F01_index ] & (u8)0x08);

    F01_index  = GETBIT( sr_s[3], 1 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[3], 3 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[3], 4 );
    F01_index <<= 1;
    F01_index |= GETBIT( sr_s[2], 5 );
    F2_index |= (u8)(F0_table[ F01_index ] & (u8)0x10);

    return F2_table[ F2_index ];
}




void sr_shift_reg( u8 shift_bit )
/****************************************************************************
*                                                                           *
* Description:                                                              *
*   Performs the shift operation of t,s. Both registers are shifted left    *
*   by one bit (with carry propagation from s to t), the feedback given by  *
*   "shift_bit" is inserted into s.                                         *
*                                                                           *
* Parameters:                                                               *
*   shift_bit: Bit to be shifted into the register, must be 0 or 1.         *
*                                                                           *
* Return: none                                                              *
*                                                                           *
****************************************************************************/
{
    sr_t[0] <<= 1;
    sr_t[0] |= GETBIT( sr_t[1], 7 );

    sr_t[1] <<= 1;
    sr_t[1] |= GETBIT( sr_s[0], 7 );

    sr_s[0] <<= 1;
    sr_s[0] |= GETBIT( sr_s[1], 7 );

    sr_s[1] <<= 1;
    sr_s[1] |= GETBIT( sr_s[2], 7 );

    sr_s[2] <<= 1;
    sr_s[2] |= GETBIT( sr_s[3], 7 );

    sr_s[3] <<= 1;
    sr_s[3] |= shift_bit;
}



u8 sr_feed_back(void)
/****************************************************************************
*                                                                           *
* Description:                                                              *
*   Calculates the feedback for oneway function 2 by EXORing the specified  *
*   bits from the shift register t,s.                                       *
*                                                                           *
* Parameters: none                                                          *
*                                                                           *
* Return: Result of feedback calculation, either 0 or 1.                    *
*                                                                           *
****************************************************************************/
{
    u8 sum;

    /* Fetch the relevant bits from shift register, perform first EXOR: */
    sum = (u8)((sr_t[0] & (u8)0xB3) ^ (sr_t[1] & (u8)0x80) ^
          (sr_s[0] & (u8)0x83) ^ (sr_s[1] & (u8)0x22) ^
          (sr_s[3] & (u8)0x73));

    /* EXOR all 8 bits of "sum" and return the result: */
    return (u8)(exor_table[ sum % 16 ] ^ exor_table[ sum / 16 ]);
}


/****************************************************************************
*                                                                           *
* Description:                                                              *
*   Performs the initialization phase of the HITAG2/HITAG2+ cryptographic   *
*   algorithm. This function can be used to implement the cryptographic     *
*   protocol in transponder mode (HITAG2/HITAG2+) and remote mode (HITAG2+) *
*   Depending on the mode of operation, the initialization is done with     *
*   different input parameters.                                             *
*                                                                           *
*   a) Transponder Mode:                                                    *
*   The feedback registers are loaded with identifier and immobilizer       *
*   secret key, and oneway function 1 is executed 32 times thereafter.      *
*   The global variables ident and secretkey are used for identifier,       *
*   immobilizer secret key, the random number is given as an input          *
*   to the function.                                                        *
*                                                                           *
*   b) Remote Mode:                                                         *
*   The feedback registers are loaded with identifier and remote            *
*   secret key, and oneway function 1 is executed 32 times thereafter.      *
*   The global variables HT2ident and HT2secretkey are used for identifier, *
*   remote secret key. The sequence increment (28bit) and the command ID    *
*   (4bit) are given together as 32bit input data block to the function.    *
*                                                                           *
*   The function outputs the initialized global shift registers t,s.        *
*                                                                           *
* Parameters:                                                               *
*   addr_rand: Pointer to a memory area of 4 u8s that contains the*
*              random number (transponder mode)                             *
*              or sequence increment + command ID (remote mode)             *
*              to be used for the initialization.                           *
*                                                                           *
* ˵��:
*       Oneway1�൱��PCF7952�����㷨�е�:��ID�ӵ��㷨�Ĵ���,�Ѹ���λ�������*
        �㷨�Ĵ���,��RAM�͵���λ����(EEPROM��)�����㷨�Ĵ���.
* Return: none                                                              *
*                                                                           *
****************************************************************************/
void sr_Oneway1_ext(u8 * addr_rand,u8 *screct)
{
    u8 bit_mask;  /* Used to fetch single bits of random/sec_key.*/
    u8 byte_cnt;  /* u8 counter for random/secret key.         */
    u8 fb;        /* Feedback bit for oneway function 1.         */

    /* Initialise oneway function 1 with identifier and parts of secret key */
    sr_t[0]=addr_rand [0];
    sr_t[1]=addr_rand [1];
    sr_s[0]=addr_rand [2];
    sr_s[1]=0;
    sr_s[2]=screct[4];
    sr_s[3]=screct[5];


    /* Perform 32 times oneway function 1 (nonlinear feedback) */
    byte_cnt = 0;
    bit_mask = 0x80; /* Setup bit mask: MSB of first u8 */
    do
    {
        
//        printf("-----byte_cnt---------bit_mask---------\n");
//        printf("-----%d---------%d---------\n", byte_cnt, bit_mask);
//        for (int i=0; i < 8; i++)
//        {
//            printf("%02x", *(addr_rand + i));
//        }
//        printf("\n");
//        for (int i=0; i < 6; i++)
//        {
//            printf("%02x", *(screct + i));
//        }
//        printf("\n");
//        printf("-----------------------\n");
        
        /* One round of oneway function 1: */
        fb = (u8)(sr_function_bit()
             ^ TEST( (screct[byte_cnt] ^ addr_rand[byte_cnt]) & bit_mask ));
        sr_shift_reg( fb );

        /* Advance to next bit of random number / secret key: */
        bit_mask>>=1;
        if ( bit_mask == 0 )
        {
            bit_mask=0x80;
            byte_cnt++;
        }
    }
    while (byte_cnt < 4);
}

void sr_Oneway2( u8  * addr, u8 length )
/****************************************************************************
*                                                                           *
* Description:                                                              *
*   Performs the encryption respective decryption of a given data block     *
*   by repeatedly executing oneway function 2 and Exclusive-Oring with the  *
*   generated cipher bits. The computation is repeated for the number       *
*   of bits as specified by "length". The global shift register contents    *
*   after the initialization by Oneway1(), or the current contents after    *
*   the last call of Oneway2() is used as start condition.                  *
*                                                                           *
* Parameters:                                                               *
*   addr:   Pointer to a memory area that contains the data to be           *
*           encrypted or decrypted.                                         *
*   length: Number of bits to encrypt / decrypt
* ˵��:
*       Oneway2�൱��PCF7952�����㷨�е�CALL r_crypto_get                   *
*                                                                           *
* Return: none                                                              *
*                                                                           *
****************************************************************************/
{
    u8 bit_mask; /* Mask for current bit of data block. */
    u8 bitval;

    bit_mask = 0x80; /* Setup bit mask: MSB of first u8 */
    do
    {
        
//        printf("-----length---------bit_mask---------\n");
//        printf("-----%d---------%d---------\n", length, bit_mask);
//        for (int i=0; i < 4; i++)
//        {
//            printf("%02x", *(addr + i));
//        }
//        printf("-----------------------\n");

        /* Calculate cipher bit and perform EXOR on data bit: */
        /* NOTE: Timing invariant implementation (uses multiplication). */
        /* NOTE: Possible performance degradation on other machines.    */
        bitval = (u8)((sr_function_bit() ^ TEST( *addr & bit_mask )) * bit_mask);
        *addr = (u8)((*addr & (u8)~bit_mask) | bitval);

        sr_shift_reg( sr_feed_back() );

        bit_mask>>=1;
        if ( bit_mask == 0 )
        {
            bit_mask=0x80;
            addr++;
        }

        length--;
    }
    while ( length );
}
