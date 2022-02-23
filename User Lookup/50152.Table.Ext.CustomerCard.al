/// <summary>
/// TableExtension CustomerCard_Ext (ID 50151) extends Record Customer.
/// </summary>
tableextension 50151 CustomerCard_Ext extends Customer
{
    fields
    {
        field(50151; "User Name"; code[50])
        {
            DataClassification = CustomerContent;
            /* TableRelation = User."User Name"; method 1
             ValidateTableRelation = false;*/
            Caption = 'User Name';

            /*trigger OnLookup() method 2
            var
                User: Record User;
            begin
                User.Reset();
                if Page.RunModal(Page::"User Lookup", User) = Action::LookupOK then
                    "User Name" := User."User Name"; */
            trigger OnLookup()  // method 3
            var
                User: Record User;
                UserSelection: Codeunit "User Selection";
            begin
                User.Reset();
                UserSelection.Open(User);
                "User Name" := User."User Name";
            end;

            trigger OnValidate() // method 3.1 , checks integrity 
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User Name");
            end;
        }
    }


}