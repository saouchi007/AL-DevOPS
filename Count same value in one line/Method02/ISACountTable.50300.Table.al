/// <summary>
/// Table ISA_CountTable (ID 50300).
/// </summary>
table 50300 ISA_CountTable
{
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1;EntryNo; Integer)
        {
            DataClassification = ToBeClassified;
            
        }
        field(2; ProcessCheck; Enum ISA_ProcessCheck)
        {
            DataClassification = ToBeClassified;
        }
    }
    
    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }
    
}