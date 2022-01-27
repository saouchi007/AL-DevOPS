/// <summary>
/// TableExtension Post Code Ext (ID 52182430) extends Record Post Code.
/// </summary>
tableextension 52182430 "Post Code Ext" extends "Post Code"
{
    fields
    {
        field(50000; Amount; Decimal)
        {
            Caption = 'Montant';
        }
    }

    var
        myInt: Integer;

    /// <summary>
    /// ValidateCity_old.
    /// </summary>
    /// <param name="City">VAR Text[30].</param>
    /// <param name="PostCode">VAR Code[20].</param>
    procedure ValidateCity_old(var City: Text[30]; var PostCode: Code[20]);
    var
        PostCodeRec: Record 225;
        PostCodeRec2: Record 225;
        SearchCity: Code[30];
    begin
        IF NOT GUIALLOWED THEN
            EXIT;
        IF City <> '' THEN BEGIN
            SearchCity := City;
            PostCodeRec.SETCURRENTKEY("Search City");
            IF STRPOS(SearchCity, '*') = STRLEN(SearchCity) THEN
                PostCodeRec.SETFILTER("Search City", SearchCity)
            ELSE
                PostCodeRec.SETRANGE("Search City", SearchCity);
            IF NOT PostCodeRec.FIND('-') THEN
                EXIT;
            PostCodeRec2.COPY(PostCodeRec);
            IF PostCodeRec2.NEXT = 1 THEN
                IF PAGE.RUNMODAL(PAGE::"Post Codes", PostCodeRec, PostCodeRec.Code) <> ACTION::LookupOK THEN
                    EXIT;
            PostCode := PostCodeRec.Code;
            City := PostCodeRec.City;
        END;
    end;

    /// <summary>
    /// ValidatePostCode_old.
    /// </summary>
    /// <param name="City">VAR Text[30].</param>
    /// <param name="PostCode">VAR Code[20].</param>
    procedure ValidatePostCode_old(var City: Text[30]; var PostCode: Code[20]);
    var
        PostCodeRec: Record 225;
        PostCodeRec2: Record 225;
    begin
        IF PostCode <> '' THEN BEGIN
            IF STRPOS(PostCode, '*') = STRLEN(PostCode) THEN
                PostCodeRec.SETFILTER(Code, PostCode)
            ELSE
                PostCodeRec.SETRANGE(Code, PostCode);
            IF NOT PostCodeRec.FIND('-') THEN
                EXIT;
            PostCodeRec2.COPY(PostCodeRec);
            IF (PostCodeRec2.NEXT = 1) AND GUIALLOWED THEN
                IF PAGE.RUNMODAL(PAGE::"Post Codes", PostCodeRec, PostCodeRec.Code) <> ACTION::LookupOK THEN
                    EXIT;
            PostCode := PostCodeRec.Code;
            City := PostCodeRec.City;
        END;
    end;

    /// <summary>
    /// LookUpCity.
    /// </summary>
    /// <param name="City">VAR Text[30].</param>
    /// <param name="PostCode">VAR Code[20].</param>
    /// <param name="ReturnValues">Boolean.</param>
    procedure LookUpCity(var City: Text[30]; var PostCode: Code[20]; ReturnValues: Boolean);
    var
        PostCodeRec: Record 225;
    begin
        IF NOT GUIALLOWED THEN
            EXIT;
        PostCodeRec.SETCURRENTKEY(City, Code);
        PostCodeRec.Code := PostCode;
        PostCodeRec.City := City;
        IF (PAGE.RUNMODAL(PAGE::"Post Codes", PostCodeRec, PostCodeRec.City) = ACTION::LookupOK) AND ReturnValues THEN BEGIN
            PostCode := PostCodeRec.Code;
            City := PostCodeRec.City;
        END;
    end;

    /// <summary>
    /// LookUpPostCode.
    /// </summary>
    /// <param name="City">VAR Text[30].</param>
    /// <param name="PostCode">VAR Code[20].</param>
    /// <param name="ReturnValues">Boolean.</param>
    procedure LookUpPostCode(var City: Text[30]; var PostCode: Code[20]; ReturnValues: Boolean);
    var
        PostCodeRec: Record 225;
    begin
        IF NOT GUIALLOWED THEN
            EXIT;
        PostCodeRec.SETCURRENTKEY(Code, City);
        PostCodeRec.Code := PostCode;
        PostCodeRec.City := City;
        IF (PAGE.RUNMODAL(PAGE::"Post Codes", PostCodeRec, PostCodeRec.Code) = ACTION::LookupOK) AND ReturnValues THEN BEGIN
            PostCode := PostCodeRec.Code;
            City := PostCodeRec.City;
        END;
    end;
}