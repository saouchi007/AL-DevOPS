pageextension 50100 CustCard extends "Customer List"
{
    trigger OnOpenPage()
    var
    begin
        //Message('Today : %1', Today + 7); // adds up 7 days to the current date
        //Message('%1', Today + 365); // adds a year to the current year, watch out for leap years
        CustomerDate();
    end;

    local procedure CustomerDate()
    var
        Cust: Record "Cust. Ledger Entry";
    begin
        //Cust.SetFilter("Posting Date", 'CQ+5D'); // last day of the quarter 5 days
        //Cust.SetFilter("Posting Date", 'week'); // displays a rang with today as a starting date and adds 7 days
        //Cust.SetFilter("Posting Date", 'quarter'); // displays rang for the first quarter
        //Cust.SetFilter("Posting Date", 'quarter+1Q'); // displays rang for the second quarter
        //Cust.SetFilter("Posting Date", 'P2'); // displays a rang for the second accouting period aka February
        //Cust.SetFilter("Posting Date", 'yesterday..tomorrow');
        // Cust.SetFilter("Posting Date", '<10D>'); //using <> will maintain Days as in english no matter the user language
        //Message(Cust.GetFilter("Posting Date"));
        //Message('%1', CalcDate('7D', Today())); // adds 7 days to today
        //Message(CurrPage.ObjectId(false)); // to retrieve the page N°
        //Report.ObjectId(true) gets you the name 
        //Page.ObjectId(false) gets you the object number 
    end;

}