/// <summary>
/// PageExtension BankAccountsList_Ext (ID 50187) extends Record Bank Account List.
/// </summary>
pageextension 50210 BankAccountsList_Ext extends "Bank Account List"
{
    trigger OnOpenPage()
    var
        Account: Text[60];
        NegAccount: Text[60];
        EmptyAccount: Text[60];
        MyAccount: Text[60];
        ResultAccount: Text[60];
        ResultNegAccount: Text[60];
        ResultEmptyAccount: Text[60];
        ResultMyAccount: Text[60];
        Text000: Label 'Account No. 99 does not balance';
        Text001: Label 'Account No. 2342 shows a total of $-452';
        Text002: Label 'My bank account is empty';
        Text003: Label 'My bank account shows a total of $0';
        Text004: Label 'The text strings before INCSTR is called : \\%1\\%2\\%3\\%4';
        Text005: Label 'The text strings after INCSTR is called : \\%1\\%2\\%3\\%4';
    begin
        Account := Text000;
        NegAccount := Text001;
        EmptyAccount := Text002;
        MyAccount := Text003;
        Message(Text004, Account, NegAccount, EmptyAccount, MyAccount);
        ResultAccount := IncStr(Account);
        ResultNegAccount := IncStr(NegAccount);
        ResultEmptyAccount := IncStr(EmptyAccount);
        ResultMyAccount := IncStr(MyAccount);
        Message(Text005, ResultAccount, ResultNegAccount, ResultEmptyAccount, ResultMyAccount);


    end;
}
/*
Remark:

If String contains more than one number, then only the number closest to the end of the string is changed. 
For example, ‘A10B20’ is changed to ‘A10B21’ and ‘a12b12c’ to ‘a12b13c’.

If String contains a negative number, then it is decreased by one. For example, ‘-55’ is changed to ‘-56’.

Zero (0) is considered a positive number. Therefore, it is increased it by one. For example, ‘A0’ is changed to ‘A1’.

When String contains a number such as 99, it is increased to 100 and the length of the output string is: LEN(String) + 1. 
For example, ‘a12b99c’ is changed to ‘a12b100c’.

If String does not contain any number, the output string is an empty string. For example, ‘aaa’ is changed to ”.

INCSTR only increments integer numbers within strings, not decimals. For example, 
if you call INCSTR on the string a99.99b then the result is a99.100b.
*/