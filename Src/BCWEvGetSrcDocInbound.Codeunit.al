codeunit 50003 "BCW Ev Get Src. Doc. Inbound"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", OnAfterCreateWhseReceiptHeaderFromWhseRequest, '', false, false)]
    local procedure OnAfterCreateWhseReceiptHeaderFromWhseRequest(var WarehouseRequest: Record "Warehouse Request")
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