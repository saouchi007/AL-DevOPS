/// <summary>
/// PageExtension ISA_LocationCard_Ext (ID 50314) extends Record Location Card.
/// </summary>
pageextension 50314 ISA_LocationCard_Ext extends "Location Card"
{
    layout
    {
        addfirst(factboxes)
        {
            part("Documents Atatched"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachements';
                SubPageLink = "Table ID" = const(14),
                              "No." = field(Code);
                Visible = true;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

}