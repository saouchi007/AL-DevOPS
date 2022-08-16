/// <summary>
/// Page ISA_StandardDialog (ID 50307).
/// </summary>
page 50307 ISA_StandardDialog
{
    PageType = StandardDialog;
    Caption = 'Standard Dialog';
    ApplicationArea = All;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            field(x; x)
            {
                ApplicationArea = All;
                Caption = 'X';
            }
            field(y; y)
            {
                ApplicationArea = All;
                Caption = 'Y';
            }
            field(z; z)
            {
                ApplicationArea = All;
                Caption = 'Z';
            }
        }

    }
    var
        x, y, z : text;

    /// <summary>
    /// ISA_Setup.
    /// </summary>
    /// <param name="_x">Text.</param>
    /// <param name="_y">text.</param>
    /// <param name="_z">text.</param>
    procedure ISA_Setup(_x: Text; _y: text; _z: text);
    begin
        x := _x;
        y := _y;
        z := _z;
    end;

    /// <summary>
    /// GetX.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetX(): Text
    begin
        exit(x);
    end;

    /// <summary>
    /// GetY.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetY(): Text
    begin
        exit(y);
    end;

    /// <summary>
    /// GetZ.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetZ(): Text
    begin
        exit(z);
    end;
}