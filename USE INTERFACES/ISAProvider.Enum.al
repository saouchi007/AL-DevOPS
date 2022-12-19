/// <summary>
/// Enum ISA_Provider (ID 50301).
/// </summary>
enum 50301 ISA_Provider implements ISA_Sports
{
    Extensible = true;
    DefaultImplementation = ISA_Sports = ISA_Default;

    value(0; Default)
    {
        Caption = '';
    }
    value(1; Basketball)
    {
        Implementation = ISA_Sports = ISA_Basketball;
    }
    value(2; Tennis)
    {
        Implementation = ISA_Sports = ISA_Tennis;
    }
}