pageextension 50001 "BCW Sales Return Order Subform" extends "Sales Return Order Subform"
{
    layout
    {
        addafter("Return Qty. to Receive")
        {
            field("Return Qty. to Receive (Whse.)"; Rec."Return Qty. to Receive (Whse.)")
            {
                ApplicationArea = Warehouse;
                BlankZero = true;
            }
            field("Ret. Qty. to Rec. (Wh.) (Base)"; Rec."Ret. Qty. to Rec. (Wh.) (Base)")
            {
                ApplicationArea = Warehouse;
                BlankZero = true;
                Visible = false;
            }
        }
    }
}