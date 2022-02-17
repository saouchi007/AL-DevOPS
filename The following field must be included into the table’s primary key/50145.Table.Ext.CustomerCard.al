/// <summary>
/// TableExtension CustomerCard_Ext (ID 50145) extends Record Customer.
/// </summary>
tableextension 50145 CustomerCard_Ext extends Customer
{
    fields
    {

        field(50145; VendorName; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Vendor Name';
            Editable = false;
            //TableRelation = Vendor.Name;
            //ValidateTableRelation = false; 1st solution

            /*          2nd solution
                        trigger OnLookup()
                        var
                            Vendor: Record Vendor;
                        begin
                            if Page.RunModal(Page::"Vendor List", Vendor) = Action::LookupOK then
                                VendorName := Vendor.Name;
                        end; */
        }
        // 3rd solution by adding No and Name */
        field(50146; VendorNo; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            Caption = 'Vendor No.';

            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin
                if Vendor.Get(VendorNo) then
                    VendorName := Vendor.Name;
            end;

        }
    }


}