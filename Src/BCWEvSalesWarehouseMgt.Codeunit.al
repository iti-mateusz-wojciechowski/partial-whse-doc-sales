codeunit 50000 "BCW Ev Sales Warehouse Mgt."
{
    var
        Math: Codeunit Math;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", OnBeforeCheckIfSalesLine2ShptLine, '', false, false)]
    local procedure CheckIfFromSalesLine2ShptLine(var SalesLine: Record "Sales Line"; var ReturnValue: Boolean; var IsHandled: Boolean)
    begin
        if SalesLine.RequireWhseShipment() then
            if SalesLine."Qty. to Ship (Whse.) (Base)" = 0 then begin
                IsHandled := true;
                ReturnValue := false;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", OnBeforeCheckIfSalesLine2ReceiptLine, '', false, false)]
    local procedure OnBeforeCheckIfSalesLine2ReceiptLine(var SalesLine: Record "Sales Line"; var ReturnValue: Boolean; var IsHandled: Boolean)
    begin
        if SalesLine.RequireWhseReceipt() then
            if SalesLine."Ret. Qty. to Rec. (Wh.) (Base)" = 0 then begin
                IsHandled := true;
                ReturnValue := false;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", OnFromSalesLine2ShptLineOnBeforeCreateShipmentLine, '', false, false)]
    local procedure OnFromSalesLine2ShptLineOnBeforeCreateShipmentLine(WarehouseShipmentHeader: Record "Warehouse Shipment Header"; SalesLine: Record "Sales Line"; var TotalOutstandingWhseShptQty: Decimal; var TotalOutstandingWhseShptQtyBase: Decimal)
    var
        AssemblyHeader: Record "Assembly Header";
        ATOWhseShptLineQty: Decimal;
        ATOWhseShptLineQtyBase: Decimal;
    begin
        if SalesLine.AsmToOrderExists(AssemblyHeader) then begin
            ATOWhseShptLineQty := AssemblyHeader."Remaining Quantity" - SalesLine."ATO Whse. Outstanding Qty.";
            ATOWhseShptLineQtyBase := AssemblyHeader."Remaining Quantity (Base)" - SalesLine."ATO Whse. Outstd. Qty. (Base)";
        end;
        TotalOutstandingWhseShptQty := Math.Max(SalesLine."Qty. to Ship (Whse.)" - ATOWhseShptLineQty, 0);
        TotalOutstandingWhseShptQtyBase := Math.Max(SalesLine."Qty. to Ship (Whse.) (Base)" - ATOWhseShptLineQtyBase, 0);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", OnSalesLine2ReceiptLineOnBeforeUpdateReceiptLine, '', false, false)]
    local procedure OnSalesLine2ReceiptLineOnBeforeUpdateReceiptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; SalesLine: Record "Sales Line")
    begin
        WarehouseReceiptLine.Quantity := Math.Max(SalesLine."Return Qty. to Receive (Whse.)", 0);
        WarehouseReceiptLine."Qty. (Base)" := Math.Max(SalesLine."Ret. Qty. to Rec. (Wh.) (Base)", 0);
        WarehouseReceiptLine.Validate("Qty. Received", 0);
        WarehouseReceiptLine.InitOutstandingQtys();
    end;
}