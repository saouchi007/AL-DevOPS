/// <summary>
/// Page ISA_DataEntry (ID 503010).
/// </summary>
page 50310 ISA_DataEntry
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {

            field(TableNo; ISA_Integer)
            {
                ApplicationArea = All;
                Caption = 'Table No';

            }
        }
    }


    /// <summary>
    /// ISA_SetNo, to set ISA_Integer
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    procedure ISA_SetNo(): Integer
    begin
        exit(ISA_Integer);
    end;

    var
        ISA_Integer: Integer;
}