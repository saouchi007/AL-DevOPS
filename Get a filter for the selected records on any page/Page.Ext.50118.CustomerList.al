/// <summary>
/// PageExtension ISA_CustomerList_Ext (ID 50118) extends Record Customer Card.
/// </summary>
pageextension 50118 ISA_CustomerList_Ext extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field(ItemFilter; ItemFilter)
            {
                Caption = 'Item Filter';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemList: Page "Item List";
                begin
                    Clear(ItemList);
                    ItemList.LookupMode(true);

                    if ItemList.RunModal() = Action::LookupOK then begin
                        Text += ItemList.GetSelectionFilter();
                        exit(true);
                    end
                    else
                        exit(false);
                end;
            }
        }
        addafter(ItemFilter)
        {
            field(PostedSIFilter; PostedSIFilter)
            {
                Caption = 'Posted SI Filter';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    PostedSalesInvocies: Page "Posted Sales Invoices";
                    SalesInvHeader: Record "Sales Invoice Header";
                    SelectionFilterManagement: Codeunit SelectionFilterManagement;
                    RecRef: RecordRef;
                begin
                    Clear(PostedSIFilter);
                    PostedSalesInvocies.SetTableView(SalesInvHeader);
                    PostedSalesInvocies.LookupMode(true);
                    if PostedSalesInvocies.RunModal = ACTION::LookupOK then begin
                        PostedSalesInvocies.SetSelectionFilter(SalesInvHeader);
                        RecRef.GetTable(SalesInvHeader);
                        PostedSIFilter := SelectionFilterManagement.GetSelectionFilter(RecRef, SalesInvHeader.FieldNo("No."));
                    end;
                end;
            }
        }
    }
    var
        ItemFilter: Code[100];
        PostedSIFilter: Code[100];
}