/// <summary>
/// PageExtension ISA_CustomerList_Ext (ID 50301) extends Record Customer List.
/// </summary>
pageextension 50301 ISA_CustomerList_Ext extends "Customer List"
{

    //------------------- Modifying records -------------------------
    local procedure ISA_ModifyCustByValue(Cust: Record Customer)
    begin
        Cust.Name := 'This name has been changed by value';
    end;

    local procedure ISA_ModifyCustByReference(var Cust: Record Customer)
    begin
        Cust.Name := 'This name has been changed by reference';
    end;

    local procedure ISA_ModifyCustName()
    var
        pCust: Record Customer;
    begin
        pCust.FindLast();

        ISA_ModifyCustByValue(pCust);
        Message('%1', pCust.Name);

        ISA_ModifyCustByReference(pCust);
        Message('%1', pCust.Name);
    end;

    //-----------------------------------------------------------------
    //------------------- Modifying lists -------------------------
    local procedure ISA_ModifyListByValue(List1: List of [Text[20]])
    begin
        List1.Set(1, 'By value');
    end;

    local procedure ISA_ModifyListByReference(var List2: List of [Text[20]])
    begin
        List2.Set(1, 'By reference');
    end;

    local procedure ISA_ModifyList()
    var
        pList: List of [Text[20]];
    begin
        pList.Add('Customer Name');
        Message(pList.Get(1));
        ISA_ModifyListByValue(pList);
        Message(pList.Get(1));
        ISA_ModifyListByReference(pList);
        Message(pList.Get(1));
    end;

    trigger OnOpenPage()
    begin
        //    ISA_ModifyCustName();
        ISA_ModifyList();
    end;
}