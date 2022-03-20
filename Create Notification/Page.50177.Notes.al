/// <summary>
/// Page Notes (ID 50177).
/// </summary>
page 50177 Notes
{
    PageType = ListPart;
    SourceTable = "Record Link";

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    Caption = 'Notifications';

    layout
    {
        area(Content)
        {
            repeater(Notifications)
            {
                field(From; Rec."User ID")
                {
                    ApplicationArea = All;
                    Caption = 'From';
                    Editable = false;

                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    Caption = 'Created';
                }
                field(Note; Rec.Note)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Page';
                    Editable = false;
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
                Image = ViewDocumentLine;

                trigger OnAction()
                begin
                    RecordR := Rec."Record ID".GetRecord();
                    VarRecR := RecordR;
                    Page.Run(0, VarRecR);
                end;
            }
        }


    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("To User ID", Rec."User ID");
        Rec.SetRange(Notify, true);
        Rec.SetRange(Company, CompanyName);
    end;

    trigger OnAfterGetCurrRecord()
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
Notes := DelStr(Format(NoteText),1,1);
            end;
        end;
    end;

    var
        CountAlpha: Integer;
        Notes: Text;
        RecordL: Record "Record Link";
        NoteText: BigText;
        Stream: InStream;
        User: Record User;
        Str: Text;
        POS: Integer;
        FinalString: Text;
        PosAlpha: Integer;
        RecID: RecordId;
        RecordR: RecordRef;
        VarRecR: Variant;
        FieldR: FieldRef;
}