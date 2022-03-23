/// <summary>
/// TableExtension ISA_ItemCard_Ext (ID 50188) extends Record Item.
/// </summary>
tableextension 50188 ISA_ItemCard_Ext extends Item
{
    fields
    {
        field(50100; VideoURL; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Video URL';
            Description = 'Emebed Video'; //* such attribute is for internal usage
        }
    }
}