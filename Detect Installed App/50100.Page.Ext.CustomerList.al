/// <summary>
/// PageExtension CustomerList_Ext (ID 50100) extends Record .
/// </summary>
pageextension 50124 CustomerList_Ext extends "Customer List"
{
    trigger OnOpenPage()
    var
        info: ModuleInfo;
        Installed: Label 'The extension is installed under the name of %1.';
        NotInstalled: Label 'The extension is not installed !';
    begin
        if NavApp.GetModuleInfo('3fe5fdf8-3e1b-4012-9a01-e3c651a09ab9', info) then
            Message(Installed, info.Name)
        else
            Message(NotInstalled);
    end;
}