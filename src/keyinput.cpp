#include "keyinput.h"


void key_action(int key){
    keybd_event(key , 0, 0, 0);
    Sleep(10);
    keybd_event(key , 0, KEYEVENTF_KEYUP, 0);
    Sleep(10);
}

void key_spaction(int key1, int key2){
    keybd_event(key1 , 0, 0, 0);
    keybd_event(key2 , 0, 0, 0);
    Sleep(20);
    keybd_event(key1, 0, KEYEVENTF_KEYUP, 0);
    keybd_event(key2, 0, KEYEVENTF_KEYUP, 0);
    Sleep(20);
}

void key_input(int* keys){
    int key = *keys;
    while(key > 0)
    {
        if(key > UPPER){
            key_spaction(VK_SHIFT, key - UPPER);
        }
        else{
            key_action(key);
        }
        key = *(++keys);
    }
}

int* create_key(QString str){
    int keys[200];
    int i;
    qDebug() << str;
    for(i = 0; i < str.length(); i++){
        if(str[i].isNumber())
            keys[i] = str[i].toLatin1() ;
        else if(str[i].isLower())
            keys[i] = (str[i].toUpper()).toLatin1();
        else if(str[i].isUpper())
            keys[i] = str[i].toLatin1() + UPPER;
        else
            keys[i]  = symbol_list(str[i].toLatin1());
        qDebug() << "key: " << keys[i];
    }
    keys[i] = -1;
    return &keys[0];
}

int symbol_list(char sym){
    switch(sym){
        case ';':
            return VK_OEM_1;
        case ':':
            return VK_OEM_1 + UPPER;
        case '=':
            return VK_OEM_PLUS;
        case '+':
            return VK_OEM_PLUS + UPPER;
        case '-':
            return VK_OEM_MINUS;
        case '_':
            return VK_OEM_MINUS + UPPER;
        case ',':
            return VK_OEM_COMMA;
        case '<':
            return VK_OEM_COMMA + UPPER;
        case '.':
            return VK_OEM_PERIOD;
        case '>':
            return VK_OEM_PERIOD + UPPER;
        case '/':
            return VK_OEM_2;
        case '?':
            return VK_OEM_2 + UPPER;
        case '`':
            return VK_OEM_3;
        case '~':
            return VK_OEM_3 + UPPER;
        case '[':
            return VK_OEM_4;
        case '{':
            return VK_OEM_4 + UPPER;
        case '\\':
            return VK_OEM_5;
        case '|':
            return VK_OEM_5 + UPPER;
        case ']':
            return VK_OEM_6;
        case '}':
            return VK_OEM_6 + UPPER;
        case '\'':
            return VK_OEM_7;
        case '"':
            return VK_OEM_7 + UPPER;
        case '!':
            return '1' + UPPER;
        case '@':
            return '2' + UPPER;
        case '#':
            return '3' + UPPER;
        case '$':
            return '4' + UPPER;
        case '%':
            return '5' + UPPER;
        case '^':
            return '6' + UPPER;
        case '&':
            return '7' + UPPER;
        case '*':
            return '8' + UPPER;
        case '(':
            return '9' + UPPER;
        case ')':
            return '0' + UPPER;
        default:
            return '-1';
    }
}



