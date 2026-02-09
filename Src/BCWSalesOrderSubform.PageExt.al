pageextension 50000 "BCW Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter("Qty. to Ship")
        {
            field("Qty. to Ship (Whse.)"; Rec."Qty. to Ship (Whse.)")
            {
                ApplicationArea = Warehouse;
                BlankZero = true;
            }
            field("Qty. to Ship (Whse.) (Base)"; Rec."Qty. to Ship (Whse.) (Base)")
            {
                ApplicationArea = Warehouse;
                BlankZero = true;
                Visible = false;
            }
        }
    }
}