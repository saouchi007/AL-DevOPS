tableextension 81550 "MICA Gen. Journal Line" extends "Gen. Journal Line" //MyTargetTableId
{
    fields
    {
        field(81550; "MICA Tax Payment"; Boolean)
        {
            Caption = 'Tax Payment';
            DataClassification = CustomerContent;
        }
        field(81551; "MICA Additional Information 1"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 1';
        }
        field(81552; "MICA Additional Information 2"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 2';
        }
        field(81553; "MICA Additional Information 3"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 3';
        }
        field(81554; "MICA Additional Information 4"; Text[35])
        {
            DataClassification = CustomerContent;
            Caption = 'Additional Information 4';
        }
        field(82040; "MICA Explanation"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Explanation';
        }
        field(82041; "MICA Explanation (VN)"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Explanation (VN)';
        }

        field(82140; "MICA Posting Group Alt."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Group Alt.';
            TableRelation = IF ("Account Type" = CONST(Customer)) "Customer Posting Group" ELSE
            IF ("Account Type" = CONST(Vendor)) "Vendor Posting Group" ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "FA Posting Group";

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Posting Group") then
                    exit;
                Validate("Posting Group", "MICA Posting Group Alt.");
            End;
        }
        field(81940; "MICA Type Of Transaction"; Option)
        {
            Caption = 'Type of Transaction';
            DataClassification = CustomerContent;
            OptionMembers = "Manual Adjustment","Rebate Creation","Rebate Reversal";
            OptionCaption = 'Manual Adjustment,Rebate Creation,Rebate Reversal';
        }

        modify("Posting Group")
        {
            trigger OnAfterValidate()
            begin
                if CurrFieldNo = FieldNo("MICA Posting Group Alt.") then
                    exit;
                Validate("MICA Posting Group Alt.", "Posting Group");
            End;
        }

        modify("Recipient Bank Account")
        {
            trigger OnAfterValidate()
            begin
                if "Document Type" = "Document Type"::Payment then
                    CheckIfBankIsBlocked();
            end;
        }
    }

    procedure UnmarkExportedPayment(var FromGenJournalLine: Record "Gen. Journal Line")
    begin
        FromGenJournalLine.ModifyAll("Exported to Payment File", false, true);
    end;

    local procedure CheckIfBankIsBlocked()
    var
        VendorBankAccount: Record "Vendor Bank Account";
    begin
        case "Account Type" of
            "Account Type"::Vendor:
                if VendorBankAccount.Get("Account No.", "Recipient Bank Account") then
                    VendorBankAccount.TestField("MICA Blocked", false);
        end;
    end;
}