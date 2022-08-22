/// <summary>
/// PageExtension ISA_CustomerCard (ID 50304) extends Record Customer List.
/// </summary>
pageextension 50304 ISA_CustomerCard extends "Customer List"
{

    trigger OnOpenPage()
    begin
        ISA_SayHi('Hi', 'Saouchi');
    end;

    local procedure ISA_SayHi(Greeting: Text; Name: Text): Text
    begin
        exit(Greeting + ' ' + Name);
    end;

    local procedure ISA_SayHi(Greeting: Text): Text
    begin
        exit(Greeting);
    end;
}