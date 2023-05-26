import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/quotation/quotation_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_product_search_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:for_practice_the_app/models/api_responses/other/designation_list_response.dart';
import 'package:for_practice_the_app/models/common/all_name_id_list.dart';
import 'package:for_practice_the_app/models/common/sales_order_table.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/inquiry/search_inquiry_product_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/quotation/quotation_add_edit/specification/specification_list_screen.dart';
import 'package:for_practice_the_app/ui/screens/DashBoard/Modules/salesorder/SaleOrder_manan_design/so_assembly/so_assembly_screen.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/ui/widgets/common_widgets.dart';
import 'package:for_practice_the_app/utils/calculation/model/product_calculation_model.dart';
import 'package:for_practice_the_app/utils/calculation/product_calulation.dart';
import 'package:for_practice_the_app/utils/date_time_extensions.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/offline_db_helper.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class SOAddEditScreenArguments {
  SalesOrderTable model;
  int StateCode;
  String HeaderDiscAmnt;
  String QuotationNo;

  SOAddEditScreenArguments(
      this.model, this.StateCode, this.HeaderDiscAmnt, this.QuotationNo);
}

class SOAddEditScreen extends BaseStatefulWidget {
  static const routeName = '/SOAddEditScreen';
  final SOAddEditScreenArguments arguments;

  SOAddEditScreen(this.arguments);

  @override
  _SOAddEditScreenState createState() => _SOAddEditScreenState();
}

class _SOAddEditScreenState extends BaseState<SOAddEditScreen>
    with BasicScreen, WidgetsBindingObserver {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productIDController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _unitController = TextEditingController();

  TextEditingController _unitPriceController = TextEditingController();
  TextEditingController _discPerController = TextEditingController();
  TextEditingController _discAmountController = TextEditingController();

  TextEditingController _netRateController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _taxPerController = TextEditingController();
  TextEditingController _taxAmountController = TextEditingController();
  TextEditingController _taxTypeController = TextEditingController();
  TextEditingController edt_Specification = TextEditingController();
  TextEditingController edt_CGST_Per = TextEditingController();
  TextEditingController edt_SGST_Per = TextEditingController();
  TextEditingController edt_CGST_Amount = TextEditingController();
  TextEditingController edt_SGST_Amount = TextEditingController();
  TextEditingController edt_IGST_Per = TextEditingController();
  TextEditingController edt_IGST_Amount = TextEditingController();
  TextEditingController edt_StateCode = TextEditingController();
  TextEditingController txt_TotalNetAmnt = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController txt_DelivaryDate = TextEditingController();
  TextEditingController txt_DelivaryDateReverse = TextEditingController();

  FocusNode QuantityFocusNode;

  final _formKey = GlobalKey<FormState>();
  bool isForUpdate = false;
  bool isProductExist = false;
  QuotationBloc _inquiryBloc;
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Designation = [];
  ProductSearchDetails _searchDetails;
  double airFlow;
  double velocity;
  double valueFinal;
  String sam, sam2;
  String airFlowText, velocityText, finalText;
  List<SalesOrderTable> _inquiryProductList = [];
  List<SalesOrderTable> _TempinquiryProductList = [];

  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;

  int CompanyID = 0;
  String LoginUserID = "";
  double CardViewHeight = 35;

  double TotalNetAmnt = 0.00;

  String _HeaderDiscAmnt = "0.00";

  String _QuotationNo = "";

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    screenStatusBarColor = colorWhite;
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    LoginUserID = _offlineLoggedInData.details[0].userID;
    CompanyID = _offlineCompanyData.details[0].pkId;

    _QuotationNo = widget.arguments.QuotationNo;
    QuantityFocusNode = FocusNode();

    if (widget.arguments.model != null) {
      //for update
      isForUpdate = true;

      _productNameController.text = widget.arguments.model.ProductName;
      _productIDController.text = widget.arguments.model.ProductID.toString();
      _quantityController.text = widget.arguments.model.Quantity.toString();
      _unitController.text = widget.arguments.model.Unit.toString();
      _unitPriceController.text =
          widget.arguments.model.UnitRate.toStringAsFixed(2);
      _netRateController.text =
          widget.arguments.model.NetRate.toStringAsFixed(2);
      _discPerController.text =
          widget.arguments.model.DiscountPercent.toStringAsFixed(2);
      _discAmountController.text =
          widget.arguments.model.DiscountAmt.toStringAsFixed(2);

      _amountController.text = widget.arguments.model.Amount.toStringAsFixed(2);

      _taxTypeController.text = widget.arguments.model.TaxType.toString();

      print("jhfd" + _taxTypeController.text.toString());

      _taxPerController.text =
          widget.arguments.model.TaxRate.toStringAsFixed(2);
      _taxAmountController.text =
          widget.arguments.model.TaxAmount.toStringAsFixed(2);
      _totalAmountController.text =
          widget.arguments.model.NetAmount.toStringAsFixed(2);
      edt_Specification.text =
          widget.arguments.model.ProductSpecification.toString();
      edt_StateCode.text = widget.arguments.StateCode.toString();
      edt_CGST_Per.text = "0.00";
      edt_SGST_Per.text = "0.00";
      edt_CGST_Amount.text = "0.00";
      edt_SGST_Amount.text = "0.00";
      txt_DelivaryDate.text = widget.arguments.model.DeliveryDate
          .getFormattedDate(fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy");
      txt_DelivaryDateReverse.text = widget.arguments.model.DeliveryDate
          .getFormattedDate(fromFormat: "yyyy-MM-dd", toFormat: "yyyy-MM-dd");
      //_totalAmountController.text = _quantityController.text +_unitPriceController.text ;
    } else {
      _quantityController.text = "0.00";
      _unitPriceController.text = "0.00";
      _discPerController.text = "0.00";
      _netRateController.text = "0.00";
      _amountController.text = "0.00";
      _taxPerController.text = "0.00";
      _taxAmountController.text = "0.00";
      _totalAmountController.text = "0.00";
      edt_CGST_Per.text = "0.00";
      edt_SGST_Per.text = "0.00";
      edt_CGST_Amount.text = "0.00";
      edt_SGST_Amount.text = "0.00";

      if (widget.arguments.StateCode != null) {
        edt_StateCode.text = widget.arguments.StateCode.toString();
      }

      txt_DelivaryDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      txt_DelivaryDateReverse.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();
    }

    //print("ldjfkd" + widget.arguments.model.DeliveryDate.toString());

    /* if (widget.arguments.model.DeliveryDate == null) {
      txt_DelivaryDate.text = selectedDate.day.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.year.toString();
      txt_DelivaryDateReverse.text = selectedDate.year.toString() +
          "-" +
          selectedDate.month.toString() +
          "-" +
          selectedDate.day.toString();
    } else {
      txt_DelivaryDate.text = widget.arguments.model.DeliveryDate
          .getFormattedDate(fromFormat: "yyyy-MM-dd", toFormat: "dd-MM-yyyy");
      txt_DelivaryDateReverse.text = widget.arguments.model.DeliveryDate
          .getFormattedDate(fromFormat: "yyyy-MM-dd", toFormat: "yyyy-MM-dd");
    }*/

    _HeaderDiscAmnt = widget.arguments.HeaderDiscAmnt;

    // _totalAmountController.text = totalCalculated();
    _quantityController.addListener(TotalAmountCalculation);
    _unitPriceController.addListener(TotalAmountCalculation);
    _discPerController.addListener(TotalAmountCalculation);
    _discAmountController.addListener(TotalAmountCalculation);
    _netRateController.addListener(TotalAmountCalculation);
    _amountController.addListener(TotalAmountCalculation);
    _taxPerController.addListener(TotalAmountCalculation);
    _taxAmountController.addListener(TotalAmountCalculation);
    _totalAmountController.addListener(TotalAmountCalculation);
    _taxTypeController.addListener(TotalAmountCalculation);
    edt_CGST_Per.addListener(TotalAmountCalculation);
    edt_SGST_Per.addListener(TotalAmountCalculation);
    edt_CGST_Amount.addListener(TotalAmountCalculation);
    edt_SGST_Amount.addListener(TotalAmountCalculation);

    _inquiryBloc = QuotationBloc(baseBloc);

    print("HeaderDis7upc" + _HeaderDiscAmnt);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<QuotationBloc, QuotationStates>(
        builder: (BuildContext context, QuotationStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, QuotationStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
    QuantityFocusNode.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _discPerController.dispose();
    _netRateController.dispose();
    _amountController.dispose();
    _taxPerController.dispose();
    _taxAmountController.dispose();
    _totalAmountController.dispose();
    edt_Specification.dispose();
    edt_CGST_Per.dispose();
    edt_SGST_Per.dispose();
    edt_CGST_Amount.dispose();
    edt_SGST_Amount.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        getCommonAppBar(context, baseTheme,
            "${isForUpdate ? "Update" : "Add"} SalesOrder Product",
            showBack: true, showHome: true),
        Expanded(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildSearchView(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 1, child: Quantity()),
                      Expanded(flex: 1, child: UNIT()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 1, child: UnitPrice()),
                    Expanded(flex: 1, child: DiscPer()),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 1, child: NetRate()),
                    Expanded(child: Amount()),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(flex: 1, child: TaxPer()),
                    Expanded(flex: 1, child: TaxAmount()),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(child: TotalAmount()),
                      Expanded(child: _buildDeliveryDate())
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text("Specification",
                            style: TextStyle(
                                fontSize: 12,
                                color: colorPrimary,
                                fontWeight: FontWeight
                                    .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 7, right: 7, top: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value.toString().trim().isEmpty) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          controller: edt_Specification,
                          minLines: 2,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              hintText: 'Enter Details',
                              hintStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isForUpdate == true
                      ? Visibility(
                          visible: false,
                          child: Row(
                            children: [
                              Expanded(
                                child: getCommonButton(baseTheme, () async {
                                  //QuotationSpecificationAddEditScreen

                                  navigateTo(context,
                                          SpecificationListScreen.routeName,
                                          arguments: SpecificationListArgument(
                                              _QuotationNo,
                                              _productIDController.text
                                                  .toString()))
                                      .then((value) {
                                    print("ljfdjg" + value.toString());
                                  });

                                  //SpecificationListScreen
                                }, "Specification",
                                    width: 300,
                                    backGroundColor: Colors.blueAccent,
                                    radius: 30),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: getCommonButton(baseTheme, () async {
                                  //QuotationSpecificationAddEditScreen

                                  navigateTo(
                                          context, SOAssemblyScreen.routeName,
                                          arguments: SOAssemblyScreenArgument(
                                              _QuotationNo,
                                              _productIDController.text
                                                  .toString()))
                                      .then((value) {
                                    print("ljfdjg" + value.toString());
                                  });

                                  //SpecificationListScreen
                                }, "Assembly",
                                    width: 300,
                                    backGroundColor: Colors.blueAccent,
                                    radius: 30),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  getCommonButton(baseTheme, () {
                    if (_productNameController.text != "") {
                      if (_quantityController.text != "") {
                        if (double.parse(_quantityController.text) > 0) {
                          if (_unitPriceController.text != "") {
                            if (double.parse(_unitPriceController.text) > 0) {
                              List<String> table = productCalculation
                                  .producwisecalculation(2.0, 3.0);

                              for (int i = 0; i < table.length; i++) {
                                print("CalculateResult" +
                                    " Result : " +
                                    table[i]);
                              }

                              _onTapOfAdd();
                            } else {
                              showCommonDialogWithSingleOption(context,
                                  "UnitRate Should not be Zero Value..!!",
                                  positiveButtonTitle: "OK",
                                  onTapOfPositiveButton: () {
                                Navigator.of(context).pop();
                              });
                            }
                          } else {
                            showCommonDialogWithSingleOption(context,
                                "UnitRate Should not be Blank Value..!!",
                                positiveButtonTitle: "OK",
                                onTapOfPositiveButton: () {
                              Navigator.of(context).pop();
                            });
                          }
                        } else {
                          showCommonDialogWithSingleOption(
                              context, "Quantity Should not be Zero Value..!!",
                              positiveButtonTitle: "OK",
                              onTapOfPositiveButton: () {
                            Navigator.of(context).pop();
                          });
                        }
                      } else {
                        showCommonDialogWithSingleOption(
                            context, "Quantity Should not be Blank Value..!!",
                            positiveButtonTitle: "OK",
                            onTapOfPositiveButton: () {
                          Navigator.of(context).pop();
                        });
                      }
                    } else {
                      showCommonDialogWithSingleOption(
                          context, "ProductName is required..!!",
                          positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                        Navigator.of(context).pop();
                      });
                    }
                  }, isForUpdate ? "Update" : "Add")
                ],
              ),
            ),
          )),
        ),
      ],
    );
  }

  _onTapOfAdd() async {
    var CGSTPer = 0.00;
    var CGSTAmount = 0.00;
    var SGSTPer = 0.00;
    var SGSTAmount = 0.00;
    var IGSTPer = 0.00;
    var IGSTAmount = 0.00;

    if (_discPerController.text == "") {
      _discPerController.text = "0.00";
    }
    if (_taxPerController.text == "") {
      _taxPerController.text = "0.00";
    }

    int productID = int.parse(_productIDController.text.toString());
    double quantity = double.parse(_quantityController.text.toString());
    double unitRate = double.parse(_unitPriceController.text.toString());
    double disc = double.parse(_discPerController.text.toString());
    double discAmount = double.parse(_discAmountController.text.toString());
    double netRate = double.parse(_netRateController.text.toString());
    double amount = double.parse(_amountController.text.toString());
    double taxPer = double.parse(_taxPerController.text.toString());
    double taxAmount = double.parse(_taxAmountController.text.toString());
    double netAmount = double.parse(_totalAmountController.text.toString());
    String Specification = edt_Specification.text.toString();
    String unit = _unitController.text.toString();

    double Taxtype = 0.00;
    int ISTaxType = 0;

    if (_taxTypeController.text != null) {
      Taxtype = double.parse(_taxTypeController.text);
      ISTaxType = Taxtype.toInt();
    }

    int StateCode = int.parse(edt_StateCode.text);

    if (_offlineLoggedInData.details[0].stateCode ==
        int.parse(edt_StateCode.text)) {
      CGSTPer = taxPer / 2;
      edt_CGST_Per.text = CGSTPer.toStringAsFixed(2);
      SGSTPer = taxPer / 2;
      edt_SGST_Per.text = CGSTPer.toStringAsFixed(2);
      CGSTAmount = taxAmount / 2;
      edt_CGST_Amount.text = CGSTPer.toStringAsFixed(2);
      SGSTAmount = taxAmount / 2;
      edt_SGST_Amount.text = CGSTPer.toStringAsFixed(2);
      edt_IGST_Per.text = "";
      edt_IGST_Amount.text = "";
    } else {
      edt_CGST_Per.text = "";
      edt_SGST_Per.text = "";
      edt_CGST_Amount.text = "";
      edt_SGST_Amount.text = "";
      IGSTPer = taxPer;
      edt_IGST_Per.text = CGSTPer.toStringAsFixed(2);
      IGSTAmount = taxAmount;
      edt_IGST_Amount.text = CGSTPer.toStringAsFixed(2);
    }

    await getInquiryProductDetails();

    if (isProductExist == false) {
      if (isForUpdate) {
        await OfflineDbHelper.getInstance().updateSalesOrderProduct(
            SalesOrderTable(
                "",
                Specification,
                productID,
                _productNameController.text.toString(),
                unit,
                quantity,
                unitRate,
                disc,
                discAmount,
                netRate,
                amount,
                taxPer,
                taxAmount,
                netAmount,
                ISTaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                StateCode,
                0,
                LoginUserID,
                CompanyID.toString(),
                0,
                0.00,
                txt_DelivaryDateReverse.text.toString(),
                id: widget.arguments.model.id));
      } else {
        await OfflineDbHelper.getInstance().insertSalesOrderProduct(
            SalesOrderTable(
                "",
                Specification,
                productID,
                _productNameController.text.toString(),
                unit,
                quantity,
                unitRate,
                disc,
                discAmount,
                netRate,
                amount,
                taxPer,
                taxAmount,
                netAmount,
                ISTaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                StateCode,
                0,
                LoginUserID,
                CompanyID.toString(),
                0,
                0.00,
                txt_DelivaryDateReverse.text.toString()));
      }
      Navigator.of(context).pop(_inquiryProductList);
    } else {
      if (isForUpdate) {
        await OfflineDbHelper.getInstance().updateSalesOrderProduct(
            SalesOrderTable(
                "",
                Specification,
                productID,
                _productNameController.text.toString(),
                unit,
                quantity,
                unitRate,
                disc,
                discAmount,
                netRate,
                amount,
                taxPer,
                taxAmount,
                netAmount,
                ISTaxType,
                CGSTPer,
                SGSTPer,
                IGSTPer,
                CGSTAmount,
                SGSTAmount,
                IGSTAmount,
                StateCode,
                0,
                LoginUserID,
                CompanyID.toString(),
                0,
                0.00,
                txt_DelivaryDateReverse.text.toString(),
                id: widget.arguments.model.id));
        Navigator.of(context).pop(_inquiryProductList);
      } else {
        showCommonDialogWithSingleOption(
            context, "Duplicate Product Not Allowed..!!",
            positiveButtonTitle: "OK", onTapOfPositiveButton: () {
          Navigator.of(context).pop();
        });
      }
    }

    /* if (_formKey.currentState.validate()) {
      //checkExistProduct();
      print("BoolProductValue"+" IsExist : " + isProductExist.toString() + "ISUpdate : " + isForUpdate.toString());

    }*/
  }

  void _onDesignationCallSuccess(DesignationApiResponse state) {
    arr_ALL_Name_ID_For_Designation.clear();
    for (var i = 0; i < state.details.length; i++) {
      print("DesignationDetails : " + state.details[i].designation);
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.details[i].designation;
      all_name_id.Name1 = state.details[i].desigCode;
      arr_ALL_Name_ID_For_Designation.add(all_name_id);
    }
  }

  Widget Quantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Quantity * ",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      focusNode: QuantityFocusNode,
                      textInputAction: TextInputAction.next,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _quantityController,
                      onTap: () => {
                            _quantityController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _quantityController.text.length,
                            )
                          },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
                /* Icon(
                  Icons.style,
                  color: colorGrayDark,
                )*/
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget UnitPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Unit Rate *",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _unitPriceController,
                      onTap: () => {
                            _unitPriceController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _unitPriceController.text.length,
                            )
                          },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget DiscPer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Disc.%",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      onTap: () => {
                            _discPerController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _discPerController.text.length,
                            )
                          },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _discPerController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget TaxPer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Tax.%",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _taxPerController,
                      onTap: () => {
                            _taxPerController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _taxPerController.text.length,
                            )
                          },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget UNIT() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Unit  ",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      controller: _unitController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "Unit",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget TotalAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Net Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _totalAmountController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget NetRate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Net Rate",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _netRateController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget Amount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _amountController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget TaxAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Text("Tax Amount",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: CardViewHeight,
            padding: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                      // key: Key(totalCalculated()),

                      validator: (value) {
                        if (value.toString().trim().isEmpty) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      enabled: false,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      controller: _taxAmountController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 10),
                        hintText: "0.00",
                        labelStyle: TextStyle(
                          color: Color(0xFF000000),
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                      ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSearchView() {
    return InkWell(
      onTap: () {
        print("VlaueForISForUpdate" + isForUpdate.toString());
        if (isForUpdate == false) {
          _onTapOfSearchView();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Search Product * ",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight
                      .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

              ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 40,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: /*TextField(
                      _searchDetails == null
                          ? "Tap to search inquiry"
                          : _searchDetails.productName,
                      style: baseTheme.textTheme.headline3.copyWith(
                          color: _searchDetails == null
                              ? colorGrayDark
                              : colorBlack),
                    ),
                    */
                        TextFormField(
                            validator: (value) {
                              if (value.toString().trim().isEmpty) {
                                return "Please enter this field";
                              }
                              return null;
                            },
                            onTap: () {
                              if (isForUpdate == false) {
                                _onTapOfSearchView();
                              }
                            },
                            readOnly: true,
                            controller: _productNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 5),
                              hintText: "Tap to search Product",
                              labelStyle: TextStyle(
                                color: Color(0xFF000000),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF000000),
                            ) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                            ),
                  ),
                  Icon(
                    Icons.search,
                    color: colorGrayDark,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _onTapOfSearchView() async {
    /* navigateTo(context, SearchInquiryProductScreen.routeName).then((value) {
      if (value != null) {
        _searchDetails = value;
        _inquiryBloc.add(InquiryProductSearchNameCallEvent(InquiryProductSearchRequest(pkID: "",CompanyId: "10032",ListMode: "L",SearchKey: value)));
       print("ProductDetailss345"+_searchDetails.productName +"Alias"+ _searchDetails.productAlias);
      }
    });*/
    navigateTo(
      context,
      SearchInquiryProductScreen.routeName,
    ).then((value) {
      if (value != null) {
        _searchDetails = ProductSearchDetails();
        _searchDetails = value;
        setState(() {
          _quantityController.text = "0.00";
          _unitPriceController.text = "0.00";
          _discPerController.text = "0.00";
          _netRateController.text = "0.00";
          _amountController.text = "0.00";
          _taxPerController.text = "0.00";
          _taxAmountController.text = "0.00";
          _totalAmountController.text = "0.00";
          _taxTypeController.text = "";
          _unitController.text = "";
          edt_Specification.text = "";
          edt_CGST_Per.text = "";
          edt_SGST_Per.text = "";
          edt_CGST_Amount.text = "";
          edt_SGST_Amount.text = "";

          // edt_Specification.text = "";
          _productNameController.text = _searchDetails.productName.toString();
          _productIDController.text = _searchDetails.pkID.toString();
          _unitPriceController.text = _searchDetails.unitPrice.toString();
          _taxPerController.text = _searchDetails.taxRate.toString();
          _taxTypeController.text = _searchDetails.taxType.toString();
          _unitController.text = _searchDetails.unit.toString();

          //_totalAmountController.text = ""
          if (_productNameController.text ==
              _searchDetails.productName.toString()) {
            QuantityFocusNode.requestFocus();
          }
          _quantityController.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _quantityController.text.length,
          );
        });
      }
    });
  }

  TotalAmountCalculation1() async {
    List<SalesOrderTable> temp =
        await OfflineDbHelper.getInstance().getSalesOrderProduct();
    double Exclusivetot_amount = 0.00;
    double Exclusivetot_tax_amt = 0.00;
    double Exclusivetot_amnt_net = 0.00;
    double Inclusivetot_amount = 0.00;
    double Inclusivetot_tax_amt = 0.00;
    double Inclusivetot_amnt_net = 0.00;

    double TotEXINNetmant = 0.00;
    double ExTotalNetAmnt = 0.00;
    double InTotalNetAmnt = 0.00;

    List<SalesOrderTable> temp2 = [];
    if (temp.length != 0) {
      for (int i = 0; i < temp.length; i++) {
        if (temp[i].TaxType == 1) {
          Exclusivetot_amount = temp[i].Quantity * temp[i].NetRate;
          Exclusivetot_tax_amt = (Exclusivetot_amount * temp[i].TaxRate) / 100;
          Exclusivetot_amnt_net = Exclusivetot_amount + Exclusivetot_tax_amt;
          ExTotalNetAmnt += Exclusivetot_amnt_net;
          print("TotExclusive" +
              "ExclusiveNaetAmnt : " +
              Exclusivetot_amnt_net.toStringAsFixed(2));
        } else {
          Inclusivetot_amount = temp[i].Quantity * temp[i].NetRate;
          Inclusivetot_tax_amt =
              ((temp[i].Quantity * temp[i].NetRate) * temp[i].TaxRate) /
                  (100 + temp[i].TaxRate);
          Inclusivetot_amnt_net =
              Inclusivetot_amount; // + Inclusivetot_tax_amt;
          InTotalNetAmnt += Inclusivetot_amnt_net;
          print("TotInclusive" +
              "InclusiveNaetAmnt : " +
              Inclusivetot_amnt_net.toStringAsFixed(2));
        }
      }
    }
    TotEXINNetmant = ExTotalNetAmnt + InTotalNetAmnt;

    double Hdrdis = _HeaderDiscAmnt == "" || _HeaderDiscAmnt == null
        ? 0.00
        : double.parse(_HeaderDiscAmnt);
    // double.parse(_HeaderDiscAmnt == null ? 0.00 : _HeaderDiscAmnt);

    /* if(isForUpdate!=true)
      {
        Hdrdis = 0.00;
      }
    else
      {
        Hdrdis = double.parse(_HeaderDiscAmnt == null ? 0.00 : _HeaderDiscAmnt);
      }*/
    print("NetAfggkj" +
        TotEXINNetmant.toStringAsFixed(2) +
        Hdrdis.toStringAsFixed(2));
    if (_quantityController.text.toString() != null &&
        _unitPriceController.text.toString() != null) {
      setState(() {
        if (_discPerController.text == "") {
          _discPerController.text = "0.00";
        }
        var Quantity = _quantityController.text == ""
            ? 0.00
            : double.parse(_quantityController.text
                .toString()); //double.parse(_quantityController.text.toString());
        var UnitPrice = _unitPriceController.text == ""
            ? 0.00
            : double.parse(_unitPriceController.text
                .toString()); //double.parse(_unitPriceController.text.toString());
        var DisPer = _discPerController.text == ""
            ? 0.00
            : double.parse(_discPerController.text
                .toString()); /*double.parse(_discPerController.text.toString() == null
            ? 0.00
            : _discPerController.text.toString());*/
        var TaxPer = _taxPerController.text == ""
            ? 0.00
            : double.parse(_taxPerController.text
                .toString()); //double.parse(_taxPerController.text.toString());
        var Amount1 = 0.00;
        var TaxAmount1 = 0.00;
        var TotalAmount = 0.00;
        var NetRate1 = 0.00;
        double ExclusiveItemWiseHeaderDisAmnt = 0.00;
        double ExclusiveItemWiseAmount = 0.00;
        double ExclusiveNetAmntAfterHeaderDisAmnt = 0.00;
        double ExclusiveItemWiseTaxAmnt = 0.00;
        double ExclusiveTaxPluse100 = 0.00;
        double ExclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

        double ExclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

        double InclusiveItemWiseHeaderDisAmnt = 0.00;
        double InclusiveItemWiseAmount = 0.00;
        double InclusiveNetAmntAfterHeaderDisAmnt = 0.00;
        double InclusiveItemWiseTaxAmnt = 0.00;
        double InclusiveTaxPluse100 = 0.00;
        double InclusiveFinalNetAmntAfterHeaderDisAmnt = 0.00;

        double InclusiveTotalNetAmntAfterHeaderDisAmnt = 0.00;

        if (DisPer > 0) {
          final disper = (UnitPrice * DisPer) / 100;
          _discAmountController.text = disper.toStringAsFixed(2);
          NetRate1 = UnitPrice - disper;
        } else {
          NetRate1 = UnitPrice;
          _discAmountController.text = "0.00";
        }

        _netRateController.text = NetRate1.toStringAsFixed(2);

        double Taxtype = 0.00;
        int intTaxType = 0;

        if (_taxTypeController.text != null) {
          Taxtype = double.parse(_taxTypeController.text);
          intTaxType = Taxtype.toInt();
        }
        print("EditedTaxType" + " TaxType : " + intTaxType.toString());

        if (intTaxType == 1) {
          if (Hdrdis == 0.00) {
            Amount1 = Quantity * NetRate1;
            _amountController.text = Amount1.toStringAsFixed(2);
            TaxAmount1 = (Amount1 * TaxPer) / 100;
            _taxAmountController.text = TaxAmount1.toStringAsFixed(2);
            TotalAmount = Amount1 + TaxAmount1;
            _totalAmountController.text = TotalAmount.toStringAsFixed(2);
          } else {
            Amount1 = Quantity * NetRate1;

            print("Onlyfg" +
                Quantity.toString() +
                " NetAmount : " +
                NetRate1.toString() +
                " Amount : " +
                Amount1.toString());
            //_amountController.text = Amount1.toStringAsFixed(2);
            TaxAmount1 = (Amount1 * TaxPer) / 100;
            // _taxAmountController.text = TaxAmount1.toStringAsFixed(2);
            TotalAmount = Amount1 + TaxAmount1;
            // _totalAmountController.text = TotalAmount.toStringAsFixed(2); //getNumber(TotalAmount,precision: 2).toString();//TotalAmount.toStringAsFixed(3);

            ExclusiveItemWiseHeaderDisAmnt =
                TotalAmount * Hdrdis / TotEXINNetmant;
            ExclusiveItemWiseAmount = Quantity * NetRate1;
            ExclusiveNetAmntAfterHeaderDisAmnt =
                ExclusiveItemWiseAmount - ExclusiveItemWiseHeaderDisAmnt;
            ExclusiveItemWiseTaxAmnt =
                (ExclusiveNetAmntAfterHeaderDisAmnt * TaxPer) / 100;
            ExclusiveFinalNetAmntAfterHeaderDisAmnt =
                ExclusiveNetAmntAfterHeaderDisAmnt;
            ExclusiveTotalNetAmntAfterHeaderDisAmnt =
                ExclusiveItemWiseAmount + ExclusiveItemWiseTaxAmnt;
            var CGSTPer = 0.00;
            var CGSTAmount = 0.00;
            var SGSTPer = 0.00;
            var SGSTAmount = 0.00;
            var IGSTPer = 0.00;
            var IGSTAmount = 0.00;

            _amountController.text =
                ExclusiveFinalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
            _taxAmountController.text =
                ExclusiveItemWiseTaxAmnt.toStringAsFixed(2);
            _totalAmountController.text =
                ExclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
          }
        } else {
          Amount1 = 0.00;
          TaxAmount1 = 0.00;
          TotalAmount = 0.00;

          if (Hdrdis == 0.00) {
            TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);
            _taxAmountController.text = TaxAmount1.toStringAsFixed(
                2); //getNumber(TaxAmount1,precision: 2).toString();

            Amount1 = (Quantity * NetRate1) - TaxAmount1;
            _amountController.text = Amount1.toStringAsFixed(
                2); //getNumber(Amount1,precision: 2).toString();
            TotalAmount = (Quantity *
                NetRate1); //+ TaxAmount1; //getNumber(TaxAmount1,precision: 2);
            _totalAmountController.text = TotalAmount.toStringAsFixed(
                2); //getNumber(TotalAmount,precision: 2).toString();
            print("dsljf333" + TotalAmount.toStringAsFixed(2));
          } else {
            TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);

            Amount1 = (Quantity * NetRate1) - TaxAmount1;

            TotalAmount = (Quantity * NetRate1) +
                TaxAmount1; //getNumber(TaxAmount1,precision: 2);

            InclusiveItemWiseHeaderDisAmnt =
                (TotalAmount * Hdrdis) / TotEXINNetmant;
            InclusiveItemWiseAmount = Quantity * NetRate1;
            InclusiveNetAmntAfterHeaderDisAmnt =
                InclusiveItemWiseAmount - InclusiveItemWiseHeaderDisAmnt;
            InclusiveTaxPluse100 = 100 + TaxPer;
            InclusiveItemWiseTaxAmnt =
                (InclusiveNetAmntAfterHeaderDisAmnt * TaxPer) /
                    InclusiveTaxPluse100;
            InclusiveFinalNetAmntAfterHeaderDisAmnt =
                InclusiveNetAmntAfterHeaderDisAmnt - InclusiveItemWiseTaxAmnt;
            InclusiveTotalNetAmntAfterHeaderDisAmnt =
                InclusiveNetAmntAfterHeaderDisAmnt; //+ InclusiveItemWiseTaxAmnt;

            print("dsljf333" +
                InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsExponential(
                    2));

            _amountController.text =
                InclusiveFinalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
            _taxAmountController.text =
                InclusiveItemWiseTaxAmnt.toStringAsFixed(2);
            _totalAmountController.text =
                InclusiveTotalNetAmntAfterHeaderDisAmnt.toStringAsFixed(2);
          }
        }
      });
    }
  }

  TotalAmountCalculation() async {
    print("jfhf" + _taxTypeController.text.toString());
    ProductCalculationModel productoutparam =
        productCalculation.funCalculateProduct(
      UnitQuantity: 1,
      TaxType: int.parse(
          _taxTypeController.text == "" ? "0" : _taxTypeController.text),
      Qty: double.parse(_quantityController.text),
      Rate: double.parse(_unitPriceController.text),
      ItmDiscPer: double.parse(_discPerController.text),
      ItmDiscAmt: 0,
      TaxPer: double.parse(_taxPerController.text),
      AddTaxPer: 0,
      HdDiscAmt: 0,
      CustomerStateId: edt_StateCode.text,
      CompanyStateId: _offlineLoggedInData.details[0].stateCode.toString(),
      TaxAmt: 0,
      CGSTPer: 0,
      CGSTAmt: 0,
      SGSTPer: 0,
      SGSTAmt: 0,
      IGSTPer: 0,
      IGSTAmt: 0,
      NetRate: 0,
      BasicAmt: 0,
      NetAmt: 0,
      ItmDiscPer1: 0,
      ItmDiscAmt1: 0,
      AddTaxAmt: 0,
    );
    _netRateController.text = productoutparam.NetRate.toString();
    _amountController.text = productoutparam.BasicAmt.toString();
    _taxAmountController.text = productoutparam.TaxAmt.toString();
    _totalAmountController.text = productoutparam.NetAmt.toString();
    _discAmountController.text = productoutparam.ItmDiscAmt1.toString();

    edt_CGST_Per.text = productoutparam.CGSTPer.toString();
    edt_SGST_Per.text = productoutparam.SGSTPer.toString();
    edt_CGST_Amount.text = productoutparam.CGSTAmt.toString();
    edt_SGST_Amount.text = productoutparam.SGSTAmt.toString();
    edt_IGST_Per.text = productoutparam.IGSTPer.toString();
    edt_IGST_Amount.text = productoutparam.IGSTAmt.toString();
    // edt_StateCode.text    = "12";

    /*int productID = int.parse(_productIDController.text.toString());
    double quantity = double.parse(_quantityController.text.toString());
    double unitRate = double.parse(_unitPriceController.text.toString());
    double disc = double.parse(_discPerController.text.toString());
    double discAmount = double.parse(_discAmountController.text.toString());
    double netRate = double.parse(_netRateController.text.toString());
    double amount = double.parse(_amountController.text.toString());
    double taxPer = double.parse(_taxPerController.text.toString());
    double taxAmount = double.parse(_taxAmountController.text.toString());
    double netAmount = double.parse(_totalAmountController.text.toString());
    String Specification = edt_Specification.text.toString();
    String unit = _unitController.text.toString();*/

    print("CGST" + productoutparam.CGSTPer.toString());
  }

  /*TotalAmountCalculation() async {
    List<QuotationTable> temp =
    await OfflineDbHelper.getInstance().getQuotationProduct();
    if (temp.length != 0) {
      TotalNetAmnt = 0.00;
      for (int i = 0; i < temp.length; i++) {
        TotalNetAmnt = TotalNetAmnt + temp[i].NetAmount;
      }
    }

    double Hdrdis =
    double.parse(_HeaderDiscAmnt == null ? 0.00 : _HeaderDiscAmnt);

    print("NetAfggkj" +
        TotalNetAmnt.toStringAsFixed(2) +
        Hdrdis.toStringAsFixed(2));
    if (_quantityController.text.toString() != null &&
        _unitPriceController.text.toString() != null) {
      setState(() {
        var Quantity = double.parse(_quantityController.text.toString());
        var UnitPrice = double.parse(_unitPriceController.text.toString());
        var DisPer = double.parse(_discPerController.text.toString() == null
            ? 0.00
            : _discPerController.text.toString());
        var TaxPer = double.parse(_taxPerController.text.toString());
        var Amount1 = 0.00;
        var TaxAmount1 = 0.00;
        var TotalAmount = 0.00;
        var NetRate1 = 0.00;

        if (DisPer > 0) {
          final disper = (UnitPrice * DisPer) / 100;
          _discAmountController.text = disper.toStringAsFixed(2);
          NetRate1 = UnitPrice - disper;
        } else {
          NetRate1 = UnitPrice;
          _discAmountController.text = "0.00";
        }

        _netRateController.text = NetRate1.toStringAsFixed(2);

        if (_taxTypeController.text == "1") {
          Amount1 = Quantity * NetRate1;
          _amountController.text = Amount1.toStringAsFixed(2);
          TaxAmount1 = (Amount1 * TaxPer) / 100;
          _taxAmountController.text = TaxAmount1.toStringAsFixed(2);
          TotalAmount = Amount1 + TaxAmount1;
          _totalAmountController.text = TotalAmount.toStringAsFixed(
              2); //getNumber(TotalAmount,precision: 2).toString();//TotalAmount.toStringAsFixed(3);

        } else {
          Amount1 = 0.00;
          TaxAmount1 = 0.00;
          TotalAmount = 0.00;

          TaxAmount1 = ((Quantity * NetRate1) * TaxPer) / (100 + TaxPer);
          _taxAmountController.text = TaxAmount1.toStringAsFixed(
              2); //getNumber(TaxAmount1,precision: 2).toString();

          Amount1 = (Quantity * NetRate1) - TaxAmount1;
          _amountController.text = Amount1.toStringAsFixed(
              2); //getNumber(Amount1,precision: 2).toString();
          TotalAmount = (Quantity * NetRate1) +
              TaxAmount1; //getNumber(TaxAmount1,precision: 2);
          _totalAmountController.text = TotalAmount.toStringAsFixed(
              2); //getNumber(TotalAmount,precision: 2).toString();

        }

      });
    }
  }*/

  double getNumber(double input, {int precision = 2}) => double.parse(
      '$input'.substring(0, '$input'.indexOf('.') + precision + 1));

  Future<void> getInquiryProductDetails() async {
    _inquiryProductList.clear();
    List<SalesOrderTable> temp =
        await OfflineDbHelper.getInstance().getSalesOrderProduct();
    _inquiryProductList.addAll(temp);
    if (_inquiryProductList.length != 0) {
      for (var i = 0; i < _inquiryProductList.length; i++) {
        print("ChekProduct" +
            " DBProduct : " +
            _inquiryProductList[i].ProductID.toString() +
            " TextProduct : " +
            _productIDController.text.toString());
        if (_inquiryProductList[i].ProductID.toString() ==
            _productIDController.text.toString()) {
          isProductExist = true;
          break;
        } else {
          isProductExist = false;
        }
      }
    }
  }

  Future<void> getInquiryDetailsFromDb() async {
    //_inquiryProductList.clear();
    List<SalesOrderTable> temp =
        await OfflineDbHelper.getInstance().getSalesOrderProduct();
    //_inquiryProductList.addAll(temp);
    // txt_TotalNetAmnt.text = "0.00";

    for (int i = 0; i < temp.length; i++) {
      TotalNetAmnt = TotalNetAmnt + temp[i].NetAmount;
    }

    // txt_TotalNetAmnt.text =TotalNetAmnt.toStringAsFixed(2);
    print("GetNetAMnt" + "Total NetAmnt : " + TotalNetAmnt.toStringAsFixed(2));
  }

  Widget _buildDeliveryDate() {
    return InkWell(
      onTap: () {
        _selectDate(context, txt_DelivaryDate);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Text("Delivery Date",
                style: TextStyle(
                    fontSize: 12,
                    color: colorPrimary,
                    fontWeight: FontWeight
                        .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              height: 35,
              padding: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      txt_DelivaryDate.text == null ||
                              txt_DelivaryDate.text == ""
                          ? "DD-MM-YYYY"
                          : txt_DelivaryDate.text,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_today_outlined,
                      color: colorGrayDark, size: 20)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController F_datecontroller) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        txt_DelivaryDate.text = selectedDate.day.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.year.toString();
        txt_DelivaryDateReverse.text = selectedDate.year.toString() +
            "-" +
            selectedDate.month.toString() +
            "-" +
            selectedDate.day.toString();
      });
  }
}
