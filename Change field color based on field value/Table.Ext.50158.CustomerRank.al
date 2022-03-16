/// <summary>
/// TableExtension ISA_CustomerRank (ID 50157) extends Record Customer.
/// </summary>
tableextension 50158 ISA_CustomerRank extends Customer
{
    fields
    {
        field(50157; Rank; Enum Ranks)
        {
            DataClassification = CustomerContent;
            Caption = 'Rank';
        }
    }
}