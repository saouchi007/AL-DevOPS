report 81900 "MICA Customer Catalog List"
{
    Caption = 'Customer Catalog List';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    PreviewMode = PrintLayout;
    RDLCLayout = './src/report/MICACustomerCatalogList.rdl';

    dataset
    {
        dataitem(SCCustomerAssortment; "SC - Cust. Assortment")
        {
            DataItemTableView = sorting("Sales Code") where(Mode = Const(Allow));

            RequestFilterFields = "Sales Code", Code;

            column(ReportCaptionLbl; ReportCaptionLbl) { }

            column(PageLbl; PageLbl) { }

            column(CompanyName; COMPANYPROPERTY.DISPLAYNAME()) { }

            column(Filters; GetFilters()) { }

            column(Sales_Type; "Sales Type") { }

            column(Sales_Code; "Sales Code") { }

            column(Type; Type) { }

            column(Code; Code) { }

            column(Mode; Mode) { }

            column(Customer_Name; Customer.Name)
            {
                IncludeCaption = true;
            }

            column(Customer_No; Customer."No.")
            {
                IncludeCaption = true;
            }

            column(Customer_Price_Group; Customer."Customer Price Group")
            {
                IncludeCaption = true;
            }

            column(Item_Description; Item.Description)
            {
                IncludeCaption = true;
            }

            column(Item_Brand; Item."MICA Brand")
            {
                IncludeCaption = true;
            }

            column(Item_CAD; 'ItemCAD') { }

            trigger OnAfterGetRecord()
            Begin
                if ("Sales Type" = "Sales Type"::Customer) then begin
                    Customer.Get("Sales Code");
                    if Customer.Blocked <> Customer.Blocked::" " then
                        CurrReport.Skip();
                End;

                if (Type = Type::Item) then begin
                    Item.Get(Code);
                    if Item.Blocked then
                        CurrReport.Skip();

                    if not (((Item."MICA Commercial. Start Date" <= Today()) or (Item."MICA Commercial. Start Date" = 0D)) and
                    ((Item."MICA Commercial. End Date" >= Today()) or (Item."MICA Commercial. End Date" = 0D)))
                    then
                        CurrReport.Skip();
                end;

            End;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }

    }
    var
        Customer: Record Customer;
        Item: Record Item;
        ReportCaptionLbl: Label 'Customer Catalog List';
        PageLbl: Label 'Page';
}