#ifndef KEYINPUT_H
#define KEYINPUT_H

#include "header.h"

void key_action(int key);
void key_spaction(int key1, int key2);
void key_input(int *keys);
int* create_key(QString str);
int symbol_list(char sym);


#endif // KEYINPUT_H

