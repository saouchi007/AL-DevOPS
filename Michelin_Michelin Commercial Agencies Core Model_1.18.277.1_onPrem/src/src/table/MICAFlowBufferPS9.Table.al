table 82080 "MICA Flow Buffer PS9"
{
    DataClassification = ToBeClassified;
    Caption = 'Flow Buffer PS9';
    DrillDownPageId = "MICA Flow Buffer PS9 Card";
    LookupPageId = "MICA Flow Buffer PS9 Card";

    fields
    {
        field(1; "Flow Code"; Code[20])
        {
            Caption = 'Flow Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow".Code;
        }
        field(2; "Flow Entry No."; Integer)
        {
            Caption = 'Flow Entry No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Flow Entry"."Entry No.";

            trigger OnValidate()
            var
                FlowEntry: Record "MICA Flow Entry";
            begin
                if FlowEntry.Get("Flow Entry No.") then
                    Validate("Flow Code", FlowEntry."Flow Code");
            end;

        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(10; "Date Time Creation"; DateTime)
        {
            Caption = 'Date Time Creation';
            DataClassification = CustomerContent;
        }
        field(12; "Date Time Last Modified"; DateTime)
        {
            Caption = 'Date time Last Modified';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(20; "Info Count"; Integer)
        {
            Caption = 'Info Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Information), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(21; "Warning Count"; Integer)
        {
            Caption = 'Warning Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Info Type" = const(Warning), "Flow Buffer Entry No." = field("Entry No.")));
        }
        field(22; "Error Count"; Integer)
        {
            Caption = 'Error Count';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("MICA Flow Information" where("Flow Entry No." = field("Flow Entry No."), "Flow Buffer Entry No." = field("Entry No."), "Info Type" = const(Error)));
        }
        field(30; "Skip Line"; Boolean)
        {
            Caption = 'Skip Line';
            DataClassification = CustomerContent;
        }
        field(40; "Linked Record ID"; RecordID)
        {
            Caption = 'Linked Record ID';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Linked Record", CopyStr(Format(RecordID()), 1, 250));
            end;
        }

        field(41; "Linked Record"; Text[250])
        {
            Caption = 'Linked Record';
            DataClassification = CustomerContent;
        }


        field(1000; "PS9 Execution DateTime"; DateTime)
        {
            Caption = 'PS9 Execution Date Time';
            DataClassification = CustomerContent;
        }

        field(100; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(101; "No. 2"; Code[20])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
        }
        field(102; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(103; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = CustomerContent;
        }
        field(104; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = CustomerContent;
        }
        field(105; "MICA Market Code"; Code[2])
        {
            Caption = 'Market Code';
            DataClassification = CustomerContent;
        }
        field(106; "MICA Sensitive Product"; Boolean)
        {
            Caption = 'Sensitive Product';
            DataClassification = CustomerContent;
        }
        field(107; "MICA Item Status"; Boolean)
        {
            Caption = 'Item status';
            DataClassification = CustomerContent;
        }
        field(108; "MICA Item Master Type Code"; Code[20])
        {
            Caption = 'Item Master Type Code';
            DataClassification = CustomerContent;
        }
        field(109; "MICA Brand"; Code[10])
        {
            Caption = 'Brand';
            DataClassification = CustomerContent;

        }
        field(110; "MICA Brand Grouping"; Code[20])
        {
            Caption = 'Brand Grouping';
            FieldClass = FlowField;
            CalcFormula = lookup("MICA Table Value"."Item Brand Grouping Code" where("Table Type" = const(ItemBrand), Code = field("MICA Brand")));
        }
        field(111; "MICA Product Segment"; Code[20])
        {
            Caption = 'Product Segment';
            DataClassification = CustomerContent;

        }
        field(112; "MICA Item Class"; Code[30])
        {
            Caption = 'Item Class';
            DataClassification = CustomerContent;
        }
        field(113; "MICA Long Description"; Text[100])
        {
            Caption = 'Long Description';
            DataClassification = CustomerContent;
        }

        field(114; "MICA Short Description"; Text[100])
        {
            Caption = 'Short Description';
            DataClassification = CustomerContent;
        }
        field(115; "MICA Primary Unit Of Measure"; Code[10])
        {
            Caption = 'Primary Unit Of Measure';
            DataClassification = CustomerContent;
        }

        field(116; "MICA LP Family Code"; Code[10])
        {
            Caption = 'LP Family Code';
            DataClassification = CustomerContent;
        }
        field(117; "MICA LPR Category"; Code[10])
        {
            Caption = 'LPR Category ';
            DataClassification = CustomerContent;
        }
        field(118; "MICA LPR Sub Family"; Code[10])
        {
            Caption = 'LPR Sub Family ';
            DataClassification = CustomerContent;
        }
        field(119; "MICA Product Nature"; Code[10])
        {
            Caption = 'Product Nature';
            DataClassification = CustomerContent;
        }

        field(120; "MICA Usage Category"; Code[10])
        {
            Caption = 'Usage Category';
            DataClassification = CustomerContent;
        }

        field(121; "MICA Prevision Indicator"; Code[10])
        {
            Caption = 'Prevision Indicator';
            DataClassification = CustomerContent;
        }

        field(122; "MICA Manufacturer Part Number"; Text[250])
        {
            Caption = 'Manufacturer Part Number';
            DataClassification = CustomerContent;
        }

        field(123; "MICA Commercial Label"; Text[250])
        {
            Caption = 'Commercial Label';
            DataClassification = CustomerContent;
        }

        field(124; "MICA Product Weight"; Decimal)
        {
            Caption = 'Product Weight';
            DataClassification = CustomerContent;
        }

        field(125; "MICA Product Weight UOM"; Code[10])
        {
            Caption = 'Product Weight UOM ';
            DataClassification = CustomerContent;
        }

        field(126; "MICA Load Index 1"; Decimal)
        {
            Caption = 'Load Index 1';
            DataClassification = CustomerContent;
        }

        field(127; "MICA Speed Index 1"; Code[10])
        {
            Caption = 'Speed Index 1';
            DataClassification = CustomerContent;
        }

        field(128; "MICA Tire Type"; Code[10])
        {
            Caption = 'Tire Type';
            DataClassification = CustomerContent;
        }

        field(129; "MICA Star Rating"; Code[10])
        {
            Caption = 'Star Rating';
            DataClassification = CustomerContent;
        }

        field(130; "MICA Grading Type"; Code[10])
        {
            Caption = 'Grading Type';
            DataClassification = CustomerContent;
        }

        field(131; "MICA Rolling Resistance2"; Text[10])
        {
            Caption = 'Rolling Resistance';
            DataClassification = CustomerContent;
        }

        field(132; "MICA Wet Grip2"; Text[10])
        {
            Caption = 'Wet Grip';
            DataClassification = CustomerContent;
        }

        field(133; "MICA Noise Performance2"; Text[10])
        {
            Caption = 'Noise Performance';
            DataClassification = CustomerContent;
        }

        field(134; "MICA Noise Wave2"; Text[10])
        {
            Caption = 'Noise Wave';
            DataClassification = CustomerContent;
        }

        field(135; "MICA Noise Class2"; Text[10])
        {
            Caption = 'Noise Class';
            DataClassification = CustomerContent;
        }

        field(136; "MICA Aspect Quality2"; Code[20])
        {
            Caption = 'Aspect Quality';
            DataClassification = CustomerContent;
        }
        field(137; "MICA Marketing Manager Name2"; Text[250])
        {
            Caption = 'Marketing Manager Name';
            DataClassification = CustomerContent;
        }

        // missing field Homologation Class (Code)

        field(139; "MICA Commercial. Start Date"; Date)
        {
            Caption = 'Commercialization Start Date';
            DataClassification = CustomerContent;
        }

        field(140; "MICA Commercial. End Date"; Date)
        {
            Caption = 'Commercialization End Date';
            DataClassification = CustomerContent;
        }
        field(141; "MICA None Update from PS9"; Boolean)
        {
            Caption = 'None Update from PS9';
            DataClassification = CustomerContent;
        }

        field(142; "MICA CCID Code"; Code[3])
        {
            Caption = 'CCID Code';
            DataClassification = CustomerContent;
        }
        field(143; "MICA User Item Type"; Code[10])
        {
            Caption = 'User Item Type';
            DataClassification = CustomerContent;
        }
        field(144; "MICA Vignette"; Boolean)
        {
            Caption = 'Vignette';
            DataClassification = CustomerContent;
        }
        field(145; "MICA Business Line"; Code[10])
        {
            Caption = 'Business Line';
            DataClassification = CustomerContent;
        }
        field(146; "MICA Business Line OE"; Code[10])
        {
            Caption = 'Business Line OE';
            DataClassification = CustomerContent;
        }
        field(147; "MICA Business Line RT"; Code[10])
        {
            Caption = 'Business Line RT';
            DataClassification = CustomerContent;
        }
        field(148; "MICA Administrative Status"; Code[20])
        {
            Caption = 'Administrative Status';
            DataClassification = CustomerContent;
        }
        field(149; "MICA Load Range"; Code[20])
        {
            Caption = 'Load Range';
            DataClassification = CustomerContent;
        }
        field(150; "MICA Airtightness"; Code[2])
        {
            Caption = 'Airtightness';
            DataClassification = CustomerContent;
        }
        field(151; "MICA Tire Size"; Text[30])
        {
            Caption = 'Tire size';
            DataClassification = CustomerContent;
        }
        field(152; "MICA Pattern Code"; Code[20])
        {
            Caption = 'Pattern Code';
            DataClassification = CustomerContent;
        }
        field(153; "MICA Homologator Code"; Code[4])
        {
            Caption = 'Homologator Code';
            DataClassification = CustomerContent;
        }
        field(154; "MICA Homologator Label"; Text[50])
        {
            Caption = 'Homologator Label';
            DataClassification = CustomerContent;
        }
        field(155; "MICA Homologation Market Code"; Code[2])
        {
            Caption = 'Homologation Market Code';
            DataClassification = CustomerContent;
        }
        field(156; "MICA Homologation Vehicle Code"; Code[3])
        {
            Caption = 'Homologation Vehicle Code';
            DataClassification = CustomerContent;
        }
        field(157; "MICA Homologation Type2"; Code[1])
        {
            Caption = 'Homologation Type';
            DataClassification = CustomerContent;
        }
        field(158; "MICA Homologation Start Date"; Date)
        {
            Caption = 'Homologation Start Date';
            DataClassification = CustomerContent;
        }
        field(159; "MICA Homologation End Date"; Date)
        {
            Caption = 'Homologation End Date';
            DataClassification = CustomerContent;
        }
        field(160; "MICA Homologa. Deliver Profil"; Text[1])
        {
            Caption = 'Homologation Deliver Profil';
            DataClassification = CustomerContent;
        }
        field(161; "MICA Homologation Country"; Code[10])
        {
            Caption = 'Homologation Country';
            DataClassification = CustomerContent;
        }
        field(162; "MICA Derogation Number"; Code[10])
        {
            Caption = 'Derogation number';
            DataClassification = CustomerContent;
        }

        field(163; "MICA Derogation Quantity"; Decimal)
        {
            Caption = 'Derogation quantity';
            DataClassification = CustomerContent;
        }
        field(164; "MICA Certificate Country"; Code[10])
        {
            Caption = 'Certificate Country';
            DataClassification = CustomerContent;
        }
        field(165; "MICA Certif. Effective Date"; Date)
        {
            Caption = 'Certificate Effective Date';
            DataClassification = CustomerContent;
        }
        field(166; "MICA Certif. Expiration Date"; Date)
        {
            Caption = 'Certificate Expiration Date';
            DataClassification = CustomerContent;
        }
        field(167; "MICA Certificate Number"; Text[50])
        {
            Caption = 'Certificate Number';
            DataClassification = CustomerContent;
        }

        field(168; "MICA Regional. Active Country"; Code[10])
        {
            Caption = 'Regionalisation Active Country';
            DataClassification = CustomerContent;
        }
        field(169; "MICA Regional. Act. Str. Date"; Date)
        {
            Caption = 'Regionalisation Active Start Date';
            DataClassification = CustomerContent;
        }
        field(170; "MICA Regional. Act. End Date"; Date)
        {
            Caption = 'Regionalisation Active End Date';
            DataClassification = CustomerContent;
        }
        field(171; "MICA Custom Export Country"; Code[10])
        {
            Caption = 'Custom Export Country';
            DataClassification = CustomerContent;
        }
        field(172; "MICA Custom Start Date"; Code[10])
        {
            Caption = 'Custom Start Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(1172; "MICA Custom Start Date2"; Date)
        {
            Caption = 'Custom Start Date';
            DataClassification = CustomerContent;
        }
        field(173; "MICA Custom End Date"; Code[10])
        {
            Caption = 'Custom End Date';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(1173; "MICA Custom End Date2"; Date)
        {
            Caption = 'Custom End Date';
            DataClassification = CustomerContent;
        }
        field(174; "MICA Military ECCN Code"; Code[50])
        {
            Caption = 'Military/ECCN code';
            DataClassification = CustomerContent;
            ObsoleteState = Removed;
            ObsoleteReason = 'Deleted';
        }
        field(1174; "MICA Military ECCN Code2"; Text[50])
        {
            Caption = 'Military/ECCN code';
            DataClassification = CustomerContent;
        }
        field(175; "MICA Military ECCN Label"; Text[50])
        {
            Caption = 'Military/ECCN label';
            DataClassification = CustomerContent;
        }
        field(176; "MICA Military Export Country"; Code[10])
        {
            Caption = 'Military Export Country';
            DataClassification = CustomerContent;
        }
        field(177; "MICA Military Start Date"; Date)
        {
            Caption = 'Military Start Date';
            DataClassification = CustomerContent;
        }
        field(178; "MICA Military End Date"; Date)
        {
            Caption = 'Military End Date';
            DataClassification = CustomerContent;
        }
        field(179; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }

        field(180; "MICA Product Volume"; Decimal)
        {
            Caption = 'Product Volume';
            DataClassification = CustomerContent;
        }
        field(181; "MICA Product Volume UoM"; Code[10])
        {
            Caption = 'Product Volume UoM';
            DataClassification = CustomerContent;
        }
        field(182; "MICA Section Width"; Decimal)
        {
            Caption = 'Section Width';
            DataClassification = CustomerContent;
        }
        field(183; "MICA Aspect Ratio"; Code[10])
        {
            Caption = 'Aspect Ratio';
            DataClassification = CustomerContent;
        }
        field(184; "MICA LB-OE"; Code[10])
        {
            Caption = 'LB-OE';
            DataClassification = CustomerContent;
        }
        field(185; "MICA LB-RT"; Code[10])
        {
            Caption = 'LB-RT';
            DataClassification = CustomerContent;
        }
        field(186; "MICA EAN Item ID"; Text[20])
        {
            Caption = 'EAN Article ID';
            DataClassification = CustomerContent;
        }

        field(82080; "MICA Last DateTime Modified"; DateTime)
        {
            Caption = 'Last DateTime Modified';
            DataClassification = CustomerContent;
        }

        field(82081; "MICA Blocked"; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(82082; "MICA Product Weight Raw"; Text[30])
        {
            Caption = 'Product Weight';
            DataClassification = CustomerContent;
        }
        field(82083; "MICA Load Index 1 Raw"; Text[30])
        {
            Caption = 'Load Index 1';
            DataClassification = CustomerContent;
        }
        field(82084; "MICA Derogation Quantity Raw"; Text[30])
        {
            Caption = 'Derogation quantity';
            DataClassification = CustomerContent;
        }
        field(82085; "MICA Product Volume Raw"; Text[30])
        {
            Caption = 'Product Volume';
            DataClassification = CustomerContent;
        }
        field(82086; "MICA Section Width Raw"; Text[30])
        {
            Caption = 'Section Width';
            DataClassification = CustomerContent;
        }
        field(80231; "MICA Rim Diameter"; Text[10])
        {
            Caption = 'Rim Diameter';
            DataClassification = CustomerContent;
        }

        field(80241; "MICA Rim Diameter UOM"; Code[10])
        {
            Caption = 'Rim diameter UOM';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Flow Code", "Flow Entry No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; "Flow Code", "PS9 Execution DateTime")
        {
            MaintainSqlIndex = true;
        }
    }
    trigger OnInsert()
    begin
        GetOrCreateNewFlowEntry();
        "Flow Code" := MICAFlowEntry."Flow Code";
        "Flow Entry No." := MICAFlowEntry."Entry No.";
        "PS9 Execution DateTime" := CurrentDateTime();
        "Entry No." := 1;
    end;

    local procedure GetOrCreateNewFlowEntry()
    var
        MICAFlow: Record "MICA Flow";
        ExistingMICAFlowBufferPS9: Record "MICA Flow Buffer PS9";
    begin
        MICAFlow.SetFilter(Code, '*PS9*');
        if MICAFlow.FindFirst() then begin
            ExistingMICAFlowBufferPS9.SetRange("Flow Code", MICAFlow.Code);
            ExistingMICAFlowBufferPS9.SetRange("PS9 Execution DateTime", "PS9 Execution DateTime");
            if ExistingMICAFlowBufferPS9.FindFirst() then
                MICAFlowEntry.Get(ExistingMICAFlowBufferPS9."Flow Entry No.")
            else
                MICAFlowEntry.Get(MICAFlow.CreateFlowEntry(MICAFlowEntry."Receive Status"::Loaded));
        end;
    end;

    var
        MICAFlowEntry: Record "MICA Flow Entry";
}