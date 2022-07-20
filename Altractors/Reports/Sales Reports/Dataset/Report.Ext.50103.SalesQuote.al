/// <summary>
/// Unknown ISA_SalesQuote_Ext (ID 50103) extends Record Standard Sales - Quote.
/// </summary>
reportextension 50103 ISA_SalesQuote_Ext extends "Standard Sales - Quote"
{
    //RDLCLayout = './Reports/Sales Quote.rdl';
    dataset
    {
        add(Header)
        {
            column(Bill_to_Contact; "Bill-to Contact")
            {

            }
            column(Sell_to_Contact; "Sell-to Contact")
            {

            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {

            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {

            }
            column(Sell_to_Customer_Name_2; "Sell-to Customer Name 2")
            {

            }
            column(ISA_Customer_FiscalID; ISA_Customer_FiscalID)
            {
            }
            column(ISA_Customer_ItemNumber; ISA_Customer_ItemNumber)
            {
            }
            column(ISA_Customer_StatisticalID; ISA_Customer_StatisticalID)
            {
            }
            column(ISA_Customer_TradeRegister; ISA_Customer_TradeRegister)
            {
            }
            column(ISA_SalesComments; ISA_SalesComments.Comment)
            {
            }
            column(Requested_Delivery_Date; "Requested Delivery Date")
            {
            }
            column(ISA_AmountInWords; ISA_AmountInWords)
            {
            }
        }

        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            var
                Customer: Record Customer;
                Int: Integer;
                Dec: Decimal;
            begin
                Customer.Reset();
                ISA_SalesComments.reset();
                ISA_SalesComments.SetRange("No.", Header."No.");
                Customer.SetRange("No.", Header."Sell-to Customer No.");
                if Customer.FindSet or ISA_SalesComments.FindSet then begin
                    ISA_Customer_FiscalID := Customer.ISA_FiscalID;
                    ISA_Customer_ItemNumber := Customer.ISA_ItemNumber;
                    ISA_Customer_StatisticalID := Customer.ISA_StatisticalID;
                    ISA_Customer_TradeRegister := Customer.ISA_TradeRegister;
                end;

                Header.CalcFields(Amount, "Amount Including VAT");
                AmountCustomer := Header."Amount Including VAT";
                Int := AmountCustomer DIV 1;
                Dec := Round(AmountCustomer) MOD 1 * 100;
                //RepCheck.InitTextVariable();
                InitTextVariable();
                //RepCheck.FormatNoText(NoText1, Round(AmountCustomer, 0.01), '');
                FormatNoText(NoText1, AmountCustomer, '');
                //RepCheck.FormatNoText(NoText1, Round(AmountCustomer, 1, '='), 'DZD');
                //RepCheck.FormatNoText(NoText2, Dec, '');
                ISA_AmountInWords := NoText1[1];
                //Message('%2', ISA_AmountInWords, Round(AmountCustomer, 1, '='));
                //ISA_AmountInWordsDec := noText2[1];
                //Message('%1 - %2', ISA_AmountInWords, AmountCustomer);
            end;

        }


    }

    /// <summary>
    /// FormatNoText.
    /// </summary>
    /// <param name="NoText">VAR array[2] of Text[80].</param>
    /// <param name="No">Decimal.</param>
    /// <param name="CurrencyCode">Code[10].</param>
    /// 
    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        TensDec: Integer;
        OnesDec: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;

    begin
        Clear(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        if No < 1 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        else begin
            for Exponent := 4 downto 1 do begin
                PrintExponent := false;
                Ones := No div Power(1000, Exponent - 1);
                Hundreds := Ones div 100;
                Tens := (Ones mod 100) div 10;
                Ones := Ones mod 10;
                if Hundreds > 0 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                end;
                /*if ((Tens > 0) or (Ones > 0)) and (Hundreds > 0) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, 'ET');*/
                if Tens >= 2 then begin
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    if Ones > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                end else
                    if (Tens * 10 + Ones) > 0 then
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                if PrintExponent and (Exponent > 1) then
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * Power(1000, Exponent - 1);
            end;

            AddToNoText(NoText, NoTextIndex, PrintExponent, 'DINARS,');
        end;

        /*if No > 0 then
            AddToNoText(NoText, NoTextIndex, PrintExponent, Format(No * 100) + '')
        else
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');*/
        if CurrencyCode <> '' then
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode)
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text1020000);

        TensDec := ((No * 100) MOD 100) DIV 10;
        OnesDec := (No * 100) MOD 10;

        IF TensDec >= 2 THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
            IF OnesDec > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
        END ELSE
            IF (TensDec * 10 + OnesDec) > 0 THEN
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
            ELSE
                AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);
        IF (CurrencyCode <> '') THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' ' + '' + ',')
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, ' CENTIMES');

    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := true;

        while StrLen(NoText[NoTextIndex] + ' ' + AddText) > MaxStrLen(NoText[1]) do begin
            NoTextIndex := NoTextIndex + 1;
            if NoTextIndex > ArrayLen(NoText) then
                Error(Text029, AddText);
        end;

        NoText[NoTextIndex] := DelChr(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;


    /// <summary>
    /// InitTextVariable.
    /// </summary>
    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;

    var
        ISA_Customer_FiscalID: Text;
        ISA_Customer_TradeRegister: Text;
        ISA_Customer_ItemNumber: Text;
        ISA_Customer_StatisticalID: Text;

        RepCheck: Report Check;
        NoText1: array[2] of Text;
        NoText2: array[2] of Text;
        ISA_AmountInWords: Text[100];
        ISA_AmountInWordsDec: Text[100];
        AmountCustomer: Decimal;

        ISA_SalesComments: Record "Sales Comment Line";



        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        OnesText: array[20] of Text[30];
        Text026: Label ' ZERO';
        Text027: Label ' CENT';
        Text028: Label ' ET';
        Text029: Label 'Void';
        Text032: Label ' UN';
        Text033: Label ' DEUX';
        Text034: Label ' TROIS';
        Text035: Label ' QUATRE';
        Text036: Label ' CINQ';
        Text037: Label ' SIX';
        Text038: Label ' SEPT';
        Text039: Label ' HUIT';
        Text040: Label ' NEUF';
        Text041: Label ' DIX';
        Text042: Label ' ONZE';
        Text043: Label ' DOUZE';
        Text044: Label ' TREIZE';
        Text045: Label ' QUATORZE';
        Text046: Label ' QUINZE';
        Text047: Label ' SEIZE';
        Text048: Label ' DIX-SEPT';
        Text049: Label ' DIX-HUIT';
        Text050: Label ' DIZ-NEUF';
        Text051: Label ' VINGT';
        Text052: Label ' TRENTE';
        Text053: Label ' QUARANTE';
        Text054: Label ' CINQUANTE';
        Text055: Label ' SOIXANTE';
        Text056: Label ' SOIXANTE-DIX';
        Text057: Label ' QUATRE-VINGT';
        Text058: Label ' QUATRE-VINGT-DIX';
        Text059: Label ' MILLE';
        Text060: Label ' MILLION';
        Text061: Label ' MILLIARD';
        Text1020000: Label ' et';

}

