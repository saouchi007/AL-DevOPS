/// <summary>
/// Page Champs (ID 52182523).
/// </summary>
page 52182523 Champs
{
    // version HALRHPAIE.6.1.01

    Editable = false;
    PageType = Card;
    SourceTable = 2000000041;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(TableNo; TableNo)
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field(TableName; TableName)
                {
                    Visible = false;
                }
                field(FieldName; FieldName)
                {
                }
                field("Field Caption"; "Field Caption")
                {
                }
                field(Type; Type)
                {
                }
                field(Len; Len)
                {
                }
                field(Class; Class)
                {
                }
                field(Enabled; Enabled)
                {
                }
            }
        }
    }

    actions
    {
    }


}

