/// <summary>
/// PageExtension Absense Registration Ext (ID 52182425) extends Record Absence Registration // 5212 Page de saisie des absences..
/// </summary>
pageextension 52182425 "Absense Registration Ext" extends "Absence Registration" // 5212 Page de saisie des absences.
{
    layout
    {
        addafter(Description)
        {
            //field("First Name"; "First Name")
            //{

            //}
            //field("Last Name"; "Last Name")
            //{

            //}
        }
        addafter(Quantity)
        {
            field("Unit of Measure"; "Unit of Measure")
            {

            }
        }
        addafter("Unit of Measure Code")
        {
            field(Authorised; Authorised)
            {

            }
            field("To Be Deducted"; "To Be Deducted")
            {


            }
            field("Employee Structure Code"; "Employee Structure Code")
            {

            }
            field("Employee Structure Description"; "Employee Structure Description")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}