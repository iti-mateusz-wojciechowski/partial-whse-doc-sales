codeunit 50005 "BCW Ev Warehouse Shipment Line"
{
    [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeleteEvent(var Rec: Record "Warehouse Shipment Line")
    var
        SalesLine: Record "Sales Line";
    begin
        if Rec."Source Type" = Database::"Sales Line" then
            if SalesLine.Get(Rec."Source Subtype", Rec."Source No.", Rec."Source Line No.") then begin
                SalesLine.InitQtyToShipReceiveWhse();
#pragma warning disable AA0214
                SalesLine.Modify(false);
#pragma warning restore AA0214
            end;
    end;
}