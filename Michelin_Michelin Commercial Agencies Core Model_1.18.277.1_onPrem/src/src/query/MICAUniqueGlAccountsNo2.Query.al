query 81021 "MICA Unique Gl Accounts No2"
{
    QueryType = Normal;
    
    elements
    {
        dataitem(GL_Account; "G/L Account")
        {
            DataItemTableFilter = "No. 2" = filter(<>'');

            column(No_2; "No. 2")
            {
                
            }
            column(CountNO2)
            {
                Method = Count;

            }
        }
    }
}