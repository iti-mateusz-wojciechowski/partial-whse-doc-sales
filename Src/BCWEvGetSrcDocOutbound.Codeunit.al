codeunit 50002 "BCW Ev Get Src. Doc. Outbound"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", OnAfterCreateWhseShipmentHeaderFromWhseRequest, '', false, false)]
    local procedure OnAfterCreateWhseShipmentHeaderFromWhseRequest(var WarehouseRequest: Record "Warehouse Request")
    var
        SalesLine: Record "Sales Line";
    begin
        if WarehouseRequest."Source Type" = Database::"Sales Line" then begin
            SalesLine.SetRange("Document Type", WarehouseRequest."Source Subtype");
            SalesLine.SetRange("Document No.", WarehouseRequest."Source No.");
            SalesLine.InitQtyToShipReceiveWhse(SalesLine);
        end;
    end;
}