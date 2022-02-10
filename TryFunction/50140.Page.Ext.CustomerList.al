/// <summary>
/// PageExtension CustomerList_Ext (ID 50140) extends Record Customer List.
/// </summary>
pageextension 50140 CustomerList_Ext extends "Customer List"
{
    trigger OnOpenPage()
    var
    //CodeU: Codeunit TryFunction;
    begin
        if MyTryFunction() then
            Message('Flying colours')
        else
            Message('Bugger !');
        Message(GetLastErrorText()); // such function retuens the error handled in the try function

        /* Calling the function without a TryFunction label before its definition on line 19, would stop the
        execution after the function error message is processed , it could be a differnt processing
    MyTryFunction();
    Message('Flying colours')*/
    end;

    [TryFunction]
    local procedure MyTryFunction()
    begin
        Error('Aha ! I was expecting you Mister Anderson ! ');
    end;
}