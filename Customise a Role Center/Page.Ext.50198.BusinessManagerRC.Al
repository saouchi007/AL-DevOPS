/// <summary>
/// PageExtension ISA_BusinessManager_Ext (ID 50198) extends Record Business Manager Role Center.
/// </summary>
pageextension 50198 ISA_BusinessManager_Ext extends "Business Manager Role Center"
{
    layout
    {

    }

    actions
    {
        addafter(Action41)
        {
            group("ISA New Menu")
            {
                Caption = 'ISA New Menu';
                action("ISACompanySettings")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ISA Company Settings';
                    Image = CompanyInformation;
                    RunObject = Page "Company Information";
                    ToolTip = 'Enter company address, name and bank information that will be used';
                }
                action("ISAAssistedSetup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'ISA Assisted Setup';
                    Image = Setup;
                    RunObject = Page "Assisted Setup";
                    ToolTip = 'Set up core functionality such as sales tax, sending documents as email';
                }
                action("ISACustomer")
                {
                    ApplicationArea = Basic, Suite;
                    AccessByPermission = tabledata Customer = IMD; //to handle permission to acecss the table
                    Caption = 'ISA Customers';
                    Image = Customer;
                    RunObject = page "Customer List";
                }
                action("ISAVendor")
                {
                    Caption = 'ISA Vendors';
                    AccessByPermission = TableData Vendor = IMD;
                    ApplicationArea = Basic, Suite;
                    Image = Vendor;
                    RunObject = Page "Vendor List";
                }
            }
        }
        addafter("Excel Reports")
        {
            group(ISANewAction)
            {
                Caption = 'ISA New Action';
                action(ISASlaesQuotes)
                {
                    Caption = 'ISA Sales Quote';
                    AccessByPermission = TableData "Sales Header" = IMD;
                    ApplicationArea = Basic, Suite;
                    Image = NewSalesQuote;
                    RunObject = page "Sales Quote";
                    RunPageMode = Create;
                }
                action(ISASaleOrders)
                {
                    Caption = 'ISA Sales Orders';
                    AccessByPermission = tabledata "Sales Header" = IMD;
                    ApplicationArea = Basic, Suite;
                    Image = NewOrder;
                    RunObject = page "Sales Order";
                    RunPageMode = Create;
                }
            }
        }
    }

    var
        myInt: Integer;
}