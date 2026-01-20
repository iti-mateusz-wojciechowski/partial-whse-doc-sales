tableextension 50000 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50000; "Qty. to Ship (Whse.)"; Decimal)
        {
            AccessByPermission = tabledata "Sales Shipment Header" = R;
            Caption = 'Qty. to Ship (Whse.)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                ErrorInfo: ErrorInfo;
            begin
                "Qty. to Ship (Whse.)" := UnitOfMeasureManagement.RoundAndValidateQty("Qty. to Ship (Whse.)", "Qty. Rounding Precision", FieldCaption("Qty. to Ship (Whse.)"));
                "Qty. to Ship (Whse.) (Base)" := CalcBaseQty("Qty. to Ship (Whse.)", FieldCaption("Qty. to Ship (Whse.)"), FieldCaption("Qty. to Ship (Whse.) (Base)"));

                if "Qty. to Ship (Whse.)" = 0 then
                    exit;

                if not RequireWhseShipment() then
                    Error(RequireWhseShipmentErr, FieldCaption("Qty. to Ship (Whse.)"));

                if not IsInventoriableItem() then
                    Error(NonInventoriableItemErr, FieldCaption("Qty. to Ship (Whse.)"));

                if ("Outstanding Quantity" - "Whse. Outstanding Qty.") < "Qty. to Ship (Whse.)" then begin
                    ErrorInfo.Title := StrSubstNo(NotValidErr, FieldCaption("Qty. to Ship (Whse.)"));
                    ErrorInfo.Message := StrSubstNo(QtyToShipErr, ("Outstanding Quantity" - "Whse. Outstanding Qty."));
                    ErrorInfo.RecordId := RecordId();
                    Error(ErrorInfo);
                end;
            end;
        }
        field(50001; "Qty. to Ship (Whse.) (Base)"; Decimal)
        {
            AccessByPermission = tabledata "Sales Shipment Header" = R;
            Caption = 'Qty. to Ship (Whse.) (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate("Qty. to Ship (Whse.)", "Qty. to Ship (Whse.) (Base)");
            end;
        }
        field(50002; "Return Qty. to Receive (Whse.)"; Decimal)
        {
            AccessByPermission = tabledata "Return Receipt Header" = R;
            Caption = 'Return Qty. to Receive (Whse.)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                ErrorInfo: ErrorInfo;
            begin
                "Return Qty. to Receive (Whse.)" := UnitOfMeasureManagement.RoundAndValidateQty("Return Qty. to Receive (Whse.)", "Qty. Rounding Precision", FieldCaption("Return Qty. to Receive (Whse.)"));
                "Ret. Qty. to Rec. (Wh.) (Base)" := CalcBaseQty("Return Qty. to Receive (Whse.)", FieldCaption("Return Qty. to Receive (Whse.)"), FieldCaption("Ret. Qty. to Rec. (Wh.) (Base)"));

                if "Return Qty. to Receive (Whse.)" = 0 then
                    exit;

                if not RequireWhseReceipt() then
                    Error(RequireWhseReceiptErr, FieldCaption("Return Qty. to Receive (Whse.)"));

                if not Rec.IsInventoriableItem() then
                    Error(NonInventoriableItemErr, FieldCaption("Return Qty. to Receive (Whse.)"));

                if ("Outstanding Quantity" - "Return Whse. Out. Qty.") < "Return Qty. to Receive (Whse.)" then begin
                    ErrorInfo.Title := StrSubstNo(NotValidErr, FieldCaption("Return Qty. to Receive (Whse.)"));
                    ErrorInfo.Message := StrSubstNo(QtyToReceiveErr, ("Outstanding Quantity" - "Return Whse. Out. Qty."));
                    ErrorInfo.RecordId := Rec.RecordId();
                    Error(ErrorInfo);
                end;
            end;
        }
        field(50003; "Ret. Qty. to Rec. (Wh.) (Base)"; Decimal)
        {
            AccessByPermission = tabledata "Return Receipt Header" = R;
            Caption = 'Return Qty. to Receive (Whse.) (Base)';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate("Return Qty. to Receive (Whse.)", "Ret. Qty. to Rec. (Wh.) (Base)");
            end;
        }
        field(50004; "Return Whse. Out. Qty."; Decimal)
        {
            AccessByPermission = tabledata Location = R;
            AllowInCustomizations = AsReadOnly;
            BlankZero = true;
            CalcFormula = sum("Warehouse Receipt Line"."Qty. Outstanding" where("Source Type" = const(Database::"Sales Line"),
                                                                                    "Source Subtype" = field("Document Type"),
                                                                                    "Source No." = field("Document No."),
                                                                                    "Source Line No." = field("Line No.")));
            Caption = 'Return Whse. Out. Qty.';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies how many units on the sales return order line remain to be handled in warehouse documents.';
        }
        field(50005; "Return Whse. Out. Qty. (Base)"; Decimal)
        {
            AccessByPermission = tabledata Location = R;
            AllowInCustomizations = AsReadOnly;
            BlankZero = true;
            CalcFormula = sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" where("Source Type" = const(Database::"Sales Line"),
                                                                                    "Source Subtype" = field("Document Type"),
                                                                                    "Source No." = field("Document No."),
                                                                                    "Source Line No." = field("Line No.")));
            Caption = 'Return Whse. Out. Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies how many units on the sales return order line remain to be handled in warehouse documents.';
        }
    }

    var
        UnitOfMeasureManagement: Codeunit "Unit of Measure Management";
        NonInventoriableItemErr: Label '%1 can be specified only for inventoriable items.', Comment = '%1 - Field Caption';
        NotValidErr: Label '%1 isn''t valid.', Comment = '%1 - Field Caption';
        QtyToReceiveErr: Label 'You cannot receive more than %1 units.', Comment = '%1 - Qty. to Receive';
        QtyToShipErr: Label 'You cannot ship more than %1 units.', Comment = '%1 - Qty. to Ship';
        RequireWhseReceiptErr: Label '%1 can be used only on locations that require warehouse receipts.', Comment = '%1 - Location Code';
        RequireWhseShipmentErr: Label '%1 can be used only on locations that require warehouse shipments.', Comment = '%1 - Location Code';

    procedure ClearQtyToShipReceiveWhse()
    begin
        Rec.Validate("Qty. to Ship (Whse.)", 0);
        Rec.Validate("Return Qty. to Receive (Whse.)", 0);
    end;

    procedure InitQtyToShipReceiveWhse()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        Math: Codeunit Math;
    begin
        SalesReceivablesSetup.Get();
        case SalesReceivablesSetup."Default Quantity to Ship" of
            SalesReceivablesSetup."Default Quantity to Ship"::Blank:
                ClearQtyToShipReceiveWhse();
            SalesReceivablesSetup."Default Quantity to Ship"::Remainder:
                if IsInventoriableItem() then
                    case Rec."Document Type" of
                        "Sales Document Type"::Order:
                            begin
                                Rec.CalcFields("Whse. Outstanding Qty.");
                                if RequireWhseShipment() then
                                    Rec.Validate("Qty. to Ship (Whse.)", Math.Max(Rec."Outstanding Quantity" - Rec."Whse. Outstanding Qty.", 0));
                            end;
                        "Sales Document Type"::"Return Order":
                            begin
                                Rec.CalcFields("Return Whse. Out. Qty. (Base)");
                                if RequireWhseReceipt() then
                                    Rec.Validate("Return Qty. to Receive (Whse.)", Math.Max(Rec."Outstanding Quantity" - Rec."Return Whse. Out. Qty. (Base)", 0));
                            end;
                    end;
        end;
    end;

    procedure RequireWhseReceipt(): Boolean
    var
        Location: Record Location;
    begin
        exit(Location.RequireReceive("Location Code"));
    end;

    procedure RequireWhseShipment(): Boolean
    var
        Location: Record Location;
    begin
        exit(Location.RequireShipment("Location Code"));
    end;
}