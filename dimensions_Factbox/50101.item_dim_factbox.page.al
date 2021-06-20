pageextension 50101 item_dim_factbox extends "Item Card"
{
    layout
    {
        addfirst(factboxes)
        {
            part(dimFactBox; "Dimensions FactBox")
            {
                ApplicationArea = all;
                SubPageLink = "Table ID" = const(27), "No." = field("No.");
            }
        }
    }

}


