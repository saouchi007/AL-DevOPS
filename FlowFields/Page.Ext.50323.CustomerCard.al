/// <summary>
/// Page ISA_Customer (ID 50323).
/// </summary>
page 50323 ISA_Customer
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ISA_Customer;

    layout
    {
        area(Content)
        {
            repeater(Rep)
            {
                Caption = 'General';

                field(CustomerNo; Rec.CustomerNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(HasInvoices; Rec.HasInvoices)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HasInvoices field.';
                }
                field(InvoicesTotal; Rec.InvoicesTotal)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoices Total field.';
                }
                field(InvoiceCount; Rec.InvoiceCount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Count field.';
                }
                field(AverageInvoice; Rec.AverageInvoice)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Average Invoice field.';
                }
                field(MaxInvoiceAmount; Rec.MaxInvoiceAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Max Invoice Amount field.';
                }
                field(MinInvoiceAmount; Rec.MinInvoiceAmount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Min Invoice Amount field.';
                }

            }
        }
    }

}