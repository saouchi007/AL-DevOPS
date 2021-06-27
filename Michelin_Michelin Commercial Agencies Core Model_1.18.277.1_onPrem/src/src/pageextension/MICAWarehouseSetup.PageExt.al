pageextension 81220 "MICA Warehouse Setup" extends "Warehouse Setup"
{
    layout
    {
        addlast(Content)
        {
            group("MICA 3PL Integration")
            {
                Caption = '3PL Integration';
                Group(Shipment)
                {
                    Caption = 'Shipment';
                    field("MICA 3PL Pick Req. FlowCode"; Rec."MICA 3PL Pick Req. FlowCode")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA 3PL Pick Ack. Flow Code"; Rec."MICA 3PL Pick Ack. Flow Code")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA 3PL Pick Ack. MaxDelay"; Rec."MICA 3PL Pick Ack. MaxDelay")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA 3PL Shp. Conf. Flow Code"; Rec."MICA 3PL Shp. Conf. Flow Code")
                    {
                        ApplicationArea = All;
                    }

                    field("MICA 3PL Rec. instr. flow code"; Rec."MICA 3PL Rec. instr. flow code")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA 3PL Weight UoM"; Rec."MICA 3PL Weight UoM")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the 3PL Weight UoM';
                    }
                    field("MICA 3PL to PS9 Weight Factor"; Rec."MICA 3PL to PS9 Weight Factor")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the 3PL to PS9 Weight Factor';
                    }
                    field("MICA 3PL Volume UoM"; Rec."MICA 3PL Volume UoM")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the 3PL Volume UoM';
                    }
                    field("MICA 3PL to PS9 Volume Factor"; Rec."MICA 3PL to PS9 Volume Factor")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the 3PL to PS9 Volume Factor';
                    }
                }
                Group(Receipt)
                {
                    Caption = 'Receipt';
                    field("MICA 3PL Receipt Ack. FlowCode"; Rec."MICA 3PL Receipt Ack. FlowCode")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA 3PL Receipt Ack. MaxDelay"; Rec."MICA 3PL Receipt Ack. MaxDelay")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA 3PL Recv. Conf. Flow Code"; Rec."MICA 3PL Recv. Conf. Flow Code")
                    {
                        ApplicationArea = All;
                    }
                    field("MICA Received Ack. Flow Code"; Rec."MICA Received Ack. Flow Code")
                    {
                        ApplicationArea = All;
                    }
                }
                field("MICA 3PL Transp.Event FlowCode"; Rec."MICA 3PL Transp.Event FlowCode")
                {
                    ApplicationArea = All;
                }
            }
            group("MICA Layout Shipment Setup")
            {
                Caption = 'Layout Shipment Setup';
                field("MICA Acceptance Note"; Rec."MICA Acceptance Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Acceptance Note';
                }
                field("MICA Cross Reference Separador"; Rec."MICA Cross Reference Separator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Cross Reference Separator';
                }
            }
        }

    }

}