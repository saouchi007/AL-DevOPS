// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!

/// <summary>
/// PageExtension CustomerListExt (ID 50306) extends Record Customer List.
/// </summary>
pageextension 50307 CustomerListExt extends "Customer List"
{
    trigger OnOpenPage();
    var
        i: Integer;
        t: Text;
        d: Decimal;
        TypeHelper: Codeunit "Type Helper";
        V: Variant;
        CultureInfo: Text;
    begin
        /*
        t := '10.000,5';
        t := t.Replace(',', '.');
        Evaluate(d, t);
        Message('%1', d);
        In this example, ',' is actually replaced with '.' which would result in 10.000.5, that would return a runtime error as 
        there would be 2 decimal parts '10.000' and '.5' 
        */

        t := '10.000,5';
        CultureInfo := TypeHelper.LanguageIDToCultureName(1030);
        V := d;
        TypeHelper.Evaluate(V, t, 'G', CultureInfo);
        d := V;
        Message('%1',d);

    end;
}