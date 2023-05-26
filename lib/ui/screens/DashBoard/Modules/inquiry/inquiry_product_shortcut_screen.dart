import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_practice_the_app/models/api_responses/inquiry/inquiry_no_to_product_response.dart';
import 'package:for_practice_the_app/models/api_responses/login/login_user_details_api_response.dart';
import 'package:lottie/lottie.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:for_practice_the_app/blocs/other/bloc_modules/inquiry/inquiry_bloc.dart';
import 'package:for_practice_the_app/models/api_requests/inquiry/inquiry_no_to_product_list_request.dart';
import 'package:for_practice_the_app/models/api_responses/company_details/company_details_response.dart';
import 'package:for_practice_the_app/ui/res/color_resources.dart';
import 'package:for_practice_the_app/ui/res/dimen_resources.dart';
import 'package:for_practice_the_app/ui/res/image_resources.dart';
import 'package:for_practice_the_app/ui/screens/base/base_screen.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';

class ProductHistoryScreenArguments {
  String InqNo, CustomerID;
  ProductHistoryScreenArguments(this.InqNo, this.CustomerID);
}

class ProductHistoryScreen extends BaseStatefulWidget {
  static const routeName = '/ProductHistoryScreen';
  final ProductHistoryScreenArguments arguments;

  ProductHistoryScreen(this.arguments);
  @override
  _ProductHistoryScreenState createState() => _ProductHistoryScreenState();
}

class _ProductHistoryScreenState extends BaseState<ProductHistoryScreen>
    with BasicScreen, WidgetsBindingObserver {
  InquiryBloc _inquiryBloc;
  InquiryNoToProductResponse _searchCustomerListResponse;
  CompanyDetailsResponse _offlineCompanyData;
  LoginUserDetialsResponse _offlineLoggedInData;
  int CompanyID = 0;
  String LoginUserID = "";
  String InqNo;
  String CustomerID;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xFF504F4F; //0x66666666;
  int title_color = 0xFF000000;

  @override
  void initState() {
    super.initState();
    _offlineLoggedInData = SharedPrefHelper.instance.getLoginUserData();
    _offlineCompanyData = SharedPrefHelper.instance.getCompanyData();
    CompanyID = _offlineCompanyData.details[0].pkId;
    LoginUserID = _offlineLoggedInData.details[0].userID;

    screenStatusBarColor = colorPrimary;
    _inquiryBloc = InquiryBloc(baseBloc);
    InqNo = widget.arguments.InqNo;
    CustomerID = widget.arguments.CustomerID;
    _inquiryBloc.add(InquiryNotoProductCallEvent(InquiryNoToProductListRequest(
        InquiryNo: InqNo, CompanyId: CompanyID.toString())));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _inquiryBloc,
      child: BlocConsumer<InquiryBloc, InquiryStates>(
        builder: (BuildContext context, InquiryStates state) {
          if (state is InquiryNotoProductResponseState) {
            _onSearchInquiryListCallSuccess(state.inquiryNoToProductResponse);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is InquiryNotoProductResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, InquiryStates state) {},
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        NewGradientAppBar(
          title: Text('Products'),
          gradient: LinearGradient(colors: [
            Color(0xff108dcf),
            Color(0xff0066b3),
            Color(0xff62bb47),
          ]),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
              top: 25,
            ),
            child: Column(
              children: [Expanded(child: _buildInquiryList())],
            ),
          ),
        ),
      ],
    );
  }

  ///builds header and title view

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (_searchCustomerListResponse != null) {
      return ListView.builder(
        itemBuilder: (context, index) {
          return _buildSearchInquiryListItem(index);
        },
        shrinkWrap: true,
        itemCount: _searchCustomerListResponse.details.length,
      );
    } else {
      return Container(
        alignment: Alignment.center,
        child: Lottie.asset(NO_DATA_ANIMATED
            /*height: 200,
              width: 200*/
            ),
      );
    }
  }

  ///builds row item view of inquiry list
  Widget _buildSearchInquiryListItem(int index) {
    InquiryProductDetails model = _searchCustomerListResponse.details[index];

    double NetAmount = model.quantity * model.unitPrice;

    return Container(
      margin: EdgeInsets.all(5),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Color(0xffffff8d),
                Color(0xffffff8d),
                Color(0xffb9f6ca),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Product Name",
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Color(label_color),
                              fontSize: _fontSize_Label,
                              letterSpacing: .3)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(model.productName == "" ? "N/A" : model.productName,
                          style: TextStyle(
                              color: Color(title_color),
                              fontSize: _fontSize_Title,
                              letterSpacing: .3))
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                child: _buildTitleWithValueView(
                  "Unit",
                  model.unit.toString(),
                ),
              ),
              Expanded(
                child: _buildTitleWithValueView(
                  "Quantity",
                  model.quantity.toStringAsFixed(2),
                ),
              )
            ]),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
            Row(children: [
              Expanded(
                child: _buildTitleWithValueView(
                    "Unit Price", model.unitPrice.toStringAsFixed(2) ?? "-"),
              ),
              Expanded(
                child: _buildTitleWithValueView(
                    "Net Amount", NetAmount.toStringAsFixed(2)),
              ),
            ]),
            SizedBox(
              height: DEFAULT_HEIGHT_BETWEEN_WIDGET,
            ),
          ]),
        ),
      ),
    );
  }

  ///calls search list api

  Widget _buildTitleWithValueView(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: _fontSize_Label,
                color: Color(0xFF504F4F),
                /*fontWeight: FontWeight.bold,*/ fontStyle: FontStyle
                    .italic) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            ),
        SizedBox(
          height: 3,
        ),
        Text(value,
            style: TextStyle(
                fontSize: _fontSize_Title,
                color:
                    colorPrimary) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),
            )
      ],
    );
  }

  void _onSearchInquiryListCallSuccess(
      InquiryNoToProductResponse inquiryNoToProductResponse) {
    _searchCustomerListResponse = inquiryNoToProductResponse;
  }
}
