/// <summary>
/// Page ISA_MyNotes (ID 50158).
/// </summary>
page 50158 ISA_MyNotes
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Record Link";
    InsertAllowed = false;
    ModifyAllowed = false;
    DelayedInsert = false;
    Caption = 'Notifications';

    layout
    {
        area(Content)
        {
            repeater(My_Notifications)
            {
                field(From; Rec."User ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'From';
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Created';

                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Note';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Caption = 'Description';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Details)
            {
                ApplicationArea = All;
                Image = ViewDetails;
                Caption = 'Details';

                trigger OnAction()
                begin
                    RecordR := Rec."Record ID".GetRecord();
                    VarRecR := RecordR;
                    Page.Run(0, VarRecR);
                end;
            }
        }
    }

    var
        RecordR: RecordRef;
        VarRecR: Variant;
        Count: Integer;
        Notes: Text;
        RecordL: Record "Record Link";
        NoteText: BigText;
        Stream: InStream;
        User: Record User;
        Str: Text;
        Pos: Integer;
        FinalString: Text;
        Pos1: Integer;
        RecID: RecordId;
        FieldR: FieldRef;

    trigger OnOpenPage()
    begin
        Rec.SetRange("To User ID", Rec."User ID");
        Rec.SetRange(Notify, true);
        Rec.SetRange(Company, CompanyName);
    end;

    trigger OnAfterGetRecord()
    begin
        RecordL.Reset();
        RecordL.SetRange("Link ID", Rec."Link ID");
        RecordL.SetRange(Notify, true);
        if RecordL.FindFirst() then begin
            RecordL.CalcFields(Note);
            if RecordL.Note.HasValue then begin
                Clear(NoteText);
                RecordL.Note.CreateInStream(Stream);
                NoteText.Read(Stream);
                Notes := DelStr(Format(NoteText), 1, 1);
            end;
        end;
    end;
}