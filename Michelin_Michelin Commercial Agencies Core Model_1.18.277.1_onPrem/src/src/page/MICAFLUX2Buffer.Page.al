page 80660 "MICA FLUX2 Buffer"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "MICA FLUX2 Buffer2";
    SourceTableTemporary = true;
    Caption = 'FLUX2 Buffer';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Consolidation Date"; Rec."Consolidation Date")
                {
                    ApplicationArea = All;
                    editable = false;
                }
                field("Company Code"; Rec."Company Code")
                {
                    ApplicationArea = All;
                    editable = false;
                }
                field("G/L Account"; Rec."G/L Account")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Group Account No."; Rec."Group Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Interco; Rec.Interco)
                {
                    ApplicationArea = All;
                    editable = false;
                }

                field(Section; Rec.Section)
                {
                    ApplicationArea = All;
                    editable = false;
                }
                field(Structure; Rec.Structure)
                {
                    ApplicationArea = All;
                    editable = false;
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                    ApplicationArea = All;
                    editable = false;
                }
                field("Invoice Currency"; Rec."Invoice Currency")
                {
                    ApplicationArea = All;
                    editable = false;
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                    ApplicationArea = All;
                    editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Export FLUX 2")
            {
                ApplicationArea = All;
                Caption = 'Export FLUX 2';
                image = ExportFile;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ExportFlux2: XmlPort "MICA Reporting FLUX2";
                begin
                    ExportFlux2.Run();
                end;
            }

            action("Generate Buffer")
            {
                ApplicationArea = All;
                Caption = 'Generate Buffer';
                Image = GetEntries;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RepGenerateFLUX2Buffer: report "MICA Generate FLUX2 Buffer";
                begin
                    RepGenerateFLUX2Buffer.RunModal();
                    GenerateData();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        GenerateData();
    end;

    local procedure GenerateData()
    var
        Flux2Buffer: Record "MICA FLUX2 Buffer2";
    begin
        if Flux2Buffer.FindSet(false, false) then
            repeat
                Rec.SetRange("Group Account No.", Flux2Buffer."Group Account No.");
                Rec.SetRange(Interco, Flux2Buffer.Interco);
                Rec.SetRange(Section, Flux2Buffer.Section);
                Rec.SetRange(Structure, Flux2Buffer.Structure);
                Rec.SetRange("Invoice Currency", Flux2Buffer."Invoice Currency");
                Rec.SetRange("Group Account No.", Flux2Buffer."Group Account No.");
                if Rec.FindFirst() then begin
                    Rec."Amount LCY" += Flux2Buffer."Amount LCY";
                    Rec."Invoice Amount" += Flux2Buffer."Invoice Amount";
                end else begin
                    Rec.Init();
                    Rec.Copy(Flux2Buffer);
                    Rec.Insert();
                end;
            until Flux2Buffer.Next() = 0;
    end;
}