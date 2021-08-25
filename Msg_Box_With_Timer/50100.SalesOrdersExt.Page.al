pageextension 50100 SalesOrdersExt extends "Sales Order List"
{
    actions
    {
        addbefore(Dimensions)
        {
            action("Message with Timer")
            {
                Image = "GetActionMessages";
                trigger OnAction()
                //trigger OnBeforeAction()
                var
                    MyDialog: Dialog;
                    MyNext: Integer;
                    Text000: Label 'This message will be closed in 10 seconds !';
                begin
                    MyNext := 11;
                    MyDialog.Open(Text000, MyNext);
                    repeat
                        Sleep(1000);
                        MyNext := MyNext - 1;
                        MyDialog.Update();
                    until MyNext = 1;
                    MyDialog.Close();
                end;
            }
        }
    }
}