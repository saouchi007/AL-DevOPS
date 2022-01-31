/// <summary>
/// Page CompanySales (ID 50129).
/// </summary>
page 50129 CompanySales
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = CompanySales;
    Caption = 'Company Sales';

    layout
    {
        area(Content)
        {
            repeater(myRepeater)
            {
                field(CompanyName; Rec.CompanyName)
                {
                    ApplicationArea = All;
                }
                field(TotalSales; Rec.TotalSales)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        Cust: Record Customer;
                    begin
                        Cust.ChangeCompany(Rec.CompanyName);
                        Page.Run(Page::"Customer List", Cust);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CompanyList: Record Company;
        Cust: Record Customer;
        TotalSales: Decimal;
    begin
        Rec.Reset();
        if not Rec.IsEmpty then
            Rec.DeleteAll();
        CompanyList.Reset();
        if CompanyList.FindSet() then
            repeat
                TotalSales := 0;
                Cust.ChangeCompany(CompanyList.Name);
                Cust.Reset();
                Cust.SetAutoCalcFields("Sales (LCY)");
                if Cust.FindSet() then
                    repeat
                        TotalSales += Cust."Sales (LCY)";
                    until Cust.Next() = 0;
                Rec.Init();
                Rec.CompanyName := CompanyList.Name;
                Rec.TotalSales := TotalSales;
                Rec.Insert();
            until CompanyList.Next() = 0;
    end;
}