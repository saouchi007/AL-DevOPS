pageextension 80100 "MICA Contact List" extends "Contact List"
{
    layout
    {

    }

    actions
    {
        addbefore("Relate&d Contacts")
        {
            action("MICA CustomerRequestList")
            {
                ApplicationArea = All;
                Caption = 'Customer Request';
                Image = CustomerRating;
                trigger OnAction()
                var
                    InteractLogEntry: Record "Interaction Log Entry";
                    Cont: Record Contact;
                begin
                    if Rec."Type" = Rec."Type"::Person then
                        InteractLogEntry.SetRange("Contact No.", Rec."No.")
                    else
                        if Rec."Type" = Rec."Type"::Company then begin
                            Cont.SetRange("Company No.", Rec."No.");
                            if Cont.FindSet() then
                                repeat
                                    InteractLogEntry.SetRange("Contact No.", Cont."No.");
                                    if InteractLogEntry.FindSet() then
                                        repeat
                                            InteractLogEntry.Mark(true);
                                        until InteractLogEntry.Next() = 0;
                                until Cont.Next() = 0;
                            InteractLogEntry.SetRange("Contact No.");
                            InteractLogEntry.MarkedOnly(true);

                        end;
                    Page.RunModal(Page::"MICA Customer Request List", InteractLogEntry);
                end;
            }
        }

        addafter("Create &Interaction")
        {
            action("MICA CreateCustomerRequest")
            {
                Caption = 'Create Customer Request';
                Image = CreateInteraction;
                ApplicationArea = All;
                trigger OnAction()
                var
                    InteractionLogEntry: Record "Interaction Log Entry";
                    MICACustRqst: Codeunit "MICA Customer Request";
                    NewCustomerRequest: Page "MICA New Customer Request";
                begin
                    MICACustRqst.CreateInteractionLogEntry(Rec, InteractionLogEntry);
                    InteractionLogEntry.SETRANGE("Entry No.", InteractionLogEntry."Entry No.");
                    NewCustomerRequest.SETTABLEVIEW(InteractionLogEntry);
                    NewCustomerRequest.Run();
                end;
            }
        }

        modify("Create &Interaction")
        {
            Visible = false;
        }

        modify("Interaction Log E&ntries")
        {
            Visible = false;
        }
    }
}