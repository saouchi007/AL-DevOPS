page 80861 "MICA Flow EndPoint List"
{

    PageType = List;
    SourceTable = "MICA Flow EndPoint";
    Caption = 'Interface EndPoints';
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Partner Code"; Rec."Partner Code")
                {
                    ApplicationArea = All;
                }
                field("EndPoint Type"; Rec."EndPoint Type")
                {
                    ApplicationArea = All;
                }
                field("Blob Storage"; Rec."Blob Storage")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 1;
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    begin
                        message(SubstituteMsgLbl,
                            Rec.FieldCaption("Blob Storage"),
                            Rec.SubstituteParameters(Rec."Blob Storage"))
                    end;
                }
                field("Blob SSAS Signature"; Rec."Blob SSAS Signature")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 1;
                }
                field("MQ URL"; Rec."MQ URL")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 2;
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    begin
                        message(SubstituteMsgLbl,
                            Rec.FieldCaption("MQ URL"),
                            Rec.SubstituteParameters(Rec."MQ URL"))
                    end;

                }
                field("MQ Login"; Rec."MQ Login")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 2;
                }
                field("MQ Password"; Rec."MQ Password")
                {
                    ApplicationArea = All;
                    Editable = Rec."EndPoint Type" = 2;
                }
                field("Use Certificate"; Rec."Use Certificate")
                {
                    ApplicationArea = All;
                }
                field("Certificate String (base64)"; Rec."Certificate String (base64)")
                {
                    ApplicationArea = All;
                    Editable = Rec."Use Certificate";
                }
                field("Certificate Password"; Rec."Certificate Password")
                {
                    ApplicationArea = All;
                    Editable = Rec."Use Certificate";
                }
                field("Flow Count"; Rec."Flow Count")
                {
                    ApplicationArea = All;
                }
                field("Count of Entry"; Rec."Count of Entry")
                {
                    ApplicationArea = All;
                }
                field("Count of Archived File"; Rec."Count of Archived File")
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date Time"; Rec."Last Modified Date Time")
                {
                    ApplicationArea = All;
                }
                field("Last Modified User ID"; Rec."Last Modified User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        SubstituteMsgLbl: Label '%1 with substitute parameters is :\%2';

}

